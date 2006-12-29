//
//  RCMmessage.m
//  MacTrek
//
//  Created by Aqua on 30/04/2006.
//  Copyright 2006 Luky Soft. See Licence.txt for licence details.
//

#import "RCMmessage.h"


@implementation RCMmessage

- (id) init {
    self = [super init];
    if (self != nil) {
        flags = 0;
        to = 0;
        type = 0;
        sender = nil;
        targetPlayer = nil;
        armies = 0;
        damage = 0;
        shields = 0;
        targetPlanet = nil;
        weaponTemp = 0;
    }
    return self;
}

- (void) setFlags: (int) newFlags {
    flags = newFlags;
}

- (void) setTo: (int) newTo{
    to = newTo;
}


- (void) setType: (int) newType{
    type = newType;
}


- (void) setSender: (Player *)newSender{
    sender = newSender;
}


- (void) setTargetPlayer: (Player *)newTargetPlayer{
    targetPlayer = newTargetPlayer;
}


- (void) setArmies: (int) newArmies{
    armies = newArmies;
}


- (void) setDamage: (int) newDamage{
    damage = newDamage;
}


- (void) setShields: (int) newShields{
    shields = newShields;
}


- (void) setTargetPlanet: (Planet *)newTargetPlanet{
    targetPlanet = newTargetPlanet;
}


- (void) setWeaponTemp: (int) newWeaponTemp {
    weaponTemp = newWeaponTemp;
}

@end
