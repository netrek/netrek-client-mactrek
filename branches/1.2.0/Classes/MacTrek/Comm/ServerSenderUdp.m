//
//  ServerSenderUdp.m
//  MacTrek
//
//  Created by Aqua on 13/05/2006.
//  Copyright 2006 Luky Soft. See Licence.txt for licence details.
//

#import "ServerSenderUdp.h"


@implementation ServerSenderUdp

- (id) initWithSocket:(ONUDPSocket*) newSocket {
        
    self = [super init];
    if (self != nil) {
        socket = newSocket;
    }
    return self;
}

- (bool) sendBuffer:(char*) buffer length:(int)size {

    LLLog(@"ServerSenderUdp.sendBuffer message: %@ (%d) size: %d", 
          [pktConv clientPacketString:buffer[0]], buffer[0], size);
    
    NSData *packet = [[NSData alloc] initWithBytes:buffer length:size];
    // $$ should test for some error in the writing?
    [socket writeData:packet];
    [packet release];
    return YES;
}

- (void) close {
    //[super close];
    [socket release];
    socket = nil;
}

@end
