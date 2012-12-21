//
//  Ball.h
//  Hoops
//
//  Created by Mike Chen on 1/13/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "CPSprite.h"

// Need to use @class directive to prevent cicular reasoning
// because GameplayLayer also imports from Ball/CPSprite
@class GameplayLayer;
@class CityplayLayer;
@class ZombieplayLayer;
@class SexyplayLayer;
@class ChampplayLayer;

@interface Ball : CPSprite {
}
- (id)initWithSpace:(cpSpace *)theSpace location:(CGPoint)location gameplayLayer:
    (GameplayLayer *)layer;
- (id)initWithSpace:(cpSpace *)theSpace location:(CGPoint)location layer:
    (CityplayLayer *)layer;
- (id)initWithSpace:(cpSpace *)theSpace location:(CGPoint)location zombieplayLayer:
    (ZombieplayLayer *)layer;
- (id)initWithSpace:(cpSpace *)theSpace location:(CGPoint)location sexyplayLayer:
    (SexyplayLayer *)layer;
- (id)initWithSpace:(cpSpace *)theSpace location:(CGPoint)location champplayLayer:
(ChampplayLayer *)layer;
@end











