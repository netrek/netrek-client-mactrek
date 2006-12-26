//
//  DemoClientController.m
//  MacTrek
//
//  Created by Aqua on 27/05/2006.
//  Copyright 2006 Luky Soft. All rights reserved.
//

#import "DemoClientController.h"


@implementation DemoClientController

- (id) init {
    self = [super init];
    if (self != nil) {
        jtrek = [[JTrekController alloc] init];
    }
    return self;
}

- (void) setServer:(MetaServerEntry *) server {
    selectedServer = server;
}

// handling of GUI
- (IBAction)play:(id)sender {
       
    if (selectedServer != nil) {
         NSLog(@"DemoClientController play at server: %@ port %d", [selectedServer address], [selectedServer port]);
        [jtrek startJTrekAt:[selectedServer address] port:[selectedServer port]];
    }    
}

@end
