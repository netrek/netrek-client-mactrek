//
//  ServerControllerNew.m
//  MacTrek
//
//  Created by Chris & Judith Lukassen on 14/12/2006.
//  Copyright 2006 Luky Soft. All rights reserved.
//

#import "ServerControllerNew.h"


@implementation ServerControllerNew

- (void)startServer {
    
	NSString *cpuType;
	
	// see what we are
	if ([LLSystemInformation isPowerPC]) {
		cpuType = @"PPC";
	} else {
		cpuType = @"INTEL";
	}
	
	NSLog(@"ServerControllerNew.startServer selecting %@", cpuType);
	
    NSString *pathToResources = [[NSBundle mainBundle] resourcePath];
    NSString *pathToServer = [NSString stringWithFormat:@"%@/PRECOMPILED/%@/bin/netrekd", cpuType, pathToResources];
    NSString *pathToLog = [NSString stringWithFormat:@"%@/PRECOMPILED/%@/var/log", pathToResources];
    
    if (serverTask != nil) {
        // still running? stop the server with restart, this will
        // start the server again after it is properly stoped
        [serverTask stopProcess];
        restartServer = YES;        
    } else {
		// clean start
        serverTask = [[LLTaskWrapper alloc] initWithController:self 
													 arguments:[NSArray arrayWithObjects:pathToServer, nil] ];
        [serverTask startProcess];
    }
    
    if (logTask != nil) {
        [logTask stopProcess];
        restartLog = YES;        
    } else {
        logTask = [[LLTaskWrapper alloc] initWithController:self 
												  arguments:[NSArray arrayWithObjects:@"/usr/bin/tail",
													  @"-f", pathToLog, nil] ];
        [logTask startProcess];         
    }
	
}

@end
