//
//  GameController.m
//  MacTrek
//
//  Created by Aqua on 02/06/2006.
//  Copyright 2006 Luky Soft. See Licence.txt for licence details.
//

#import "GameController.h"


@implementation GameController

bool forceBarUpdate = NO;

- (void) awakeFromNib {
      
    // watch my shields and stuff
    // but beware that the events are received in the main thread
    
    // when we receive status messages, we update the textfield
    [notificationCenter addObserver:self selector:@selector(newMessage:) name:@"SP_WARNING"
                             object:nil useLocks:NO useMainRunLoop:YES];
    [notificationCenter addObserver:self selector:@selector(newMessage:) name:@"PM_WARNING"
                             object:nil useLocks:NO useMainRunLoop:NO]; // is fired in main loop
    [notificationCenter addObserver:self selector:@selector(newInfoMessage:) name:@"GV_MODE_INFO"
                             object:nil useLocks:NO useMainRunLoop:NO]; // is fired in main loop
    universe = [Universe defaultInstance];
    
    // set up discrete bars
    [armiesBar setDiscrete:YES];
    [torpsBar setDiscrete:YES];
    //[phasersBar setDiscrete:YES];
    
    // add speech
    //synth = [[NSSpeechSynthesizer alloc] initWithVoice:@"com.apple.speech.synthesis.voice.Zarvox"];
    synth = [[NSSpeechSynthesizer alloc] initWithVoice:@"com.apple.speech.synthesis.voice.Trinoids"]; 
    shouldSpeak = YES;
    
    //synth is an ivar    
    [synth setDelegate:self];
}

- (GameView *)gameView {
	return gameView;
}

- (void) setSpeakComputerMessages:(bool)speak {
    shouldSpeak = speak;
}

- (void) repaint {
    // invoked by timer
    
    // repaint the dashboard here
    [self updateDashboard:[universe playerThatIsMe]];
    
    // do the messages list if an update occured
    if ([messages hasChanged]) {
        //NSLog(@"GameController.repaint repainting messages view");
        [messages setNeedsDisplay:YES];
    }
    // do the playerList list if an update occured
    if ([playerList hasChanged]) {
        //NSLog(@"GameController.repaint repainting playerList view");
        [playerList setNeedsDisplay:YES];
    }
    
    // and the main view    
    [mapView setNeedsDisplay:YES];
    // $$ see if this is faster
    [gameView setNeedsDisplay:YES];
    //[gameView display];
}

- (void) newInfoMessage:(NSString*)message {
    
    if ([[messageTextField stringValue] isEqualToString:message]) {
        return; // no need to update
    }
    [messageTextField setStringValue:message];
}

- (void) newMessage:(NSString*)message {

    [self newInfoMessage:message];
    
    // add speech...
    if (shouldSpeak && (![synth isSpeaking])) {
        [synth startSpeakingString:message];
    }
    
}

- (void) updateBar:(LLBar*) bar andTextValue:(NSTextField*)field 
         withValue:(int)value max:(int)maxValue inverseWarning:(bool)inverse {
    [self updateBar:bar andTextValue:field withValue:value max:maxValue
            tempMax:maxValue inverseWarning:inverse];
}
      
- (void) updateBar:(LLBar*) bar andTextValue:(NSTextField*)field 
         withValue:(int)value max:(int)maxValue tempMax:(int)tempMax inverseWarning:(bool)inverse {
    // NOTE: as this is called from a seperate thread, we need to tell the main
    // thread that it needs to re-display explictly !
    
    if (bar == nil) {
        return;
    }
    
    // update only if required 
    if (([bar max] != maxValue) || forceBarUpdate) {
        //NSLog(@"GameController.updateBar %@ setting max to %d", [bar name], maxValue);
        if (field != nil) { // overrules max
            [field setStringValue:[NSString stringWithFormat:@"%d / %d", value, tempMax]];
        }
        [bar setMax:maxValue * 1.0];
        if (inverse) {
            [bar setCritical:maxValue * 0.5];
            [bar setWarning:maxValue * 0.3];
        } else {
            [bar setCritical:maxValue * 0.3];
            [bar setWarning:maxValue * 0.5];
        }
        [bar setNeedsDisplay:YES];
    }
    if (([bar tempMax] != tempMax) || forceBarUpdate) {
        //NSLog(@"GameController.updateBar %@ setting tempMax to %d", [bar name], tempMax);
        [bar setTempMax:tempMax * 1.0];
        [bar setNeedsDisplay:YES];
        if (field != nil) { // overrules max
            [field setStringValue:[NSString stringWithFormat:@"%d / %d", value, tempMax]];
        }
    }    
    if (([bar value] != value) || forceBarUpdate) {
        //NSLog(@"GameController.updateBar %d setting value to %d", [bar tag], value);
        if (field != nil) {              
            [field setStringValue:[NSString stringWithFormat:@"%d / %d", value, tempMax]];                            
        } 
        [bar setValue:value * 1.0]; 
        [bar setNeedsDisplay:YES];
    }         
}

- (void) updateDashboard:(Player*) me {
    
    if (![me isMe]) { // this is not me...
        return;
    }
	
	// refresh every now and then
	static int frameCount = 0;
	
	if (frameCount++ > FRAMES_PER_FULL_UPDATE_DASHBOARD) {
		frameCount = 0;
		forceBarUpdate = YES;
	} else {
		forceBarUpdate = NO;
	}

    [self updateBar:hullBar   andTextValue:hullValue   
          withValue:[me hull] max:[[me ship] maxHull] inverseWarning:NO];
    [self updateBar:shieldBar andTextValue:shieldValue 
          withValue:[me shield] max:[[me ship] maxShield]
     inverseWarning:NO];
    [self updateBar:fuelBar   andTextValue:fuelValue   
          withValue:[me fuel] max:[[me ship] maxFuel] inverseWarning:NO];
    [self updateBar:eTempBar  andTextValue:eTempValue  
          withValue:[me engineTemp] / 10 max:[[me ship] maxEngineTemp] / 10
          inverseWarning:YES];
    [self updateBar:wTempBar  andTextValue:wTempValue  
          withValue:[me weaponTemp] / 10 max:[[me ship] maxWeaponTemp] / 10  
          inverseWarning:YES];
    [self updateBar:speedBar  andTextValue:speedValue  
          withValue:[me speed] max:[[me ship] maxSpeed] tempMax:[me maxSpeed] inverseWarning:YES];
    // special max armies is depended on the players kills
    [self updateBar:armiesBar andTextValue:nil    
          withValue:[me armies] max:[[me ship] maxArmies] tempMax:[me maxArmies] inverseWarning:NO];
    [self updateBar:torpsBar andTextValue:nil     
          withValue:[me availableTorps] max:[me maxTorps]
          inverseWarning:NO];
    [self updateBar:phasersBar andTextValue:nil   
          withValue:[me availablePhaserShots] max:[me maxPhaserShots] 
          inverseWarning:NO];
}

- (void) setKeyMap:(MTKeyMap *)newKeyMap {
    // pass it on
    [gameView setKeyMap:newKeyMap];
}

- (void) setPainter:(PainterFactory*)newPainter {
    [gameView setPainter:newPainter];
}

- (void) stopGame {
    [gameView stopTrackingMouse];
    [mapView stopTrackingMouse];
    
    // The optimizations may prevent sibling subviews from being displayed in the correct order—which matters only if the subviews 
    // overlap. You should always set flag to YES if there are no overlapping subviews within the NSWindow. The default is NO.
    [[gameView window] useOptimizedDrawing:NO];    
}

- (void) startGame {
    // set focus on main view
    // the view now reacts to mouse movements
    //[gameView dummyMouseAction];
    [gameView startTrackingMouse];
    [mapView startTrackingMouse];
    
    // The optimizations may prevent sibling subviews from being displayed in the correct order—which matters only if the subviews 
    // overlap. You should always set flag to YES if there are no overlapping subviews within the NSWindow. The default is NO.
    [[gameView window] useOptimizedDrawing:YES];
    
}

@end