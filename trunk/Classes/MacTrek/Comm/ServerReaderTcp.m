//
//  ServerReaderTcp.m
//  MacTrek
//
//  Created by Aqua on 06/05/2006.
//  Copyright 2006 Luky Soft. All rights reserved.
//

#import "ServerReaderTcp.h"

@implementation ServerReaderTcp


- (id) init {
    self = [super init];
    if (self != nil) {
		sock = nil;
        stream = nil; // very bad if we get here
    }
    return self;
}

- (id)initWithUniverse:(Universe*)newUniverse communication:(Communication*)comm
                socket:(ONTCPSocket*) socket {

    self = [super initWithUniverse:newUniverse communication:comm];
    if (self != nil) {
        // connect has already been done and create a stream
        stream = [ONSocketStream streamWithSocket:socket];
        [stream retain];
		sock = socket;
		[sock retain];
    }
    return self;
}

- (NSData *) doRead {
	// wait with timeout if needed
    if (timeOut > 0.0) {
		if ([sock waitForInputWithTimeout:timeOut] == NO) {
			// trouble!
			NSLog(@"ServerReaderTcp.doRead TIMEOUT! more than %f sec passed", timeOut);
			return nil;
		}
	}	
	// read max one TCP frame per time
	// note this could still go wrong if the buffer contains less bytes then 1536 ?
    NSData *result = [stream readDataWithMaxLength:1536];
    return result;
}

- (void) close {
    [stream release];
    stream = nil;
}

@end
