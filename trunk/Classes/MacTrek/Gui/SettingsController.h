//
//  SettingsController.h
//  MacTrek
//
//  Created by Aqua on 26/05/2006.
//  Copyright 2006 Luky Soft. See Licence.txt for licence details.
//

#import <Cocoa/Cocoa.h>
#import "KeyMapTableDataSource.h"
#import "LLPersistantSettings.h"

#define GRAPHICS_MODEL_NETREK  0
#define GRAPHICS_MODEL_MACTREK 1
#define GRAPHICS_MODEL_TAC     2

@interface SettingsController : KeyMapTableDataSource {
    IBOutlet NSSlider              *musicLevel;
    IBOutlet NSSlider              *fxLevel;
    IBOutlet NSSegmentedControl    *graphicsModel;  
    IBOutlet NSButton              *voiceOver;
	IBOutlet NSButton              *voiceCmds;
	IBOutlet NSButton              *accelerateButton;
	IBOutlet NSButton              *trackingEnabledButton;
    // the Back button is covered by the menu controller
}

- (bool)  trackingEnabled;
- (bool)  soundEnabled;
- (bool)  voiceEnabled;
- (bool) voiceCommands;
- (bool)  accelerate;
- (float) musicLevel;
- (float) fxLevel;
- (int)   graphicsModel;
- (void)  setPreviousValues;
- (void)  saveSettings;

@end
