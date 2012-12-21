//
//  ChampScene.m
//  Hoops
//
//  Created by Mike Chen on 4/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//
#import "ChampScene.h"
@implementation ChampScene
- (id)init
{
    self = [super init];
    if (self) {
        // Background Layer
        ChampbackLayer *champbackLayer = [ChampbackLayer node];
        [self addChild:champbackLayer  z:0];
        // Gameplay Layer
        ChampplayLayer *champplayLayer = [ChampplayLayer node];
        [self addChild:champplayLayer z:5];
    }
    return self;
}
@end

