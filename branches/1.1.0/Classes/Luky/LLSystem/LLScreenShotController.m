//
//  LLScreenShotController.m
//  MacTrek
//
//  Created by Chris & Judith Lukassen on 9/6/06.
//  Copyright 2006 Luky Soft. All rights reserved.
//

#import "LLScreenShotController.h"


@implementation LLScreenShotController
- (id) init {
    self = [super init];
    if (self != nil) {
        process = nil;
		counter = 0;
		isRunning = NO;
    }
    return self;
}

- (bool)snap {
    
	NSLog(@"LLScreenShotController.snap %d", counter);
	
    if (isRunning) {
        // still running? 
		return NO;
    } else {	
		isRunning = YES;
		// clean up
		[process release];
		process = nil;
		
		// create
		NSString *arg = [[NSString stringWithFormat:@"~/Desktop/shot-%d.png", [NSDate timeIntervalSinceReferenceDate]] stringByExpandingTildeInPath];
		process = [[LLTaskWrapper alloc] initWithController:self 
                                              arguments:[NSArray arrayWithObjects: @"/usr/sbin/screencapture", 
                                                  arg, nil]]; 
		counter++;
        [process startProcess];
		NSLog(@"LLScreenShotController.snap with name %@", arg);
		return YES;
    }
}

- (void)processStarted:(id)task {
    NSLog(@"LLScreenShotController.processStarted");
}

- (void)processFinished:(id)task {
    NSLog(@"LLScreenShotController.processFinished:  done");
	isRunning = NO;
}

- (void)appendOutput:(NSString *)output fromTask:(id) task {
	return;
}

@end
