//
//  BaseView.m
//  MacTrek
//
//  Created by Aqua on 24/07/2006.
//  Copyright 2006 Luky Soft. All rights reserved.
//

#import "BaseView.h"


@implementation BaseView

- (void) awakeFromNib {
    
    notificationCenter = [LLNotificationCenter defaultCenter];
    universe = [Universe defaultInstance];
    [self allocateGState]; // efficient, but memory hog
}

// view and window exist, add rects
- (void) viewDidMoveToWindow {

    // resetCursorRects should be called automatically
    [self startTrackingMouse];     
}

- (void) stopTrackingMouse {
    [self removeTrackingRect:myCursorRect];
}

- (void) startTrackingMouse {
    // first remove old one
    [self stopTrackingMouse];
    
    // add a tracking rectangle so we get mouseEnter and mouseExit events
    bool mouseInView = NSPointInRect([self mousePos], [self bounds]);
    myCursorRect = [self addTrackingRect:[self bounds] owner:self userData:nil assumeInside:mouseInView];
    if (mouseInView) { // fire inital event
        [self mouseEntered:nil];
    }
}

/*
- (void) resetCursorRects {
    [self addCursorRect:[self bounds] cursor:[NSCursor crosshairCursor]];
}
*/

// old style cursor change, but works
// default behaviour = focus follows mouse
- (void) mouseEntered:(NSEvent*)evt {
    NSLog(@"BaseView.mouseEntered making myself first responder");
    [[self window] makeFirstResponder:self];
    [[NSCursor crosshairCursor] push];
}

- (void) mouseExited:(NSEvent*)evt {
    NSLog(@"BaseView.mouseExited resigning myself as first responder");
    [[self window] resignFirstResponder];
    [[NSCursor crosshairCursor] pop];
}

- (NSPoint) mousePos {
    // get mouse point in window
    NSPoint mouseBase = [[self window] mouseLocationOutsideOfEventStream];
    
    // convert to GameView coordinates
    NSPoint mouseLocation = [self convertPoint:mouseBase fromView:nil];
    
    return mouseLocation;
}

- (bool) acceptsFirstMouse {
    return YES; // $$ check...
}

- (bool) isOpaque{
    return YES; // speed bump
}

- (bool) opaque{
    return YES; // speed bump
}

// old X11 calls were flipped
- (bool) isFlipped {
    return YES;
}


// i will accept key and mouse input
- (bool) acceptsFirstResponder {
    return YES;
}

// and i will accept it now
- (bool) becomeFirstResponder {
    [self setNeedsDisplay:YES];
    /* not needed, done by trackingRect and mouseEnter
    if([[self window] makeFirstResponder:self]) { // make this view first responder
        NSLog(@"BaseView.becomeFirstResponder OK");
    } else {
        NSLog(@"BaseView.becomeFirstResponder failed");
    }
     */ 
    NSLog(@"BaseView.becomeFirstResponder ok i accept");
    return YES; // always accept
}

- (bool) resignFirstResponder {
    [self setNeedsDisplay:YES];
    NSLog(@"BaseView.resignFirstResponder ok i resign");
    return [super resignFirstResponder];
}


@end
