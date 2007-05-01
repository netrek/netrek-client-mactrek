//
//  RSAWrapper.h
//  MacTrek
//
//  Created by Chris & Judith Lukassen on 15/11/2006.
//  Copyright 2006 Luky Soft. See Licence.txt for licence details.
//

#import <Cocoa/Cocoa.h>
#import "BaseClass.h"
#import <OmniNetworking/OmniNetworking.h>

// implicitly linked
void rsa_black_box(unsigned char *out, unsigned char *in,
                   unsigned char *public, unsigned char *global);

@interface RSAWrapper : BaseClass {

}

- (NSData *) encode:(NSMutableData *)data forHost:(ONHost*)host onPort:(int)port;

@end
