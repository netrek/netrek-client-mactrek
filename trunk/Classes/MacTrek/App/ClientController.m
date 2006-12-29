//
//  ClientController.m
//  MacTrek
//
//  Created by Aqua on 5/19/06.
//  Copyright 2006 Luky Soft. See Licence.txt for licence details.
//

#import "ClientController.h"


@implementation ClientController

// privates
bool ghostStart = NO;

- (id) init {
	self = [super init];
	if (self != nil) {      
        // need the main run loop other wise the performSelector afterDelay will fail
        [notificationCenter addObserver:self selector:@selector(checkForDeath:) name:@"SP_PSTATUS" 
                                 object:nil useLocks:NO useMainRunLoop:YES];
		communication = [[Communication alloc] init];
    }
	return self;
}

- (id) initWithUniverse:(Universe*)newUniverse {
	self = [self init];
	if (self != nil) {
		universe = newUniverse;
        communication = [[Communication alloc] initWithUniverse:universe baseUdpPort:0];
    }
	return self;
}

- (void) checkForDeath:(Player *)player {
    // did i die?
    if ([player isMe]) {
        NSLog(@"ClientController.checkForDeath status = %@", [player statusString]);
        if (([player status] == PLAYER_EXPLODE) ) {
            NSLog(@"ClientController.checkForDeath: firing delayed death warrent");
            // wait for the drawing to end 
            // $$ then generate an event on the drawing of the explosion!
            // [self performSelector: @selector(iDied:) withObject:player afterDelay: 2.0];
            // $$ doesn't happen.. after delay?
            [self iDied:player];
        }
    }
}

- (void) slowDeath:(Player *)me {
    // needed because this is called while still drawing the gameview 
    // changing the drawing now would invoke a different graphic context
    NSLog(@"ClientController.slowDeath: i think i am dead");
   [self performSelector: @selector(iDied:) withObject:me afterDelay: 0.1]; 
}


- (void) iDied:(Player *)me {
    // go to outfitting
    NSLog(@"ClientController.iDied: today was a good day to die");
    [me setStatus:PLAYER_OUTFIT];
    [notificationCenter postNotificationName:@"CC_GO_OUTFIT" 
                                      object:self 
                                    userInfo:nil];    
}

- (bool) slotObtained {
    
    // if i got a slot, i have become a player
	Player *me = [universe playerThatIsMe];
	if (me == nil) {
        NSLog(@"ClientController.slotObtained checking... nope");
        return NO;
    } else {
        NSLog(@"ClientController.slotObtained checking... YES");
        return YES;
    }    
}

- (void) setupSlot {
    
    // should only be called if i got a slot
    if (![self slotObtained]) {
        // i'm not a player yet
		 NSLog(@"ClientController.setupSlot called, but not a player");
		return; 
    }
    
    Player *me = [universe playerThatIsMe];
    
	// report our success
    NSLog(@"ClientController.setupSlot started");
	[notificationCenter postNotificationName:@"CC_SLOT_FOUND" 
									  object:self 
									userInfo:nil];
	
	if (ghostStart) {
		// see if i exploded
		if ([me damage] > [[me ship] maxDamage]) {
			[me setStatus:PLAYER_OUTFIT];
			// go to outfitting
			[notificationCenter postNotificationName:@"CC_GO_OUTFIT" 
											  object:self 
											userInfo:nil];
		} else {
			[me setStatus:PLAYER_ALIVE];
            // continue game
		}		
	} 
	
	return;
}


// use this when multithreading
- (void) findSlot {
    ///NSLog(@"ClientController.findSlot start looking for a slot");
    
    // loop until i find a slot $$ very BAD, wait for the proper event (something with
    // a player update i suppose :
    // SP_S_YOU_SS or SP_S_YOU or SP_YOU (probably the last entry) then unsubscribe
    // to avoid updates, for now it works ok
    if (![self slotObtained]) {
        // i'm not a player yet, keep trying
		[self performSelector: @selector(findSlot) withObject: self afterDelay: 0.1];
		return; 
    }
    [self setupSlot];
}

- (bool)sendSlotSettingsToServer {
	
	//try UDP
	//[communication sendUdpReq:[NSNumber numberWithInt:COMM_UDP]];
    [notificationCenter postNotificationName:@"COMM_SEND_SHORT_REQ" object:self userInfo:[NSNumber numberWithInt:COMM_UDP]];        
	//try short packets
	//[communication sendShortReq:[NSNumber numberWithInt:SPK_VON]];
    [notificationCenter postNotificationName:@"COMM_SEND_SHORT_REQ" object:self userInfo:[NSNumber numberWithInt:SPK_VON]];
	//send options we have set
	//[communication sendOptionsPacket];
    [notificationCenter postNotificationName:@"COMM_SEND_OPTIONS_PACKET" object:self userInfo:nil];
	// $$ don't ping yet
    //[communication sendPingReq:[NSNumber numberWithBool:NO]];
    [notificationCenter postNotificationName:@"COMM_SEND_PING_REQ" object:self userInfo:[NSNumber numberWithBool:NO]];
	//send desired updates per second
	//[communication sendUpdatePacket:[NSNumber numberWithInt:COMM_UPDATES_PER_SECOND]];
    [notificationCenter postNotificationName:@"COMM_SEND_UPDATE_PACKET" object:self userInfo:[NSNumber numberWithInt:COMM_UPDATES_PER_SECOND]]; 
    return YES;
}

- (void)singleReadFromServer {
    [communication readFromServer];
}

- (bool)startClientAt:(NSString *)server port:(int)port seperate:(bool)multiThread {
	
	NSLog(@"ClientController.startClientAt: %@ port %d", server, port);
    
    // call the server
	if ([communication callServer:server port:port]) {      
        //[notificationCenter postNotificationName:@"CC_SERVER_CALL_SUCCESS"];
        
        // start listening to it
        [communication setMultiThreaded:multiThread]; 
        if (multiThread) {
            // invoke a seperate thread to read from the server
            // and use findslot to check if it was successfull
			bool result = NO;
			
			// check if a session is in place
			if ([communication isSleeping]) {
				// try to awake the activity
				result = [communication awakeCommunicationThread];
			} else {
				result = [communication startCommunicationThread];
			}
				
            if (result) {            
                // try to find a slot
                [self findSlot];
                return YES;
            } else {
                NSLog(@"ClientController.startClientAt: ERROR starting thread");
                return NO;
            } 
        } else {
            // poll loop until we get a slot
            while (![self slotObtained]) {
                [communication readFromServer];  // $$ let's hope it doesn't block
            }
            // yeah we are in
            [self setupSlot];
            return YES;
        }

    } else {
        NSLog(@"ClientController.startClientAt: %@ port %d NO CONNECTION", server, port);
        [notificationCenter postNotificationName:@"CC_SERVER_CALL_FAILED"];
        return NO;
    }
}

- (void)stop {
    NSLog(@"ClientController.stop stoping thread and cleaning self");
	if ([communication isRunning]) {
		// try to suspend the activity
		[communication suspendCommunicationThread];
	} else {
		[communication stopCommunicationThread];
	}
	[communication cleanUp:self];	
    // remove me from the universe (or i become a ghost)
    [[universe playerThatIsMe] setIsMe:NO];
	//[universe reset];  // !!! must be done later
}

@end
