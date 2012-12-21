//
//  ZombiebackLayer.m
//  Hoops
//
//  Created by Mike Chen on 4/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//
#import "ZombiebackLayer.h"
@implementation ZombiebackLayer

- (id)init  
{
		self = [super init]; 
    if (self) {
        // Initialization code here.
        
        CCSprite *backgroundImage;
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            backgroundImage = [CCSprite
                               spriteWithFile:@"ZombieBackground.png"];
        } else {
            // backgroundImage = [CCSprite
            //            spriteWithFile:@"backgroundiPhone.png"];
            
            
            backgroundImage = [CCSprite
                               spriteWithFile:@"ZombieBackground.png"];
        }
        CGSize screenSize = [[CCDirector sharedDirector] winSize];
        [backgroundImage setPosition:
         CGPointMake(screenSize.width/2, screenSize.height/2)];
        [self addChild:backgroundImage z:7 tag:0]; 
    }
    return self;
}
@end
