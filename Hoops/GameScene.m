//
//  GameScene.m
//  Ragdoll
//
//  Created by Mike Chen on 1/7/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "GameScene.h"
@implementation GameScene
- (id)init
{
    self = [super init];
    if (self) {
        // Background Layer
        BackgroundLayer *backgroundLayer = [BackgroundLayer node];
        [self addChild:backgroundLayer  z:0];
        
        // Gameplay Layer
        GameplayLayer *gameplayLayer = [GameplayLayer node];
        [self addChild:gameplayLayer z:5];
    }
    return self;
}
@end







