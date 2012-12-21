//
//  OptionsLayer.m
//  Hoops
//
//  Created by Mike Chen on 4/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "OptionsLayer.h"
@implementation OptionsLayer
-(void)showTwitter {
    NSURL *urlToOpen = 
        [NSURL URLWithString:
         @"https://mobile.twitter.com/jeremyball17"];
    [[UIApplication sharedApplication] openURL:urlToOpen];
}

-(void)showEmail {
    NSURL *urlToOpen = 
    [NSURL URLWithString:
     @"mailto:jlinball@hotmail.com"];
    [[UIApplication sharedApplication] openURL:urlToOpen];
}

-(void)showFacebook {
    NSURL *urlToOpen = 
    [NSURL URLWithString:
     @"http://www.facebook.com/jlinball"];
    [[UIApplication sharedApplication] openURL:urlToOpen];
}

-(void)rateGame {
    if (!rateGameShown) {
    CCMenuItemImage *twitterLink = [CCMenuItemImage 
                                       itemFromNormalImage:@"twitter.png" 
                                       selectedImage:nil 
                                       disabledImage:nil 
                                       target:self 
                                       selector:@selector(showTwitter)];
    CCMenuItemImage *emailLink = [CCMenuItemImage 
                                      itemFromNormalImage:@"email.png" 
                                      selectedImage:nil 
                                      disabledImage:nil 
                                      target:self 
                                      selector:@selector(showEmail)];
    CCMenuItemImage *facebookLink = [CCMenuItemImage 
                                      itemFromNormalImage:@"facebook.png" 
                                      selectedImage:nil 
                                      disabledImage:nil 
                                      target:self 
                                      selector:@selector(showFacebook)];
    CGSize screenSize = [CCDirector sharedDirector].winSize; 
    CCMenu *mainMenu = [CCMenu 
                menuWithItems:twitterLink, emailLink, facebookLink, nil];
    [mainMenu alignItemsHorizontallyWithPadding:screenSize.height * 0.059f];
    [mainMenu setPosition:
     ccp(screenSize.width / 2.0f,
         screenSize.height * 1.2f)];
    id moveAction = 
    [CCMoveTo actionWithDuration:.7f 
                        position:ccp(screenSize.width / 2.0f,
                                     screenSize.height * .9f)];
    id moveEffect = [CCEaseIn actionWithAction:moveAction rate:2.0f];
    [mainMenu runAction:moveEffect];
    [self addChild:mainMenu ];
    rateGameShown = TRUE;    
    }    
}

-(void)returnToMainMenu {
	[[GameManager sharedGameManager] runSceneWithID:kMainMenuScene];
}

-(void)MusicButtonTapped {
    BOOL music = [GameManager sharedGameManager].isMusicON;
    // If background music is on, pause otherwise resume
    if (music) {
        [[SimpleAudioEngine sharedEngine] pauseBackgroundMusic];
        [GameManager sharedGameManager].isMusicON = FALSE;
    }
    else {
        [[SimpleAudioEngine sharedEngine] resumeBackgroundMusic];
        [GameManager sharedGameManager].isMusicON = TRUE;
    }
}

-(void)SoundButtonTapped {
    BOOL sound = [GameManager sharedGameManager].isSoundEffectsON;
    // If sound is on, turn off otherwise turn on
    if (sound) {
        // Mute option turns off sound effect and background so
        // you have to turn the toggle off for both.
        [CDAudioManager sharedManager].mute = TRUE;
        [GameManager sharedGameManager].isSoundEffectsON = FALSE;
        [GameManager sharedGameManager].isMusicON = FALSE;
    }
    else {
        [CDAudioManager sharedManager].mute = FALSE;
        [GameManager sharedGameManager].isSoundEffectsON = TRUE;
        [GameManager sharedGameManager].isMusicON = TRUE;
    }
}

-(id)init {
	self = [super init];
	if (self != nil) {
		CGSize screenSize = [CCDirector sharedDirector].winSize; 
		CCSprite *background = [CCSprite spriteWithFile:@"Citybackground.png"];
		[background setPosition:ccp(screenSize.width/2, screenSize.height/2)];
		[self addChild:background];
        // Add missing net
        CCSprite *net = [CCSprite spriteWithFile:@"net.png"];
        [net setPosition:ccp(screenSize.width * 0.8530f, screenSize.height * 0.571f)];
        [self addChild:net];
        // Music and Sound labels and menus
		CCLabelBMFont *musicOnLabelText = [CCLabelBMFont labelWithString:@"Music ON" fntFile:@"lightblue25.fnt"];
		CCLabelBMFont *musicOffLabelText = [CCLabelBMFont labelWithString:@"Music OFF" fntFile:@"lightblue25.fnt"];
		CCLabelBMFont *soundOnLabelText = [CCLabelBMFont labelWithString:@"Sound Effects ON" fntFile:@"lightblue25.fnt"];
		CCLabelBMFont *soundOffLabelText = [CCLabelBMFont labelWithString:@"Sound Effects OFF" fntFile:@"lightblue25.fnt"];
		CCMenuItemLabel *musicOnLabel = [CCMenuItemLabel itemWithLabel:musicOnLabelText target:self selector:nil];
		CCMenuItemLabel *musicOffLabel = [CCMenuItemLabel itemWithLabel:musicOffLabelText target:self selector:nil];
		CCMenuItemLabel *soundOnLabel = [CCMenuItemLabel itemWithLabel:soundOnLabelText target:self selector:nil];
		CCMenuItemLabel *soundOffLabel = [CCMenuItemLabel itemWithLabel:soundOffLabelText target:self selector:nil];
		CCLabelBMFont *rateButtonLabel = [CCLabelBMFont labelWithString:@"Which Jeremy would\n      you like to see?" fntFile:@"lightblue25.fnt"];
		CCMenuItemLabel	*rateButton = [CCMenuItemLabel itemWithLabel:rateButtonLabel target:self selector:@selector(rateGame)];
		CCMenuItemToggle *musicToggle = [CCMenuItemToggle itemWithTarget:self 
            selector:@selector(MusicButtonTapped) items:musicOnLabel,musicOffLabel,nil];
		CCMenuItemToggle *soundToggle = [CCMenuItemToggle itemWithTarget:self 
            selector:@selector(SoundButtonTapped) items:soundOnLabel,soundOffLabel,nil];
		CCLabelBMFont *backButtonLabel = [CCLabelBMFont labelWithString:@"Back" fntFile:@"lightblue25.fnt"];
		CCMenuItemLabel	*backButton = [CCMenuItemLabel itemWithLabel:backButtonLabel target:self selector:@selector(returnToMainMenu)];
        CCMenu *optionsMenu = [CCMenu menuWithItems:rateButton,musicToggle,
                               soundToggle,backButton,nil];
        [optionsMenu alignItemsVerticallyWithPadding:30.0f];
        [optionsMenu setPosition:ccp(screenSize.width/2, screenSize.height * .415)];
        [self addChild:optionsMenu];
        if ([[GameManager sharedGameManager] isMusicON] == NO) {
            [musicToggle setSelectedIndex:1]; // Music is OFF
        }
        if ([[GameManager sharedGameManager] isSoundEffectsON] == NO) {
            [soundToggle setSelectedIndex:1]; // SFX are OFF
        }
	}
	return self;
}
@end

