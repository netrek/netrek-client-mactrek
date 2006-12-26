//
//  ServerReaderUdp.h
//  MacTrek
//
//  Created by Aqua on 06/05/2006.
//  Copyright 2006 Luky Soft. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <OmniNetworking/OmniNetworking.h>
@class ServerReader;
#import "ServerReader.h"
@class Communication;
#import "Communication.h"
#import "UdpStats.h"

#define SRV_UDP_MAX_DATA_LENGTH  1300


@interface ServerReaderUdp : ServerReader {
    UdpStats *udpStats;
	ONUDPSocket *udpSocket;
}

- (id)initWithUniverse:(Universe*)newUniverse communication:(Communication*)comm socket:(ONUDPSocket *)socket udpStats:(UdpStats*)stats;
-(UdpStats*)udpStats;

@end
