//
//  MTMacroHandler.m
//  MacTrek
//
//  Created by Chris & Judith Lukassen on 26/02/2007.
//  Copyright 2006 Luky Soft. See Licence.txt for licence details.
//

#import "MTMacroHandler.h"


@implementation MTMacroHandler

char buffer[10 * MAX_MACRO_LENGTH];
int  line_length = 0;

- (id) init {
	self = [super init];
	if (self != nil) {
		featureList = nil;
		//keyMap = nil;
		storedMacro = nil;
		gameViewPointOfCursor = NSZeroPoint;
		macros = [[NSMutableDictionary alloc] init];
		[self initializeMacros];
	}
	return self;
}

- (void) setGameViewPointOfCursor:(NSPoint) p {
	gameViewPointOfCursor = p;
}

- (void) initializeMacros {
	// Read from a file here
	// syntax conforms to netrek standard... (wauw!)
	NSString *pathToResources = [[NSBundle mainBundle] resourcePath];
	NSString *pathToMacros = [NSString stringWithFormat:@"%@/macros.txt", pathToResources];
	NSString *stringWithAllMacros = [[NSString alloc]
                                      initWithContentsOfFile:pathToMacros
													encoding:NSUTF8StringEncoding
													   error:nil];
	if (stringWithAllMacros == nil) {
		// setup some defaults
		// the key should be identical to the description used in MTKeyMap to create a key to activate this macro
		// be sure to specify NSControlKeyMask too
		[macros setObject:[[MTMacro alloc] initWithName:@"mac.f.T" macro:@"Help!  Carrying %a!!"] forKey:@"f"];		
	} else {
		// parse the macro file (let's hope it is there)
		NSArray *lines = [stringWithAllMacros componentsSeparatedByString:@"\n"];
		unsigned int i, count = [lines count];
		for (i = 0; i < count; i++) {
			NSString *macroLine = [lines objectAtIndex:i];
			NSArray *macroElements = [macroLine componentsSeparatedByString:@":"];
			if ([macroElements count] == 2) {
				MTMacro *macro = [[MTMacro alloc] initWithName:[macroElements objectAtIndex:0] macro:[macroElements objectAtIndex:1]];
				[macros setObject:macro forKey:[macro keyAsString]];
			} else {
				LLLog(@"MTMacroHandler.initializeMacros illigal macro %@", macroLine);
			}
		}
	}
}

- (void) setFeatureList:(FeatureList *)list {
	featureList = list;
}

/*
- (void) setKeyMap:(MTKeyMap *)list {
	keyMap = list;
}

- (MTMacro *)getMacroForKey:(char)key {
	int action = [keyMap actionForKey:key withModifierFlags: NSControlKeyMask]; // $$ hoops? what flags to use?
	NSString *description = [keyMap descriptionForAction:action];
	return [macros objectForKey:description];
}
*/
/** handleMacro */
- (bool) handleMacroForKey:(char) key {
	
	if(storedMacro != nil) {
		[self sendMacro:storedMacro toPlayer:key];
		storedMacro = nil;
		return YES;
	}
	
	//MTMacro *macro = [self getMacroForKey:key];
	MTMacro *macro = [macros objectForKey:[NSString stringWithFormat:@"%c", key]];	
	
	if(macro == nil) {
		
		// could be a default distress 
		// $$ leave this for now, distress is normal macro
		/*
		for(int r = 0; r < Defaults.rcds.length; ++r) {
			if(key == Defaults.rcds[r].key) {
				[self sendDistress:r];
				return YES;
			}
		}
		*/
		// status display should listen to this
		[notificationCenter postNotificationName:@"MH_UNKNOWN_MACRO" userInfo:[NSNumber numberWithChar:key]];
		
		return YES;
	}
	return [self executeMacro:macro];
}

/** handleSingleMacro */
- (bool) handleSingleMacroForKey:(char) key {
	
	//MTMacro *macro = [self getMacroForKey:key];
	MTMacro *macro = [macros objectForKey:[NSString stringWithFormat:@"%c", key]];
	if(macro == nil) {
		[notificationCenter postNotificationName:@"MH_UNKNOWN_MACRO" userInfo:[NSNumber numberWithChar:key]];
		return YES; 
	}
	return [self executeMacro:macro];
}


/** executeMacro */
- (bool) executeMacro:(MTMacro *) macro {
	if([macro type] != MACRO_NBTM && [featureList valueForFeature:FEATURE_LIST_NEW_MACRO] != FEATURE_ON) {
		[notificationCenter postNotificationName:@"MH_SERVER_NOT_ALLOWS_NEWMACRO"];
		return YES;
	}
	if([macro type] == MACRO_NEWM) {
		storedMacro = macro;
		// wait until we are assigned a destination
		//[notificationCenter postNotificationName:@"MH_UNKNOWN_DESTINATION_MACRO"];
		return NO;
	}
	[self sendMacro:macro];
	return YES;
}

/** sendMacro */
-(void) sendMacro:(MTMacro*) macro {
	[self sendMacro:macro toPlayer:[macro who]];
}

/** sendMacro */
-(void) sendMacro:(MTMacro*) macro toPlayer:(char) who {
	
	switch([macro type]) {
		case MACRO_NBTM:
		case MACRO_NEWMSPEC:
		case MACRO_NEWM:
			break;
		case MACRO_NEWMOUSE: {
			int target_type ;
			switch([macro who]) {
				case MACRO_FRIEND:
				case MACRO_ENEMY:
				case MACRO_PLAYER: {
					target_type = UNIVERSE_TARG_PLAYER | UNIVERSE_TARG_CLOAK;
					if([macro who] == MACRO_ENEMY) {
						target_type |= UNIVERSE_TARG_ENEMY;
					}
					else if([macro who] == MACRO_FRIEND) {
						target_type |= UNIVERSE_TARG_FRIEND;
					}
					Player *player =  [universe playerNearPosition:gameViewPointOfCursor ofType:target_type];
					who = [[player team] letterForPlayer:[player playerId]];
					break;	
				}
				case MACRO_TEAM: {
					Planet *planet = [universe planetNearPosition:gameViewPointOfCursor];
					Player *player = [universe playerNearPosition:gameViewPointOfCursor ofType:UNIVERSE_TARG_PLAYER];
					if ([universe entity:player closerToMeThan:planet]) {
						who = [[player team] letterForPlayer:[player playerId]];
					} else {
						who = [[player team] letterForTeam];
					}
					break;
					default:
						player =  [universe playerThatIsMe];
						who = [[player team] letterForPlayer:[player playerId]];
						break;
				}
			}
			break;
		}
	}
	
	// use clean macro's or create a distress call..
	NSString *message;
	if ([macro type] != MACRO_NBTM) {
		MTDistress *distress = [[MTDistress alloc] initWithType:0 gamePointForMousePosition:gameViewPointOfCursor];
		message = [self parseMacro:distress];
		[distress release];
	} else {
		message = [macro macroString];
	}
	
	// iterate message for newlines
	NSRange range = [message rangeOfString:@"\n"];
	if (range.location == NSNotFound) {
		[notificationCenter postNotificationName:@"MT_MESSAGE" userInfo:message];
	} else {
		while (range.location != NSNotFound) {
			NSRange lineRange = NSMakeRange(0, range.location);
			[notificationCenter postNotificationName:@"MT_MESSAGE" userInfo:[message substringWithRange:lineRange]];
			message = [message substringFromIndex:range.location+1];
		}
	}
}

/** sendDistress */
-(void) sendDistress:(int) type {
	MTDistress *distress = [[MTDistress alloc] initWithType:type];
	
	[distress setDestinationGroup: (TEAM | DISTR)
					   individual: [[[universe playerThatIsMe] team] bitMask]];
	
	NSString *message = [self parseMacro:distress];
	[distress release];
	
	// iterate message for newlines
	NSRange range = [message rangeOfString:@"\n"];
	if (range.location == NSNotFound) {
		[notificationCenter postNotificationName:@"MT_MESSAGE" userInfo:message];
	} else {
		while (range.location != NSNotFound) {
			NSRange lineRange = NSMakeRange(0, range.location);
			[notificationCenter postNotificationName:@"MT_MESSAGE" userInfo:[message substringWithRange:lineRange]];
			message = [message substringFromIndex:range.location+1];
		}
	}	
	
	//[notificationCenter postNotificationName:@"MT_DISTRESS" userInfo:distress];
}

/** parseMacro */
- (NSString*) parseMacro:(MTDistress*) distress {
	
	// first step is to substitute variables
	NSMutableString *buffer = [NSMutableString stringWithString:[distress filledMacroString]];
	
	// second step is to evaluate tests
	[self parseTests:buffer];
	
	// third step is to include conditional text
	[self parseConditionals:buffer];
	
	// fourth step is to remove all the rest of the control characters
	[self parseRemaining:buffer];
	
	return buffer; // watch out is autoretained
}


/** parseTests */
- (void) parseTests:(NSMutableString *)buffer {
	
	for(int bpos = 0; bpos < [buffer length] - 1; ++bpos) {
		if([buffer characterAtIndex:bpos] == '%') {
			switch([buffer characterAtIndex:bpos + 1]) {
				case '*' :
				case '%' :
				case '{' :
				case '}' :
				case '!' :
					++bpos;
					break;
				case '?' : { 					// solve the conditional
					
					int op_pos = bpos + 2;
					while([buffer characterAtIndex:op_pos] != '<' && [buffer characterAtIndex:op_pos] != '>' && [buffer characterAtIndex:op_pos] != '=') {
						if(op_pos >= [buffer length]) {
							// $$$ MIGHT WANT TO DO SOMETHING SMART HERE!!!
							return;
						}
						op_pos++;
					}
					char operation = [buffer characterAtIndex:op_pos];
					
					int end = op_pos;
					while(++end < [buffer length] - 1) {
						if([buffer characterAtIndex:end] == '%' && ([buffer characterAtIndex:end + 1] == '?' || [buffer characterAtIndex:end + 1] == '{')) {
							break;
						}
					}
					
					NSString *left = [buffer substringWithRange:NSMakeRange(bpos + 2, op_pos - bpos - 2)];
					NSString *right = [buffer substringWithRange:NSMakeRange(op_pos + 1, end - op_pos - 1)];
					
					int compare = [left compare:right]; // $$ assuming this is the 
					switch(operation) {
						case '=' :					// character by character equality
							[buffer replaceCharactersInRange:NSMakeRange(bpos, 1) withString: ((compare ==  NSOrderedSame) ? @"1" : @"0")];
							break;
						case '<' :
							[buffer replaceCharactersInRange:NSMakeRange(bpos, 1) withString: ((compare < NSOrderedAscending) ? @"1" : @"0")];
							break;
						case '>' :
							[buffer replaceCharactersInRange:NSMakeRange(bpos, 1) withString: ((compare > NSOrderedDescending) ? @"1" : @"0")];
							break;
						default :
							[buffer replaceCharactersInRange:NSMakeRange(bpos, 1) withString:@"1"];
							LLLog(@"MTMacroHandler.parseTests Bad operation %c", operation);
					}
					[buffer deleteCharactersInRange:NSMakeRange(bpos + 1, (end - bpos - 1))];
				}
					break;
				default :
					LLLog(@"MTMacroHandler.parseTests Bad character %c", [buffer characterAtIndex:(bpos + 1)]);
					// remove the bad tokens
					[buffer deleteCharactersInRange:NSMakeRange(bpos, 2)];
					break;
			}
		}
	}	
}

/** parseConditionals */
- (void) parseConditionals:(NSMutableString *)buffer {
	
	for(int bpos = 1; bpos < [buffer length] - 1;) {
		if([buffer characterAtIndex:bpos] == '%' && [buffer characterAtIndex:bpos + 1] == '{') {
			char c = [buffer characterAtIndex:bpos - 1];
			if(c == '0' || c == '1') {
				[buffer deleteCharactersInRange:NSMakeRange(bpos - 1, 2)]; //	deleteChars(bpos - 1, bpos + 1);
				bpos = [self evaluateConditionalBlockStartingAt:(bpos - 1) inBuffer:buffer include:(c == '1')];
				continue;
			}
		} 
		++bpos;		
	}
}

/** evaluateConditionalBlock */
-  (int) evaluateConditionalBlockStartingAt:(int) bpos inBuffer:(NSMutableString *)buffer include: (bool) include {
	
	int remove_start = bpos;
	while(bpos < [buffer length] - 1) {
		if([buffer characterAtIndex:bpos] == '%') {
			switch([buffer characterAtIndex:bpos + 1]) {
				case '}' :					// done with this conditional, return
					if(!include) {
						[buffer deleteCharactersInRange:NSMakeRange(remove_start, bpos + 1 - remove_start)]; //	deleteChars(remove_start, bpos + 1);
						return remove_start;
					}
					[buffer deleteCharactersInRange:NSMakeRange(bpos, 1)];
					return bpos;
				case '{' :					// handle new conditional
					if(include) {
						char c = [buffer characterAtIndex:bpos - 1];
						if(c == '0' || c == '1') {
							[buffer deleteCharactersInRange:NSMakeRange(bpos - 1, 2)];
							// $$$ wauw recursion
							bpos = [self evaluateConditionalBlockStartingAt:bpos - 1 inBuffer:buffer include:c == '1'];
							continue;
						}
					}
					bpos += 2;
					break;
				case '!' :					// handle not indicator
					if(include) {
						remove_start = bpos;
						++bpos;
					}
					else {
						[buffer deleteCharactersInRange:NSMakeRange(remove_start, bpos + 1 - remove_start)]; 
						bpos = remove_start;
					}
					include = !include;
					break;
				default :
					++bpos;
			}
		}
		else {
			++bpos;
		}
	}
	if(!include) {
		[buffer deleteCharactersInRange:NSMakeRange(remove_start, [buffer length] - 1 - remove_start)]; //	deleteChars(remove_start, [buffer length] - 1);			
	}
	
	return [buffer length];	
}

/** parseRemaining */
- (void) parseRemaining:(NSMutableString *)buffer {
	for(int bpos = 0; bpos < [buffer length]; ++bpos) {
		if([buffer characterAtIndex:bpos] == '%') {
			[buffer deleteCharactersInRange:NSMakeRange(bpos, 1)];
		}
	}
}

@end
