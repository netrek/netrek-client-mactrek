//
//  LLColorFilter.h
//  MacTrek
//
//  Created by Aqua on 15/08/2006.
//  Copyright 2006 Luky Soft. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "LLObject.h"

@interface LLColorFilter : LLObject {

}

- (NSImage *)replaceColor:(NSColor *)srcCol withColor:(NSColor *)dstColor 
                  inImage:(NSImage *)srcImage ignoreAlha:(bool)ignoreAlpha;

- (NSImage *)grayScaleImage:(NSImage *)srcImage;

@end
