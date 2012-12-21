//
//  CityScene.m
//  Hoops
//
//  Created by Mike Chen on 4/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//
#import "CityScene.h"
@implementation CityScene
- (id)init
{
    self = [super init];
    if (self) {
        CitybackLayer  *citybackLayer = [CitybackLayer node];
        [self addChild:citybackLayer z:0];
        
        CityplayLayer *cityplayLayer = [CityplayLayer node];
        [self addChild:cityplayLayer z:5];
    }
    return self;
}
@end
