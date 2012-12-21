//
//  GameManager.m
//  Hoops
//
//  Created by Mike Chen on 3/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constants.h"
#import "cocos2d.h"
#import "SimpleAudioEngine.h"
#import "CocosDenshion.h"
#import "CDAudioManager.h"
@interface GameManager : NSObject {
    SceneTypes currentScene;
    //Audio
    SimpleAudioEngine *sae;
    ALuint soundID;

    BOOL isMusicON;
    BOOL isSoundEffectsON;
}

@property (readwrite) BOOL isMusicON;
@property (readwrite) BOOL isSoundEffectsON;

+(GameManager*)sharedGameManager; // 1
-(void)runSceneWithID:(SceneTypes)sceneID; // 2
-(void)preloadSoundEffects;
-(void)unloadSoundEffects;
-(void)playScore;
-(void)playBoard;
-(void)playMiss;
-(void)playRim;
-(void)playShot;
-(void)playBasicSound;
-(void)playFinalMiss;
-(void)playFinalScore;

@end
  
  
  
  
  
  
  
  
  
  
  
  
  
