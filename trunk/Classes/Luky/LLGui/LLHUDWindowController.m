//
//  AppController.m
//  HUDWindow
//
//  Created by Matt Gemmell on 11/03/2006.
//  Copyright 2006 Magic Aubergine. All rights reserved.
//

#import "LLHUDWindowController.h"

@implementation LLHUDWindowController

- (void)awakeFromNib
{
    // Make a rect to position the window at the top-right of the screen.
    NSSize windowSize = NSMakeSize(325.0, 765.0);
    NSSize screenSize = [[NSScreen mainScreen] frame].size;
    //NSRect windowFrame = NSMakeRect(screenSize.width - windowSize.width - 10.0, 
	//screenSize.height - windowSize.height, // - [NSMenuView menuBarHeight] - 10.0 
	//	windowSize.width, windowSize.height);
	
	// left side full screen
	NSRect windowFrame = NSMakeRect(0, screenSize.height - windowSize.height, windowSize.width, windowSize.height);
    
    // Create a HUDWindow.
    // Note: the styleMask is ignored; NSBorderlessWindowMask is always used.
    window = [[LLHUDWindow alloc] initWithContentRect:windowFrame 
                                          styleMask:NSBorderlessWindowMask 
                                            backing:NSBackingStoreBuffered 
                                              defer:NO];
    
    // Add some text to the window.
    //float textHeight = 20.0;
    //textField = [[NStextField alloc] initWithFrame:NSMakeRect(0.0, (windowSize.height / 2.0) - (textHeight / 2.0), windowSize.width, textHeight)];	
	textField = [[NSTextField alloc] initWithFrame:NSMakeRect(10.0, 0.0, windowSize.width, windowSize.height - 20.0)];

    [[window contentView] addSubview:textField];
    [textField setEditable:NO];
    [textField setTextColor:[NSColor whiteColor]];
    [textField setDrawsBackground:NO];
    [textField setBordered:NO];
    //[textField setAlignment:NSCenterTextAlignment];
    //[textField setString:@"Some sample text"];
    //[textField release];  // keep it around so we can change the contents
    
    // Set the window's title and display it.
    [window setTitle:@"Default title"];
    //[window orderFront:self]; // initially hide ourselfs
}

-(NSTextField*) textField {
	return textField;
}

-(LLHUDWindow*) window {
	return window;
}

@end
