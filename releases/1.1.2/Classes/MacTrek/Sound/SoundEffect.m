//
//  SoundEffect.m
//  MacTrek
//
//  Created by Aqua on 03/07/2006.
//  Copyright 2006 Luky Soft. All rights reserved.
//

#import "SoundEffect.h"


@implementation SoundEffect

- (id) init {
    self = [super init];
    if (self != nil) {
		soundInstances = [[NSMutableArray alloc] init];
		autogrow = NO;
        name = nil;
    }
    return self;
}
/*
-(id) initSound:(QTMovie *)newSound withName:(NSString *)newName {
    self = [self init];
    if (self != nil) {
        sound = newSound;
        name = newName;
    }
    return self;
}*/

- (bool) loadSoundWithName:(NSString*)soundName {
	return [self loadSoundWithName:soundName nrOfInstances:SE_DEFAULT_INSTANCES];
}

- (bool) loadSoundWithName:(NSString*)soundName nrOfInstances:(int)nrOfInstances {

    // assume in resources/SoundEffects, and an .au file
    NSString *pathToResources = [[NSBundle mainBundle] resourcePath];
    NSString *pathToSound = [NSString stringWithFormat:@"%@/%@", pathToResources, soundName];
    [self setName:soundName];    
    
	QTMovie *sound;
	for (int i = 0; i < nrOfInstances; i++) {
		sound = [QTMovie movieWithFile:pathToSound error:nil];
		[soundInstances addObject:sound];
	}
    
    return YES;
}

-(QTMovie *)sound {
	QTMovie *sound;
	// find first free sound
	for (int i = 0; i < [soundInstances count]; i++) {
		
		sound = [soundInstances objectAtIndex:i];
		
		if (([sound currentTime].timeValue > 0 ) && 
			([sound currentTime].timeValue  < [sound duration].timeValue)) {
			//NSLog(@"SoundEffect.sound already playing sound %@, skipping....", name);
		} else {
			//NSLog(@"SoundEffect.sound free sound found %@", name);
			[sound gotoBeginning];
			return sound;
		}
	}
	// none found ...
	if (autogrow) {
		// do something
	}
	NSLog(@"SoundEffect.sound no free sound found %@", name);
	return nil;		
}

-(NSString *)name {
    return name;
}

/*
-(void) setSound:(QTMovie *)newSound {
    [sound release];
    sound = newSound;
    [sound retain];
}
*/

-(void) setName:(NSString *)newName {
    [name release];
    name = newName;
    [name retain];
}

-(void) play {
	QTMovie *sound = [self sound];	
	if (sound != nil) {
		[sound play];
	}
    
}

-(void) playWithVolume:(float)vol {
	QTMovie *sound = [self sound];
	if (sound != nil) {
		[sound setVolume:vol];
		NSLog(@"SoundEffect.playWithVolume %f sound %@", vol, name);
		[sound play];
	}
}

-(void) playWithVolume:(float)vol balance:(float)bal {
	
	QTMovie *sound = [self sound];
	if (sound != nil) {		
		// assume bal is between -1 and 1
		// convert to -128 to 127
		short balance = 127 * bal; // sort of..    
		
		// QTMovie * is actually a void pntr to the raw QT data media handler
			
		MediaSetSoundBalance((void*)sound, balance); 
		[sound setVolume:vol];
		NSLog(@"SoundEffect.playWithVolume %f balance %f (%d) sound %@", vol, bal, balance, name);
		[sound play];
	}
}

@end
