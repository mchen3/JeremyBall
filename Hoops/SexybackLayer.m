//
//  SexybackLayer.m
//  Hoops
//
//  Created by Mike Chen on 4/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//
#import "SexybackLayer.h"
@implementation SexybackLayer

- (id)init
{
    self = [super init]; // Have to enter a value for self 
    //  whether it's super init or a color
    
    if (self) {
        // Initialization code here.
        CCSprite *backgroundImage;
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            backgroundImage = [CCSprite
                               spriteWithFile:@"SexyBackground-IPAD.png"];
        } else {
            backgroundImage = [CCSprite
                               spriteWithFile:@"SexyBackground.png"];
        }
        CGSize screenSize = [[CCDirector sharedDirector] winSize];
        [backgroundImage setPosition:
         CGPointMake(screenSize.width/2, screenSize.height/2)];
        [self addChild:backgroundImage z:7 tag:0]; 
    }
    return self;
}
@end



