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
#import "MTMouseMap.h"
#import "Luky.h"
#import "BaseClass.h"
#import "MTDistressKeyMap.h"
#import "MenuController.h"

#define GRAPHICS_MODEL_NETREK  0
#define GRAPHICS_MODEL_MACTREK 1
#define GRAPHICS_MODEL_TAC     2

@interface SettingsController : BaseClass {
    IBOutlet NSSlider              *musicLevel;
    IBOutlet NSSlider              *fxLevel;
    IBOutlet NSSegmentedControl    *graphicsModel;  
    IBOutlet NSButton              *voiceOver;
	IBOutlet NSButton              *voiceCmds;
	IBOutlet NSButton              *accelerateButton;
	IBOutlet NSButton              *trackingEnabledButton;
	
	IBOutlet NSPopUpButton		   *leftMouse;
	IBOutlet NSPopUpButton		   *rightMouse;
	IBOutlet NSPopUpButton		   *middleMouse;
	IBOutlet NSPopUpButton		   *wheelMouse;
	
	IBOutlet KeyMapTableDataSource *actionKeyMapDataSource;
	IBOutlet KeyMapTableDataSource *distressKeyMapDataSource;
}

- (MTKeyMap*) distressKeyMap;
- (MTKeyMap*) actionKeyMap;

- (bool)  trackingEnabled;
- (bool)  soundEnabled;
- (bool)  voiceEnabled;
- (bool)  voiceCommands;
- (bool)  accelerate;
- (float) musicLevel;
- (float) fxLevel;
- (int)   graphicsModel;
- (void)  setPreviousValues;
- (void)  saveSettings;
- (int)   actionForButton:(NSPopUpButton *) button;
- (NSString *) stringForAction:(int) action;
- (MTMouseMap *)mouseMap;
  

@end
