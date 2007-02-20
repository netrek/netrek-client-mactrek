//
//  SettingsController.m
//  MacTrek
//
//  Created by Aqua on 26/05/2006.
//  Copyright 2006 Luky Soft. See Licence.txt for licence details.
//

#import "SettingsController.h"


@implementation SettingsController

- (void) awakeFromNib {
    [notificationCenter addObserver:self selector:@selector(saveSettings) name:@"MC_LEAVING_SETTINGS"];
    [self setPreviousValues];
}

- (void) setPreviousValues {
    LLPersistantSettings *settings = [LLPersistantSettings defaultSettings];
    
    NSNumber *val;
    
    val = [settings valueForKey:@"MUSIC_LEVEL"];
    if (val != nil) {
        [musicLevel setFloatValue:[val floatValue]];
    }
    val = [settings valueForKey:@"FX_LEVEL"];
    if (val != nil) {
        [fxLevel setFloatValue:[val floatValue]];
    }
	val = [settings valueForKey:@"VOICE_CMDS"];
    if (val != nil) {
        if ([val boolValue]) {
			[voiceCmds setState:NSOnState];   
        } else {
            [voiceCmds setState:NSOffState];
        }        
    }
    val = [settings valueForKey:@"VOICE_OVER"];
    if (val != nil) {
        if ([val boolValue]) {
           [voiceOver setState:NSOnState];   
        } else {
            [voiceOver setState:NSOffState];
        }        
    }
	val = [settings valueForKey:@"ACCELERATE"];
    if (val != nil) {
        if ([val boolValue]) {
			[accelerateButton setState:NSOnState];   
        } else {
            [accelerateButton setState:NSOffState];
        }        
    }
    val = [settings valueForKey:@"THEME"];
    if (val != nil) {
        [graphicsModel setSelectedSegment:[val intValue]];
    }
	val = [settings valueForKey:@"TRACKING"];
    if (val != nil) {
        if ([val boolValue]) {
			[trackingEnabledButton setState:NSOnState];   
        } else {
            [trackingEnabledButton setState:NSOffState];
        }        
    }
	[[SimpleTracker defaultTracker] setEnabled:[self trackingEnabled]];
}

- (void) saveSettings {
    
    LLPersistantSettings *settings = [LLPersistantSettings defaultSettings];
    
    [settings setLazyValue:[NSNumber numberWithFloat:[self musicLevel]] forKey:@"MUSIC_LEVEL"];
    [settings setLazyValue:[NSNumber numberWithFloat:[self fxLevel]] forKey:@"FX_LEVEL"];
	[settings setLazyValue:[NSNumber numberWithBool:[self voiceCommands]] forKey:@"VOICE_CMDS"];
    [settings setLazyValue:[NSNumber numberWithBool:[self voiceEnabled]] forKey:@"VOICE_OVER"];
	[settings setLazyValue:[NSNumber numberWithBool:[self accelerate]] forKey:@"ACCELERATE"];
    [settings setLazyValue:[NSNumber numberWithInt:[self graphicsModel]] forKey:@"THEME"];   
	[settings setLazyValue:[NSNumber numberWithBool:[self trackingEnabled]] forKey:@"TRACKING"];
    [settings update];
	
	// an excellent place to tell the tracker what the status is
	[[SimpleTracker defaultTracker] setEnabled:[self trackingEnabled]];
}


- (bool)  trackingEnabled {
	return ([trackingEnabledButton state] == NSOnState);
}

- (float)  musicLevel {
    return [musicLevel floatValue];
}

- (float)  fxLevel {
    return [fxLevel floatValue];
}

- (bool) soundEnabled {
    if (([musicLevel intValue] > 0) ||  ([fxLevel intValue] > 0)) {
        return YES;
    } else {
        return NO;
    }
}

- (bool) accelerate {
    return ([accelerateButton state] == NSOnState);
}

- (bool) voiceCommands {
    return ([voiceCmds state] == NSOnState);
}

- (bool) voiceEnabled {
    return ([voiceOver state] == NSOnState);
}

- (int)  graphicsModel {
    return [graphicsModel selectedSegment];
}

@end
