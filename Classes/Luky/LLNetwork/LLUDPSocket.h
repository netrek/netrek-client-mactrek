//
//  LLUDPSocket.h
//  MacTrek
//
//  Created by Chris & Judith Lukassen on 17/04/2007.
//  Copyright 2007 Luky Soft. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "LLSocket.h"

@interface LLUDPSocket : LLSocket {

}

	// Making connections
- (void)connectToHost:(LLHost*)host port:(unsigned short)port;

	// Receiving connections
- (void)listenOnPort:(unsigned short)port;
- (void)listenOnPort:(unsigned short)port maxPendingConnections:(unsigned int)maxPendingConnections;

	// Reading and writing
- (int) readData:(NSMutableData*)data;
- (void)writeData:(NSData*)data;
- (void)writeString:(NSString*)string;

@end
