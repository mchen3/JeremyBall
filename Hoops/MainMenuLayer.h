//
//  MainMenuLayer.h
//  2-SpaceViking
//
//  Created by Mike Chen on 10/15/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Constants.h"
#import "GameManager.h"
#import "SimpleAudioEngine.h"
#import "CocosDenshion.h"
#import "CDAudioManager.h"
@interface MainMenuLayer : CCLayer {
    CCMenu *mainMenu;
    CCMenu *sceneSelectMenu;
    SimpleAudioEngine *sae;
}
@end
