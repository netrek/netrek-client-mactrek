//
//  SelectServerController.m
//  MacTrek
//
//  Created by Aqua on 26/05/2006.
//  Copyright 2006 Luky Soft. All rights reserved.
//

#import "SelectServerController.h"


@implementation SelectServerController

bool validServer; 

- (id) init {
    self = [super init];
    if (self != nil) {

    }
    return self;
}


- (void) awakeFromNib {

    // verify did end typinh
    [[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(manualEntryDidEndEditing:)
												 name:@"NSControlTextDidEndEditingNotification"
											   object:serverNameTextField];    
}

- (void) invalidServer {
    NSLog(@"SelectServerController.invalidServer called");
    // can not use [self setServerSelected:nil] because it would generate another event
    // MS_SERVER_SELECTED which would trigger a connect, which would be invalid which would ...
    validServer = NO;
    // setServerSelected will take it from here
}

- (void) disableLogin {
    [loginButton setEnabled:NO];
}
- (void) enableLogin {
    [loginButton setEnabled:YES];
}

- (void) deselectServer:(id)sender {
    [super deselectServer];
    [serverNameTextField setStringValue:@""];
}

- (void) setServerSelected:(MetaServerEntry *) server {
    

    NSLog(@"SelectServerController.setServerSelected called");
	// start spinning
	[spinner startAnimation:self];
    // assume the server is valid
    validServer = YES;
    // call the super to initate and verify the server
    [super setServerSelected:server];    
    // the super has sent a event caught by me (invalidServer) if the server was not ok
	[spinner stopAnimation:self];
    if ((server != nil) && (validServer)) {
        //[loginButton setEnabled:YES];  only after we found a slot
        [serverNameTextField setStringValue:[server address]];
    } else {
        [loginButton setEnabled:NO];
        [self deselectServer];
        [serverNameTextField setStringValue:@"Error occured, please select a different server"];
    }  
}

- (void)manualEntryDidEndEditing:(NSNotification *)aNotification {
	NSLog(@"SelectServerController.manualEntryDidEndEditing %@", [aNotification name]);
	
	// is called upon a manual enter in the textfield
	// okay is leak, but how often do you enter a server
	MetaServerEntry *entry = [[MetaServerEntry alloc] init]; 
	
	// defaults
    [entry setAddress: @"192.168.1.6"];
    [entry setPort:    2592];
    [entry setStatus:  DEFAULT];
    [entry setGameType:    BRONCO];	

	// to allow for manual selection of server
    NSLog(@"SelectServerController.manualEntryDidEndEditing should connect to %@", [serverNameTextField stringValue]);    
	// try and find the port number
	NSString *name = [serverNameTextField stringValue];
	NSRange dot = [name rangeOfString:@":"];
	if (dot.location != NSNotFound) {
		// use port
		[entry setPort:[[name substringFromIndex:dot.location+1] intValue]];
		[entry setAddress:[name substringToIndex:dot.location]];
	} else {
		[entry setAddress:name];
	}
	
	// select
	[self setServerSelected:entry];
}

@end
