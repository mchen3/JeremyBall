//
//  SexyScene.m
//  Hoops
//
//  Created by Mike Chen on 4/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//
#import "SexyScene.h"
@implementation SexyScene
- (id)init
{
    self = [super init];
    if (self) {
        // Background Layer
       SexybackLayer *sexybackLayer = [SexybackLayer node];
        [self addChild:sexybackLayer  z:0];
        
        // Gameplay Layer
       SexyplayLayer *sexyplayLayer = [SexyplayLayer node];
        [self addChild:sexyplayLayer z:5];
    }
    return self;
}
@end
