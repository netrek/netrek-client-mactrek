//
//  MTMacroHandler.h
//  MacTrek
//
//  Created by Chris & Judith Lukassen on 26/02/2007.
//  Copyright 2006 Luky Soft. See Licence.txt for licence details.
//

#import <Cocoa/Cocoa.h>
#import "BaseClass.h"
#import "MessageConstants.h"
#import "MTMacro.h"
#import "FeatureList.h"
//#import "MTKeyMap.h"
#import "Data.h"
#import "MTDistress.h"

#define MAX_MACRO_LENGTH 85


@interface MTMacroHandler : BaseClass {
	NSMutableDictionary *macros;
	FeatureList *featureList;
	//MTKeyMap *keyMap;
	MTMacro *storedMacro; 
	NSPoint gameViewPointOfCursor;
}

// setup
//- (void) setKeyMap:(MTKeyMap *)list;
- (void) setFeatureList:(FeatureList *)list;
- (void) setGameViewPointOfCursor:(NSPoint)p;

// internal storage of macros
- (void) initializeMacros;
//- (MTMacro *)getMacroForKey:(char)key;

// external
- (bool) handleMacroForKey:(char) key;
- (bool) handleSingleMacroForKey:(char) key;
- (void) sendDistress:(int) type;

// protected
- (bool) executeMacro:(MTMacro *) macro;
- (void) sendMacro:(MTMacro*) macro;
- (void) sendMacro:(MTMacro*) macro toPlayer:(char) who;
- (NSString*) parseMacro:(MTDistress*) distress;
- (void) parseTests:(NSMutableString *)buffer;
- (void) parseConditionals:(NSMutableString *)buffer;
- (int) evaluateConditionalBlockStartingAt:(int) bpos inBuffer:(NSMutableString *)buffer include: (bool) include;
- (void) parseRemaining:(NSMutableString *)buffer;

@end
