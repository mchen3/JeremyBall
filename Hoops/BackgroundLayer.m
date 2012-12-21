//
//  BackgroundLayer.m
//  Hoops
//
//  Created by Mike Chen on 1/7/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//
#import "BackgroundLayer.h"
@implementation BackgroundLayer
- (id)init  
{
		self = [super init];     
    if (self) {
        // Initialization code here.
        CCSprite *backgroundImage;
       if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            backgroundImage = [CCSprite
                               spriteWithFile:@"BasicBackground.png"];
        } else {
            backgroundImage = [CCSprite
                               spriteWithFile:@"BasicBackground.png"];
    }
		CGSize screenSize = [[CCDirector sharedDirector] winSize];
		[backgroundImage setPosition:
		CGPointMake(screenSize.width/2, screenSize.height/2)];
		[self addChild:backgroundImage z:7 tag:0]; 
    }
    return self;
}
@end























