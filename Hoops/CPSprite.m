//
//  CPSprite.m
//  Hoops
//
//  Created by Mike Chen on 1/13/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.

#import "CPSprite.h"
#import "CityplayLayer.h"
#import "GameplayLayer.h"
#import "ZombieplayLayer.h"
#import "SexyplayLayer.h"
#import "ChampplayLayer.h"
#import "chipmunk.h"
@implementation CPSprite
@synthesize body;
@synthesize delayBalldestroy;
@synthesize particleDestroy;

-(void)dealloc {
    
    /* Will cause a crash
     cpSpaceFree(space);
	  //space = NULL;
    */
    [super dealloc];
}

- (void)update {    
    
    self.position= body->p;
    self.rotation = CC_RADIANS_TO_DEGREES(-1 * body->a);
    // Ball body itself wasn't rotating, cpBodSetVel, 
    // so you have to add angvel
    cpBodySetAngVel(body, 3.5f);

    // Emitter particle created in playLayer follows ball body
    [emitter setPosition: body->p];
    
    // emitter will stop after the fifth bounce in callback ground
    if (particleDestroy) {
        [emitter stopSystem];
    }
        
    // Keep body within Margins
    CGSize winSize = [CCDirector sharedDirector].winSize;
    
    // Don't set the margin to 0 or even .01, the ball disappears
    //  margin = 0;
    float margin = winSize.width * .02f;
    // x axis
    // Left side 
    if (body->p.x < margin) {
        cpBodySetPos(body, ccp(margin, body->p.y));
    }
    // Right side
    if (body->p.x > winSize.width - margin) {
        cpBodySetPos(body, ccp(winSize.width - margin, body->p.y));
    }
    
    // y axis
    // bottom
    if (body->p.y < margin ) {
      // When the velocity is high, it drags on the floor and gets stuck
      // A ghost image on the bottom left occurs when you shoot the ball  
      //  cpBodySetPos(body, ccp(body->p.x, margin));
    }
    // Top
    if (body->p.y > winSize.height + 300) {
        CCLOG(@"X = %.1f, Y = %.1f", body->p.x, body->p.y);
        cpBodySetPos(body, ccp(body->p.x,body->p.y));
    }   
}

- (void)createBodyAtLocation:(CGPoint)location {
    
    // Create body
    float boxSize = 100.0;
    float mass = 20;
    body = cpBodyNew(mass,
                     cpMomentForBox(mass, boxSize, boxSize)); 
    body->p = location;
    cpSpaceAddBody(space, body); 
    
    // Set the body->data to self so later you can get this
    // ball sprite info from 'body->data'
    body->data = self;
    
    // Have to pass shape back to gameplaylayer for collision callbacks
    shape = cpCircleShapeNew(body, 10, cpvzero);
    shape->e = .8; 
    shape->u = 0; 
    shape->group = 1;
    shape->collision_type = 0;
    
		// shape->data = self; Causes unrecognized selector error
    cpSpaceAddShape(space, shape); 
}

// Gameplay / Basic
- (id)initWithSpace:(cpSpace *)theSpace location:(CGPoint)location spriteFrameName:(NSString *)spriteFrameName  gameplayLayer:(GameplayLayer *)layer{
    
    if ((self = [super initWithSpriteFrameName:spriteFrameName])) 
    {
        space = theSpace;
        [self createBodyAtLocation:location];
        basiclayer = layer;
       
        if (basiclayer.currentRound == 3) {
            emitter = [ARCH_OPTIMAL_PARTICLE_SYSTEM 
                       particleWithFile:@"basicR3.plist"];
            [emitter setScale:.3];
            [basiclayer addChild:emitter];
        }
        else if (basiclayer.currentRound == 4) {
            emitter = [ARCH_OPTIMAL_PARTICLE_SYSTEM 
                       particleWithFile:@"basicR4.plist"];
            [emitter setScale:.3];
            [basiclayer addChild:emitter];
        }
    }
    return self;
}

// The Cityplaylayer is passed through so you can add the particle 
- (id)initWithSpace:(cpSpace *)theSpace location:(CGPoint)location spriteFrameName:(NSString *)spriteFrameName  layer:(CityplayLayer *)layer        {
    
    // Change when you add ball to spriteFrame name and you'll
    // be using the this or the super class CPSprite's 
    // initwithSpriteFrameName, in other words, batch node or sprite file png
    if ((self = [super initWithSpriteFrameName:spriteFrameName])) 
        // if ((self = [super initWithFile:spriteFrameName]))    
    {
        space = theSpace;
        [self createBodyAtLocation:location];
        
        /*  Note, you can't add a particle (only can add a individual sprite)
         to a sprite like Ball class, which is itself part of a batchnode.
         That's why you passed in the gameplayLayer, so you can add
         the particle as a child and just update the particle position
         to the same as the Ball position
         */
        citylayer = layer;
        
        if (citylayer.currentRound == 3) {
            emitter = [ARCH_OPTIMAL_PARTICLE_SYSTEM 
                       particleWithFile:@"cityR3.plist"];
            [emitter setScale:.3];
            [citylayer addChild:emitter];
        }
        else if (citylayer.currentRound == 4) {
            emitter = [ARCH_OPTIMAL_PARTICLE_SYSTEM 
                       particleWithFile:@"cityR4.plist"];
            [emitter setScale:.3];
            [citylayer addChild:emitter];
        }
        
    }
    return self;
}

// Zombie
- (id)initWithSpace:(cpSpace *)theSpace location:(CGPoint)location spriteFrameName:(NSString *)spriteFrameName  zombieplayLayer:(ZombieplayLayer *)layer{
    
    if ((self = [super initWithSpriteFrameName:spriteFrameName])) 
        // if ((self = [super initWithFile:spriteFrameName]))    
    {
        space = theSpace;
        [self createBodyAtLocation:location];
        zombielayer = layer;        
        
        if (zombielayer.currentRound == 3) {
            // Third round
            emitter = [ARCH_OPTIMAL_PARTICLE_SYSTEM 
                       particleWithFile:@"zombieR3.plist"];
            [emitter setScale:.3];
            [zombielayer addChild:emitter];
        } 
        else if (zombielayer.currentRound == 4) {
            // Final round
            emitter = [ARCH_OPTIMAL_PARTICLE_SYSTEM 
                       particleWithFile:@"zombieR4.plist"];
            [emitter setScale:.3];
            [zombielayer addChild:emitter];    
        }
    }
    return self;
}

// Sexy
- (id)initWithSpace:(cpSpace *)theSpace location:(CGPoint)location spriteFrameName:(NSString *)spriteFrameName  sexyplayLayer:(SexyplayLayer *)layer{
    
    if ((self = [super initWithSpriteFrameName:spriteFrameName])) 
        // if ((self = [super initWithFile:spriteFrameName]))    
    {
        space = theSpace;
        [self createBodyAtLocation:location];
        sexylayer = layer;        
       
        if (sexylayer.currentRound == 3) {
            emitter = [ARCH_OPTIMAL_PARTICLE_SYSTEM 
                       particleWithFile:@"sexyR3.plist"];
            [emitter setScale:.3];
            [sexylayer addChild:emitter];
        }
        else if (sexylayer.currentRound == 4) {
            emitter = [ARCH_OPTIMAL_PARTICLE_SYSTEM 
                       particleWithFile:@"sexyR4.plist"];
            [emitter setScale:.3];
            [sexylayer addChild:emitter];
        }
    }
    return self;
}

//Champion
- (id)initWithSpace:(cpSpace *)theSpace location:(CGPoint)location spriteFrameName:(NSString *)spriteFrameName  champplayLayer:(ChampplayLayer *)layer{
    
    if ((self = [super initWithSpriteFrameName:spriteFrameName])) 
        // if ((self = [super initWithFile:spriteFrameName]))    
    {
        space = theSpace;
        [self createBodyAtLocation:location];
        champlayer = layer;        
        
        if (champlayer.currentRound == 3) {
            emitter = [ARCH_OPTIMAL_PARTICLE_SYSTEM 
                       particleWithFile:@"champR3.plist"];
            [emitter setScale:.3];
            [champlayer addChild:emitter];
        }
        else if (champlayer.currentRound == 4) {
            emitter = [ARCH_OPTIMAL_PARTICLE_SYSTEM 
                       particleWithFile:@"champR4.plist"];
            [emitter setScale:.3];
            [champlayer addChild:emitter];
        }
    }
    return self;
}
@end













