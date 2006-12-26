//
//  KeyMap.m
//  MacTrek
//
//  Created by Aqua on 21/04/2006.
//  Copyright 2006 Luky Soft. All rights reserved.
//

#import "MTKeyMap.h"


@implementation MTKeyMap

- (void) fillWithDefaults {
    MTKeyMapEntry *entry;
    
    // combat
    entry = [[MTKeyMapEntry alloc] initAction: ACTION_CLOAK 
                                    withKey:'c' 
                              modifierFlags: 0 
                                description: @"Toggle cloak"];
    [keyMap setObject:entry forKey:[NSNumber numberWithInt:[entry action]]];
    
    entry = [[MTKeyMapEntry alloc] initAction: ACTION_DET_ENEMY 
                                    withKey:'d' 
                              modifierFlags: 0 
                                description: @"Detonate enemy topedos"];
    [keyMap setObject:entry forKey:[NSNumber numberWithInt:[entry action]]];
    
    entry = [[MTKeyMapEntry alloc] initAction: ACTION_DET_OWN 
                                    withKey:'D' 
                              modifierFlags: 0 
                                description: @"Detonate own topedos"];
    [keyMap setObject:entry forKey:[NSNumber numberWithInt:[entry action]]];
        
    entry = [[MTKeyMapEntry alloc] initAction: ACTION_FIRE_PLASMA 
                                    withKey:'f' 
                              modifierFlags: 0 
                                description: @"Fire plasma torpedo"];
    [keyMap setObject:entry forKey:[NSNumber numberWithInt:[entry action]]];
    
    entry = [[MTKeyMapEntry alloc] initAction: ACTION_FIRE_TORPEDO
                                    withKey:'t' 
                              modifierFlags: 0 
                                description: @"Fire photon torpedo"];
    [keyMap setObject:entry forKey:[NSNumber numberWithInt:[entry action]]];
    
    entry = [[MTKeyMapEntry alloc] initAction: ACTION_FIRE_PHASER
                                    withKey:'p' 
                              modifierFlags: 0 
                                description: @"Fire phaser"];
    [keyMap setObject:entry forKey:[NSNumber numberWithInt:[entry action]]];
                
    
    entry = [[MTKeyMapEntry alloc] initAction: ACTION_SHIELDS
                                    withKey:'s' 
                              modifierFlags: 0 
                                description: @"Toggle shields"];
    [keyMap setObject:entry forKey:[NSNumber numberWithInt:[entry action]]];
    
    entry = [[MTKeyMapEntry alloc] initAction: ACTION_TRACTOR
                                    withKey:'y' 
                              modifierFlags: 0 
                                description: @"Toggle tractor beam"];
    [keyMap setObject:entry forKey:[NSNumber numberWithInt:[entry action]]];
    
    entry = [[MTKeyMapEntry alloc] initAction: ACTION_PRESSOR
                                    withKey:'u' 
                              modifierFlags: 0 
                                description: @"Toggle pressor beam"];
    [keyMap setObject:entry forKey:[NSNumber numberWithInt:[entry action]]];
    
    // Movement And Navigation Functions:
    entry = [[MTKeyMapEntry alloc] initAction: ACTION_WARP_0 
                                    withKey:'0' 
                              modifierFlags: 0 
                                description: @"Set speed to warp 0 (stop)"];
    [keyMap setObject:entry forKey:[NSNumber numberWithInt:[entry action]]];
    
    entry = [[MTKeyMapEntry alloc] initAction: ACTION_WARP_1 
                                    withKey:'1' 
                              modifierFlags: 0 
                                description: @"Set speed to warp 1"];
    [keyMap setObject:entry forKey:[NSNumber numberWithInt:[entry action]]];
    
    entry = [[MTKeyMapEntry alloc] initAction: ACTION_WARP_2
                                    withKey:'2' 
                              modifierFlags: 0 
                                description: @"Set speed to warp 2"];
    [keyMap setObject:entry forKey:[NSNumber numberWithInt:[entry action]]];
    
    entry = [[MTKeyMapEntry alloc] initAction: ACTION_WARP_3 
                                    withKey:'3' 
                              modifierFlags: 0 
                                description: @"Set speed to warp 3"];
    [keyMap setObject:entry forKey:[NSNumber numberWithInt:[entry action]]];
    
    entry = [[MTKeyMapEntry alloc] initAction: ACTION_WARP_4 
                                    withKey:'4' 
                              modifierFlags: 0 
                                description: @"Set speed to warp 4"];
    [keyMap setObject:entry forKey:[NSNumber numberWithInt:[entry action]]];
    
    entry = [[MTKeyMapEntry alloc] initAction: ACTION_WARP_5
                                    withKey:'5' 
                              modifierFlags: 0 
                                description: @"Set speed to warp 5"];
    [keyMap setObject:entry forKey:[NSNumber numberWithInt:[entry action]]];
    
    entry = [[MTKeyMapEntry alloc] initAction: ACTION_WARP_6
                                    withKey:'6' 
                              modifierFlags: 0 
                                description: @"Set speed to warp 6"];
    [keyMap setObject:entry forKey:[NSNumber numberWithInt:[entry action]]];
    
    entry = [[MTKeyMapEntry alloc] initAction: ACTION_WARP_7
                                    withKey:'7' 
                              modifierFlags: 0 
                                description: @"Set speed to warp 7"];
    [keyMap setObject:entry forKey:[NSNumber numberWithInt:[entry action]]];
    
    entry = [[MTKeyMapEntry alloc] initAction: ACTION_WARP_8 
                                    withKey:'8' 
                              modifierFlags: 0 
                                description: @"Set speed to warp 8"];
    [keyMap setObject:entry forKey:[NSNumber numberWithInt:[entry action]]];
    
    entry = [[MTKeyMapEntry alloc] initAction: ACTION_WARP_9 
                                    withKey:'9' 
                              modifierFlags: 0 
                                description: @"Set speed to warp 9"];
    [keyMap setObject:entry forKey:[NSNumber numberWithInt:[entry action]]];
    
    entry = [[MTKeyMapEntry alloc] initAction: ACTION_WARP_10 
                                    withKey:')' 
                              modifierFlags: 0 
                                description: @"Set speed to warp 10"];
    [keyMap setObject:entry forKey:[NSNumber numberWithInt:[entry action]]];
    
    entry = [[MTKeyMapEntry alloc] initAction: ACTION_WARP_11 
                                    withKey:'!' 
                              modifierFlags: 0 
                                description: @"Set speed to warp 11"];
    [keyMap setObject:entry forKey:[NSNumber numberWithInt:[entry action]]];
    
    entry = [[MTKeyMapEntry alloc] initAction: ACTION_WARP_12
                                    withKey:'@' 
                              modifierFlags: 0 
                                description: @"Set speed to warp 12"];
    [keyMap setObject:entry forKey:[NSNumber numberWithInt:[entry action]]];
    
    entry = [[MTKeyMapEntry alloc] initAction: ACTION_WARP_MAX
                                    withKey:'%' 
                              modifierFlags: 0 
                                description: @"Set speed to maximum warp"];
    [keyMap setObject:entry forKey:[NSNumber numberWithInt:[entry action]]];
    
    entry = [[MTKeyMapEntry alloc] initAction: ACTION_WARP_HALF_MAX
                                    withKey:'#' 
                              modifierFlags: 0 
                                description: @"Set speed to half of maximum warp"];
    [keyMap setObject:entry forKey:[NSNumber numberWithInt:[entry action]]];
    
    entry = [[MTKeyMapEntry alloc] initAction: ACTION_WARP_INCREASE
                                    withKey:'>' 
                              modifierFlags: 0 
                                description: @"Increase speed by 1"];
    [keyMap setObject:entry forKey:[NSNumber numberWithInt:[entry action]]];
    
    entry = [[MTKeyMapEntry alloc] initAction: ACTION_WARP_DECREASE
                                    withKey:'<' 
                              modifierFlags: 0 
                                description: @"Decrease speed by 1"];
    [keyMap setObject:entry forKey:[NSNumber numberWithInt:[entry action]]];
    
    entry = [[MTKeyMapEntry alloc] initAction: ACTION_SET_COURSE
                                    withKey:'k' 
                              modifierFlags: 0 
                                description: @"Set course"];
    [keyMap setObject:entry forKey:[NSNumber numberWithInt:[entry action]]];
        
    entry = [[MTKeyMapEntry alloc] initAction: ACTION_LOCK
                                    withKey:'l' 
                              modifierFlags: 0 
                                description: @"Lock on target"];
    [keyMap setObject:entry forKey:[NSNumber numberWithInt:[entry action]]];
                        
    entry = [[MTKeyMapEntry alloc] initAction: ACTION_PRACTICE_BOT
                                    withKey:'*' 
                              modifierFlags: 0 
                                description: @"Send in practice bot"];
    [keyMap setObject:entry forKey:[NSNumber numberWithInt:[entry action]]];
    
    entry = [[MTKeyMapEntry alloc] initAction: ACTION_TRANSWARP
                                    withKey:'*' 
                              modifierFlags: 0 
                                description: @"Engage transwarp drive"];
    [keyMap setObject:entry forKey:[NSNumber numberWithInt:[entry action]]];
    
    // Planet Functions                                
    entry = [[MTKeyMapEntry alloc] initAction: ACTION_BOMB
                                    withKey:'b' 
                              modifierFlags: 0 
                                description: @"Bombard planet"];
    [keyMap setObject:entry forKey:[NSNumber numberWithInt:[entry action]]];
    
    entry = [[MTKeyMapEntry alloc] initAction: ACTION_ORBIT
                                    withKey:'o' 
                              modifierFlags: 0 
                                description: @"Orbit planet"];
    [keyMap setObject:entry forKey:[NSNumber numberWithInt:[entry action]]];
                                    
    entry = [[MTKeyMapEntry alloc] initAction: ACTION_BEAM_DOWN
                                    withKey:'x' 
                              modifierFlags: 0 
                                description: @"Beam armies down"];
    [keyMap setObject:entry forKey:[NSNumber numberWithInt:[entry action]]];
    
    entry = [[MTKeyMapEntry alloc] initAction: ACTION_BEAM_UP
                                    withKey:'z' 
                              modifierFlags: 0 
                                description: @"Beam armies up"];
    [keyMap setObject:entry forKey:[NSNumber numberWithInt:[entry action]]];
                                    
    //Message Functions
    entry = [[MTKeyMapEntry alloc] initAction: ACTION_DISTRESS_CALL
                                    withKey:'E' 
                              modifierFlags: 0 
                                description: @"Send distress call"];
    [keyMap setObject:entry forKey:[NSNumber numberWithInt:[entry action]]];       
    
    entry = [[MTKeyMapEntry alloc] initAction: ACTION_ARMIES_CARRIED_REPORT
                                    withKey:'F' 
                              modifierFlags: 0 
                                description: @"Send armies carried report"];
    [keyMap setObject:entry forKey:[NSNumber numberWithInt:[entry action]]]; 

    entry = [[MTKeyMapEntry alloc] initAction: ACTION_MESSAGE
                                    withKey:'m' 
                              modifierFlags: 0 
                                description: @"Start sending message"];
    [keyMap setObject:entry forKey:[NSNumber numberWithInt:[entry action]]]; 
          
    // Macro and RCD left out for now
    
    // Misc. Functions
    entry = [[MTKeyMapEntry alloc] initAction: ACTION_DOCK_PERMISSION
                                    withKey:'e' 
                              modifierFlags: 0 
                                description: @"Toggle docking permission"];
    [keyMap setObject:entry forKey:[NSNumber numberWithInt:[entry action]]];                                     
                                      
    entry = [[MTKeyMapEntry alloc] initAction: ACTION_INFO
                                    withKey:'i' 
                              modifierFlags: 0 
                                description: @"Get information on object near mouse"];
    [keyMap setObject:entry forKey:[NSNumber numberWithInt:[entry action]]];       
                                            
    entry = [[MTKeyMapEntry alloc] initAction: ACTION_REFIT
                                    withKey:'r' 
                              modifierFlags: 0 
                                description: @"Refit to different shiptype"];    
    [keyMap setObject:entry forKey:[NSNumber numberWithInt:[entry action]]];
        
    entry = [[MTKeyMapEntry alloc] initAction: ACTION_REPAIR
                                    withKey:'R' 
                              modifierFlags: 0 
                                description: @"Shut down for repairs"];    
    [keyMap setObject:entry forKey:[NSNumber numberWithInt:[entry action]]]; 
     
    entry = [[MTKeyMapEntry alloc] initAction: ACTION_QUIT
                                    withKey:'q' 
                              modifierFlags: 0 
                                description: @"Quit"];    
    [keyMap setObject:entry forKey:[NSNumber numberWithInt:[entry action]]];                                                        

    //Window And Display Functions:
    entry = [[MTKeyMapEntry alloc] initAction: ACTION_HELP
                                    withKey:'h' 
                              modifierFlags: 0 
                                description: @"Show help window"];    
    [keyMap setObject:entry forKey:[NSNumber numberWithInt:[entry action]]];
    
    entry = [[MTKeyMapEntry alloc] initAction: ACTION_DEBUG
                                      withKey:'?' 
                                modifierFlags: 0 
                                  description: @"Activate debug labels"];    
    [keyMap setObject:entry forKey:[NSNumber numberWithInt:[entry action]]];
		
    entry = [[MTKeyMapEntry alloc] initAction: ACTION_SCREENSHOT
                                      withKey:'\\' 
                                modifierFlags: 0 
                                  description: @"Take screenshot"];    
    [keyMap setObject:entry forKey:[NSNumber numberWithInt:[entry action]]];

	entry = [[MTKeyMapEntry alloc] initAction: ACTION_WAR
                                      withKey:'W' 
                                modifierFlags: 0 
                                  description: @"Declare war on nearest planet"];    
    [keyMap setObject:entry forKey:[NSNumber numberWithInt:[entry action]]];
	
	entry = [[MTKeyMapEntry alloc] initAction: ACTION_COUP
                                      withKey:'C' 
                                modifierFlags: 0 
                                  description: @"Coup homeplanet"];    
    [keyMap setObject:entry forKey:[NSNumber numberWithInt:[entry action]]];
	
}

- (id) init {
    self = [super init];
    if (self != nil) {
        // create a default
        keyMap = [[NSMutableDictionary alloc] init];        
        [self fillWithDefaults];
        // set vars
        changedSinceLastWrite = NO;
        NSString *pathToResources = [[NSBundle mainBundle] resourcePath];
        pathToKeyMap = [NSString stringWithFormat:@"%@/keymap.xml", pathToResources];
        [pathToKeyMap retain];
    }

    return self;
}

/*
- (id) initWithDefaultFile {
    NSString *pathToResources = [[NSBundle mainBundle] resourcePath];
    pathToKeyMap = [NSString stringWithFormat:@"%@/keymap.xml", pathToResources];
    
    self = [self initWithFile:pathToKeyMap];
    if (self != nil) {
        if ([keyMap count] == 0) {
            // something went wrong
            NSLog(@"MTKeyMap.initWithDefaultFile keymap file is empty, loading defaults");
            [self fillWithDefaults];
        } else {
            NSLog(@"MTKeyMap.initWithDefaultFile keymap file loaded %d", [keyMap count]);
        }
        
    }
    return self;
}


- (id) initWithFile:(NSString *) file {
    self = [super init];
    if (self != nil) {
        // load keymap as dict in dict
        NSMutableDictionary *temp = [[NSMutableDictionary alloc] initWithContentsOfFile:file];
        
        // iterate temp and add all entries as keyMapEntries
        NSEnumerator *enumerator = [temp keyEnumerator];
        NSDictionary *entryAsDict;
        
        // convert all dicts to Keymap entries and add them
        while ((entryAsDict = [temp objectForKey:[enumerator nextObject]])) {
            MTKeyMapEntry *keyEntry = [[MTKeyMapEntry alloc] initWithDictionairy:entryAsDict];
            [keyMap setObject:keyEntry forKey:[NSNumber numberWithInt:[keyEntry action]]];
        }        
        
        // set vars
        changedSinceLastWrite = NO;
        NSString *pathToResources = [[NSBundle mainBundle] resourcePath];
        pathToKeyMap = [NSString stringWithFormat:@"%@/keymap.xml", pathToResources];
        [pathToKeyMap retain];
    }
    return self;
}
*/

- (void) readDefaultKeyMap {
    // create a private pool for this thread
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    // load keymap
    NSMutableDictionary *newKeyMap = [[NSMutableDictionary alloc] init];
    
    // --- copy from init with file
    // load keymap as dict in dict
    NSMutableDictionary *temp = [[NSMutableDictionary alloc] initWithContentsOfFile:pathToKeyMap];
    
    // iterate temp and add all entries as keyMapEntries
    NSEnumerator *enumerator = [temp keyEnumerator];
    NSDictionary *entryAsDict;
    
    // convert all dicts to Keymap entries and add them
    while ((entryAsDict = [temp objectForKey:[enumerator nextObject]])) {
        MTKeyMapEntry *keyEntry = [[MTKeyMapEntry alloc] initWithDictionairy:entryAsDict];
        NSLog(@"MTKeyMap.readDefaultKeyMap setting key [%c] for action: %@", [keyEntry key], [keyEntry description]);
        [newKeyMap setObject:keyEntry forKey:[NSNumber numberWithInt:[keyEntry action]]];
    }          
    // ---
    
    if ([newKeyMap count] == 0) {
        // something went wrong
        NSLog(@"MTKeyMap.readDefaultKeyMap keymap file is empty");
        return;
    } else {
        NSLog(@"MTKeyMap.readDefaultKeyMap loaded %d items", [newKeyMap count]);
    }
    // swap maps
    [keyMap release];
    keyMap = newKeyMap;

    [pool release];
}

- (void) writeToFile:(NSString *)file {
    
    NSMutableDictionary *temp = [[NSMutableDictionary alloc] init];
    
    // iterate keyMap and add all entries as dictionairies
    NSEnumerator *enumerator = [keyMap keyEnumerator];
    MTKeyMapEntry *keyEntry;
    
    while ((keyEntry = [keyMap objectForKey:[enumerator nextObject]])) {
        NSDictionary *dict = [keyEntry asDictionary];      
        [temp setObject:dict forKey:[NSString stringWithFormat:@"%d", [keyEntry action]]];
    }
    
    // dicts in dicts can be written to disk
    if ([temp writeToFile:file atomically:NO]) {
        NSLog(@"MTKeyMap.writeToFile %@ successfull", file);
    } else {
        NSLog(@"MTKeyMap.writeToFile %@ failed", file); 
    }

    changedSinceLastWrite = NO;
    [temp removeAllObjects];
    [temp release];
}

- (void)writeToDefaultFileIfChanged {
    if (changedSinceLastWrite) {
        [self writeToFile:pathToKeyMap];
    }
}

// not very efficient this code will be invoked a lot, so maybe
// create a hashtable on keys as well and not only on actions.
- (int) actionForKey:(char) key withModifierFlags:(unsigned int) flags {
    NSEnumerator *enumerator = [keyMap keyEnumerator];
    MTKeyMapEntry *keyEntry;
      
    while ((keyEntry = [keyMap objectForKey:[enumerator nextObject]])) {
        if (keyEntry != nil) { 
            if (([keyEntry key] == key)  
                // && ([keyEntry modifierFlags] == flags)  // ignoring modifiers for now $$
                ) {
                return [keyEntry action];
            } 
        }
    }
    return ACTION_UNKNOWN;
}

- (NSString *) descriptionForAction:(int) action {
    MTKeyMapEntry *keyEntry = [keyMap objectForKey:[NSNumber numberWithInt: action]];
    return [keyEntry description];
}

- (char) keyForAction:(int) action {
    MTKeyMapEntry *keyEntry = [keyMap objectForKey:[NSNumber numberWithInt: action]];
    return [keyEntry key]; 
}
- (unsigned int) flagsForAction:(int) action {
    MTKeyMapEntry *keyEntry = [keyMap objectForKey:[NSNumber numberWithInt: action]];
    return [keyEntry modifierFlags];
}
- (void) setKey: (char) key forAction:(int) action {
    MTKeyMapEntry *keyEntry = [keyMap objectForKey:[NSNumber numberWithInt: action]];
    [keyEntry setKey:key];
    changedSinceLastWrite = YES;
}
- (void) setFlags: (unsigned int) flags ForAction:(int) action {
    MTKeyMapEntry *keyEntry = [keyMap objectForKey:[NSNumber numberWithInt: action]];
    [keyEntry setModifierFlags:flags];
    changedSinceLastWrite = YES;
}

- (int) count {
    return [keyMap count];
}

- (NSArray *) allKeys {
    return [keyMap allKeys];
}

@end
