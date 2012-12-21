//
//  Constants.h
//  Hoops
//
//  Created by Mike Chen on 1/9/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#define kVikingSpriteZValue 100
#define kVikingSpriteTagValue 0
#define kVikingIdleTimer 3.0f
#define kVikingFistDamage 10
#define kVikingMalletDamage 40
#define kRadarDishTagValue 10

#define kBoardTagValue 10
typedef enum {
    kNoSceneUninitialized=0,
    kCreditsScene=3,
    kLevelCompleteScene=4,
    kIntroScene=100,
    kGameLevel1=101,
    kGameLevel2=102,
    kGameLevel3=103,
    kGameLevel4=104,
    kGameLevel5=105,
    kCutSceneForLevel2=201,
    
    // Jeremy Ball
    kGameScene,
    kCityScene,
    kZombieScene,
    kSexyScene,
    kChampScene,
    kMainMenuScene,
    kPlayScene,
    kOptionsScene,
} SceneTypes;
typedef enum {
    kLinkTypeBookSite,
    kLinkTypeDeveloperSiteRod,
    kLinkTypeDeveloperSiteRay,
    kLinkTypeArtistSite,
    kLinkTypeMusicianSite
} LinkTypes;



