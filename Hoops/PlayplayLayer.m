//
//  PlayplayLayer.m
//  Hoops
//
//  Created by Mike Chen on 4/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PlayplayLayer.h"
@implementation PlayplayLayer
-(void)dealloc {
    [super dealloc];
}

-(void)callBasic {
    [[GameManager sharedGameManager] runSceneWithID:kGameScene];
}

-(void)callCity {
    NSUserDefaults *ud=[NSUserDefaults standardUserDefaults]; 
    BOOL cityPassed = [ud boolForKey:@"city"];
    if (cityPassed) { 
    [[GameManager sharedGameManager] runSceneWithID:kCityScene];
    }
}

-(void)callZombie {
    
    NSUserDefaults *ud=[NSUserDefaults standardUserDefaults]; 
    BOOL zombiePassed = [ud boolForKey:@"zombie"];
    if (zombiePassed) { 
    [[GameManager sharedGameManager] runSceneWithID:kZombieScene];
    }
}

-(void)callSexy {
    NSUserDefaults *ud=[NSUserDefaults standardUserDefaults]; 
    BOOL sexyPassed = [ud boolForKey:@"sexy"];
    if (sexyPassed) { 
    [[GameManager sharedGameManager] runSceneWithID:kSexyScene];
    }
}

-(void)callChamp {
    NSUserDefaults *ud=[NSUserDefaults standardUserDefaults]; 
    BOOL champPassed = [ud boolForKey:@"champ"];
    if (champPassed) { 
    [[GameManager sharedGameManager] runSceneWithID:kChampScene];
    }
}

-(void)returnMenu {
    [[GameManager sharedGameManager] runSceneWithID:kMainMenuScene];
}

-(void)scroll {
    
    // get screen size
    CGSize screenSize = [CCDirector sharedDirector].winSize;
    
    [[CCSpriteFrameCache sharedSpriteFrameCache] 
     addSpriteFramesWithFile:@"PlaySprite.plist"];
    spriteSheet = [CCSpriteBatchNode
                   batchNodeWithFile:@"PlaySprite.png"];
    [self addChild:spriteSheet z:1];
    [spriteSheet setAnchorPoint:ccp(0.0f, 0.0f)];
    
    
    // Return to main menu
    CCSprite *leftarrow = [CCSprite spriteWithSpriteFrameName:@"scrollarrow.png"];
    CCSprite *leftarrowClicked =
    [CCSprite spriteWithSpriteFrameName:@"scrollarrowclick.png"];
    
    CCMenuItemSprite * arrowItem = [CCMenuItemSprite itemFromNormalSprite:leftarrow 
				selectedSprite:leftarrowClicked target:self selector:@selector(returnMenu)];
    CCMenu *arrowMenu = [CCMenu menuWithItems: arrowItem, nil];
    [arrowMenu setPosition:ccp(screenSize.width * .11, screenSize.height * .872 )];
    [self addChild:arrowMenu];    
    
    //Basic Layer
    CCLayer *basicLayer = [[CCLayer alloc] init];     
    [basicLayer setScale:.50];
    
    //Background image
    CCSprite *BasicBackground  = [CCSprite
                                  spriteWithFile:@"BasicBackground.png"];
    
    // Add background as menu
    CCMenuItemSprite * basicItem = [CCMenuItemSprite itemFromNormalSprite:BasicBackground 
						selectedSprite:nil target:self selector:@selector(callBasic)];
    CCMenu *basicMenu = [CCMenu menuWithItems: basicItem, nil];
    [basicMenu setPosition:ccp(screenSize.width * .60, screenSize.height  )];
    [basicLayer addChild:basicMenu];
    
    // Add missing net
    CCSprite *netBasic = [CCSprite spriteWithSpriteFrameName:@"net.png"];
    [netBasic setPosition:ccp(screenSize.width * 0.855f, screenSize.height * 0.5630f)];
    [BasicBackground addChild:netBasic];
    
    // Big Jeremyimage
    CCSprite *BasicJeremy  = [CCSprite spriteWithSpriteFrameName:@"BigBasicJeremy.png"];
    [BasicJeremy setPosition:ccp(screenSize.width * .30 , screenSize.height * .75)];
    [basicLayer addChild:BasicJeremy];
    
    // Label
    CCLabelBMFont *jeremyLabel = [CCLabelBMFont labelWithString:@"Jeremy"
                                                        fntFile:@"blue23.fnt"];
    [jeremyLabel setPosition:ccp(screenSize.width * .63, screenSize.height * 1.56 )];
    [jeremyLabel setScale:2];
    [basicLayer addChild:jeremyLabel];
    
    //City Layer
    CCLayer *cityLayer = [[CCLayer alloc] init];
    [cityLayer setScale:.50];
    
    //Background image
    CCSprite *CityBackground  = [CCSprite
                                 spriteWithFile:@"Citybackground.png"];
    // Add background as menu
    CCMenuItemSprite * cityItem = [CCMenuItemSprite itemFromNormalSprite:CityBackground 
						selectedSprite:nil target:self selector:@selector(callCity)];
    CCMenu *cityMenu = [CCMenu menuWithItems: cityItem, nil];
    [cityMenu setPosition:ccp(screenSize.width * .60, screenSize.height  )];
    [cityLayer addChild:cityMenu];
    
    CCSprite *netCity = [CCSprite spriteWithSpriteFrameName:@"net.png"];
    [netCity setPosition:ccp(screenSize.width * 0.8530f, screenSize.height * 0.571f)];
    [CityBackground addChild:netCity];
    
    // Big Jeremyimage
    CCSprite *CityJeremy  = [CCSprite spriteWithSpriteFrameName:@"BigCityJeremy.png"];
    [CityJeremy setPosition:ccp(screenSize.width * .30 , screenSize.height * .70)];
    [cityLayer addChild:CityJeremy];
    
    // Label
    CCLabelBMFont *cityLabel = [CCLabelBMFont labelWithString:@"City Jeremy"
                                                      fntFile:@"red23.fnt"];
    [cityLabel setPosition:ccp(screenSize.width * .63, screenSize.height * 1.56 )];
    [cityLabel setScale:2];
    [cityLayer addChild:cityLabel];
    
    // Lock scenes
    // Don't have to initialize and variable to false, just pull
    // the object "city" which hasn't been created, it will
    // go to nil, after the finish the level, you will
    // create and set the value.
    NSUserDefaults *ud=[NSUserDefaults standardUserDefaults]; 
    BOOL cityPassed = [ud boolForKey:@"city"];
    
    if (!cityPassed) {
        CCSprite *lockCity = [CCSprite spriteWithSpriteFrameName:@"lock.png"];
        [lockCity setPosition:ccp(screenSize.width * 0.5f, screenSize.height * 0)];
        [CityBackground addChild:lockCity];
    }
    
    //Zombie Layer
    CCLayer *zombieLayer = [[CCLayer alloc] init];
    [zombieLayer setScale:.50];
    
    //Background image
    CCSprite *ZombieBackground  = [CCSprite
                                   spriteWithFile:@"ZombieBackground.png"];
    // Add background as menu
    CCMenuItemSprite * zombieItem = [CCMenuItemSprite itemFromNormalSprite:ZombieBackground selectedSprite:nil target:self selector:@selector(callZombie)];
    CCMenu *zombieMenu = [CCMenu menuWithItems: zombieItem, nil];
    [zombieMenu setPosition:ccp(screenSize.width * .60, screenSize.height  )];
    [zombieLayer addChild:zombieMenu];
    
    CCSprite *netZombie = [CCSprite spriteWithSpriteFrameName:@"net.png"];
    [netZombie setPosition:ccp(screenSize.width * 0.8545f, screenSize.height * 0.582f)];
    [ZombieBackground addChild:netZombie];
    
    // Big Zombieimage
    CCSprite *ZombieJeremy  = [CCSprite spriteWithSpriteFrameName:@"BigZombieJeremy.png"];
    [ZombieJeremy setPosition:ccp(screenSize.width * .30 , screenSize.height * .70)];
    [zombieLayer addChild:ZombieJeremy];
    
    // Label
    CCLabelBMFont *zombieLabel = [CCLabelBMFont labelWithString:@"Zombie Jeremy"
                                                        fntFile:@"green23.fnt"];
    [zombieLabel setPosition:ccp(screenSize.width * .63, screenSize.height * 1.56)];
    [zombieLabel setScale:2];
    [zombieLayer addChild:zombieLabel];
    
    // Lock
    BOOL zombiePassed = [ud boolForKey:@"zombie"];
    if (!zombiePassed) {
        CCSprite *lockZombie = [CCSprite spriteWithSpriteFrameName:@"lock.png"];
        [lockZombie setPosition:ccp(screenSize.width * 0.5f, screenSize.height * 0)];
        [ZombieBackground addChild:lockZombie];
    }
    
    //Sexy Layer
    CCLayer *sexyLayer = [[CCLayer alloc] init];
    [sexyLayer setScale:.50];
    
    //Background image
    CCSprite *SexyBackground  = [CCSprite
                                 spriteWithFile:@"SexyBackground.png"];
    // Add background as menu
    CCMenuItemSprite * sexyItem = [CCMenuItemSprite itemFromNormalSprite:SexyBackground 
				selectedSprite:nil target:self selector:@selector(callSexy)];
    CCMenu *sexyMenu = [CCMenu menuWithItems: sexyItem, nil];
    [sexyMenu setPosition:ccp(screenSize.width * .60, screenSize.height  )];
    [sexyLayer addChild:sexyMenu];
    
    CCSprite *netSexy = [CCSprite spriteWithSpriteFrameName:@"net.png"];
    [netSexy setPosition:ccp(screenSize.width * 0.8540f, screenSize.height * 0.580f)];
    [SexyBackground addChild:netSexy];
    
    // Big Sexyimage
    CCSprite *SexyJeremy  = [CCSprite spriteWithSpriteFrameName:@"BigSexyJeremy.png"];
    [SexyJeremy setPosition:ccp(screenSize.width * .30 , screenSize.height * .70)];
    [sexyLayer addChild:SexyJeremy];
    
    // Label
    CCLabelBMFont *sexyLabel = [CCLabelBMFont labelWithString:@"Sexy Jeremy"
                                                      fntFile:@"pink23.fnt"];
    [sexyLabel setPosition:ccp(screenSize.width * .63, screenSize.height * 1.56 )];
    [sexyLabel setScale:2];
    [sexyLayer addChild:sexyLabel];
    
    // Lock
    BOOL sexyPassed = [ud boolForKey:@"sexy"];
    if (!sexyPassed) {
        CCSprite *lockSexy = [CCSprite spriteWithSpriteFrameName:@"lock.png"];
        [lockSexy setPosition:ccp(screenSize.width * 0.5f, screenSize.height * 0)];
        [SexyBackground addChild:lockSexy];
    }
    
    //Champ Layer
    CCLayer *champLayer = [[CCLayer alloc] init];
    [champLayer setScale:.50];
    
    //Background image
    CCSprite *ChampBackground  = [CCSprite
                                  spriteWithFile:@"ChampionBackground.png"];
    // Add background as menu
    CCMenuItemSprite * champItem = [CCMenuItemSprite itemFromNormalSprite:ChampBackground 
						selectedSprite:nil target:self selector:@selector(callChamp)];
    CCMenu *champMenu = [CCMenu menuWithItems: champItem, nil];
    [champMenu setPosition:ccp(screenSize.width * .60, screenSize.height  )];
    [champLayer addChild:champMenu];
    
    CCSprite *netChamp = [CCSprite spriteWithSpriteFrameName:@"net.png"];
    [netChamp setPosition:ccp(screenSize.width * 0.8500f, screenSize.height * 0.565f)];
    [ChampBackground addChild:netChamp];
    
    // Big Champ image
    CCSprite *ChampJeremy  = [CCSprite spriteWithSpriteFrameName:@"BigChampJeremy.png"];
    [ChampJeremy setPosition:ccp(screenSize.width * .35 , screenSize.height * .70)];
    [champLayer addChild:ChampJeremy];
    
    // Label
    CCLabelBMFont *champLabel = [CCLabelBMFont labelWithString:@"Champion"
                                                       fntFile:@"gold23.fnt"];
    [champLabel setPosition:ccp(screenSize.width * .63, screenSize.height * 1.56 )];
    [champLabel setScale:2];
    [champLayer addChild:champLabel];
    
    // Lock
    BOOL champPassed = [ud boolForKey:@"champ"];
    if (!champPassed) {
        CCSprite *lockChamp = [CCSprite spriteWithSpriteFrameName:@"lock.png"];
        [lockChamp setPosition:ccp(screenSize.width * 0.5f, screenSize.height * 0)];
        [ChampBackground addChild:lockChamp];
    }
    
    // now create the scroller and pass-in the pages (set widthOffset to 0 for fullscreen pages)
    CCScrollLayer *scroller = [[CCScrollLayer alloc] initWithLayers:[NSMutableArray arrayWithObjects: basicLayer,cityLayer,zombieLayer,sexyLayer,champLayer,nil] widthOffset: 215];
    
    // finally add the scroller to your scene
    [self addChild:scroller];
    
    [scroller release];
    [basicLayer release];
    [cityLayer release];
    [zombieLayer release];
    [sexyLayer release];
    [champLayer release];
    
}

- (id)init  
{
    self = [super init];    
    if (self) {
        [self scroll];
    }
    return self;
}

@end
