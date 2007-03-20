//
//  LLView.m
//  MacTrek
//
//  Created by Chris & Judith Lukassen on 14/11/2006.
//  Copyright 2006 Luky Soft. LGPL Licence.
//

#import "LLView.h"

NSMutableDictionary* globalProperties;

@implementation LLView

- (id) init {
	self = [super init];
	if (self != nil) {
		properties = [LLObject properties];
	}
	return self;
}


@end
