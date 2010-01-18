//
//  LLScreenResolution.m
//  MacTrek
//
//  Created by Chris & Judith Lukassen on 11/03/2007.
//  Copyright 2007 Luky Soft. All rights reserved.
//

#import "LLScreenResolution.h"


@implementation LLScreenResolution

LLScreenResolution* defaultScreenResolution;

/*
// helper
static int numberForKey( CFDictionaryRef desc, CFStringRef key ) {
    CFNumberRef value;
    int num = 0;
	
    if ( (value = CFDictionaryGetValue(desc, key)) == NULL )
        return 0;
    CFNumberGetValue(value, kCFNumberIntType, &num);
    return num;
}
*/

+ (LLScreenResolution*) defaultScreenResolution {
    if (defaultScreenResolution == nil) {
        defaultScreenResolution = [[LLScreenResolution alloc] init];
    }
    return defaultScreenResolution;
}

- (NSRect) frameForPrimairyDisplay {
	
	NSRect frame = NSMakeRect(0, 0, CGDisplayPixelsWide(CGMainDisplayID()), CGDisplayPixelsHigh(CGMainDisplayID()));
	return frame;
}

- (struct screenMode) screenModeOnPrimairyDisplay {
	
	struct screenMode mode;
	
	mode.width = CGDisplayPixelsWide(CGMainDisplayID());
	mode.height = CGDisplayPixelsHigh(CGMainDisplayID());
	mode.bitsPerPixel = CGDisplayBitsPerPixel(CGMainDisplayID());
	
	return mode;
}

- (void) setPrimairyDisplayToMode: (struct screenMode) mode {
	
	[self setDisplay: [self primairyDisplayId] toMode:mode];
} 

/*

- (CFDictionaryRef) descriptionForPrimairyDisplay {
	
	return CGDisplayCurrentMode( [self primairyDisplayId] );
}

- (bool) supportForAquaOnPrimairyDisplay {
	CFDictionaryRef desc = [self descriptionForPrimairyDisplay];
	if ( CFDictionaryGetValue(desc, kCGDisplayModeUsableForDesktopGUI) == kCFBooleanTrue )
        return YES;
    else
        return NO;
} 

- (int) displayWidthOnPrimairyDisplay {
	CFDictionaryRef desc = [self descriptionForPrimairyDisplay];
	return numberForKey(desc, kCGDisplayWidth);
}

- (int) displayHeigthOnPrimairyDisplay {
	CFDictionaryRef desc = [self descriptionForPrimairyDisplay];
	return numberForKey(desc, kCGDisplayHeight);
}

- (int) displayBitsPerPixelOnPrimairyDisplay {
	CFDictionaryRef desc = [self descriptionForPrimairyDisplay];
	return numberForKey(desc, kCGDisplayBitsPerPixel);
}

- (int) displayRefreshRateOnPrimairyDisplay {
	CFDictionaryRef desc = [self descriptionForPrimairyDisplay];
	return numberForKey(desc, kCGDisplayRefreshRate);
}

- (bool) supportForAquaInDescr: (CFDictionaryRef) desc {
	if ( CFDictionaryGetValue(desc, kCGDisplayModeUsableForDesktopGUI) == kCFBooleanTrue )
        return YES;
    else
        return NO;
} 

- (int) displayWidthInDescr: (CFDictionaryRef) desc {
	return numberForKey(desc, kCGDisplayWidth);
}

- (int) displayHeigthInDescr: (CFDictionaryRef) desc {
	return numberForKey(desc, kCGDisplayHeight);
}

- (int) displayBitsPerPixelInDescr: (CFDictionaryRef) desc {
	return numberForKey(desc, kCGDisplayBitsPerPixel);
}

- (int) displayRefreshRateInDescr: (CFDictionaryRef) desc {
	return numberForKey(desc, kCGDisplayRefreshRate);
}

- (void) setDisplay:(CGDirectDisplayID) dspy toMode: (struct screenMode) screenMode {

    CFDictionaryRef mode;
    CFDictionaryRef originalMode;
    boolean_t exactMatch;
    CGDisplayErr err;
    
    originalMode = CGDisplayCurrentMode( dspy );
    if ( originalMode == NULL ) {
		LLLog(@"LLScreenResolution.setDisplay display with id %d is invalid", (int)dspy);
        return;
    }
    
	// look for a matching displ
	LLLog(@"LLScreenResolution.setDisplay setting display 0x%x: looking for %ld x %ld, %ld Bits Per Pixel",
		  (unsigned int)dspy,
		  screenMode.width,
		  screenMode.height,
		  screenMode.bitsPerPixel );
	
	mode = CGDisplayBestModeForParameters(dspy,
										  screenMode.bitsPerPixel,
										  screenMode.width,
										  screenMode.height,
										  &exactMatch);
	if ( exactMatch ) {
		LLLog(@"LLScreenResolution.setDisplay found an exact match, switching modes" );
	} else {
		LLLog(@"LLScreenResolution.setDisplay found a mode, switching modes" );
	}
	
	err = CGDisplaySwitchToMode(dspy, mode);
	if ( err != CGDisplayNoErr ) {
		LLLog(@"LLScreenResolution.setDisplay Oops!  Mode switch failed?!?? (%d)", err );
		
		// try to reset
		err = CGDisplaySwitchToMode(dspy, originalMode);
		if ( err != CGDisplayNoErr )
			LLLog(@"LLScreenResolution.setDisplay Oops!  Mode restore failed?!?? (%d)", err );
	}
	
	// check result
	CFDictionaryRef currentMode = CGDisplayCurrentMode( dspy );
	LLLog(@"LLScreenResolution.setDisplay display has been set to %ld x %ld, %ld Bits Per Pixel",
		  [self displayWidthInDescr:currentMode],
		  [self displayHeigthInDescr:currentMode],
		  [self displayBitsPerPixelInDescr:currentMode]);	
}

- (CGDirectDisplayID) primairyDisplayId {
	NSArray *displays = [self arrayOfDisplayIDs];
	return (CGDirectDisplayID) [displays objectAtIndex:0];
}

- (NSArray *) arrayOfDisplayIDs {
    CGDirectDisplayID display[kMaxDisplays];
    CGDisplayCount numDisplays;
    CGDisplayCount i;
    CGDisplayErr err;
	
    err = CGGetActiveDisplayList(kMaxDisplays,
                                 display,
                                 &numDisplays);
    if ( err != CGDisplayNoErr ) {
		NSMutableArray* disIDs = [[[NSMutableArray alloc] init] autorelease];
		for ( i = 0; i < numDisplays; ++i ) {
			[disIDs addObject:[NSNumber numberWithInt:(int)display[i]]];
		}
		return disIDs;
	} else {
		return nil;
	}	
}

- (int) numberOfDisplays {
	
    CGDirectDisplayID display[kMaxDisplays];
    CGDisplayCount numDisplays;
    CGDisplayErr err;
	
    err = CGGetActiveDisplayList(kMaxDisplays,
                                 display,
                                 &numDisplays);
    if ( err != CGDisplayNoErr ) {
		return numDisplays;
	} else {
		return -1;
	}
}
*/
@end
