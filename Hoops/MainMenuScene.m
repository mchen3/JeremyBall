//
//  MainMenuScene.m
//  2-SpaceViking
//
//  Created by Mike Chen on 10/15/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MainMenuScene.h"
@implementation MainMenuScene

- (id)init
{
    self = [super init];
    if (self != nil) {
        mainMenuLayer = [MainMenuLayer node];
        [self addChild:mainMenuLayer];
    }
    return self;
}

@end





















