//
//  BaseClass.h
//  MacTrek
//
//  Created by Aqua on 27/05/2006.
//  Copyright 2006 Luky Soft. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "Luky.h"
#import "SimpleBaseClass.h"

@class BaseClass;

#import "Universe.h"

@interface BaseClass : SimpleBaseClass {
    LLNotificationCenter *notificationCenter;
    Universe *universe;
}

@end
