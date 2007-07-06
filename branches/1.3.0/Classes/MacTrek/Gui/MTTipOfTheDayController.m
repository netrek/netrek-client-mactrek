//
//  MTTipOfTheDayController.m
//  MacTrek
//
//  Created by Chris & Judith Lukassen on 26/05/2007.
//  Copyright 2007 Luky Soft. All rights reserved.
//

#import "MTTipOfTheDayController.h"


@implementation MTTipOfTheDayController

- (void) setUpWindow {
	
	if (!tipOfTheDayWindowController) {
		tipOfTheDayWindowController = [[LLHUDWindowController alloc] init];
		
		// create a window
		NSSize windowSize = NSMakeSize(325.0, 325.0);
		
		// mid of full screen
		NSSize screenSize = [[NSScreen mainScreen] frame].size;
		NSRect windowFrame = NSMakeRect(((screenSize.width - windowSize.width) / 2), (screenSize.height - windowSize.height) / 2, windowSize.width, windowSize.height);
		
		[tipOfTheDayWindowController createWindowWithTextFieldInFrame:windowFrame];
	}
	
	[[tipOfTheDayWindowController window] setTitle:@"Tip of the day"];
	
	LLLog(@"MTTipOfTheDayController.setUpWindow: DONE");
}

- (id) init {
	self = [super init];
	if (self != nil) {
		tipOfTheDayWindowController = nil;
		[self setUpWindow];
		tips = [[NSArray alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/tips.plist", [[NSBundle mainBundle] resourcePath]]];
	}
	return self;
}


- (void) showTip {
	
	NSString *tipOfTheDay;
	
	if ([tips count] > 0) {
		long tipNr = random() % [tips count];
		tipOfTheDay = [tips objectAtIndex:tipNr];
	} else {
		tipOfTheDay = @"Did you know: your tips file is as empty as the void of space";
	}
	
	[[tipOfTheDayWindowController textField] setStringValue:tipOfTheDay];
	[[tipOfTheDayWindowController window] orderFront:self];
}



@end
