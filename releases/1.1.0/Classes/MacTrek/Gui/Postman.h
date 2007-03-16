//
//  Postman.h
//  MacTrek
//
//  Created by Aqua on 06/08/2006.
//  Copyright 2006 Luky Soft. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "BaseClass.h"
#import "PlayerListView.h"
#import "MessagesListView.h"
#import "MessageConstants.h"

@interface Postman : BaseClass {
    IBOutlet NSTextField *commTextField;
    IBOutlet NSTextField *toField; 
    IBOutlet PlayerListView *playerList;
    IBOutlet MessagesListView *messageList;
}

// get/set the field (called by click in lists or keyevent)
- (void)      setDestination:(NSString*) dst;
- (NSString*) destination;
// get/set message for macros
- (void)      setMessage:(NSString*)msg;
- (NSString*) message;
// send it when enter is pressed or on macro event
- (void)      sendCurrentMessage;
- (void)      sendMessage:(NSString*)msg to:(NSString*) dst;
// internal stuff
- (NSNumber *) individualIdOfAdress:(NSString*) address;
- (NSNumber *) groupOfAdress:(NSString*) address;

@end