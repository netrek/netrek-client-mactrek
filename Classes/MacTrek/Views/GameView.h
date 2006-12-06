//
//  GameView.h
//  MacTrek
//
//  Created by Aqua on 02/06/2006.
//  Copyright 2006 Luky Soft. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "MTKeyMap.h"
#import "BaseView.h"
#import "Luky.h"
#import "Data.h"
#import "PainterFactory.h"
#import "PainterFactoryForNetrek.h"
#import "Carbon/Carbon.h"
#import "LLScreenShotController.h"

#define FRAME_RATE  20 
#define MAX_WAIT_BEFORE_DRAW  (1/(2*FRAME_RATE)) 

// 10%
#define GV_SCALE_STEP 0.1

// input modes
#define GV_NORMAL_MODE	0
#define GV_MESSAGE_MODE	1
#define GV_MACRO_MODE	2
#define GV_REFIT_MODE	3
#define GV_WAR_MODE		4

@interface GameView : BaseView {
    MTKeyMap *keyMap;
	char warMask;
	Team *warTeam;
    int scale;
    int inputMode;
    float step;
    LLTrigonometry *trigonometry;
    PainterFactory *painter;
    Entity  *angleConvertor; // use this class to convert between netrek and our courses
    LLScreenShotController *screenshotController;
    bool busyDrawing;
}

- (void) setPainter:(PainterFactory*)newPainter;

- (NSPoint) gamePointRepresentingCentreOfView; // override if i am not in center

- (void) setScaleFullView;  // overrules scale setting
- (void) setScale:(int)scale;
- (int)  scale;

- (void) setKeyMap:(MTKeyMap *)newKeyMap;

-(float) mouseDir;

- (void) sendSpeedReq:(int)speed;
- (bool) performAction:(int) action;

- (void) normalModeKeyDown:(NSEvent *)theEvent;
- (void) messageModeKeyDown:(NSEvent *)theEvent;
- (void) macroModeKeyDown:(NSEvent *)theEvent;
- (void) refitModeKeyDown:(NSEvent *)theEvent;
- (void) warModeKeyDown:(NSEvent *)theEvent;
- (void) makeFirstResponder;

@end
