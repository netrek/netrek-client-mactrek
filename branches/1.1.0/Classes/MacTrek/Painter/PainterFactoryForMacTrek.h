//
//  PainterFactoryForMacTrek.h
//  MacTrek
//
//  Created by Aqua on 23/07/2006.
//  Copyright 2006 Luky Soft. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "PainterFactory.h"
#import "PainterFactoryForNetrek.h"

// $$ temp extend on netrek
@interface PainterFactoryForMacTrek : PainterFactoryForNetrek {
    NSImage *imgBackground;
}

@end