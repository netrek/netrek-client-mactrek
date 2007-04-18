//
//  LLSocket.h
//  MacTrek
//
//  Created by Chris & Judith Lukassen on 17/04/2007.
//  Copyright 2007 Luky Soft. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "LLObject.h"
#import "LLHost.h"

#import <fcntl.h>
#import <netdb.h>
#import <netinet/in.h>
#import <sys/socket.h>
#import <sys/time.h>
#import <sys/types.h>
#import <arpa/inet.h>
#import <unistd.h>

//
// Based upon:
//
// AbstractSocket.h
//
// SmallSockets Library (http://smallsockets.sourceforge.net/)
//
// Copyright (C) 2001 Steven Frank (stevenf@panic.com)
//
// This software is provided 'as-is', without any express or implied 
// warranty. In no event will the authors be held liable for any damages 
// arising from the use of this software.
//
// Permission is granted to anyone to use this software for any purpose, 
// including commercial applications, and to alter it and redistribute it 
// freely, subject to the following restrictions:
//
//     1. The origin of this software must not be misrepresented; you must 
//        not claim that you wrote the original software. If you use this 
//        software in a product, an acknowledgment in the product 
//        documentation (and/or about box) would be appreciated but is not 
//        required.
//
//     2. Altered source versions must be plainly marked as such, and must
//        not be misrepresented as being the original software.
//
//     3. This notice may not be removed or altered from any source 
//        distribution.
//        

#import <Foundation/Foundation.h>

// SMALLSOCKETS_VERSION is the version number of SmallSockets in binary-coded
// decimal.  (ie; version 1.3.2 == 0x0132)

#define SMALLSOCKETS_VERSION 0x0060

// SOCKET_DEFAULT_READ_BUFFER_SIZE is the default size of the buffer 
// used by readData, which all the other read calls are built upon.  
// readData will not read more than this amount in a single call.
// You can change this buffer size on a per-socket basis by
// calling -setReadBufferSize

#define SOCKET_DEFAULT_READ_BUFFER_SIZE 4096

// SOCKET_MAX_PENDING_CONNECTIONS is the maximum number of pending connections
// that should be allowed during a listen operation before connections start
// being refused.  You can specify a different number by using 
// -listenOnPort:maxPendingConnections: instead of -listenToPort: which will
// use this default value.

#define SOCKET_MAX_PENDING_CONNECTIONS 5

// The following defines are strings used to raise exceptions.
// The _F versions are formatting strings for the exception's description.
// The %s is replaced by the value of strerror(errno) which usually gives
// a pretty good idea of what went wrong.

#define SOCKET_EX_ACCEPT_FAILED				@"Socket: Accept failed"
#define SOCKET_EX_ACCEPT_FAILED_F			@"Socket: Accept failed: %s"
#define SOCKET_EX_ALREADY_CONNECTED			@"Socket: Already connected"
#define SOCKET_EX_BAD_SOCKET_DESCRIPTOR		@"Socket: Bad socket descriptor"
#define SOCKET_EX_BIND_FAILED				@"Socket: Bind failed"
#define SOCKET_EX_BIND_FAILED_F				@"Socket: Bind failed: %s"
#define SOCKET_EX_CANT_CREATE_SOCKET		@"Socket: Can't create socket"
#define SOCKET_EX_CANT_CREATE_SOCKET_F		@"Socket: Can't create socket: %s"
#define SOCKET_EX_CONNECT_FAILED			@"Socket: Connect failed"
#define SOCKET_EX_CONNECT_FAILED_F			@"Socket: Connect failed: %s"
#define SOCKET_EX_FCNTL_FAILED				@"Socket: Fcntl failed"
#define SOCKET_EX_FCNTL_FAILED_F			@"Socket: Fcntl failed: %s"
#define SOCKET_EX_HOST_NOT_FOUND			@"Socket: Host not found"
#define SOCKET_EX_HOST_NOT_FOUND_F			@"Socket: Host not found: %s"
#define SOCKET_EX_INVALID_BUFFER			@"Socket: Invalid buffer"
#define SOCKET_EX_LISTEN_FAILED				@"Socket: Listen failed"
#define SOCKET_EX_LISTEN_FAILED_F			@"Socket: Listen failed: %s"
#define SOCKET_EX_MALLOC_FAILED				@"Socket: Malloc failed"
#define SOCKET_EX_NOT_CONNECTED				@"Socket: Not connected"
#define SOCKET_EX_NOT_LISTENING				@"Socket: Not listening"
#define SOCKET_EX_RECV_FAILED				@"Socket: Recv failed"
#define SOCKET_EX_RECV_FAILED_F				@"Socket: Recv failed: %s"
#define SOCKET_EX_SELECT_FAILED				@"Socket: Select failed"
#define SOCKET_EX_SELECT_FAILED_F			@"Socket: Select failed: %s"
#define SOCKET_EX_SEND_FAILED				@"Socket: Send failed"
#define SOCKET_EX_SEND_FAILED_F				@"Socket: Send failed: %s"
#define SOCKET_EX_SETSOCKOPT_FAILED			@"Socket: Setsockopt failed"
#define SOCKET_EX_SETSOCKOPT_FAILED_F		@"Socket: Setsockopt failed: %s"

// Default, uninitialized values for instance variables

#define SOCKET_INVALID_PORT	0
#define SOCKET_INVALID_DESCRIPTOR -1

@interface LLSocket : LLObject {
    void*			readBuffer;
    unsigned int	readBufferSize;
    NSString* 		remoteHostName;
    unsigned short 	remotePort;
    int 			socketfd;
	BOOL 			connected;
	BOOL			listening;
}

	// Designated initializer
- (id)init;

	// Accessor functions
- (LLHost*)remoteHost;
- (unsigned short) remotePort;

	// Reading and writing data
- (BOOL)isReadable;
- (BOOL)isWritable;
- (BOOL)waitForReadableWithTimeout:(NSTimeInterval) waittime;

	// Utility functions
- (void)setBlocking:(BOOL)shouldBlock;
- (unsigned int)readBufferSize;
- (void)setReadBufferSize:(unsigned int)size;

	// protected functions
- (void)_close;
- (void)_bindTo:(u_int32_t)address port:(unsigned short)port;
- (NSString*)_dottedIPFromAddress:(struct in_addr*)address;
- (id)_initWithFD:(int)fd remoteAddress:(struct sockaddr_in*)remoteAddress;

   // abstract functions
- (int)readData:(NSMutableData*)data;
- (void)writeData:(NSData*)data;

/* PRIVATE 
	// Class utilities

	// Internal utility function.  You should not call this from client code.
- (void)allocReadBuffer;


*/

@end


