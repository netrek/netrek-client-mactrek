//
//  Position.h
//  MacTrek
//
//  Created by Chris & Judith Lukassen on 19/11/2006.
//  Copyright 2006 Luky Soft. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "LLTarget.h"

@interface TrackUpdate : LLTarget {
	NSString* ident;
}

- (NSString*) ident;
- (void)setIdent:(NSString*) name;

@end
