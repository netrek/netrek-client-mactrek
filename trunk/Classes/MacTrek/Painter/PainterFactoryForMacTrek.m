//
//  PainterFactoryForMacTrek.m
//  MacTrek
//
//  Created by Aqua on 23/07/2006.
//  Copyright 2006 Luky Soft. See Licence.txt for licence details.
//

#import "PainterFactoryForMacTrek.h"


@implementation PainterFactoryForMacTrek

- (id) init {
	self = [super init];
	if (self != nil) {
		iconStaticScaler = 1; // keep icons small
	}
	return self;
}


- (NSImage *)loadImage:(NSString*)imageName {
    
    // try new image first
    NSString *pathToResources = [[NSBundle mainBundle] resourcePath];
    NSString *pathToImage = [NSString stringWithFormat:@"%@/ImagesPainter2%@", pathToResources, imageName];
    
    NSImage *rawImage = [[NSImage alloc] initWithContentsOfFile:pathToImage];
    
    if (rawImage == nil) {
        //LLLog(@"PainterFactoryForMacTrek.loadImage %@ failed, reverting to super", pathToImage);
        // something went wrong try super image
        return [super loadImage:imageName];
    }
       
    return rawImage;
}

- (void) cacheImages {
    [super cacheImages];
	
	// we have some different types of files 
	[imgBackground release];    
	imgBackground = [self cacheImage:@"/background.gif"];
	[imgFuel release];
	imgFuel       = [self cacheImage:@"/Planets/fuel.png"]; 
    [imgArmy release];
	imgArmy       = [self cacheImage:@"/Planets/army.png"]; 
    [imgRepair release];
	imgRepair     = [self cacheImage:@"/Planets/wrench.png"]; 
	[imgShipCloak release];
	imgShipCloak  = [self cacheImage:@"/Misc/cloak.png"];
	
}

- (void)   drawBackgroundImageInRect:(NSRect) Rect {
    NSRect sourceRect = NSMakeRect(0, 0, 0, 0);
    sourceRect.size = [imgBackground size];
    
    [imgBackground drawInRect:Rect fromRect:sourceRect  operation:NSCompositeSourceOver fraction:1.0];
}

- (NSSize) backGroundImageSize {
    return [imgBackground size];
}

- (NSString*) labelForPlayer:(Player*)player {
	
	// bug 1666845 Cloaked ships should be ?? (unless it is me)
	if (([player flags] & PLAYER_CLOAK) && (![player isMe])) {
		return @"??";
	}
	
	NSString *label = [NSString stringWithFormat:@"%@ (%@)", [player mapCharsWithKillIndicator],
		[player name]];
	
    // extended label?
	if ([player showInfo] || debugLabels) {
		label = [NSString stringWithFormat:@"%@ (%@)", [player mapCharsWithKillIndicator],
			[player nameWithRank]];
	}
	return label;
}

- (NSString*) label2ForPlayer:(Player*)player {
		
	// bug 1666845 Cloaked ships should be ?? (unless it is me)
	if (([player flags] & PLAYER_CLOAK) && (![player isMe])) {
		return nil;
	}
	
	// extended label?
	if ([player showInfo] || debugLabels) {
		return [NSString stringWithFormat:@"S%d K%d A%d T%d [%c%c%c%c%c%c]", 
			[player speed],
            [player kills],
            [player armies],
			[player availableTorps],
            ([player flags] & PLAYER_REPAIR ? 'R' : '-'),
            ([player flags] & PLAYER_BOMB ?   'B' : '-'),
            ([player flags] & PLAYER_ORBIT ?  'O' : '-'),
            ([player flags] & PLAYER_CLOAK ?  'C' : '-'),
            ([player flags] & PLAYER_BEAMUP ?  'U' : '-'),
            ([player flags] & PLAYER_BEAMDOWN ?  'D' : '-') ];
	} else {
		return nil;
	}
}

- (NSString*) label3ForPlayer:(Player*)player {
	
	return nil;
}

- (void) drawLabelBackgroundForRect:(NSRect)aRect {
	
	[shapes roundedLabel:aRect withColor:[NSColor grayColor]];
}

@end
