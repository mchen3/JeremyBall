//
//  Ball.m
//  Hoops
//
//  Created by Mike Chen on 1/13/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "Ball.h"
#import "GameplayLayer.h"
#import "CityplayLayer.h"
#import "ZombieplayLayer.h"
#import "SexyplayLayer.h"
@implementation Ball

// The Gameplaylayer is passed through so you can add the particle 
- (id)initWithSpace:(cpSpace *)theSpace location:(CGPoint)location gameplayLayer:(GameplayLayer *)layer
{
    if ((self = [super initWithSpace:theSpace location:location spriteFrameName:@"Ball.png" gameplayLayer:layer])) 
    {
        
    }
    return self;
}

// The Cityplaylayer is passed through so you can add the particle 
- (id)initWithSpace:(cpSpace *)theSpace location:(CGPoint)location layer:
     (CityplayLayer *)layer
{
    
 if ((self = [super initWithSpace:theSpace location:location spriteFrameName:@"red.png" layer:layer])) 
    {
            
    }
    return self;
}

// The Zombieplaylayer is passed through so you can add the particle 
- (id)initWithSpace:(cpSpace *)theSpace location:(CGPoint)location zombieplayLayer:(ZombieplayLayer *)layer
{
    
    if ((self = [super initWithSpace:theSpace location:location spriteFrameName:@"zombieHead.png" zombieplayLayer:layer])) 
    {
        
    }
    return self;
}

// The Sexyplaylayer is passed through so you can add the particle 
- (id)initWithSpace:(cpSpace *)theSpace location:(CGPoint)location sexyplayLayer:
(SexyplayLayer *)layer
{
    
    if ((self = [super initWithSpace:theSpace location:location spriteFrameName:@"beachball.png" sexyplayLayer:layer])) 
    {
        
    }
    return self;
}

// The Champplaylayer is passed through so you can add the particle 
- (id)initWithSpace:(cpSpace *)theSpace location:(CGPoint)location champplayLayer:
(ChampplayLayer *)layer
{
    
    if ((self = [super initWithSpace:theSpace location:location spriteFrameName:@"yellowBall.png" champplayLayer:layer])) 
    {
        
    }
    return self;
}

// Ball.png is the regular ball
// red.png for city
// zombieHead.png
// beachball.png
// yellowBall.png


@end



































