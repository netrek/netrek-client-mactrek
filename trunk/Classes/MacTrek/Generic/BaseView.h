//
//  BaseView.h
//  MacTrek
//
//  Created by Aqua on 24/07/2006.
//  Copyright 2006 Luky Soft. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "Luky.h"
#import "Universe.h"


@interface BaseView : NSView {
    LLNotificationCenter *notificationCenter;
    Universe *universe;
    NSTrackingRectTag myCursorRect;
}

- (NSPoint) mousePos;
- (void) stopTrackingMouse;
- (void) startTrackingMouse;

@end
