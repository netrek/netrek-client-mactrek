//
//  ClientController.h
//  MacTrek
//
//  Created by Aqua on 5/19/06.
//  Copyright 2006 Luky Soft. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "Data.h"
#import "Comm.h"
#import "LLNotificationCenter.h"
#import "BaseClass.h"


@interface ClientController : BaseClass {
	Communication *communication;
}

- (void)iDied:(Player *)me;
- (id)  initWithUniverse:(Universe*)newUniverse;
- (void)singleReadFromServer;
- (bool)startClientAt:(NSString *)server port:(int)port seperate:(bool)multiThread;
- (bool)sendSlotSettingsToServer;
- (void)stop;

@end
