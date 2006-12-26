//
//  ServerSenderUdp.h
//  MacTrek
//
//  Created by Aqua on 13/05/2006.
//  Copyright 2006 Luky Soft. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <OmniNetworking/OmniNetworking.h>
#import "ServerSender.h"


@interface ServerSenderUdp : ServerSender {
    ONUDPSocket *socket;
}

- (id) initWithSocket:(ONUDPSocket*) socket;
- (void) close;

@end
