//
//  GuiManager.m
//  MacTrek
//
//  Created by Aqua on 27/05/2006.
//  Copyright 2006 Luky Soft. All rights reserved.
//

#import "GuiManager.h"
//
// The GuiManger maintains (among others) the game state machine, or to be precise the state machine that handles
// the changes between the menus. It uses the following table to jump between states and specifies which events
// trigger a state change
//                     State          1          2          3          4          5          7          8
// Event                              no       server     server     slot       login      outfit     game
//                                  server    selected   contacted   found     accepted   accepted   entered
//                                 selected          
// MS_SERVER_SELECT                   2          2          2          2          2                    
// LOGIN button pressed                                                5          5                    
// CC_SERVER_CALL_SUCCESS                        3                                                  
// CC_SERVER_CALL_FAILED                         1                                                  
// CC_SLOT_FOUND                                            4                                        
// LM_LOGIN_INVALID_SERVER                                             1                              
// LM_LOGIN_COMPLETE                                                              7                              
// OM_ENTER_GAME                                                                             8          
// CC_GO_OUTFIT                                                                                        7
// CC_GO_LOGIN                                                                                         5
//
// AddOn: there actually is a state 0 (begin state) that shows the splashScreen. The Splash Screen waits for
//        a number of events before it raises the menu pane and allows the game to start 
//

@implementation GuiManager

bool clientRuns = NO;
int startUpEvents = 0;

- (id) init {
    self = [super init];
    if (self != nil) {
		
		// ROOT PLACE to turn Luky Softhreading off, only tested for guest login
		// turn only off for testing!
		multiThreaded = YES; 
		
        // setup our client
        //client = [[ClientController alloc] initWithUniverse:universe];
		client = [[ClientController alloc] init];
        currentServer = nil;
		
        // load the themes
        soundPlayerTheme1 = [[SoundPlayerForNetrek alloc] init];
        painterTheme1     = [[PainterFactoryForNetrek alloc] init];
        soundPlayerTheme2 = [[SoundPlayerForMacTrek alloc] init];
        painterTheme2     = [[PainterFactoryForMacTrek alloc] init];
        soundPlayerTheme3 = [[SoundPlayerForTac alloc] init];
        painterTheme3     = [[PainterFactoryForTac alloc] init];
        // pick a default
        soundPlayerActiveTheme = soundPlayerTheme1;
        painterActiveTheme = painterTheme1;
        activeTheme = -1;
        
        // reset gameState
        gameState = GS_NO_SERVER_SELECTED;
        
        // tag events
        [notificationCenter addObserver:self selector:@selector(serverSelected:) 
                                   name:@"MS_SERVER_SELECTED" object:nil];
        [notificationCenter addObserver:self selector:@selector(serverSlotFound) 
                                   name:@"CC_SLOT_FOUND" object:nil];
        [notificationCenter addObserver:self selector:@selector(serverDeSelected) 
                                   name:@"LC_INVALID_SERVER" object:nil];
        [notificationCenter addObserver:self selector:@selector(loginComplete) 
                                   name:@"LC_LOGIN_COMPLETE" object:nil];
        [notificationCenter addObserver:self selector:@selector(outfitAccepted) 
                                   name:@"SP_PICKOK" object:nil];
        [notificationCenter addObserver:self selector:@selector(loginComplete) 
                                   name:@"SP_PICKNOK" object:nil];
        // when killed
        [notificationCenter addObserver:self selector:@selector(iDied) 
                                   name:@"CC_GO_OUTFIT" object:nil];
		// or suicide
		//[notificationCenter addObserver:self selector:@selector(iDied) 
        //                           name:@"COMM_SEND_QUIT_REQ" object:nil];
		
        [notificationCenter addObserver:self selector:@selector(commError) 
                                   name:@"COMM_TCP_WRITE_ERROR" object:nil];
        // needed to keep polling for changed masks.. (at a very low rate)
        [notificationCenter addObserver:self selector:@selector(handleTeamMask:) 
                                   name:@"SP_MASK" object:nil];
        
        // startup events
        //[notificationCenter addObserver:self selector:@selector(increaseStartUpCounter) 
        //                           name:@"MS_SERVERS_READ"]; $$ sent, before i am observer..
        [notificationCenter addObserver:self selector:@selector(increaseStartUpCounter) 
                                   name:@"PF_IMAGES_CACHED"]; 
        [notificationCenter addObserver:self selector:@selector(increaseStartUpCounter) 
                                   name:@"SP_SOUNDS_CACHED"]; 
		
		// help pressed
		[notificationCenter addObserver:self selector:@selector(showKeyMapPanel) 
                                   name:@"GV_SHOW_HELP" object:nil];
		
		// message sent, move focus to gameview
		[notificationCenter addObserver:self selector:@selector(focusToGameView) 
                                   name:@"COMM_SEND_MESSAGE" object:nil];
				
		// shutdown
		[notificationCenter addObserver:self selector:@selector(shutdown) name:@"MC_MACTREK_SHUTDOWN"];

    }
    return self;
}

- (void) focusToGameView {
	[[gameCntrl gameView] makeFirstResponder];
}

- (void) shutdown {
	// kill all robots
	// leave some old code intact	
	[localServerCntrl stopServer:self];
	
	// but stop the new server too
	// should kill the robots as well
	[server stopServer];
}

// to be called..
- (void) playIntroSoundEffect {
    [soundPlayerActiveTheme playSoundEffect:@"INTRO_SOUND"];  
}

// Application delegate function
- (NSApplicationTerminateReply)applicationShouldTerminate:(NSApplication *)sender {
	[self shutdown];
	return NSTerminateNow;
}

- (void) increaseStartUpCounter {
    
    startUpEvents++;
    [startUpProgress setIntValue:startUpEvents];
    [startUpProgress setNeedsDisplay:YES];
    NSLog(@"GuiManager.increaseStartUpCounter got event %d of %d", startUpEvents, NR_OF_EVENTS_BEFORE_SHOWING_MENU);
    
    if (startUpEvents == NR_OF_EVENTS_BEFORE_SHOWING_MENU) {
        
        //[startUpProgress setHidden:YES];
        //[startUpProgress setNeedsDisplay:YES];
        [self playIntroSoundEffect];
        
        //[menuCntrl raiseMenu:self]; // $$ should be on mouseclick
        [menuButton setHidden:NO]; // enable going to the memu
        [menuButton setEnabled:YES];
        [menuButton setNeedsDisplay:YES];
        // or go automaticaly after 10 seconds (use obj nil since menu does not know us
        [menuCntrl  performSelector:@selector(leaveSplashScreen) withObject:nil afterDelay: 10];
        [splashView performSelector:@selector(stop:) withObject:self afterDelay: 10];
        
    } else if (startUpEvents > NR_OF_EVENTS_BEFORE_SHOWING_MENU) {
        
        NSLog(@"GuiManager.increaseStartUpCounter did not expect this event... %d", startUpEvents);
        [menuCntrl raiseMenu:self]; // $$ try..
    }    
}

- (void) awakeFromNib { 
    // set the startup bar value
    [startUpProgress setMaxValue:NR_OF_EVENTS_BEFORE_SHOWING_MENU];
    
    // set up a timer to redraw at FRAME_RATE 
    // since some data is updated outside the main loop and in the receive 
    // thread
    [NSTimer scheduledTimerWithTimeInterval: (1 / FRAME_RATE)
                                     target:self selector:@selector(screenRefreshTimerFired:)
                                   userInfo:nil 
                                    repeats:YES];
    // does the controller wait, or asks for reads herself...
    [loginCntrl setMultiThreaded:multiThreaded];
	
	// set the version string
	[versionString setStringValue:[NSString stringWithFormat:@"Version %@", VERSION]];
	NSLog(@"GuiManager.awakeFromNib Setting version to %@", VERSION);
		
	// new server controller. No longer managed with buttons but allways running!
	server = [[ServerControllerNew alloc] init];
	[server startServer];		// stop only on shutdown...
								// add localhost if it is not already there
	if ([selectServerCntrl findServer:@"localhost"] == nil) {
		MetaServerEntry *entry = [[MetaServerEntry alloc] init];
		[entry setAddress: @"localhost"];
		[entry setPort:    2592];
		[entry setStatus:  DEFAULT];
		[entry setGameType:    BRONCO];	
		[selectServerCntrl addServerPassivly:entry];  // gets selected automatically  
	}
	
}

- (void)handleTeamMask:(NSNumber *) mask {
    // we have received a new mask, as long as we are not in the game
    // the mask may change. So we keep an eye out for a change.
    if ((gameState == GS_LOGIN_ACCEPTED) && (!multiThreaded)) {
        // no outit done yet try 10ms delay
        NSLog(@"GuiManager.handleTeamMask firing up a read");
        [client performSelector: @selector(singleReadFromServer) 
                     withObject: self 
                     afterDelay: 1];
    }
}

- (void)screenRefreshTimerFired:(NSTimer*)theTimer {
    
   //static NSTimeInterval start, stop;
   //start = [NSDate timeIntervalSinceReferenceDate]; 
   //NSLog(@"GuiManager.screenRefreshTimerFired(slept): %f sec", (start-stop));        

    if (gameState == GS_GAME_ACTIVE) {
        // $$ this will work, but what about when we are killed?
        if (!multiThreaded) {
            //[notificationCenter setEnable:NO];
            [client singleReadFromServer]; // single threaded 
        }

        // after that, repaint
        [gameCntrl repaint];        
    } else {
        //[notificationCenter setEnable:YES];
    }
    //stop = [NSDate timeIntervalSinceReferenceDate];  
    //NSLog(@"GuiManager.screenRefreshTimerFired(spent): %f sec", (stop-start));
    //[mainWindow displayIfNeeded];   // not needed comm is now threadsafe 
}

- (void)serverSelected:(MetaServerEntry *) selectedServer {
    
    switch (gameState) {
        case GS_NO_SERVER_SELECTED:
        case GS_SERVER_SELECTED:
            // this event can also be a deselect 
            // handle it seperatly
            if (selectedServer == nil) {
                NSLog(@"GuiManager.serverSelected forwarding to deselect");
                [self serverDeSelected];
                return;
            }
            // when a server is selected, connect to it
            // to see if we can go to the login panel
            gameState = GS_SERVER_SELECTED;
            currentServer = selectedServer;
            
            // now initiate the step to the next state 
            [client stop];
            // run the client in the main thread (no seperate)
            if ([client startClientAt:[selectedServer address] 
                                 port:[selectedServer port] 
                             seperate:multiThreaded]) {
                // equals a CC_SERVER_CALL_SUCCESS
                NSLog(@"GuiManager.serverSelected connect to server successfull"); 
                // handle state entering
                if (multiThreaded) {            // other wise we have already a slot found
                   [self serverConnected]; 
                }
                            
            } else {
                // equals a CC_SERVER_CALL_FAILED
                NSLog(@"GuiManager.serverSelected cannot connect to server!");                
                // fall back to the first state
                [self serverDeSelected];
                // tell the selector that this server is no good
                [selectServerCntrl invalidServer];                
            }
            break;
        case GS_SERVER_CONNECTED:
        case GS_SERVER_SLOT_FOUND:
        case GS_LOGIN_ACCEPTED:
            // same server selected again?
            if (currentServer != selectedServer) {
                
                if (currentServer != nil) {
                     // close old connection
                    [self serverDeSelected];
                }
                // open to new
                [self serverSelected:selectedServer];
                currentServer = selectedServer;
            }
            break;
        case GS_OUTFIT_ACCEPTED:
        case GS_GAME_ACTIVE:
            NSLog(@"GuiManager.serverSelected unexpected gameState %d, reseting", gameState);
            [self serverDeSelected];
            [menuCntrl raiseMenu:self];
            break;
        default:
            NSLog(@"GuiManager.serverSelected unknown gameState %d", gameState);
            break;
    }  	
    
    NSLog(@"GuiManager.serverSelected GAMESTATE = %d", gameState);
}

- (void) serverDeSelected {
    // if no server was selected disable login cntrl
    gameState = GS_NO_SERVER_SELECTED;
    // stop connection
    [client stop];
    //[client release];
    // create an empty client
    //client = [[ClientController alloc] initWithUniverse:universe];
    // cannot login
    [menuCntrl disableLogin];
    [localServerCntrl disableLogin];
    [selectServerCntrl disableLogin];
    // when we can not type our name
    [loginCntrl disablePlayerName];
    [loginCntrl reset];
    currentServer = nil;
    // get's also called to force our state back to deselection
    // so make sure nothing is selected after all
    [selectServerCntrl deselectServer:self];
    
    NSLog(@"GuiManager.serverDeSelected GAMESTATE = %d", gameState);
}

- (void) serverConnected {

    switch (gameState) {

        case GS_SERVER_SELECTED:            
            // nothing sepecial,
            // wait for a slot found
            gameState = GS_SERVER_CONNECTED;
            break;
        case GS_SERVER_SLOT_FOUND:
            // sometimes this happens immideatly
            break;            
        case GS_SERVER_CONNECTED:
        case GS_OUTFIT_ACCEPTED:            
        case GS_GAME_ACTIVE:
        case GS_LOGIN_ACCEPTED:
        case GS_NO_SERVER_SELECTED:
            NSLog(@"GuiManager.serverConnected unexpected gameState %d, reseting", gameState);
            [self serverDeSelected];
            [menuCntrl raiseMenu:self];            
            break;
        default:
            NSLog(@"GuiManager.serverConnected unknown gameState %d", gameState);
            break;
    }
 
    
    NSLog(@"GuiManager.serverConnected GAMESTATE = %d", gameState);
}

- (void) serverSlotFound {
    switch (gameState) {
        case GS_NO_SERVER_SELECTED:

        case GS_OUTFIT_ACCEPTED:
            NSLog(@"GuiManager.serverSlotFound unexpected gameState %d, reseting", gameState);
            [self serverDeSelected];
            [menuCntrl raiseMenu:self];            
            break;
        case GS_SERVER_CONNECTED:
        case GS_SERVER_SELECTED:                // can happen because of seperate thread
        case GS_GAME_ACTIVE:                    // after a ghostbust, reconnect is done automatically
            gameState = GS_SERVER_SLOT_FOUND;
            // now we can login
            [menuCntrl enableLogin];
            [localServerCntrl enableLogin];
            [selectServerCntrl enableLogin];
            [loginCntrl enablePlayerName];
            [loginCntrl startClock];
            // raise login window automatically
            // [menuCntrl raiseLogin:self];
            
            // a successfull login moves us to the next state
            
            // send our settings to the server            
            if (![client sendSlotSettingsToServer]) {
                NSLog(@"GuiManager.serverSlotFound cannot send slot settings to server!");
                [self serverDeSelected];
            }
            break;
        default:
            NSLog(@"GuiManager.serverSlotFound unknown gameState %d", gameState);
            break;
    }
    
    NSLog(@"GuiManager.serverSlotFound GAMESTATE = %d", gameState);
}

- (void) iDied {
    // restore the cursor if needed
    if ([NSCursor currentCursor] == [NSCursor crosshairCursor]) {
        [[NSCursor crosshairCursor] pop];
    }
	[keyMapPanel close]; // remove the help screen
    [gameCntrl stopGame];
    [self loginComplete];
}

- (void) loginComplete {
    switch (gameState) {
        case GS_NO_SERVER_SELECTED:
        case GS_SERVER_SELECTED:
        case GS_SERVER_CONNECTED:
        case GS_OUTFIT_ACCEPTED:
            NSLog(@"GuiManager.loginComplete unexpected gameState %d, reseting", gameState);
            [self serverDeSelected];
            [menuCntrl raiseMenu:self]; 
            break;
        case GS_LOGIN_ACCEPTED: // when outfit is not accepted try again
            NSLog(@"GuiManager.loginComplete login was not accepted, try again");
            // a successfull outfit moves us to the next state
            break;
        case GS_SERVER_SLOT_FOUND:
            gameState = GS_LOGIN_ACCEPTED;
            // cannot login twice
            [menuCntrl disableLogin];
            [localServerCntrl disableLogin];
            [selectServerCntrl disableLogin];
            // when we can not type our name
            [loginCntrl disablePlayerName];
            // set the theme
			[self setTheme];
            // raise the outfit window automatically
            [menuCntrl raiseOutfit:self];
            // start with a empty login
            [outfitCntrl setInstructionFieldToDefault];
            // when we receive status messages, outfitCntrl updates the textfield 
            // only as long as we are in outfit!!!
            [notificationCenter addObserver:outfitCntrl selector:@selector(setInstructionField:) name:@"SP_WARNING"
                                     object:nil useLocks:NO useMainRunLoop:YES]; 
            // a successfull outfit moves us to the next state
            break;
        case GS_GAME_ACTIVE:    // if we are killed we get back here
            // start with a empty login
            [outfitCntrl setInstructionFieldToDefault];
            // when we receive status messages, outfitCntrl updates the textfield 
            // only as long as we are in outfit!!!
            [notificationCenter addObserver:outfitCntrl selector:@selector(setInstructionField:) name:@"SP_WARNING"
                                     object:nil useLocks:NO useMainRunLoop:YES]; 
            gameState = GS_LOGIN_ACCEPTED;
            // raise the outfit window automatically
            [menuCntrl raiseOutfit:self];
            // a successfull outfit moves us to the next state
            break;
        default:
            NSLog(@"GuiManager.loginComplete unknown gameState %d", gameState);
            break;
    }
    NSLog(@"GuiManager.loginComplete GAMESTATE = %d", gameState);
}

- (void) outfitAccepted {
    switch (gameState) {
        case GS_NO_SERVER_SELECTED:
        case GS_SERVER_SELECTED:
        case GS_SERVER_CONNECTED:
        case GS_OUTFIT_ACCEPTED:
        case GS_SERVER_SLOT_FOUND:
        case GS_GAME_ACTIVE:
            NSLog(@"GuiManager.outfitAccepted unexpected gameState %d, reseting", gameState);
            [self serverDeSelected];
			[menuCntrl setCanPlay:NO];
            [menuCntrl raiseMenu:self];            
            break;
        case GS_LOGIN_ACCEPTED:
            gameState = GS_OUTFIT_ACCEPTED;
            // let outfitCntrl stop listening to warnings
            [notificationCenter removeObserver:outfitCntrl name:@"SP_WARNING"];
            [outfitCntrl setInstructionFieldToDefault];
			[menuCntrl setCanPlay:YES];
            // activate the game
            [self gameEntered];
 
            break;
        default:
            NSLog(@"GuiManager.outfitAccepted unknown gameState %d", gameState);
            break;
    }
    NSLog(@"GuiManager.outfitAccepted GAMESTATE = %d", gameState);
}

- (void) gameEntered { 

    switch (gameState) {
        case GS_NO_SERVER_SELECTED:
        case GS_SERVER_SELECTED:
        case GS_SERVER_CONNECTED:
        case GS_LOGIN_ACCEPTED:
        case GS_SERVER_SLOT_FOUND:
        case GS_GAME_ACTIVE:
            NSLog(@"GuiManager.gameEntered unexpected gameState %d, reseting", gameState);
            [self serverDeSelected];
            [menuCntrl raiseMenu:self];            
            break;
        case GS_OUTFIT_ACCEPTED:     
            // save the keymap if it was changed
            [[settingsCntrl keyMap] writeToDefaultFileIfChanged];
            // first pass on the keyMap that was created in the settings
            [gameCntrl setKeyMap:[settingsCntrl keyMap]]; 
			[self fillKeyMapPanel];
            // and the volume setting
            [soundPlayerActiveTheme setVolumeFx:[settingsCntrl fxLevel]];
            [soundPlayerActiveTheme setVolumeMusic:[settingsCntrl musicLevel]];
            // go and play
            [menuCntrl raiseGame:self];
            [gameCntrl startGame];
            gameState = GS_GAME_ACTIVE;
            // a kill or error will get us out of the game  
            [soundPlayerActiveTheme playSoundEffect:@"ENTER_SHIP_SOUND"];
			[notificationCenter postNotificationName:@"GM_GAME_ENTERED"];
            break;
        default:
            NSLog(@"GuiManager.gameEntered unknown gameState %d", gameState);
            break;
    }
    NSLog(@"GuiManager.gameEntered GAMESTATE = %d", gameState);
}

- (void) commError { 
    switch (gameState) {
        case GS_NO_SERVER_SELECTED:
        case GS_SERVER_SELECTED:
            break;                      // queued events 
        case GS_SERVER_CONNECTED:
        case GS_LOGIN_ACCEPTED:
        case GS_SERVER_SLOT_FOUND:
        case GS_GAME_ACTIVE:
        case GS_OUTFIT_ACCEPTED:
            NSLog(@"GuiManager.commError unexpected (gameState %d), reseting", gameState);
			[keyMapPanel close]; // remove the help screen
            [self serverDeSelected];
			[menuCntrl disableLogin];
            [menuCntrl raiseMenu:self];            
            break;
        default:
            NSLog(@"GuiManager.gameEntered unknown gameState %d", gameState);
            break;
    }
    NSLog(@"GuiManager.commError GAMESTATE = %d", gameState);
}

- (void) setTheme {
    
    // we are not yet setting the mapview to a themed painter,
    // can do so in the future if desired.    
    int theme = [settingsCntrl graphicsModel] + 1; // we count 1,2,3 graphicsModel starts at 0
    bool shouldSpeak = [settingsCntrl voiceEnabled];
	bool accel = [settingsCntrl accelerate];
    
    if (theme != activeTheme) {
        NSLog(@"GuiManager.setTheme to theme %d", theme);
        switch (theme) {
        case 1:            
            [gameCntrl setPainter:painterTheme1];
            painterActiveTheme = painterTheme1;
            [soundPlayerActiveTheme unSubscibeToNotifications]; // silence
            soundPlayerActiveTheme = soundPlayerTheme1;
            [soundPlayerActiveTheme subscribeToNotifications];  // activate            
            break;
        case 2:            
            [gameCntrl setPainter:painterTheme2];
            painterActiveTheme = painterTheme2;
            [soundPlayerActiveTheme unSubscibeToNotifications]; // silence
            soundPlayerActiveTheme = soundPlayerTheme2;
            [soundPlayerActiveTheme subscribeToNotifications];  // activate
            break;
        case 3:            
            [gameCntrl setPainter:painterTheme3];
            painterActiveTheme = painterTheme3;
            [soundPlayerActiveTheme unSubscibeToNotifications]; // silence
            soundPlayerActiveTheme = soundPlayerTheme3;
            [soundPlayerActiveTheme subscribeToNotifications];  // activate            
            break;            
        default:
            NSLog(@"GuiManager.setTheme ERROR, do not know of theme %d", theme);
            break;
        }
		activeTheme = theme;
		[gameCntrl setSpeakComputerMessages:shouldSpeak];
		[painterActiveTheme setAccelerate:accel];
    }
    
    [soundPlayerActiveTheme setVolumeFx:[settingsCntrl fxLevel]]; 
	[outfitCntrl setActivePainter:painterActiveTheme];
	
    if ([settingsCntrl fxLevel] == 0.0) {
        // special case disable all sound
        [soundPlayerActiveTheme unSubscibeToNotifications]; // silence
        NSLog(@"GuiManager.setTheme silencing SOUND");
    }
}

- (void) showKeyMapPanel {
	// toggle position
	if ([keyMapPanel isVisible]) {
		[keyMapPanel close];
	} else {
		[keyMapPanel orderFront:self];
	}		
}

- (void) fillKeyMapPanel {
	NSLog(@"GuiManager.fillKeyMapPanel setting keymap in help panel");

	NSMutableString *result = [[[NSMutableString alloc] init] autorelease];
	MTKeyMap *keyMap = [settingsCntrl keyMap];
	NSArray *actionKeys = [keyMap allKeys];

	for (int i = 0; i < [actionKeys count]; i++) {
		int action = [[actionKeys objectAtIndex:i] intValue];
		[result appendString:[NSString stringWithFormat:@"%c - %@\n", 
			[keyMap keyForAction:action], [keyMap descriptionForAction:action]]];
    }
		
	[keyMapList setString:result];
}


// demo 
/*
- (void) play {
    [jtrekCntrl setServer:[selectServerCntrl selectedServer]];
    [jtrekCntrl play:self];
}
*/
@end
