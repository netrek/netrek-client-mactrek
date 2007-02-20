//
//  Postman.m
//  MacTrek
//
//  Created by Aqua on 06/08/2006.
//  Copyright 2006 Luky Soft. See Licence.txt for licence details.
//

#import "Postman.h"


@implementation Postman

// setup 
- (void) awakeFromNib {
    // user clicked on message list
    [notificationCenter addObserver:self selector:@selector(messageSelected:) name:@"MV_MESSAGE_SELECTION"];
    // user clicked on player list
    [notificationCenter addObserver:self selector:@selector(playerSelected:) name:@"PV_PLAYER_SELECTION"];
    // user manually choose a destination
    [notificationCenter addObserver:self selector:@selector(manualSelection:) name:@"GV_MESSAGE_DEST"];
	// check for hog request
	[notificationCenter addObserver:self selector:@selector(newMessage:) name:@"MV_NEW_MESSAGE"];
}

// check for hog request
- (void) newMessage:(NSString*) str {	
	
	// a hog request is 5 spaces
	// e.g.         < F2->ALL        >
	
	// Bug 1625370 hog calls do not end on 5 spaces, but consist of 5 spaces
	// thus stringlength is 15
	NSString *hog = [str substringWithRange:NSMakeRange(10, 5)];
	if ( ([hog isEqualToString:@"     "]) && ([str length] != 15) ){
		// found 5 spaces at starting at right spot in a string with the right length
	
		// respond by sending version number
		LLLog(@"Postman.newMessage hog request");
		// see if we can find the addressy
		NSRange range = [str rangeOfString:@"->"];
		if (range.location == NSNotFound) {
			// Bug 1625370 only reply to real users
			//LLLog(@"Postman.newMessage responding to ALL with version");
			//[self sendMessage:[NSString stringWithFormat:@"Running: %@ %@", APP_NAME, VERSION] to:@"ALL"];
		} else {
			NSString *origin = [[str substringToIndex:range.location] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
			LLLog(@"Postman.newMessage responding to %@ with version", origin);
			[self sendMessage:[NSString stringWithFormat:@"Running: %@ %@", APP_NAME, VERSION] to:origin];
		}		
	} 
}

// external event handling
- (void) messageSelected:(NSString*) str {
    // the sender may be a player 
    if ([str length] == 2) {
        // it is is [F|R|O|I] followed by index
        // check first
        if ([self individualIdOfAdress:[str substringWithRange:NSMakeRange(0,2)]] == nil) {
            LLLog(@"Postman.messageSelected can't find a sender in %@", str);
            return;
        }
        [self setDestination:[str substringWithRange:NSMakeRange(0,2)]];        
    } else if ([str characterAtIndex:0] == ' ') {
        // it is [F|R|O|I] followed by index
        // check first
        if ([self individualIdOfAdress:[str substringWithRange:NSMakeRange(1,2)]] == nil) {
            LLLog(@"Postman.messageSelected can't find a sender in %@", str);
            return;
        }
        [self setDestination:[str substringWithRange:NSMakeRange(1,2)]];
    } else if (([str characterAtIndex:2] == ' ') ||
               ([str characterAtIndex:2] == '-')) {
        // it is is [F|R|O|I] followed by index
        // check first
        if ([self individualIdOfAdress:[str substringWithRange:NSMakeRange(0,2)]] == nil) {
            LLLog(@"Postman.messageSelected can't find a sender in %@", str);
            return;
        }
        [self setDestination:[str substringWithRange:NSMakeRange(0,2)]];
    } else {
        // must be GOD or ALL or FED.. try:
        if ([self individualIdOfAdress:[str substringWithRange:NSMakeRange(0,3)]] == nil) {
            LLLog(@"Postman.messageSelected can't find a sender in %@", str);
            return;
        }
        [self setDestination:[str substringWithRange:NSMakeRange(0,3)]];        
    }
}

- (void) playerSelected:(NSString*) str {
    // player strings has the id between brackets
    NSRange temp = [str rangeOfString:@"("];
    if (temp.location == NSNotFound) {
        LLLog(@"Postman.playerSelected can't find a sender in %@", str);
        return;
    }
    int start = temp.location + 1;
    temp = [str rangeOfString:@")"];
    if (temp.location == NSNotFound) {
        LLLog(@"Postman.playerSelected can't find a sender in %@", str);
        return;
    }
    int size = temp.location - start; 
    
    [self messageSelected:[str substringWithRange:NSMakeRange(start, size)]];
}

- (void) manualSelection:(NSString*) str {
    [self setDestination:str];
}

// getters / setters
- (void) setDestination:(NSString*) dst {
    [toField setStringValue:dst];
    [commTextField becomeFirstResponder];
}

- (NSString*) destination {
    return [toField stringValue];
}

- (void) setMessage:(NSString*)msg {
    [commTextField setStringValue:msg];
}

- (NSString*) message {
    return [commTextField stringValue];
}


// sending logic
- (void) sendCurrentMessage {
    [self sendMessage:[self message] to:[self destination]];
}

- (void) sendMessage:(NSString*)msg to:(NSString*) dst {
    
    NSNumber *group = [self groupOfAdress:dst];
    NSNumber *indiv = [self individualIdOfAdress:dst];
    
    if (indiv == nil) {
        return;
    }

	if ((msg == nil) || ([msg isEqualToString:@""])) {
		LLLog(@"Postman.sendMessage refuse to send empty message");
        return;
    }
	
    [notificationCenter postNotificationName:@"COMM_SEND_MESSAGE" userInfo: [NSDictionary dictionaryWithObjectsAndKeys:
        group, @"group", indiv, @"indiv", msg, @"message", nil]];
    
    // it won't be echoed by the server, show it here
	/*
	 
	 bugfix, apperently it _is_ echoed on the server..
	 
    NSString *localEcho = [NSString stringWithFormat:@"%@ -> %@ %@", 
        [[universe playerThatIsMe] mapChars], dst, msg];
    [notificationCenter postNotificationName:@"PM_MESSAGE" userInfo:localEcho];    
	 */
}

- (NSNumber *) individualIdOfAdress:(NSString*) address {
    if        ([address isEqualToString:@"TEAM"]) {
        return [NSNumber numberWithChar:[[[universe playerThatIsMe] team] bitMask]];
    } else if ([address isEqualToString:@"ALL"]) {
        return [NSNumber numberWithChar:0];
    } else if ([address isEqualToString:@"FED"]) {
        return [NSNumber numberWithChar:[[universe teamWithId:TEAM_FED] bitMask]];
    } else if ([address isEqualToString:@"KLI"]) {
        return [NSNumber numberWithChar:[[universe teamWithId:TEAM_KLI] bitMask]];
    } else if ([address isEqualToString:@"ORI"]) {
        return [NSNumber numberWithChar:[[universe teamWithId:TEAM_ORI] bitMask]];
    } else if ([address isEqualToString:@"ROM"]) {
        return [NSNumber numberWithChar:[[universe teamWithId:TEAM_ROM] bitMask]];
    } else if ([address isEqualToString:@"GOD"]) {
        return [NSNumber numberWithChar:255];
    } else {
        // it must be a player [F|O|R|K][0..f]
        // find out the player id
        char playerId = [address characterAtIndex:1];
        if (playerId >= '0' && playerId <= '9') {
            playerId -= '0';
        } else if (playerId >= 'a' && playerId <= 'f'){
            playerId -= 'a';
            playerId += 10;
        } else {
            [notificationCenter postNotificationName:@"PM_WARNING" userInfo:@"Unknown player. message not sent."];
            LLLog(@"Postman.individualIdOfAdress Unknown player %@ message not sent.", address);
            return nil;  
        }

        // simple sanity check
        if ([[universe playerWithId:playerId] status] == PLAYER_FREE) {
            [notificationCenter postNotificationName:@"PM_WARNING" userInfo:@"That player left the game. message not sent."];
            LLLog(@"Postman.individualIdOfAdress player %@ left game message not sent.", address);
            return nil;
        }
        return [NSNumber numberWithChar:playerId];
    }    
}

- (NSNumber *) groupOfAdress:(NSString*) address {
    
    if        ([address isEqualToString:@"TEAM"]) {
        return [NSNumber numberWithChar:TEAM];
    } else if ([address isEqualToString:@"ALL"]) {
        return [NSNumber numberWithChar:ALL];
    } else if ([address isEqualToString:@"FED"]) {
        return [NSNumber numberWithChar:TEAM];
    } else if ([address isEqualToString:@"KLI"]) {
        return [NSNumber numberWithChar:TEAM];
    } else if ([address isEqualToString:@"ORI"]) {
        return [NSNumber numberWithChar:TEAM];
    } else if ([address isEqualToString:@"ROM"]) {
        return [NSNumber numberWithChar:TEAM];
    } else if ([address isEqualToString:@"GOD"]) {
        return [NSNumber numberWithChar:GOD];
    } else {
        return [NSNumber numberWithChar:INDIV];
    }    
}
     
// delegate functions of textfield
- (void)controlTextDidEndEditing:(NSNotification *)aNotification {
    if ([[self message] length] > 0) {
        LLLog(@"Postman.controlTextDidEndEditing sending message [%@]", [self message]);
        [self sendCurrentMessage];
        // clean up since the change of focus when the mouse moves creates a 
        // second event that we do not wish to send.
        // $$ alternatively check if we are losing first responder status since that is not
        // the same as pressing enter
        [self setMessage:@""];  
		// try to return the focus
		NSWindow *win = [gameView window];
		if ([win makeFirstResponder:gameView]) {
			LLLog(@"Postman.controlTextDidEndEditing returned focus");
		} else {
			LLLog(@"Postman.controlTextDidEndEditing ERROR returning focus");
		}
    } else {
        LLLog(@"Postman.controlTextDidEndEditing ignoring message %@", [self message]);
    }
}

@end
