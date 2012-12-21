//
//  PlayScene.m
//  Hoops
//
//  Created by Mike Chen on 4/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//
#import "PlayScene.h"
@implementation PlayScene
- (id)init
{
    self = [super init];
    if (self) {
        // Background Layer
        PlaybackLayer *playbackLayer = [PlaybackLayer node];
        [self addChild:playbackLayer  z:0];
        
        // Playplay Layer
        PlayplayLayer *playplayLayer = [PlayplayLayer node];
        [self addChild:playplayLayer z:5];
    }
    return self;
}
@end
