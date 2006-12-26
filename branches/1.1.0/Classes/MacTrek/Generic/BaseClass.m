//
//  BaseClass.m
//  MacTrek
//
//  Created by Aqua on 27/05/2006.
//  Copyright 2006 Luky Soft. All rights reserved.
//

#import "BaseClass.h"


@implementation BaseClass

- (id) init {
    self = [super init];
    if (self != nil) {
        notificationCenter = [LLNotificationCenter defaultCenter];
        universe = [Universe defaultInstance];
    }
    return self;
}

@end
