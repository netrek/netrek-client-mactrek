//
//  PainterFactoryForMacTrek.m
//  MacTrek
//
//  Created by Aqua on 23/07/2006.
//  Copyright 2006 Luky Soft. All rights reserved.
//

#import "PainterFactoryForMacTrek.h"


@implementation PainterFactoryForMacTrek

- (NSImage *)loadImage:(NSString*)imageName {
    
    // try new image first
    NSString *pathToResources = [[NSBundle mainBundle] resourcePath];
    NSString *pathToImage = [NSString stringWithFormat:@"%@/ImagesPainter2%@", pathToResources, imageName];
    
    NSImage *rawImage = [[NSImage alloc] initWithContentsOfFile:pathToImage];
    
    if (rawImage == nil) {
        //NSLog(@"PainterFactoryForMacTrek.loadImage %@ failed, reverting to super", pathToImage);
        // something went wrong try super image
        return [super loadImage:imageName];
    }
       
    return rawImage;
}

- (void) cacheImages {
    [super cacheImages];
    imgBackground = [self cacheImage:@"/background.gif"];
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
