//
//  ServerReaderTcp.h
//  MacTrek
//
//  Created by Aqua on 06/05/2006.
//  Copyright 2006 Luky Soft. All rights reserved.
//

#import <Cocoa/Cocoa.h>
@class ServerReader;
#import "ServerReader.h"

@class Communication;
#import "Communication.h"
#import <OmniNetworking/OmniNetworking.h>

@interface ServerReaderTcp : ServerReader {
	
	ONSocketStream *stream;
	ONTCPSocket *sock;
}

- (id)initWithUniverse:(Universe*)newUniverse communication:(Communication*)comm
                socket:(ONTCPSocket*) socket;

@end
