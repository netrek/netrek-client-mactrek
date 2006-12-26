//
//  ServerSenderTcp.h
//  MacTrek
//
//  Created by Aqua on 13/05/2006.
//  Copyright 2006 Luky Soft. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <OmniNetworking/OmniNetworking.h>
#import "ServerSender.h"


@interface ServerSenderTcp : ServerSender {
    ONTCPSocket *socket;
}

- (id) initWithSocket:(ONTCPSocket*) socket;
- (int) serverPort;
- (ONHost*) serverHost;

@end
