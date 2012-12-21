//
//  GameplayLayer.h
//  Ragdoll
//
//  Created by Mike Chen on 1/7/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import <UIKit/UIKit.h>
#import "chipmunk.h"
#import "cpMouse.h"
#import "drawSpace.h"
#import "AppDelegate.h"
#import "Constants.h"
#import "Ball.h"
#import "CPSprite.h"
#import "MainMenuScene.h"
#import "SimpleAudioEngine.h"
#import "CocosDenshion.h"
#import "CDAudioManager.h"
#import "GameManager.h"
@interface GameplayLayer : CCLayer 
{
        cpSpace *space;
        cpBody *groundBody;
    
        cpShape *shapeTopground;
        cpShape *shapeBottomground;
        cpShape *shapeLeftground;
        cpShape *shapeRightground;
        cpShape *shapeBoard1;
        cpShape *shapeBoard2;
        cpShape *shapeBoard3;
        cpShape *shapeScore;
        cpShape *shapeMiss;
        cpShape *shapeNet;
    
        cpMouse *mouse;
        cpBody *board;
        cpBody *ballBody;
        CCSprite *holdball;
        CCSprite *netImage;
        CCSprite *fanImage;
    
        CCAnimation *holdAnim;
        CCAnimation *shootAnim;
        CCAnimation *netAnim;
        CCAnimation *fanAnim;

        CCAction *holdballAction;
        CCAction *shootballAction;
        CCAction *netAction;
        CCAction *fanAction;
        CCAction *moveAction;
        CCAction *moveAction1;
        
        double jumpStartTime;
    
        CCSprite *ballsprite;
        CCSpriteBatchNode *spriteSheet;
        Ball * ballsprite1;
        CPSprite *cpSprite;
        CCMenu *pauseMenu;
        CCLabelTTF *commentLabel;
        CCLabelTTF *scoreLabel;
        int scoreCounter;
    
        // Pause menu
        CCMenu *pauseLayerMenu;
        bool _pauseScreenUp;
        CCLayer *pauseLayer;
        CCMenu *_pauseScreenMenu;
        BOOL pausingMenu;
        CCSprite *bigjeremymenu;
    
        // Goals menu
        CCSprite *goalMenusprite;
        CCMenuItem *GoalMenuItem;
        CCMenu *goalsMenu;
        BOOL goalScreenUp;
    
        // Opening message
        CCLabelTTF *gameBeginLabel;
    
        CCLabelTTF *goalsLabel;
       //  CCLabelTTF *roundLabel;
        CCLabelBMFont *roundLabel;
    
        // Gameplay shots
        int shot;
        NSString *shots;
        NSArray *roundOne;
        NSArray *roundTwo;
        NSArray *roundThree;
        NSArray *championRound;
        int strike;
        int currentRound;

        //Front Labels for 
        CCSprite *goalSprite;
        CCSprite *scoreSprite;
        CCSprite *zerostrikeSprite;
        CCSprite *onestrikeSprite;
        CCSprite *twostrikeSprite;
    
        // Help Menu
        CCLayerColor *helpLayer;
        int helpCounter;
        CCSprite *shotLabel;
        CCSprite *holdLabel;
        CCSprite *shotTypeLabel;
        CCSprite *scoreCountLabel;
        CCSprite *goalLabel;
        CCSprite *champLabel;
        CCSprite *letsgoLabel;
    
        // Bool to prevent multiple sprites from showing
        // if the user keeps on playing after he wins
        BOOL nextLevelShown;
        SimpleAudioEngine *sae;
        CCParticleSystem *emitter;
}
@property (nonatomic, retain) CCAction *holdballAction;
@property (nonatomic, retain) CCAction *shootballAction;
@property (nonatomic, retain) CCAction *netAction;
@property (nonatomic, retain) CCAction *fanAction;
@property (nonatomic, retain) CCAction *moveAction;
@property (nonatomic, retain) CCAction *moveAction1;
@property (nonatomic, retain) CPSprite *cpSprite;
@property (nonatomic, retain) CCLabelTTF *commentLabel;
@property (nonatomic, retain) CCLabelTTF *scoreLabel;
@property (nonatomic, retain) NSArray *roundOne;
@property (nonatomic, retain) NSArray *roundTwo;
@property (nonatomic, retain) NSArray *roundThree;
@property (nonatomic, retain) NSArray *championRound;
@property (nonatomic, readwrite) int currentRound;
@end



















