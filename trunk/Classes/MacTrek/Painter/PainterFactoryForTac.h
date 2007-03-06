//
//  PainterFactoryForTac.h
//  MacTrek
//
//  Created by Aqua on 23/07/2006.
//  Copyright 2006 Luky Soft. See Licence.txt for licence details.
//

#import <Cocoa/Cocoa.h>
#import "PainterFactoryForMacTrek.h"

@interface PainterFactoryForTac : PainterFactoryForMacTrek {
	
	NSMutableDictionary *extraImages;
}

@end