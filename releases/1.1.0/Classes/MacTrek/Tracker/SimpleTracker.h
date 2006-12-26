//
//  SimpleTracker.h
//  MacTrek
//
//  Created by Chris & Judith Lukassen on 19/11/2006.
//  Copyright 2006 Luky Soft. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "SimpleBaseClass.h"
#import "TrackUpdate.h"
#import "LLTrigonometry.h"

// number of history to maintain
#define TRACK_HISTORY 10
// pixels in gamegrid per second
#define WARP1 200

@interface SimpleTracker : SimpleBaseClass {
	bool enabled;
	NSDate* referenceTime;
	LLTrigonometry *geoCalc;
}

+ (SimpleTracker*) defaultTracker;
- (bool) enabled;
- (void) setEnabled:(bool)onOff;
- (NSDate*)referenceTime;
- (void) setReferenceTime:(NSDate*)time;
- (NSPoint) positionForHistory:(NSMutableArray*)history;
- (NSPoint) positionAtTime:(NSDate*)time forHistory:(NSMutableArray*)history;

@end
