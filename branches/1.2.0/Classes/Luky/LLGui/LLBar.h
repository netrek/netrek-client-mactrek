//
//  LLBar.h
//  MacTrek
//
//  Created by Aqua on 27/04/2006.
//  Copyright 2006 Luky Soft. LGPL Licence.
//

#import <Cocoa/Cocoa.h>
#import "LLGradientRect.h"
#import "LLView.h"

#define LLBAR_SEPERATION_BETWEEN_RECTS 1

@interface LLBar : LLView {

	float max;
	float min;
	float value;
	float tempMax;
	float warning;
	float critical;
    NSString *name;
    bool discrete;
	LLGradientRect *gradientRect;
}

- (NSString *)name;
- (float) min;
- (float) max;
- (float) value;
- (float) tempMax;
- (float) warning;
- (float) critical;
- (bool)  discrete;

- (void) setName:(NSString *) newValue;
- (void) setDiscrete:(bool)discrete;
- (void) setMin:(float)newValue;
- (void) setMax:(float)newValue;
- (void) setValue:(float)newValue;
- (void) setTempMax:(float)newValue;
- (void) setWarning:(float)newValue;
- (void) setCritical:(float)newValue;

@end
