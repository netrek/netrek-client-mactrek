//
//  MetaServerTableDataSource.h
//  MacTrek
//
//  Created by Aqua on 26/05/2006.
//  Copyright 2006 Luky Soft. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "BaseClass.h"
#import "MetaServerParser.h"

@interface MetaServerTableDataSource : BaseClass {

    // must be tied to the tableview in question
    IBOutlet NSTableView *serverTableView;
    
    // internal data
    MetaServerParser *meta;
    NSMutableArray *entries;  
    
    // selected entry
    MetaServerEntry *selectedServer;
}

- (IBAction)refreshServers:(id)sender;
- (void) refreshServersInSeperateThread:(id)sender;
- (MetaServerEntry *) selectedServer;
- (void) removeServer:(NSString *)name;
- (void) addServer:(MetaServerEntry *) entry;
- (void) addServerPassivly:(MetaServerEntry *) entry;
- (MetaServerEntry *) findServer:(NSString *)name;
- (void) deselectServer;
- (void) setServerSelected:(MetaServerEntry *) server;

@end
