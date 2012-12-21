
#import "chipmunk.h"
#import "GameManager.h"
#import "MainMenuScene.h"
#import "GameScene.h"
#import "CityScene.h"
#import "SexyScene.h"
#import "ChampScene.h"
#import "ZombieScene.h"
#import "PlayScene.h"
#import "OptionsScene.h"
@implementation GameManager

static GameManager* _sharedGameManager = nil; // 1
@synthesize isMusicON;
@synthesize isSoundEffectsON;

+(GameManager*)sharedGameManager {
    @synchronized([GameManager class]) // 2
    {
        if(!_sharedGameManager) // 3
            [[self alloc] init];
        return _sharedGameManager; // 4
    }
    return nil;
}

+(id)alloc
{
    @synchronized ([GameManager class])
    {
        NSAssert(_sharedGameManager == nil,
                 @"Attempted to allocate a second instance of the Game Manager singleton");
        _sharedGameManager = [super alloc];
        return _sharedGameManager;
    }
    return nil;
}

// Audio 
-(void)preloadSoundEffects {
    [sae preloadEffect:@"swish.wav"];
    [sae preloadEffect:@"board.wav"];
    [sae preloadEffect:@"rim.wav"];
    [sae preloadEffect:@"miss.wav"];
    [sae preloadEffect:@"oh.wav"];
    [sae preloadEffect:@"ahyeah.wav"];
}

-(void)unloadSoundEffects {
    [sae unloadEffect:@"swish.wav"];
    [sae unloadEffect:@"board.wav"];
    [sae unloadEffect:@"rim.wav"];
    [sae unloadEffect:@"miss.wav"];
    [sae unloadEffect:@"oh.wav"];
    [sae unloadEffect:@"ahyeah.wav"];    
}

-(void)playBasicSound {
    [sae stopBackgroundMusic];
}

// Audio
-(void)playScore {
    [[SimpleAudioEngine sharedEngine] playEffect:@"swish.wav"];
}

-(void)playBoard {
    [[SimpleAudioEngine sharedEngine] playEffect:@"board.wav"];
}

-(void)playMiss {
    [[SimpleAudioEngine sharedEngine] playEffect:@"miss.wav"];
   // [self playBasicSound];
}

-(void)playRim {
    [[SimpleAudioEngine sharedEngine] playEffect:@"rim.wav"];
}

-(void)playShot {
    // Left out laser shot, didn't sound right
    if (isSoundEffectsON) {
        //[[SimpleAudioEngine sharedEngine] playEffect:@"Laser.wav"];
    }
}

-(void)playFinalMiss {
    [[SimpleAudioEngine sharedEngine] playEffect:@"oh.wav"];
}

-(void)playFinalScore {
    [[SimpleAudioEngine sharedEngine] playEffect:@"ahyeah.wav"];
}

-(id)init { // 8
    self = [super init];
    if (self != nil) {
				isMusicON = TRUE;
        isSoundEffectsON = TRUE;
        cpInitChipmunk();
    }
    return self;
}

-(void)runSceneWithID:(SceneTypes)sceneID {
    SceneTypes oldScene = currentScene;
    currentScene = sceneID;
    
    // Audio
    sae = [SimpleAudioEngine sharedEngine];
    
    id sceneToRun = nil;
    switch (sceneID) {
        case kMainMenuScene: 
            
            [[CCSpriteFrameCache sharedSpriteFrameCache] removeUnusedSpriteFrames];
            [[CCTextureCache sharedTextureCache] removeUnusedTextures];
            sceneToRun = [MainMenuScene node];
            
            //Audio
            if (sae != nil) {
                // Make sure the two toggles are in line.
                if (isMusicON && [CDAudioManager sharedManager].mute == FALSE) {
                    [sae stopBackgroundMusic];
                    [sae preloadBackgroundMusic:@"Menu.mp3"];
                    [sae playBackgroundMusic:@"Menu.mp3"];
                    sae.backgroundMusicVolume = .3f;

                    // Save in case there is a bug
                    // Turn the music toggle on so the menus inside the
                    // scenes will turn their toggle back to on.
                    // Also check if the mute button was switched on
                    
                    //  if ([CDAudioManager sharedManager].mute == FALSE)
                    //      {isMusicON = TRUE;}
                }
            }
            break;
            
         case kPlayScene:   
            [[CCSpriteFrameCache sharedSpriteFrameCache] removeUnusedSpriteFrames];
            [[CCTextureCache sharedTextureCache] removeUnusedTextures];            
            sceneToRun = [PlayScene node];
            break;
            
         case kGameScene:
						sceneToRun = [GameScene node];
            //Audio 
           if (sae != nil) { 
                if (isMusicON && [CDAudioManager sharedManager].mute == FALSE) {
                    [sae stopBackgroundMusic];
                    [sae preloadBackgroundMusic:@"Basic.mp3"];
                    [sae playBackgroundMusic:@"Basic.mp3"];
                    sae.backgroundMusicVolume = 0.3f;
                }
           }
            break;
            
        case kCityScene:
            
            [[CCSpriteFrameCache sharedSpriteFrameCache] removeUnusedSpriteFrames];
            [[CCTextureCache sharedTextureCache] removeUnusedTextures];
            sceneToRun = [CityScene node];
            // Audio
            if (sae != nil) {
                if (isMusicON && [CDAudioManager sharedManager].mute == FALSE) {                    [sae stopBackgroundMusic];
                    [sae preloadBackgroundMusic:@"City.mp3"];
                    [sae playBackgroundMusic:@"City.mp3"];
                    sae.backgroundMusicVolume = 0.3f;
                }
            }
            break;
						
        case kZombieScene:
            [[CCSpriteFrameCache sharedSpriteFrameCache] removeUnusedSpriteFrames];
            [[CCTextureCache sharedTextureCache] removeUnusedTextures];
            sceneToRun = [ZombieScene node];
				
            // Audio
            if (sae != nil) {
                if (isMusicON && [CDAudioManager sharedManager].mute == FALSE) {
                    [sae stopBackgroundMusic];
                    [sae preloadBackgroundMusic:@"Zombie.mp3"];
                    [sae playBackgroundMusic:@"Zombie.mp3"];
                    sae.backgroundMusicVolume = 0.3f;
                }
            }
            break;
            
        case kSexyScene:
            [[CCSpriteFrameCache sharedSpriteFrameCache] removeUnusedSpriteFrames];
            [[CCTextureCache sharedTextureCache] removeUnusedTextures];
            sceneToRun = [SexyScene node];
            
            if (sae != nil) {
                if (isMusicON && [CDAudioManager sharedManager].mute == FALSE) {
                    [sae stopBackgroundMusic];
                    [sae preloadBackgroundMusic:@"Sexy.mp3"];
                    [sae playBackgroundMusic:@"Sexy.mp3"];
                    sae.backgroundMusicVolume = 0.3f;
                }
            }
            break;
            
        case kChampScene:
            [[CCSpriteFrameCache sharedSpriteFrameCache] removeUnusedSpriteFrames];
            [[CCTextureCache sharedTextureCache] removeUnusedTextures];
            sceneToRun = [ChampScene node];
        
            if (sae != nil) {
                if (isMusicON && [CDAudioManager sharedManager].mute == FALSE) {
                    [sae stopBackgroundMusic];
                    [sae preloadBackgroundMusic:@"Champ.mp3"];
                    [sae playBackgroundMusic:@"Champ.mp3"];
                    sae.backgroundMusicVolume = 0.3f;
                }
            }
            break;
            
        case kOptionsScene:   
            [[CCSpriteFrameCache sharedSpriteFrameCache] removeUnusedSpriteFrames];
            [[CCTextureCache sharedTextureCache] removeUnusedTextures];
            sceneToRun = [OptionsScene node];
            break;
            
         default:
            CCLOG(@"Unknown ID, cannot switch scene");
            return;
            break;
    }
    if (sceneToRun == nil) {
        //Revert back, since no new scene was found
        currentScene = oldScene;
        return;
    }
    if ([[CCDirector sharedDirector] runningScene] == nil) {
        [[CCDirector sharedDirector] runWithScene:sceneToRun];
    } else {
        [[CCDirector sharedDirector] replaceScene:sceneToRun];
    }
    currentScene = sceneID;
}
@end















