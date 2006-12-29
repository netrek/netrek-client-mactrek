//
//  MetaServerTableDataSource.m
//  MacTrek
//
//  Created by Aqua on 26/05/2006.
//  Copyright 2006 Luky Soft. See Licence.txt for licence details.
//

#import "MetaServerTableDataSource.h"


@implementation MetaServerTableDataSource

- (id) init {
    self = [super init];
    if (self != nil) {
        selectedServer = nil;
        meta = [[MetaServerParser alloc] init];
		entries = [[NSMutableArray alloc] init];
        // initial query is in seperate thread
        [NSThread detachNewThreadSelector:@selector(refreshServersInSeperateThread:) toTarget:self withObject:nil];
    }
    return self;
}

- (void) refreshServersInSeperateThread:(id)sender {
    // technically this should be done with locks since
    // it can be invoked from init and by user if he is very very fast...
    
    // create a private pool for this thread
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    NSLog(@"MetaServerTableDataSource.refreshServersInSeperateThread: start running");
    [self refreshServers:self];
    NSLog(@"MetaServerTableDataSource.refreshServersInSeperateThread: complete");
    
    //[notificationCenter postNotificationName:@"MS_SERVERS_READ"];
    
    // release the pool
    [pool release];
}

- (IBAction)refreshServers:(id)sender {  
	
	NSMutableArray *result;
	@try {
		result = [meta readFromMetaServer:@"metaserver.netrek.org" atPort:3521];
	}
	@catch (NSException * e) {
		NSLog(@"MetaServerTableDataSource.refreshServers: error %@", [e reason]);
		return;
	}

	// small protection allows for initial emty array, so when tehre is no internet,
	// you can still play on the local server.
	if (result != nil) {
		// check for localhost before releaseing
		MetaServerEntry *localhost = [self findServer:@"localhost"];
		[entries release];
		entries = result;
		if (localhost != nil) {
			NSLog(@"MetaServerTableDataSource.refreshServers: keeping localhost");
			[self addServerPassivly:localhost];
		}
	}
    [serverTableView reloadData];
}

- (int)numberOfRowsInTableView:(NSTableView *)aTableView {
    if (serverTableView == aTableView) {
        return [entries count];
    }
    return 0;
}

- (id)tableView:(NSTableView *)aTableView
    objectValueForTableColumn:(NSTableColumn *)aTableColumn
            row:(int)rowIndex {
    
    if (serverTableView == aTableView) {
        MetaServerEntry *entry = [entries objectAtIndex:rowIndex];
        
        if ([[aTableColumn identifier] isEqualTo: @"address"]) {
            return [entry address];
        } else if ([[aTableColumn identifier] isEqualTo: @"status"]) {
            return [entry statusString];
        } else if ([[aTableColumn identifier] isEqualTo: @"players"]) {
            return [NSString stringWithFormat:@"%d", [entry players]];
        } else if ([[aTableColumn identifier] isEqualTo: @"game"]) {
            return [entry gameTypeString];
        } else {
            return @"ERROR"; // unknown column
        }
    }
    return @"ERROR";
}

- (MetaServerEntry *) selectedServer {
    return selectedServer;
}

- (void) setServerSelected:(MetaServerEntry *) server {

    NSLog(@"MetaServerTableDataSource.setServerSelected called");
    [selectedServer release];
    selectedServer = server;
    [selectedServer retain];
    
    [notificationCenter postNotificationName:@"MS_SERVER_SELECTED" object:self userInfo:selectedServer];
}


// delegate functions
- (BOOL)tableView:(NSTableView *)aTableView shouldSelectRow:(int)rowIndex {
    
    // we abuse shouldSelectRow since it is a delegate function and not
    // a notification. (simpler)
    
    // update the selected server
    if (aTableView == serverTableView) {
        MetaServerEntry *entry = [entries objectAtIndex:rowIndex]; 
        [self setServerSelected:entry];
    }
    
    return YES;
}

- (void) deselectServer {
    selectedServer = nil;
    [serverTableView deselectAll:self];
}

- (MetaServerEntry *) findServer:(NSString *)name {
    
    for (int i = 0; i < [entries count]; i++) {
        MetaServerEntry *entry = [entries objectAtIndex:i];
        if ([[entry address] isEqualToString:name]) {
            return entry;
        }
    }
    return nil;    
}

- (void) addServerPassivly:(MetaServerEntry *) entry {
    [entries insertObject:entry atIndex:0];    
    [serverTableView reloadData];
}

- (void) addServer:(MetaServerEntry *) entry {
    [entries insertObject:entry atIndex:0];    
    [serverTableView reloadData];
    // and select it
    [self setServerSelected:entry];
}

- (void) removeServer:(NSString *)name {
    
    MetaServerEntry *entry = [self findServer:name];
    if (entry != nil) {
        [entries removeObject:entry];
        [serverTableView reloadData];
        if (entry == selectedServer) {
            [self deselectServer];
        }
    }
}

@end
