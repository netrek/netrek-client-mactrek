//
//  PainterFactory.m
//  MacTrek
//
//  Created by Aqua on 19/06/2006.
//  Copyright 2006 Luky Soft. See Licence.txt for licence details.
//

#import "PainterFactory.h"

@implementation PainterFactory


#define ALERT_FILTER (PLAYER_GREEN | PLAYER_YELLOW | PLAYER_RED)

- (id) init {
    self = [super init];
    if (self != nil) {
        // init vars
        backGroundStartPoint.x = 0;
        backGroundStartPoint.y = 0;
        debugLabels = NO;
        simple = NO;
		accelerate = NO;
        alert = PLAYER_GREEN;
        
        //create helpers
        galaxy = NSMakeRect(0, 0, UNIVERSE_PIXEL_SIZE, UNIVERSE_PIXEL_SIZE);
        trigonometry = [LLTrigonometry defaultInstance];
        shapes = [[LLShapes alloc] init];
        line = [[NSBezierPath alloc] init];        
        dashedLine = [[NSBezierPath alloc] init];
        float dash[] = { 1.0, 3.0 };
        [dashedLine setLineDash: dash count: 2 phase: 0.0]; 
        
        normalStateAttribute =[[NSMutableDictionary dictionaryWithObjectsAndKeys:
        [NSColor whiteColor],NSForegroundColorAttributeName,nil] retain];
        // initial cache is in seperate thread
        [NSThread detachNewThreadSelector:@selector(cacheImagesInSeperateThread:) toTarget:self withObject:nil];

    }
    return self;
}

- (void) setSimplifyDrawing:(bool)simpleDraw {
    simple = simpleDraw;
}

- (void) setAccelerate:(bool)accel {
	NSLog(@"PainterFactory.setAccelerate");
    accelerate = accel;
}

- (void) setDebugLabels:(bool)debug {
    debugLabels = debug;
}

- (bool) debugLabels {
    return debugLabels;
}

- (int) maxScale {
    return 400; // 10* netrek zoom out
}

- (int) minScale {
    return 2;   // netrek game grid
}

// overrule in subclass to cache the images
- (void) cacheImages {
    // takes about 5 seconds..
    sleep(2);
}

- (void) cacheImagesInSeperateThread:(id)sender {
    
    // create a private pool for this thread
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    NSLog(@"PainterFactory.cacheImagesInSeperateThread: start running");
    [self cacheImages];
    NSLog(@"PainterFactory.cacheImagesInSeperateThread: complete");
    
    [notificationCenter postNotificationName:@"PF_IMAGES_CACHED"];
    
    // release the pool
    [pool release];
}

- (NSSize) backGroundImageSize {
    return PF_DEFAULT_BACKGROUND_IMAGE_SIZE;
}

- (NSColor*) colorForTeam:(Team*)team {
    return [team colorForTeam];
}

- (NSPoint) centreOfRect:(NSRect)aRect {

    return [shapes centreOfRect:aRect];
}

- (NSPoint) gamePointFromViewPoint:(NSPoint)point withMeInViewRect:(NSRect)bounds withScale:(int)scale {
     
    // our game pos
    NSPoint centrePos = [[universe playerThatIsMe] predictedPosition];
    return [self gamePointFromViewPoint:point viewRect:bounds gamePosInCentreOfView:centrePos withScale:scale];
}

- (NSPoint) gamePointFromViewPoint:(NSPoint)point viewRect:(NSRect)bounds 
             gamePosInCentreOfView:(NSPoint)centrePos withScale:(int)scale {
    
    // we are in the center of our view, thus bounds / 2
    // get the relative position in the view
    int deltaX = point.x - (bounds.size.width / 2);
    int deltaY = point.y - (bounds.size.height / 2);

    
    // the point is relative to me with scaling
    NSPoint gamePoint;
    gamePoint.x = centrePos.x + deltaX*scale;
    gamePoint.y = centrePos.y + deltaY*scale;
    
    return gamePoint;    
}

// warning: this does not effect the origin
// for that i need to know the view bounds
- (NSSize)  gameSizeFromViewSize:(NSSize)rect withScale:(int)scale {
    
    NSSize size;
    
    size.height = rect.height*scale;
    size.width  = rect.width*scale;
    
    return size;
}
    
- (NSRect) gameRectAround:(NSPoint)gamePoint forView:(NSRect)bounds withScale:(int)scale {
            
    // optimise a little
    static NSRect result;
    static NSRect previousBounds;
    static int previousScale;

    previousScale = scale;
    previousBounds = bounds;
    
    // resize the bounds to the right scale
    result.size = [self gameSizeFromViewSize:bounds.size withScale:scale];
    
    // the view frame starts at 0,0 but that is not the origin of
    // the game view
    result.origin = [self gamePointFromViewPoint:bounds.origin
                                        viewRect:bounds 
                           gamePosInCentreOfView:gamePoint 
                                       withScale:scale];  
    return result;
}

- (NSSize)  viewSizeFromGameSize:(NSSize)rect withScale:(int)scale{
    
    NSSize size;
    
    size.height = rect.height / scale;
    size.width  = rect.width / scale;
    
    return size;
}

- (NSPoint) viewPointFromGamePoint:(NSPoint)point withMeInViewRect:(NSRect)bounds withScale:(int)scale {    
    // our game pos
    NSPoint centrePos = [[universe playerThatIsMe] predictedPosition];
    return [self viewPointFromGamePoint:point viewRect:bounds gamePosInCentreOfView:centrePos withScale:scale];
}

- (NSPoint) viewPointFromGamePoint:(NSPoint)point viewRect:(NSRect)bounds 
             gamePosInCentreOfView:(NSPoint)centrePos withScale:(int)scale {
    // offset to the other point
    int deltaX = point.x - centrePos.x;
    int deltaY = point.y - centrePos.y;
    
    // we are in the center of our view, thus bounds / 2
    // the point is relative to me with scaling
    NSPoint viewPoint;
    viewPoint.x = (bounds.size.width / 2) + deltaX / scale;
    viewPoint.y = (bounds.size.height / 2) + deltaY / scale;
    
    return viewPoint;    
}

- (void) drawAlertBorder:(NSRect) bounds forMe:(Player *)me {
    
    // Change border color to signify alert status
    if (alert != ([me flags] & ALERT_FILTER)) {
        alert = ([me flags] & ALERT_FILTER);
        // probably START on change to RED, abort on all other
        [notificationCenter postNotificationName:@"PL_ALERT_STATUS_CHANGED" userInfo:[NSNumber numberWithInt:alert]]; 
    }
    if ([me flags] & ALERT_FILTER) {
        switch (alert) {
			case PLAYER_GREEN :
                [[NSColor greenColor] set];
				break;
			case PLAYER_YELLOW :
                [[NSColor yellowColor] set];
				break;
			case PLAYER_RED :
                [[NSColor redColor] set];
				break;
        }		

        // draw the border
        [line removeAllPoints];
        [line appendBezierPathWithRect:bounds];
        float oldWidth = [line lineWidth]; // remember
        [line setLineWidth: PF_ALERT_BORDER_WIDTH];
        [line stroke];
        [line setLineWidth:oldWidth]; // restore
    }
    
}

- (void) drawBackgroundInRect:(NSRect) drawingBounds ofViewBounds:(NSRect)viewBounds forMe:(Player*) me {
    
    // get the size of the stamp
    NSSize backGroundImageSize = [self backGroundImageSize];
    // use a local var so we can debug...
    NSPoint startPoint = backGroundStartPoint;
    
    // $$ scale the stars (nah don't do that)
    
    // move the start point away  in the oposite dir, based on my speed
    float course = [me course];
    
    startPoint.y -= cos(course) * (float)[me speed] / 4.0f;
    startPoint.x -= sin(course) * (float)[me speed] / 4.0f;
    
    //NSLog(@"### c %f sp (%f, %f)", course, startPoint.x, startPoint.y);
    
    // repeat the bitmap if it shifted completely out of view
    if(startPoint.x < -backGroundImageSize.width) {
        startPoint.x += backGroundImageSize.width;
    }
    else if(startPoint.x > 0.0f) {
        startPoint.x -= backGroundImageSize.width;
    } 
    if(startPoint.y < -backGroundImageSize.height) {
        startPoint.y += backGroundImageSize.height;
    }
    else if(startPoint.y > 0.0f) {
        startPoint.y -= backGroundImageSize.height;	
    }
    
    // paint the image all over the the bounds that have been given for view
    NSRect targetArea;
    // $$ do not scale the stars here?
    targetArea.size = backGroundImageSize;
    // go and paint 
    for(int y = (int)startPoint.y; y < viewBounds.size.height; y += backGroundImageSize.height) {
        for(int x = (int)startPoint.x; x < viewBounds.size.width; x += backGroundImageSize.width) {
            targetArea.origin.x = x;
            targetArea.origin.y = y;
            
            // is the image in the drawing rectangle?
            if (!NSIntersectsRect(targetArea, drawingBounds)) {
                continue;
            } 
            
            [self drawBackgroundImageInRect: targetArea];
        }
    } 
    
    backGroundStartPoint = startPoint;
}

- (void) drawGalaxyEdgesInRect:(NSRect) drawingBounds forGameRect:(NSRect)gameBounds ofViewBounds:(NSRect)viewBounds withScale:(int)scale {
    
    // the line color
    [[NSColor brownColor] set];
    
    // orgin in view coordinates
    NSPoint upperLeft = [self viewPointFromGamePoint:NSMakePoint(0, 0) 
                                            viewRect:viewBounds
                               gamePosInCentreOfView:[self centreOfRect:gameBounds]
                                           withScale:scale];
    NSPoint lowerRight = [self viewPointFromGamePoint:NSMakePoint(UNIVERSE_PIXEL_SIZE, UNIVERSE_PIXEL_SIZE)
                                             viewRect:viewBounds 
                                gamePosInCentreOfView:[self centreOfRect:gameBounds] 
                                            withScale:scale];
    
    // $$ but do we need to draw it ? check with drawingBounds to make sure...
    // $$ todo, but it is only a few lines    
    
    // are we near the north line?
    if (gameBounds.origin.y <= 0) {
        [line removeAllPoints];
        [line moveToPoint:upperLeft];
        [line lineToPoint:NSMakePoint(lowerRight.x, upperLeft.y)];
        [line stroke];        
    }
    
    // are we near the south line?
    if (gameBounds.origin.y + gameBounds.size.height > UNIVERSE_PIXEL_SIZE) {
        [line removeAllPoints];
        [line moveToPoint:lowerRight];
        [line lineToPoint:NSMakePoint(upperLeft.x, lowerRight.y)];
        [line stroke];        
    }
    
    // are we near the west line?
    if (gameBounds.origin.x <= 0) {       
        [line removeAllPoints];
        [line moveToPoint:upperLeft];
        [line lineToPoint:NSMakePoint(upperLeft.x, lowerRight.y)];
        [line stroke];        
    }
    
    // are we near the east line?
    if (gameBounds.origin.x + gameBounds.size.width > UNIVERSE_PIXEL_SIZE) {
        [line removeAllPoints];
        [line moveToPoint:lowerRight];
        [line lineToPoint:NSMakePoint(lowerRight.x, upperLeft.y)];
        [line stroke];        
    }
    
}

- (void)drawPlanetsInRect:(NSRect)drawingBounds forGameRect:(NSRect)gameBounds ofViewBounds:(NSRect)viewBounds withScale:(int)scale {
    
    NSRect planetGameBounds;
    NSRect planetViewBounds;
    Planet *planet;
    NSPoint centreOfGameBounds = [self centreOfRect:gameBounds];
    
    // request it once for efficiency, planets do not change maxFuse
    // (like explode)
    int maxFuse = [self maxFuseForPlanet];
    
    for (int i = 0; i < UNIVERSE_MAX_PLANETS; i++) {
        planet = [universe planetWithId:i];
        
        // ---
        // check for fuse and status changes
        // ---       
        // check fuse overrun (maxfuse (n) sets the number of frames 0..n-1)
        if ((!simple) &&([planet fuse] >= maxFuse)) {
            // reset the counter we will loop the images for  planets
            [planet setFuse:0];                
        }
        
        // ---
        // the actual drawing code
        // ---
        
        // check if in other dimension
        if (!NSPointInRect([planet predictedPosition], galaxy)) {
            continue;
        } 
        // get the rect around the planet in game coordinates
        planetGameBounds.origin = [planet predictedPosition];
        planetGameBounds.size = [planet size];
        // offset the origin to the upper left
        planetGameBounds.origin.x -= planetGameBounds.size.width / 2;
        planetGameBounds.origin.y -= planetGameBounds.size.height / 2;
        
        // convert to the view 
        planetViewBounds.size = [self viewSizeFromGameSize: planetGameBounds.size withScale: scale];
        planetViewBounds.origin = [self viewPointFromGamePoint: planetGameBounds.origin 
                                                      viewRect:viewBounds
                                         gamePosInCentreOfView:centreOfGameBounds
                                                     withScale:scale];
        
        // is the planet in the drawing rectangle?
        if (!NSIntersectsRect(planetViewBounds, drawingBounds)) {
            continue;
        } 
        
        // draw it
        [self drawPlanet: planet inRect:planetViewBounds];
        if (!simple) {   // in simple mode we do not increase counters
            [planet increaseFuse];
            //NSLog(@"PainterFactory.drawPlanet %@ increased fuse to %d", [planet name], [planet fuse]);
        }
                
        // draw the name
        [self drawLabelForPlanet:planet belowRect:planetViewBounds];
    }
    
}

- (void)drawPlayersInRect:(NSRect)drawingBounds forGameRect:(NSRect)gameBounds ofViewBounds:(NSRect)viewBounds  withScale:(int)scale {
    
    NSRect playerGameBounds;
    NSRect playerViewBounds;
    Player *player;
    Player *me = [universe playerThatIsMe];
    NSPoint centreOfGameBounds = [self centreOfRect:gameBounds];
    
    for (int i = 0; i < UNIVERSE_MAX_PLAYERS; i++) {
        player = [universe playerWithId:i];
           
        if (!simple) {
            // see if this player is active
            if (([player status] != PLAYER_ALIVE && [player status] != PLAYER_EXPLODE) || ([player flags] & PLAYER_OBSERV) != 0) {
                [player setPreviousStatus:[player status]];
                continue;
            }
            
            // handle the drawing of cloak phase frames
            if (([player flags] & PLAYER_CLOAK) != 0) {
                if ([player cloakPhase] < (PLAYER_CLOAK_PHASES - 1)) {
                    if([player isMe] && [player cloakPhase] == 0) {
                        [notificationCenter postNotificationName:@"PL_CLOAKING" userInfo:[NSNumber numberWithBool:YES]];                   
                    }
                    [player increaseCloakPhase];
                }
            }
            else if ([player cloakPhase] > 0) {
                if ([player cloakPhase] == PLAYER_CLOAK_PHASES - 1) {
                    // $$ do not report others YET
                    if ([player isMe]) {
                        [notificationCenter postNotificationName:@"PL_UNCLOAKING" userInfo:[NSNumber numberWithBool:NO]];
                    }
                }
                else {
                    // $$ do not report others YET
                    //[notificationCenter postNotificationName:@"PL_CLOAKING" userInfo:[NSNumber numberWithBool:YES]];
                }
                [player decreaseCloakPhase];
            }
            
            // ---
            // check for fuse and status changes
            // ---
            
            // check fuse overrun (maxfuse (n) sets the number of frames 0..n-1)
            if ([player fuse] >= [player maxfuse]) {
                // we have drawn all frames for this phase do we need to loop?
                if (([player status] == PLAYER_EXPLODE) &&
                    ([player previousStatus] == PLAYER_EXPLODE)) {
                    // report if i died
                    if ([player isMe]) {
                        [notificationCenter postNotificationName:@"PL_I_DIED" userInfo:player]; 
                    }
                    // we have completed the process of exploding
                    [player setStatus:PLAYER_OUTFIT];
                    // next state will be moving
                    [player setFuse:0];
                    [player setMaxFuse:[self maxFuseForMovingPlayer]];
                    // no need to draw it.
                    continue; 
                }
                // if we are not exploding we are moving, thus reset the counter
                // we will loop the images for moving players
                [player setFuse:0];                
            }
            
            // check for detonate
            if (([player status] == PLAYER_EXPLODE) &&
                ([player previousStatus] != PLAYER_EXPLODE)) {
                // set the fuse
                [player setFuse:0];
                [player setMaxFuse:[self maxFuseForExplodingPlayer]];
                // it just went boom
                [notificationCenter postNotificationName:@"PL_PLAYER_EXPLODED" userInfo:player];
            }
            
            // we have tested all status changes, so preserve the previous for
            // the next run
            [player setPreviousStatus:[player status]];     
        } else {
			// Stil have to check if see if this player is active
            if (([player status] != PLAYER_ALIVE && [player status] != PLAYER_EXPLODE) || ([player flags] & PLAYER_OBSERV) != 0) {
                //[player setPreviousStatus:[player status]]; but don't change it when simple
                continue;
            }
		}
        
        // ---
        // the actual drawing code of the player
        // ---   

        // check if in other dimension
        if (!NSPointInRect([player predictedPosition], galaxy)) {
            continue;
        }
        // get the rect around the player in game coordinates
        playerGameBounds.origin = [player predictedPosition];
        playerGameBounds.size = [[player ship] size];
        // offset the origin to the upper left
        playerGameBounds.origin.x -= playerGameBounds.size.width / 2;
        playerGameBounds.origin.y -= playerGameBounds.size.height / 2;
        
        // convert to the view         
        playerViewBounds.size = [self viewSizeFromGameSize: playerGameBounds.size withScale: scale];
        playerViewBounds.origin = [self viewPointFromGamePoint: playerGameBounds.origin 
                                                      viewRect:viewBounds
                                         gamePosInCentreOfView:centreOfGameBounds
                                                     withScale:scale];
        
        // is the player in the drawing rectangle?
        if (!NSIntersectsRect(playerViewBounds, drawingBounds)) {
            continue;
        } 
        
        // draw it
        [self rotateAndDrawPlayer: player inRect:playerViewBounds];
    
        [player increaseFuse]; // move to next image in frame
        
        // ---
        // the actual drawing code of the label
        // ---  
        
        // draw name
        [self drawLabelForPlayer:player belowRect:playerViewBounds];
        
        if (simple) {   // in simple mode we do not draw any weapons
            continue;
        }
        
        // ---
        // the actual drawing code of the shields
        // ---  
        
        // check shield raised, lowered
        if (([player flags] & PLAYER_SHIELD) &&
            !([player previousFlags] & PLAYER_SHIELD)) {
            // the player raised shields
            [notificationCenter postNotificationName:@"PL_SHIELD_UP_PLAYER" userInfo:player];
        }         
        if (!([player flags] & PLAYER_SHIELD) &&
            ([player previousFlags] & PLAYER_SHIELD)) {
            // the player lowered shields
            [notificationCenter postNotificationName:@"PL_SHIELD_DOWN_PLAYER" userInfo:player];
        }         
        [player setPreviousFlags:[player flags]];   
        
        // calculate in percent and draw shields
        if ([player flags] & PLAYER_SHIELD) {
            float shieldStrenght = 100.0;
            if ([player isMe]) {
                shieldStrenght = [player shield] * 100 / [[player ship] maxShield];
            }
            [self drawShieldWithStrenght: shieldStrenght inRect:playerViewBounds];            
        }
        
        // save this value, we may need it again
        NSPoint playerPositionInView = [self viewPointFromGamePoint: [player predictedPosition] 
                                                           viewRect:viewBounds
                                              gamePosInCentreOfView:centreOfGameBounds
                                                          withScale:scale];        
        // ---
        // the actual drawing code of the phaser
        // ---  
        
        // draw the players phaser
        Phaser *phaser = [universe phaserWithId:[player phaserId]];
        NSPoint phaserEndPoint;
        
        if ([phaser status] != PHASER_FREE) {
            if([phaser previousStatus] == PHASER_FREE) { // from free to not free
                if ([player isMe]) {
                    [notificationCenter postNotificationName:@"PL_MY_PHASER_FIRING" userInfo:phaser];
                } else {
                    [notificationCenter postNotificationName:@"PL_OTHER_PHASER_FIRING" userInfo:phaser];
                }                
            }
            
            float compute;
            switch ([phaser status]) { 
				case PHASER_MISS:
					// Here I will have to compute the end coordinate
					compute = PHASER_MAX_DISTANCE * ([[player ship] phaserDamage ] / 100.0f);
                    // use radian conversion or tri
                    //NSLog(@"deg %d rad %f, cos %f, sin %f disx %d disy %d, px %f, py %f", 
                    //[phaser course], [phaser dirInRad],
                    //      sinf([phaser dirInRad]), cosf([phaser dirInRad]),
                    //      (int) (compute * cosf([phaser dirInRad])), (int)(compute * sinf([phaser dirInRad])),
                    //      [player predictedPosition].x, [player predictedPosition].y);
					phaserEndPoint.x = (int)([player predictedPosition].x + (int)(compute * sinf([phaser dirInRad]))); 
                    phaserEndPoint.y = (int)([player predictedPosition].y - (int)(compute * cosf([phaser dirInRad]))); // flipped coordinates
					break;
                    
				case PHASER_HIT2:
					phaserEndPoint = [phaser predictedPosition];
					break;
				default:
                    phaserEndPoint = [[phaser target] predictedPosition];
					break;
            }
            
            NSPoint phaserStartPoint =[player predictedPosition];
            // phaser shooting exactly at me?
            if (phaserStartPoint.x != phaserEndPoint.x || phaserStartPoint.y != phaserEndPoint.y) {
                if ([phaser status] == PHASER_MISS || (([phaser fuse] % 2) == 0) || [player team] != [me team]) {
                    // get the team color so that my phaser will not always be white
                    [[self colorForTeam:[player team]] set];
                }
                else {
                    [[NSColor whiteColor] set];
                }

                // project the phaser
                phaserStartPoint = playerPositionInView; // we calculated this before...
                
                phaserEndPoint = [self viewPointFromGamePoint: phaserEndPoint 
                                                     viewRect:viewBounds
                                        gamePosInCentreOfView:centreOfGameBounds
                                                    withScale:scale];
                
                //NSLog(@"PainterFactory.playerPhaser firing at x=%f, y=%f", phaserEndPoint.x, phaserEndPoint.y);
                
                [line removeAllPoints];
                [line moveToPoint:phaserStartPoint];
                [line lineToPoint:phaserEndPoint];
                [line stroke];
                
                // increase the faser duration
                [phaser increaseFuse];
                if([phaser fuse] > [phaser maxfuse]) {
                    [phaser setStatus: PHASER_FREE];
                }
            }
        }
        
        // update
        [phaser setPreviousStatus:[phaser status]];
        
        // ---
        // the actual drawing code of the tractors/pressors
        // ---  
        
        // draw tractors/pressors         
        // needed?
        if(([player flags] & (PLAYER_TRACT | PLAYER_PRESS)) == 0 || [player status] != PLAYER_ALIVE) {
            continue;
        }
        
        // hmm no target?
        Player *tractee = [player tractorTarget];
        if(tractee == nil) {
            continue;
        }
        
        // dead target ?
        if ([tractee status] != PLAYER_ALIVE) {            
            // $$ we can tractor cloaked targets....
            //|| ((tractee.flags & PLAYER_CLOAK) != 0 && tractee.cloakphase == (PLAYER_CLOAK_PHASES - 1)) {
            continue;
            }
        
        NSPoint tractorStartPoint = playerPositionInView;    // we calculated this before    
        NSPoint tractorEndPoint = [self viewPointFromGamePoint: [tractee predictedPosition] 
                                                      viewRect:viewBounds
                                         gamePosInCentreOfView:centreOfGameBounds
                                                     withScale:scale];
        if (tractorStartPoint.x == tractorEndPoint.x && tractorStartPoint.y == tractorEndPoint.y) {
            continue;
        }
        
        //NSLog(@"PainterFactory.drawPlayers tractor from (%f, %f) to (%f, %f)",
        //      tractorStartPoint.x, tractorStartPoint.y,
        //      tractorEndPoint.x, tractorEndPoint.y);
        
        double theta = atan2((double)(tractorEndPoint.x - tractorStartPoint.x), 
                             (double)(tractorStartPoint.y - tractorEndPoint.y)) + pi / 2.0;
        //double dir = theta / pi * 128; // no need we can work in rad
                
        //NSLog(@"PainterFactory.drawPlayers tractor from (%f / %f) to (%f)",
        //      ((double)(tractorEndPoint.x - tractorStartPoint.x)), 
        //      ((double)(tractorStartPoint.y - tractorEndPoint.y)) + pi / 2.0);

        // $$ fixed the colors here...
        if ([player flags] & PLAYER_PRESS) {
            [[NSColor purpleColor] set];
        } else {
            [[NSColor greenColor] set];
        }
        
        NSSize tracteeSize = [self viewSizeFromGameSize: [[tractee ship] size] withScale: scale];
        int width  = tracteeSize.width;
        int height = tracteeSize.height;
        double maxDim = ( width > height ? width : height) / 2.0;
        int yOffset = (int)(cos(theta) * maxDim);
        int xOffset = (int)(sin(theta) * maxDim);
        
        //NSLog(@"PainterFactory.drawPlayers tractor tetha %f xOff %d, yOff %d", theta, xOffset, yOffset);
        
        // draw it
        NSPoint p1 = NSMakePoint(tractorEndPoint.x + xOffset, tractorEndPoint.y + yOffset);
        NSPoint p2 = NSMakePoint(tractorEndPoint.x - xOffset, tractorEndPoint.y - yOffset);
        [dashedLine removeAllPoints];        
        [dashedLine moveToPoint:p1];
        [dashedLine lineToPoint:tractorStartPoint];
        [dashedLine lineToPoint:p2];
        [dashedLine stroke];
    }    
}

- (void)drawTorpsInRect:(NSRect)drawingBounds forGameRect:(NSRect)gameBounds ofViewBounds:(NSRect)viewBounds withScale:(int)scale {
    
    NSRect torpGameBounds;
    NSRect torpViewBounds;
    Player *player;
    NSPoint centreOfGameBounds = [self centreOfRect:gameBounds];
    
    // check all torps of all players
    for (int i = 0; i < UNIVERSE_MAX_PLAYERS; i++) {
        player = [universe playerWithId:i];
        
        NSArray *torps = [player torps];
        int freeTorps = UNIVERSE_MAX_TORPS;
        for (int t = 0; t < [torps count]; t++) {
            // check this torp
            Torp *torp = [torps objectAtIndex:t];            
            
            if (!simple) {
                
                // check if we need to process this torp
                if ([torp status] == TORP_FREE) {
                    [torp setPreviousStatus:[torp status]];
                    continue;
                }            
                // it is not free
                freeTorps--;
                
                // ---
                // check for fuse and status changes
                // ---
                //NSLog(@"PainterFactory.drawTorpsInRect status %d, previous %d", [torp status], [torp previousStatus]);
                
                // check fuse overrun (maxfuse (n) sets the number of frames 0..n-1)
                if ([torp fuse] >= [torp maxfuse]) {
                    // we have drawn all frames for this phase do we need to loop?
                    if (([torp status] == TORP_EXPLODE) &&
                        ([torp previousStatus] == TORP_EXPLODE)) {
                        // we have completed the process of exploding
                        [torp setStatus:TORP_FREE];
                        // next state will be moving
                        [torp setFuse:0];
                        [torp setMaxFuse:[self maxFuseForMovingTorp]];
                        // no need to draw it.
                        continue; 
                    }
                    // if we are not exploding we are moving, thus reset the counter
                    // we will loop the images for moving torps
                    [torp setFuse:0];                
                }
                
                // check for launch
                if (([torp status] == TORP_MOVE) && 
                    ([torp previousStatus] != TORP_MOVE)) { 
                    // it should already be set to moving but can't hurt to do it again.
                    [torp setFuse:0];
                    [torp setMaxFuse:[self maxFuseForMovingTorp]];
                    // tell the soundplayer what happend
                    if ([player isMe]) {
                        [notificationCenter postNotificationName:@"PL_TORP_FIRED_BY_ME" userInfo:torp];
                    } else {
                        [notificationCenter postNotificationName:@"PL_TORP_FIRED_BY_OTHER" userInfo:torp];
                    }
                } 
                
                // check for detonate
                if (([torp status] == TORP_EXPLODE) &&
                    ([torp previousStatus] != TORP_EXPLODE)) {
                    // set the fuse
                    [torp setFuse:0];
                    [torp setMaxFuse:[self maxFuseForExplodingTorp]];
                    // it just went boom
                    [notificationCenter postNotificationName:@"PL_TORP_EXPLODED" userInfo:torp];
                }
                
                // we have tested all status changes, so preserve the previous for
                // the next run
                [torp setPreviousStatus:[torp status]];            
                               
            }
            
            // ---
            // the actual drawing code
            // ---
            // check if in other dimension
            if (!NSPointInRect([torp predictedPosition], galaxy)) {
                continue;
            }
            // get the rect around the torp in game coordinates
            torpGameBounds.origin = [torp predictedPosition];
            if ([torp status] == TORP_EXPLODE) {
                torpGameBounds.size = [torp explosionSize];
            } else {
                torpGameBounds.size = [torp size];
            }
            // offset the origin to the upper left
            torpGameBounds.origin.x -= torpGameBounds.size.width / 2;
            torpGameBounds.origin.y -= torpGameBounds.size.height / 2;
            
            // convert to the view 
            torpViewBounds.size = [self viewSizeFromGameSize: torpGameBounds.size withScale: scale];
            torpViewBounds.origin = [self viewPointFromGamePoint: torpGameBounds.origin 
                                                        viewRect:viewBounds
                                           gamePosInCentreOfView:centreOfGameBounds
                                                       withScale:scale];
            
            // is the torp in the drawing rectangle?
            if (!NSIntersectsRect(torpViewBounds, drawingBounds)) {
                continue;
            } 
            
            // draw it
            [self drawTorp: torp inRect:torpViewBounds];
            
            // and move to the next image to paint
            [torp increaseFuse]; 
        }
        [player setTorpCount:freeTorps];
    }
}

- (void)drawPlasmasInRect:(NSRect)drawingBounds forGameRect:(NSRect)gameBounds ofViewBounds:(NSRect)viewBounds  withScale:(int)scale  {
    
    NSRect plasmaGameBounds;
    NSRect plasmaViewBounds;
    Player *player;
    NSPoint centreOfGameBounds = [self centreOfRect:gameBounds];
    
    // check all plasmas of all players
    for (int i = 0; i < UNIVERSE_MAX_PLAYERS; i++) {
        player = [universe playerWithId:i];        
        Plasma *plasma = [universe plasmaWithId:[player plasmaId]];            
        
        if (!simple) {
            if ([plasma status] == PLASMA_FREE) {
                [plasma setPreviousStatus:[plasma status]]; 
                continue;
            }
            
            // ---
            // check for fuse and status changes
            // ---
            
            // check fuse overrun (maxfuse (n) sets the number of frames 0..n-1)
            if ([plasma fuse] >= [plasma maxfuse]) {
                // we have drawn all frames for this phase do we need to loop?
                if (([plasma status] == PLASMA_EXPLODE) &&
                    ([plasma previousStatus] == PLASMA_EXPLODE)) {
                    // we have completed the process of exploding
                    [plasma setStatus:PLASMA_FREE];
                    // next state will be moving
                    [plasma setFuse:0];
                    [plasma setMaxFuse:[self maxFuseForMovingPlasma]];
                    // no need to draw it.
                    continue; 
                }
                // if we are not exploding we are moving, thus reset the counter
                // we will loop the images for moving plasmas
                [plasma setFuse:0];                
            }
            
            // check for launch
            if (([plasma status] == PLASMA_MOVE) && 
                ([plasma previousStatus] != PLASMA_MOVE)) { 
                // it should already be set to moving but can't hurt to do it again.
                [plasma setFuse:0];
                [plasma setMaxFuse:[self maxFuseForMovingPlasma]];
                // tell the soundplayer what happend
                if ([player isMe]) {
                    [notificationCenter postNotificationName:@"PL_PLASMA_FIRED_BY_ME" userInfo:plasma];
                } else {
                    [notificationCenter postNotificationName:@"PL_PLASMA_FIRED_BY_OTHER" userInfo:plasma];
                }
            } 
            
            // check for detonate
            if (([plasma status] == PLASMA_EXPLODE) &&
                ([plasma previousStatus] != PLASMA_EXPLODE)) {
                // set the fuse
                [plasma setFuse:0];
                [plasma setMaxFuse:[self maxFuseForExplodingPlasma]];
                // it just went boom
                [notificationCenter postNotificationName:@"PL_PLASMA_EXPLODED" userInfo:plasma];
            }
            
            // we have tested all status changes, so preserve the previous for
            // the next run
            [plasma setPreviousStatus:[plasma status]];            
        }
        
        
        // ---
        // the actual drawing code
        // ---        
        
        // check if in other dimension
        if (!NSPointInRect([plasma predictedPosition], galaxy)) {
            continue;
        }
        // get the rect around the plasma in game coordinates
        plasmaGameBounds.origin = [plasma predictedPosition];
        if ([plasma status] == PLASMA_EXPLODE) {
            plasmaGameBounds.size = [plasma explosionSize];
        } else {
            plasmaGameBounds.size = [plasma size];
        }
        // offset the origin to the upper left
        plasmaGameBounds.origin.x -= plasmaGameBounds.size.width / 2;
        plasmaGameBounds.origin.y -= plasmaGameBounds.size.height / 2;
        
        // convert to the view 
        plasmaViewBounds.size = [self viewSizeFromGameSize: plasmaGameBounds.size withScale: scale];
        plasmaViewBounds.origin = [self viewPointFromGamePoint: plasmaGameBounds.origin 
                                                      viewRect:viewBounds
                                         gamePosInCentreOfView:centreOfGameBounds
                                                     withScale:scale];
        
        // is the player in the drawing rectangle?
        if (!NSIntersectsRect(plasmaViewBounds, drawingBounds)) {
            continue;
        } 
        
        // draw it
        [self drawPlasma: plasma inRect:plasmaViewBounds];
        
        // and move to the next image to paint
        [plasma increaseFuse];              
    }
}

- (void)drawLockInRect:(NSRect)drawingBounds forGameRect:(NSRect)gameBounds ofViewBounds:(NSRect)viewBounds withScale:(int)scale {
    
    Player *me = [universe playerThatIsMe];
    NSPoint triangleViewPoint;
    NSPoint triangleGamePoint;

    // default colour
    [[NSColor whiteColor] set];
   	
    // are we locked?
    if ((([me flags] & PLAYER_PLOCK) != 0) || 
        (([me flags] & PLAYER_PLLOCK) != 0)) {        
        // yes
        if (([me flags] & PLAYER_PLOCK) != 0) {
            // locked onto a ship
            Player *player = [me playerLock];
            // player cloaked?
            if (([player flags] & PLAYER_CLOAK) == 0) {
                // or outside screen?
                if (NSPointInRect([player predictedPosition], gameBounds)) {
                    // find point
                    triangleGamePoint = [player predictedPosition];
                    // on top of ship
                    triangleGamePoint.y -= [[player ship] size].height / 2;
                    triangleViewPoint = [self viewPointFromGamePoint:triangleGamePoint 
                                                            viewRect:viewBounds
                                               gamePosInCentreOfView:[self centreOfRect:gameBounds]
                                                           withScale:scale];
                } else {
                    return; // outside view
                }
            } else {
                return; // cloacked
            }
        } else { 
            // locked onto a planet
            Planet *planet = [me planetLock];
            // or outside screen?
            if (NSPointInRect([planet predictedPosition], gameBounds)) {
                // find point
                triangleGamePoint = [planet predictedPosition];
                // on top of planet
                triangleGamePoint.y -= [planet size].height / 2;
                triangleViewPoint = [self viewPointFromGamePoint:triangleGamePoint 
                                                        viewRect:viewBounds
                                           gamePosInCentreOfView:[self centreOfRect:gameBounds]
                                                       withScale:scale];
            } else {
                return; // outside view
            }
        }
        
        // set up the drawing erea
        NSRect rect;
        rect.size.width = (PF_TRIANGLE_WIDTH) / scale;
        rect.size.height = (PF_TRIANGLE_HEIGHT) / scale;
        // triangleViewPoint points at the notch
        rect.origin.x = triangleViewPoint.x - rect.size.width / 2;
        rect.origin.y = triangleViewPoint.y - rect.size.height;
        
        // is the player in the drawing rectangle?
        if (!NSIntersectsRect(rect, drawingBounds)) {
            return;
        }
        
        [shapes drawTriangleNotchDownInRect:rect];
    }
}

- (void) prepareForDraw {
    // nothing, just convienience for subclasss
}

- (void) postpareForDraw {
    // nothing, just convienience for subclasss
}

- (void) drawRect:(NSRect)drawingBounds ofViewBounds:(NSRect)viewBounds whichRepresentsGameBounds:(NSRect)gameBounds 
        withScale:(int)scale {
    
    // pre-code
    [self prepareForDraw];
    
	// set the reference time for the tracker
	[[SimpleTracker defaultTracker] setReferenceTime:[NSDate date]];
	
    // get some helpers
    Player *me = [universe playerThatIsMe];   
    
    // -------------------------------------------------------------------------
    // 0. gather some metrics
    // -------------------------------------------------------------------------
    
    static NSTimeInterval start, stop;
    start = [NSDate timeIntervalSinceReferenceDate];  
    if ((start-stop) > 0.1) {
        NSLog(@"PainterFactory.drawView: slept %f sec", (start-stop));
    }
    
    // -------------------------------------------------------------------------
    // 1. draw alert border (yellow/red/green)
    // -------------------------------------------------------------------------
    if (!simple) {
        [self drawAlertBorder:viewBounds forMe:me];
    }
    
    // make sure our border is respected
    // by schrinking the view
    viewBounds = NSInsetRect(viewBounds, PF_ALERT_BORDER_WIDTH, PF_ALERT_BORDER_WIDTH);
    
    // and cliping upon it
    [[NSBezierPath bezierPathWithRect:viewBounds] addClip];
    
    // -------------------------------------------------------------------------
    // 2. draw background stars
    //      these are small stars floating in the oposite direction
    //      the original calculations are based on the game view:
    //      - every update, we will have shifted aprox the same amount as the
    //        calculation below, but planets will move
    //      - by applying it to the local view the stars will move with respect
    //        to me thus should stay roughly on top of the planets.
    //      - because we draw in the view, we must respect the alert border too.
    // -------------------------------------------------------------------------
    
    if (!simple) {
            [self drawBackgroundInRect:drawingBounds ofViewBounds:viewBounds forMe:me];
    } else {
        // at least clear the screen
        [[NSColor blackColor] set];
        NSRectFill(drawingBounds);
    }
    
    // -------------------------------------------------------------------------
    // 3. draw galaxy edges 
    //      is a Rect measuring UNIVERSE_PIXEL_SIZE in the gameView
    // -------------------------------------------------------------------------
    [self drawGalaxyEdgesInRect:drawingBounds forGameRect:gameBounds ofViewBounds:viewBounds withScale:scale];
        
    // -------------------------------------------------------------------------
    // 4. draw the planets which are in the view
    // -------------------------------------------------------------------------
    [self drawPlanetsInRect:drawingBounds forGameRect:gameBounds ofViewBounds:viewBounds withScale:scale];
    
    // -------------------------------------------------------------------------
    // 5. draw the players which are in the view
    //      this includes phasers and tractors/pressors
    // -------------------------------------------------------------------------
    [self drawPlayersInRect:drawingBounds forGameRect:gameBounds ofViewBounds:viewBounds withScale:scale];
    
    // -------------------------------------------------------------------------
    // 6. draw torps
    // -------------------------------------------------------------------------
    if (!simple) {
        [self drawTorpsInRect:drawingBounds forGameRect:gameBounds ofViewBounds:viewBounds withScale:scale];
    }
    
    // -------------------------------------------------------------------------
    // 7. draw plasmas
    // -------------------------------------------------------------------------
    if (!simple) {
        [self drawPlasmasInRect:drawingBounds forGameRect:gameBounds ofViewBounds:viewBounds withScale:scale];    
    }
    
    // -------------------------------------------------------------------------
    // 8. draw locking triangle
    // -------------------------------------------------------------------------
    [self drawLockInRect:drawingBounds forGameRect:gameBounds ofViewBounds:viewBounds withScale:scale];
    
    // -------------------------------------------------------------------------
    // 0. gather some metrics
    // -------------------------------------------------------------------------
    stop = [NSDate timeIntervalSinceReferenceDate];  
    if ((stop - start) > 0.1) {
        NSLog(@"PainterFactory.drawView: %f sec", (stop-start));
    }
    
    // post-code
    [self postpareForDraw];
    
}

- (void) rotateAndDrawPlayer:(Player*) player inRect:(NSRect) Rect {
    
    float course = [player course];
    //float course = 0;
    
    // first save the GC
    [[NSGraphicsContext currentContext] saveGraphicsState];
    
    // set up the rotate
    NSAffineTransform *transform = [NSAffineTransform transform];
    
    // assume ship drawn at 0,0 and move to ship position
    NSPoint center = [self centreOfRect:Rect];
    // transforms are read in reverse so this reads: first rotate then translate!
    [transform translateXBy:center.x yBy:center.y];
    [transform rotateByDegrees:course];  
    // concat the transform
    [transform concat];
    
    // draw the ship around 0,0
    Rect.origin = NSZeroPoint;
    [self drawPlayer:player inRect:[shapes createRectAroundOrigin:Rect]];
    
    // and restore the GC
    [transform invert];
    [transform concat];
    [[NSGraphicsContext currentContext] restoreGraphicsState];
}

// --------
// should be overwritten by subclasses
// --------

- (void)   drawPlayer:(Player*) player inRect:(NSRect) Rect {
    //NSLog(@"PainterFactory.drawPlayer course %f %@",course, 
    //      [NSString stringWithFormat:@"x=%f, y=%f, w=%f, h=%f", 
    //          Rect.origin.x, Rect.origin.y, Rect.size.width, Rect.size.height]);
    
    NSColor *col = [self colorForTeam:[player team]];
    if ([player cloakPhase] > 0) {
        // find out aplha value PF_MIN_ALPHA_VALUE (0.1) means fully cloaked
        // 1.0 means fully uncloaked
        float alpha = 1.0;
        alpha -= (((1.0 - PF_MIN_ALPHA_VALUE) * [player cloakPhase]) / PLAYER_CLOAK_PHASES);
        col = [col colorWithAlphaComponent:alpha];
    }
    
    [col set];
        
    // draw the ship in a sqrt(2)/2 size rect (inner circle)
    // sides should be 0.707 * rect.width thus reduced by 0,292893218813 / 2
    [shapes drawSpaceShipInRect:NSInsetRect(Rect, Rect.size.width*0.1515, Rect.size.height*0.1515)];
    
}

- (void) drawShipType:(int)type forTeamId:(int) teamId withCloakPhase:(int)cloakPhase inRect:(NSRect)Rect {
	Player *p;
	
	p = [[Player alloc] init];
	
	[p setTeam:[universe teamWithId:teamId]];
	[self drawPlayer:p inRect:Rect];
	
	[p release];
}

- (void)   drawShieldWithStrenght: (float)shieldPercentage inRect:(NSRect) Rect {
    
    // recalculate
    NSPoint centre = [self centreOfRect:Rect];
    // shield extends our ship by 1 point
    float radius = (Rect.size.width / 2) + 1; // assume Rect is square!!
    
    // get the colour
    NSColor *shieldColor = [NSColor greenColor];
    if (shieldPercentage < 50.0) {
        shieldColor = [NSColor yellowColor];
    }
    if (shieldPercentage < 25.0) {
        shieldColor = [NSColor redColor];
    }
    
    // get angle
    float angle = (360.0 * shieldPercentage / 100);
    
    //NSLog(@"PainterFactory.drawShield strenght %f, angle %f", shieldPercentage, angle);
    
    // draw
    [shieldColor set];
    
    // first the remaining strenght
    [line removeAllPoints];  
    [line appendBezierPathWithArcWithCenter:centre radius:radius startAngle:0.0 endAngle:angle];
    [line stroke]; 
    // then the lost shield
    if (angle < 360.0) {
        [dashedLine removeAllPoints];
        [dashedLine appendBezierPathWithArcWithCenter:centre radius:radius startAngle:angle endAngle:360.0];
        [dashedLine stroke];
    }

}

- (void)   drawPlanet:(Planet*) planet inRect:(NSRect) Rect {
    //NSLog(@"PainterFactory.drawPlanet %@", 
    //      [NSString stringWithFormat:@"x=%f, y=%f, w=%f, h=%f", 
    //          Rect.origin.x, Rect.origin.y, Rect.size.width, Rect.size.height]);
	
	[[NSColor whiteColor] set]; // safety precaution since planet owner can be nil!
	
    NSColor *col = [[planet owner] colorForTeam];
	[col set];
	
    [shapes drawDoubleCircleInRect:Rect];
}

- (void)   drawTorp:(Torp*) torp       inRect:(NSRect) Rect {

    [[self colorForTeam:[[torp owner] team]] set];
    
    // do something with the fuse
    float delta = 0.0;
    // zoom up the torp
    if ([torp status] == TORP_EXPLODE) {
        delta += [torp fuse] * Rect.size.width; // up to maxfuse*current width        
    } else {
        delta += [torp fuse] * Rect.size.width / 2;
    }
    
    Rect = NSInsetRect(Rect, -delta, -delta); // use minus to make larger
    
    //NSLog(@"PainterFactory.drawTorp %@",  
    //     [NSString stringWithFormat:@"x=%f, y=%f, w=%f, h=%f", 
    //       Rect.origin.x, Rect.origin.y, Rect.size.width, Rect.size.height]);
    [shapes drawCircleInRect:Rect];
}

- (void)   drawPlasma:(Plasma*) plasma inRect:(NSRect) Rect {
    //NSLog(@"PainterFactory.drawPlasma %@", 
    //      [NSString stringWithFormat:@"x=%f, y=%f, w=%f, h=%f", 
    //          Rect.origin.x, Rect.origin.y, Rect.size.width, Rect.size.height]);
    [[self colorForTeam:[plasma team]] set];
    
    [shapes drawCircleInRect:Rect];
}

- (void)   drawBackgroundImageInRect:(NSRect) Rect {
    // at least clear
    [[NSColor blackColor] set];
    NSRectFill(Rect);
    //NSLog(@"PainterFactory.drawBackgroundImageInRect %@",  
    //[NSString stringWithFormat:@"x=%f, y=%f, w=%f, h=%f", 
    //    Rect.origin.x, Rect.origin.y, Rect.size.width, Rect.size.height]);
}

- (NSString *)labelForPlanet:(Planet*)planet {
	
	NSString *label = [NSString stringWithString:[planet nameWithArmiesIndicator]];
    
    // extended label?
    if ([planet showInfo] || debugLabels) {
        label = [NSString stringWithFormat:@"%@ %d [%c%c%c]",
            [planet name],
            [planet armies],
            ([planet flags] & PLANET_REPAIR ? 'R' : '-'),
            ([planet flags] & PLANET_FUEL ?   'F' : '-'),
            ([planet flags] & PLANET_AGRI ?   'A' : '-')
            ];
    } 
	return label;	
}

- (void) drawLabel:(NSString*)label inRect:(NSRect)aRect withColor:(NSColor*)col { 
	//[col set]; 
	
	NSColor *oldColor =	[normalStateAttribute valueForKey:NSForegroundColorAttributeName];
	[normalStateAttribute setValue:col forKey:NSForegroundColorAttributeName];
	
	[label drawInRect:aRect withAttributes:normalStateAttribute];
	
	[normalStateAttribute setValue:oldColor forKey:NSForegroundColorAttributeName];
}

- (void) drawLabelForPlayer:(Player*)player belowRect:(NSRect)playerViewBounds {
    
    // draw the name, 12pnt below the player  
    NSString *label  = [self labelForPlayer:player];
	NSString *label2 = [self label2ForPlayer:player];
	NSString *label3 = [self label3ForPlayer:player];
	
	// get color
	NSColor *col = [[player team] colorForTeam];
	// NSColor *col = [NSColor whiteColor];
	
	// less code but slower
	if (!accelerate) {
		
		// calculate position
		NSSize labelSize = [label sizeWithAttributes:normalStateAttribute];		
		int labelHeight = labelSize.height;		
		NSPoint namePosition = playerViewBounds.origin;
		
		namePosition.y += playerViewBounds.size.height; // +  labelHeight;
		namePosition.x += (playerViewBounds.size.width - labelSize.width) / 2;
		
		// increase size slighly to fit text in
		labelSize.width += 4;
		namePosition.x -= 2;
		
		// create a background label
		if (label2 != nil) {
			labelSize.height += labelHeight;
			if (labelSize.width < [label2 sizeWithAttributes:normalStateAttribute].width) {
				labelSize.width = [label2 sizeWithAttributes:normalStateAttribute].width;
			}
		}
		if (label3 != nil) {
			labelSize.height += labelHeight;
			if (labelSize.width < [label3 sizeWithAttributes:normalStateAttribute].width) {
				labelSize.width = [label3 sizeWithAttributes:normalStateAttribute].width;
			}
		}
		
		// draw		
		[self drawLabelBackgroundForRect:NSMakeRect(namePosition.x, namePosition.y, labelSize.width, labelSize.height)];
		[self drawLabel:label atPoint:namePosition withColor:col];
		
		if (label2 != nil) {
			// calculate position		
			namePosition.y += labelHeight;
			
			// draw
			[self drawLabel:label2 atPoint:namePosition withColor:col];
		}
		
		if (label3 != nil) {
			// calculate position		
			namePosition.y += labelHeight;
			
			// draw
			[self drawLabel:label3 atPoint:namePosition withColor:col];
		}
	} else {
		// make key
		NSString *key = [NSString stringWithFormat:@"%@-%@-%@", label, label2, label3];
		
		// check if we already have an image for this label
		NSImage *labelImage = [player labelForKey:key];
		
		// nope, make one
		if (labelImage == nil) {
			// calculate size
			NSSize labelSize = [label sizeWithAttributes:normalStateAttribute];
			int height = labelSize.height;
			if (label2 != nil) {
				labelSize.height += height;
				if (labelSize.width < [label2 sizeWithAttributes:normalStateAttribute].width) {
					labelSize.width = [label2 sizeWithAttributes:normalStateAttribute].width;
				}
			}
			if (label3 != nil) {
				labelSize.height += height;
				if (labelSize.width < [label3 sizeWithAttributes:normalStateAttribute].width) {
					labelSize.width = [label3 sizeWithAttributes:normalStateAttribute].width;
				}
			}			
			
			// increase size slighly to fit text in
			labelSize.width += 4;
		
			labelImage = [[[NSImage alloc] initWithSize:labelSize] autorelease];
			NSRect labelRect;
			labelRect.size = labelSize;
			labelRect.origin = NSZeroPoint;
			
			// the actual drawing      
			[labelImage lockFocus];
			[self drawLabelBackgroundForRect:labelRect];
			NSPoint p = NSZeroPoint;
			if (label3 != nil) { // draw flipped, so last first
				[self drawLabel:label3 atPoint:p withColor:col];
				p.y += height;
			}
			if (label2 != nil) {
				[self drawLabel:label2 atPoint:p withColor:col];
				p.y += height;
			}
			[self drawLabel:label atPoint:p withColor:col];
			[labelImage unlockFocus];        
			
			// and store it
			[player setLabel:labelImage forKey:key];
			NSLog(@"PainterFactory.drawLabelForPlayer created label: %@", label);
		} else {
			//NSLog(@"PainterFactory.drawLabelForPlayer using cached label: %@", label);
		}
		
		NSRect destRect;
		destRect.origin = playerViewBounds.origin;
		destRect.origin.y += playerViewBounds.size.height;
		destRect.origin.y += [labelImage size].height; // seems to be needed, maybe due to flipped
		int labelWidth =  [labelImage size].width;
		destRect.origin.x += (playerViewBounds.size.width - labelWidth) / 2;
		destRect.size = [labelImage size];
		
		NSRect sourceRect;
		sourceRect.origin = NSZeroPoint;
		sourceRect.size = [labelImage size];
		
		// actual draw
		[labelImage compositeToPoint:destRect.origin operation:NSCompositeSourceOver];
		
	}
	
}

- (void) drawLabelBackgroundForRect:(NSRect)aRect {
	return;
}

- (void) drawLabelForPlanet:(Planet*)planet belowRect:(NSRect)planetViewBounds {
    
    // get the name
    NSString *label = [self labelForPlanet:planet];
	
	// get color
	NSColor *col = [[planet owner] colorForTeam];
	// NSColor *col = [NSColor whiteColor];
    
	// check accelleration
	// this is short code, but heavy on processor
	if (!accelerate) {
		NSSize labelSize = [label sizeWithAttributes:normalStateAttribute];
		NSRect destRect;
		destRect.origin = planetViewBounds.origin;
		destRect.origin.y += planetViewBounds.size.height;
		int labelWidth = labelSize.width;
		destRect.origin.x += (planetViewBounds.size.width - labelWidth) / 2;
		destRect.size = labelSize;
		
		// increase slighlty to fit text
		destRect.size.width += 4;
		destRect.origin.x -= 2;
		[self drawLabelBackgroundForRect:destRect];
		[self drawLabel:label inRect:destRect withColor:col];
		return;
	}
	
    // check if we already have an image for this label
    NSImage *labelImage = [planet labelForKey:label];
    
    // nope, make one
    if (labelImage == nil) {
        // calculate size
        NSSize labelSize = [label sizeWithAttributes:normalStateAttribute];
		
		// increase slighlty to fit text
		labelSize.width += 4;
		
        labelImage = [[[NSImage alloc] initWithSize:labelSize] autorelease];
        NSRect labelRect;
        labelRect.size = labelSize;
        labelRect.origin = NSZeroPoint;
        
        // the actual drawing      
        [labelImage lockFocus];
		[self drawLabelBackgroundForRect:labelRect];
		[self drawLabel:label inRect:labelRect withColor:col];
        [labelImage unlockFocus];        
        
        // and store it
        [planet setLabel:labelImage forKey:label];
        NSLog(@"PainterFactory.drawLabelForPlanet created label: %@", label);
    } else {
        //NSLog(@"PainterFactory.drawLabelForPlanet using cached label: %@", label);
    }

    NSRect destRect;
    destRect.origin = planetViewBounds.origin;
    destRect.origin.y += planetViewBounds.size.height;
	destRect.origin.y += [labelImage size].height; // seems to be needed, maybe due to flipped
    int labelWidth =  [labelImage size].width;
    destRect.origin.x += (planetViewBounds.size.width - labelWidth) / 2;
    destRect.size = [labelImage size];
    
    NSRect sourceRect;
    sourceRect.origin = NSZeroPoint;
    sourceRect.size = [labelImage size];
    
    // actual draw
	[labelImage compositeToPoint:destRect.origin operation:NSCompositeSourceOver];
    //[labelImage drawInRect:destRect fromRect:sourceRect operation:NSCompositeSourceOver fraction:1.0];
}

- (NSString*) labelForPlayer:(Player*)player {
	
	NSString *label = [NSString stringWithFormat:@"%@", [player mapCharsWithKillIndicator]];
	
    // extended label?
    if ([player showInfo] || debugLabels) {
        label = [NSString stringWithFormat:@"%@ %d(%d) %d %d [%c%c%c%c%c%c] %d %@",
            [player longNameWithKillIndicator],
            [player speed],
            [player requestedSpeed],
            [player kills],
            [player armies],
            ([player flags] & PLAYER_REPAIR ? 'R' : '-'),
            ([player flags] & PLAYER_BOMB ?   'B' : '-'),
            ([player flags] & PLAYER_ORBIT ?  'O' : '-'),
            ([player flags] & PLAYER_CLOAK ?  'C' : '-'),
            ([player flags] & PLAYER_BEAMUP ?  'U' : '-'),
            ([player flags] & PLAYER_BEAMDOWN ?  'D' : '-'),
            [player cloakPhase],
            (debugLabels ? [[player statusString] substringFromIndex:7] : @"") // in debug we show status
            ];
    }   
	return label;
}

- (NSString*) label2ForPlayer:(Player*)player {
	if (debugLabels) {
		// prepare another line
		NSArray *torps = [player torps];
		NSString *label = [NSString stringWithFormat:@"%@ T[%c%c%c%c%c%c%c%c]",
			[[player ship] longName],
			[[torps objectAtIndex:0] statusChar],  // we know that there are 8 and this is debug
			[[torps objectAtIndex:1] statusChar],
			[[torps objectAtIndex:2] statusChar],
			[[torps objectAtIndex:3] statusChar],
			[[torps objectAtIndex:4] statusChar],
			[[torps objectAtIndex:5] statusChar],
			[[torps objectAtIndex:6] statusChar],
			[[torps objectAtIndex:7] statusChar]];
		return label;
	}
	return nil;
}

- (NSString*) label3ForPlayer:(Player*)player {
	if (debugLabels) {
		// prepare another line		 			
		Plasma *plasma = [universe plasmaWithId:[player plasmaId]];
		Phaser *phaser = [universe phaserWithId:[player phaserId]];
		NSString *label = [NSString stringWithFormat:@"PH[%c][%d] PL[%c][%d]",
			[phaser statusChar],
			[phaser fuse],
			[plasma statusChar],
			[plasma fuse]];
		return label;
	}
	return nil;
}

- (void) drawLabel:(NSString*)label atPoint:(NSPoint)aPoint withColor:(NSColor*)col{
	//[col set];  
	// NOT enough ! the color is hidden in the normalStateAttribute,
	// set it there!
	NSColor *oldColor =	[normalStateAttribute valueForKey:NSForegroundColorAttributeName];
	
	[normalStateAttribute setValue:col forKey:NSForegroundColorAttributeName];
	
	[label drawAtPoint: aPoint withAttributes:normalStateAttribute];  	
	[normalStateAttribute setValue:oldColor forKey:NSForegroundColorAttributeName];
}

- (int)    maxFuseForMovingTorp {
    return 2; // two frames     
}

- (int)    maxFuseForExplodingTorp {
    return 10; // ten frames
}


- (int)    maxFuseForMovingPlasma {
    return 3; // two frames     
}

- (int)    maxFuseForExplodingPlasma {
    return 12; // ten frames
}

- (int)    maxFuseForMovingPlayer {
    return 1;
} 

- (int)    maxFuseForExplodingPlayer {
    return 10;
}

- (int)    maxFuseForPlanet {
    return 1;
}

@end
