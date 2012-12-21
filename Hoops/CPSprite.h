//
//  CPSprite.h
//  Hoops
//
//  Created by Mike Chen on 1/13/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.

#import "cocos2d.h"
#import "chipmunk.h"

// Need to use @class directive to prevent cicular reasoning
// because GameplayLayer also imports from Ball/CPSprite
@class GameplayLayer;
@class CityplayLayer;
@class ZombieplayLayer;
@class SexyplayLayer;
@class ChampplayLayer;

typedef enum {
    kCollisionTypeGround = 0x1,
    kCollisionTypeCat,
    kCollisionTypeBed
} CollisionType;

@interface CPSprite : CCSprite {
    cpBody *body;
    cpShape *shape;
    cpSpace *space;

    // counter to delay destroying ball after 5 bounces
    int delayBalldestroy;
    // set particle destroy to true in callback for ground
		// (in play layer) after 5th bounce
    BOOL particleDestroy;
    CCParticleSystem *emitter;
    CityplayLayer *citylayer;
    GameplayLayer *basiclayer;
    ZombieplayLayer *zombielayer;
    SexyplayLayer *sexylayer;
    ChampplayLayer *champlayer;
}

@property (assign) cpBody *body;
@property (readwrite) int delayBalldestroy;
@property (readwrite) BOOL particleDestroy;

- (void)update;
- (void)createBodyAtLocation:(CGPoint)location;
- (id)initWithSpace:(cpSpace *)theSpace location:(CGPoint)location spriteFrameName:(NSString *)spriteFrameName  layer:(CityplayLayer *)layer;
- (id)initWithSpace:(cpSpace *)theSpace location:(CGPoint)location spriteFrameName:(NSString *)spriteFrameName  gameplayLayer:(GameplayLayer *)layer;
- (id)initWithSpace:(cpSpace *)theSpace location:(CGPoint)location spriteFrameName:(NSString *)spriteFrameName  zombieplayLayer:(ZombieplayLayer *)layer;
- (id)initWithSpace:(cpSpace *)theSpace location:(CGPoint)location spriteFrameName:(NSString *)spriteFrameName  sexyplayLayer:(SexyplayLayer *)layer;
- (id)initWithSpace:(cpSpace *)theSpace location:(CGPoint)location spriteFrameName:(NSString *)spriteFrameName  champplayLayer:(ChampplayLayer *)layer;

@end







