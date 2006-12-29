//
//  RCMmessage.h
//  MacTrek
//
//  Created by Aqua on 30/04/2006.
//  Copyright 2006 Luky Soft. See Licence.txt for licence details.
//

#import <Cocoa/Cocoa.h>
#import "Data.h"
#import "BaseClass.h"

@interface RCMmessage : BaseClass {
    int flags;
    int to;
    int type;
    Player *sender;
    Player *targetPlayer;
    int armies;
    int damage;
    int shields;
    Planet *targetPlanet;
    int weaponTemp;    
}

- (void) setFlags: (int) flags;
- (void) setTo: (int) to;
- (void) setType: (int) type;
- (void) setSender: (Player *)sender;
- (void) setTargetPlayer: (Player *)targetPlayer;
- (void) setArmies: (int) armies;
- (void) setDamage: (int) damage;
- (void) setShields: (int) shields;
- (void) setTargetPlanet: (Planet *)targetPlanet;
- (void) setWeaponTemp: (int) weaponTemp;

@end
