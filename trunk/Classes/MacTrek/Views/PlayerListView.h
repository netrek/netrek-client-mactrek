//
//  PlayerListView.h
//  MacTrek
//
//  Created by Aqua on 01/08/2006.
//  Copyright 2006 Luky Soft. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "Luky.h"
#import "LLStringTable.h"
#import "Data.h"


@interface PlayerListView : LLStringTable {
    Universe *universe;
    NSMutableArray  *players;
}

@end
