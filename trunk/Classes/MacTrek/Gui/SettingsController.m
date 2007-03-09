//
//  SettingsController.m
//  MacTrek
//
//  Created by Aqua on 26/05/2006.
//  Copyright 2006 Luky Soft. See Licence.txt for licence details.
//

#import "SettingsController.h"


@implementation SettingsController

- (void) awakeFromNib {
    [notificationCenter addObserver:self selector:@selector(saveSettings) name:@"MC_LEAVING_SETTINGS"];
    [self setPreviousValues];
	
	// actionKeyMap uses default KeyMap
	MTKeyMap *actionKeyMap = [[MTKeyMap alloc] init];
	[actionKeyMap readDefaultKeyMap];
	[actionKeyMapDataSource setKeyMap:actionKeyMap];
	
	// distressMap uses default KeyMap
	MTDistressKeyMap *distressKeyMap = [[MTDistressKeyMap alloc] init];
	[distressKeyMap readDefaultKeyMap];
	[distressKeyMapDataSource setKeyMap:distressKeyMap];	
}

- (MTKeyMap*) actionKeyMap {
	return [actionKeyMapDataSource keyMap];
}

- (MTKeyMap*) distressKeyMap {
	return [distressKeyMapDataSource keyMap];
}

- (void) setPreviousValues {
    LLPersistantSettings *settings = [LLPersistantSettings defaultSettings];
	
    NSNumber *val;
    
    val = [settings valueForKey:@"MUSIC_LEVEL"];
    if (val != nil) {
        [musicLevel setFloatValue:[val floatValue]];
    }
    val = [settings valueForKey:@"FX_LEVEL"];
    if (val != nil) {
        [fxLevel setFloatValue:[val floatValue]];
    }
	val = [settings valueForKey:@"VOICE_CMDS"];
    if (val != nil) {
        if ([val boolValue]) {
			[voiceCmds setState:NSOnState];   
        } else {
            [voiceCmds setState:NSOffState];
        }        
    }
    val = [settings valueForKey:@"VOICE_OVER"];
    if (val != nil) {
        if ([val boolValue]) {
           [voiceOver setState:NSOnState];   
        } else {
            [voiceOver setState:NSOffState];
        }        
    }
	val = [settings valueForKey:@"ACCELERATE"];
    if (val != nil) {
        if ([val boolValue]) {
			[accelerateButton setState:NSOnState];   
        } else {
            [accelerateButton setState:NSOffState];
        }        
    }
    val = [settings valueForKey:@"THEME"];
    if (val != nil) {
        [graphicsModel setSelectedSegment:[val intValue]];
    }
	val = [settings valueForKey:@"TRACKING"];
    if (val != nil) {
        if ([val boolValue]) {
			[trackingEnabledButton setState:NSOnState];   
        } else {
            [trackingEnabledButton setState:NSOffState];
        }        
    }
	// set the mouse settings too FR 1666849
	val = [settings valueForKey:@"LEFT_MOUSE"];
    if (val != nil) {
        [leftMouse selectItemWithTitle:[self stringForAction:[val intValue]]];
    }
	val = [settings valueForKey:@"MIDDLE_MOUSE"];
    if (val != nil) {
        [middleMouse selectItemWithTitle:[self stringForAction:[val intValue]]];
    }
	val = [settings valueForKey:@"RIGHT_MOUSE"];
    if (val != nil) {
        [rightMouse selectItemWithTitle:[self stringForAction:[val intValue]]];
    }
	val = [settings valueForKey:@"WHEEL_MOUSE"];
    if (val != nil) {
        [wheelMouse selectItemWithTitle:[self stringForAction:[val intValue]]];
    }
		
	// set internal tracker state
	[[SimpleTracker defaultTracker] setEnabled:[self trackingEnabled]];
}

- (void) saveSettings {
    
	LLLog(@"SettingsController.saveSettings called");
    LLPersistantSettings *settings = [LLPersistantSettings defaultSettings];
    
    [settings setLazyValue:[NSNumber numberWithFloat:[self musicLevel]] forKey:@"MUSIC_LEVEL"];
    [settings setLazyValue:[NSNumber numberWithFloat:[self fxLevel]] forKey:@"FX_LEVEL"];
	[settings setLazyValue:[NSNumber numberWithBool:[self voiceCommands]] forKey:@"VOICE_CMDS"];
    [settings setLazyValue:[NSNumber numberWithBool:[self voiceEnabled]] forKey:@"VOICE_OVER"];
	[settings setLazyValue:[NSNumber numberWithBool:[self accelerate]] forKey:@"ACCELERATE"];
    [settings setLazyValue:[NSNumber numberWithInt:[self graphicsModel]] forKey:@"THEME"];   
	[settings setLazyValue:[NSNumber numberWithBool:[self trackingEnabled]] forKey:@"TRACKING"];
	
	// get the mouse settings too FR 1666849
	MTMouseMap *mouseMap = [self mouseMap];
	[settings setLazyValue:[NSNumber numberWithInt:[mouseMap actionMouseLeft]] forKey:@"LEFT_MOUSE"];
	[settings setLazyValue:[NSNumber numberWithInt:[mouseMap actionMouseMiddle]] forKey:@"MIDDLE_MOUSE"];
	[settings setLazyValue:[NSNumber numberWithInt:[mouseMap actionMouseRight]] forKey:@"RIGHT_MOUSE"];
	[settings setLazyValue:[NSNumber numberWithInt:[mouseMap actionMouseWheel]] forKey:@"WHEEL_MOUSE"];
	
    [settings update];
	
	// an excellent place to tell the tracker what the status is
	[[SimpleTracker defaultTracker] setEnabled:[self trackingEnabled]];
	
	// and the keymaps of course
	// BUG 1674341
	[[self actionKeyMap] writeToDefaultFileIfChanged];
	[[self distressKeyMap] writeToDefaultFileIfChanged];
}


- (bool)  trackingEnabled {
	return ([trackingEnabledButton state] == NSOnState);
}

- (float)  musicLevel {
    return [musicLevel floatValue];
}

- (float)  fxLevel {
    return [fxLevel floatValue];
}

- (bool) soundEnabled {
    if (([musicLevel intValue] > 0) ||  ([fxLevel intValue] > 0)) {
        return YES;
    } else {
        return NO;
    }
}

- (bool) accelerate {
    return ([accelerateButton state] == NSOnState);
}

- (bool) voiceCommands {
    return ([voiceCmds state] == NSOnState);
}

- (bool) voiceEnabled {
    return ([voiceOver state] == NSOnState);
}

- (int)  graphicsModel {
    return [graphicsModel selectedSegment];
}

- (NSString *) stringForAction:(int) action {
	
	switch (action) {
	case ACTION_SET_COURSE:
		return @"Course";
		break;
	case ACTION_FIRE_PHASER:
		return @"Phaser";
		break;
	case ACTION_FIRE_TORPEDO:
		return @"Torpedo";
		break;
	case ACTION_ZOOM:
		return @"Zoom";
		break;
	default:
		LLLog(@"SettingsController.stringForAction action %d unknown", action);
		return nil;
		break;
	}
}

- (int) actionForButton:(NSPopUpButton *) button {
	if ([[[button selectedItem] title] isEqualToString:@"Course"] ) {
		return ACTION_SET_COURSE;
	} else if ([[[button selectedItem] title] isEqualToString:@"Torpedo"] ) {
		return ACTION_FIRE_TORPEDO;
	} else if ([[[button selectedItem] title] isEqualToString:@"Phaser"] ) {
		return ACTION_FIRE_PHASER;
	} else if ([[[button selectedItem] title] isEqualToString:@"Zoom"] ) {
		return ACTION_ZOOM;
	} else {
		LLLog(@"SettingsController.actionForButton item %@ unknown", [[button selectedItem] title]);
		// @@@ dirty hack BUG 1674341
		// this gets called by accident if the back button is pressed in the settings pane
		// (probably more often) easy place to save the settings though
		// $$$ side effect cannot fire torps with mouse .... (strange)
		//[[self keyMap] writeToDefaultFileIfChanged];
		return -1;
	}
}

- (MTMouseMap *)mouseMap {
	
	MTMouseMap *mouseMap = [[[MTMouseMap alloc] init] autorelease];
	
	[mouseMap setActionMouseLeft:[self actionForButton:leftMouse]];
	[mouseMap setActionMouseRight:[self actionForButton:rightMouse]];
	[mouseMap setActionMouseMiddle:[self actionForButton:middleMouse]];
	[mouseMap setActionMouseWheel:[self actionForButton:wheelMouse]];
	
	return mouseMap;	
}

@end
