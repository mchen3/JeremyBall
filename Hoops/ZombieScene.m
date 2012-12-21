//
//  ZombieScene.m
//  Hoops
//
//  Created by Mike Chen on 4/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ZombieScene.h"
@implementation ZombieScene
- (id)init
{
    self = [super init];
    if (self) {
      ZombiebackLayer  *zombiebackLayer = [ZombiebackLayer node];
        [self addChild:zombiebackLayer z:0];
        
       ZombieplayLayer *zombieplayLayer = [ZombieplayLayer node];
        [self addChild:zombieplayLayer z:5];
        
    }
    return self;
}
@end
