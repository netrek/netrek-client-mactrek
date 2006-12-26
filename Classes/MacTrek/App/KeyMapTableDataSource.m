//
//  KeyMapTableDataSource.m
//  MacTrek
//
//  Created by Aqua on 26/05/2006.
//  Copyright 2006 Luky Soft. All rights reserved.
//

#import "KeyMapTableDataSource.h"


@implementation KeyMapTableDataSource

- (id) init {
    self = [super init];
    if (self != nil) {
        // allocate the default map
        myMap = [[MTKeyMap alloc] init];
        // initial query is in seperate thread
       //[NSThread detachNewThreadSelector:@selector(readDefaultKeyMap) toTarget:myMap withObject:nil];
       [myMap readDefaultKeyMap]; // except when debugging
	   [keyMapTableView performSelector: @selector(reloadData) withObject:nil afterDelay: 1.0];

    }
    return self;
}

- (void) awakeFromNib {
	// hmmm seems not to be called at all ?
	// -> yes! but if changed, delete and reinstantiate the SettingsController in the
	// NIB since the object is archived
	[keyMapTableView reloadData];
	[keyMapTableView noteNumberOfRowsChanged];
	NSLog(@"KeyMapTableDataSource.awakeFromNib");
}

- (MTKeyMap *) keyMap {
    return myMap;
}

- (int)numberOfRowsInTableView:(NSTableView *)aTableView {

    if (keyMapTableView == aTableView) {
		 NSLog(@"KeyMapTableDataSource.numberOfRowsInTableView %d", [myMap count]);
        return [myMap count];
    }
    return 0;
}

- (id)tableView:(NSTableView *)aTableView
    objectValueForTableColumn:(NSTableColumn *)aTableColumn
            row:(int)rowIndex {
   //NSLog(@"KeyMapTableDataSource.objectValueForTableColumn row %d", rowIndex);
	
    if (keyMapTableView == aTableView) {
        NSArray *actionKeys = [myMap allKeys];
        int action = [[actionKeys objectAtIndex:rowIndex] intValue];
        if ([[aTableColumn identifier] isEqualTo: @"description"]) {
            return [myMap descriptionForAction:action];
        } else if ([[aTableColumn identifier] isEqualTo: @"key"]) {
            return [NSString stringWithFormat:@"%c", [myMap keyForAction:action]];
        } else {
            return @"ERROR"; // unknown column
        }
    }
    return @"ERROR";
}

// delegate functions
- (BOOL)tableView:(NSTableView *)aTableView shouldEditTableColumn:(NSTableColumn *)aTableColumn row:(int)rowIndex {
    if ([[aTableColumn identifier] isEqualToString:@"description"]) {
        return NO;
    } else {
        return YES;
    }
}

- (void)tableView:(NSTableView *)tableView setObjectValue:(id)object
   forTableColumn:(NSTableColumn *)column row:(int)row {
    
    // only the key column is editable
    if (tableView == keyMapTableView) {           
        NSArray *actionKeys = [myMap allKeys];
        int action = [[actionKeys objectAtIndex:row] intValue];
        // only accept a single character
        // use of a formatter would be better
        if ([object length] == 1) {
            NSString *newkey = object;
            char c = [newkey characterAtIndex:0];
            [myMap setKey:c forAction:action];
        }
    }
}


@end
