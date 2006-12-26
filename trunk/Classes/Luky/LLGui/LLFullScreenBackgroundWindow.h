//
//  FullScreenBackgroundWindow.h
//  MacTrek
//
//  Created by Aqua on 16/04/2006.
//  Copyright 2006 Luky Soft. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "LLObject.h"

@interface LLFullScreenBackgroundWindow : NSWindow {
	bool canBecomeKeyWindow;
}

- (void) setCanBecomeKeyWindow:(bool)can;

@end
