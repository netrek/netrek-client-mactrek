//
//  Entity.h
//  MacTrek
//
//  Created by Aqua on 27/04/2006.
//  Copyright 2006 Luky Soft. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "SimpleBaseClass.h"
#import "SimpleTracker.h"

@interface Entity : SimpleBaseClass {
    NSPoint position;
	float dir;									// Real direction
	int speed;									// Real speed
    float requestedDir;							
	int   requestedSpeed;	
    bool  showInfo;
    int fuse;						// Life left in current state
    int maxfuse;					// max fuse, normalized for updates per second 
    int step; // steps in fuse
    NSString *labelKey;
    NSImage *label;
	NSMutableArray *history;
	SimpleTracker *tracker;
	NSString *ident;
}

- (void) setNetrekFormatCourse:(char)newDir;
- (void) setPosition:(NSPoint)pos;
- (void) setCourse:(int)course;
- (void) setSpeed:(int)speed;
- (void) setRequestedCourse:(int)course;
- (void) setRequestedSpeed:(int)speed;
- (void) setShowInfo:(bool)show;
- (void) setFuse:(int)newLevel;
- (void) setMaxFuse:(int)newLevel;
- (void) setFuseStep:(int)newLevel;

// internal
- (void) trackUpdate;
- (NSString*) ident;

// cache complex drawing
- (NSString*) labelKey;
- (NSImage*)  label;
- (bool)      setLabel:(NSImage*)label forKey:(NSString *)labelKey;
- (NSImage*)  labelForKey:(NSString *)labelKey;

- (int)  fuse;
- (int)  maxfuse;
- (NSPoint) position;
- (NSPoint) predictedPosition;
- (int) course;
- (char) netrekFormatCourse;
- (float) dirInRad;
- (int) speed;
- (int) requestedCourse;
- (int) requestedSpeed;
- (int) predictedCourse;
- (bool)showInfo;
- (void) increaseFuse;
- (void) decreaseFuse;
- (void) resetFuse;

@end
