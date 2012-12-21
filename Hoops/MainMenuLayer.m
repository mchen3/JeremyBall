//
//  MainMenuLayer.m
//  2-SpaceViking
//
//  Created by Mike Chen on 10/15/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MainMenuLayer.h"
#import "GameScene.h"
#import "cocos2d.h"

@interface MainMenuLayer()
-(void)displayMainMenu;
@end

@implementation MainMenuLayer
-(void) dealloc {
    [super dealloc];
}

-(void)playGame {
    [[GameManager sharedGameManager] runSceneWithID:kPlayScene];
}

-(void)showOptions {
    [[GameManager sharedGameManager] runSceneWithID:kOptionsScene];
}

-(void)displayMainMenu {
    CGSize screenSize = [CCDirector sharedDirector].winSize;
    if (sceneSelectMenu != nil) {
        [sceneSelectMenu removeFromParentAndCleanup:YES];
    }
    // Main Menu
    CCMenuItemImage *playGameButton = [CCMenuItemImage
        itemFromNormalImage:@"play.png"
        selectedImage:@"playclick.png"
        disabledImage:nil
        target:self
        selector:@selector(playGame)];

    CCMenuItemImage *optionsButton = [CCMenuItemImage
        itemFromNormalImage:@"options.png" 
        selectedImage:@"optionsclick.png" 
        disabledImage:nil 
        target:self 
        selector:@selector(showOptions)];
    
    mainMenu = [CCMenu 
                menuWithItems:playGameButton,optionsButton,nil];
    [mainMenu alignItemsHorizontallyWithPadding:
     screenSize.height * 0.345f];
    [mainMenu setPosition:
     ccp(screenSize.width * .592,
         screenSize.height * .63)];
    [self addChild:mainMenu z:0 tag:8];
}
-(id)init {
    self = [super init];
    if (self) {
        CGSize screenSize = [CCDirector sharedDirector].winSize; 
       CCSprite *background = 
       [CCSprite spriteWithFile:@"MainBackground.png"];
		   [background setPosition:ccp(screenSize.width/2, 
                                    screenSize.height/2)];
		   [self addChild:background];
		   [self displayMainMenu];        
    }
    return self;
}

@end












































