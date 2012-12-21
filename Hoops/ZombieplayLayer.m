//
//  ZombieplayLayer.m
//  Hoops
//
//  Created by Mike Chen on 4/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ZombieplayLayer.h"
#import "GameManager.h"
static void
eachShape(void *ptr, void* unused)
{
	cpShape *shape = (cpShape*) ptr;
	CCSprite *sprite = shape->data;
	if( sprite ) {
		cpBody *body = shape->body;
		
		// TIP: cocos2d and chipmunk uses the same struct to store it's position
		// chipmunk uses: cpVect, and cocos2d uses CGPoint but in reality the are the same
		// since v0.7.1 you can mix them if you want.		
		[sprite setPosition: body->p];
		[sprite setRotation: (float) CC_RADIANS_TO_DEGREES( -body->a )];
	}
}

@implementation ZombieplayLayer
@synthesize holdballAction;
@synthesize shootballAction;
@synthesize netAction;
@synthesize fanAction;
@synthesize moveAction;
@synthesize moveAction1;
@synthesize cpSprite;
@synthesize commentLabel;
@synthesize scoreLabel;
@synthesize roundOne;
@synthesize roundTwo;
@synthesize roundThree;
@synthesize championRound;
@synthesize currentRound;

- (void)draw {
    
    // Got this draw method from Space Viking, Scene 5 Escape
    drawSpaceOptions options = {
        0,    // drawHash;
        0,    // drawBBs
        0,    // drawShapes
        0.0f, // collisionPointSize // Was size 4, but red dots/collision points showed
        0.0f, // bodyPointSize
        1.5f, //lineThickness
    };
    
  // Added the Gl functions from Lembke
  glDisable(GL_TEXTURE_2D);
	glDisableClientState(GL_TEXTURE_COORD_ARRAY);
	glDisableClientState(GL_COLOR_ARRAY);
	
  // Implement scaling for retina devices
	glPushMatrix();    
  glScalef(CC_CONTENT_SCALE_FACTOR(), CC_CONTENT_SCALE_FACTOR(), 1.0f);
  drawSpace(space, &options);
    
	glPopMatrix();
	glEnableClientState(GL_COLOR_ARRAY);
	glEnableClientState(GL_TEXTURE_COORD_ARRAY);
	glEnable(GL_TEXTURE_2D);
    
}
// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
    
    cpMouseFree(mouse);
    cpBodyFree(groundBody);
    cpShapeFree(shapeTopground);
    cpShapeFree(shapeBottomground);
    cpShapeFree(shapeLeftground);
    cpShapeFree(shapeRightground);
    cpShapeFree(shapeBoard1);
    cpShapeFree(shapeBoard2);
    cpShapeFree(shapeBoard3);
    cpShapeFree(shapeScore);
    cpShapeFree(shapeMiss);
    cpShapeFree(shapeNet);
    cpSpaceFree(space);

    [self.roundOne release];
    [self.roundTwo release];
    [self.roundThree release];
    [self.championRound release];
    
    [holdballAction release];
    [shootballAction release];
    [netAction release];
    [fanAction release];
    [moveAction release];
    [moveAction1 release];
    [cpSprite release];
    [commentLabel release];
    [scoreLabel release];
    [[GameManager sharedGameManager] unloadSoundEffects];
    
	  [super dealloc];
}

- (void)initBall {
    
    // Load Sprite sheets
    [[CCSpriteFrameCache sharedSpriteFrameCache] 
     addSpriteFramesWithFile:@"zombieSprite.plist"];
    spriteSheet = [CCSpriteBatchNode
                   batchNodeWithFile:@"zombieSprite.png"];
    
    [self addChild:spriteSheet z:1];
    [spriteSheet setAnchorPoint:ccp(0.0f, 0.0f)];
    
    // Add child to Batchnode so you can call the update method on each sprite
    // so it follows the bodies position. The ball class for it's update and this one
    // Animation for holdball
    NSMutableArray *holdAnimFrames = [NSMutableArray array];
    for (int i = 1; i <= 7; ++i) {
        [holdAnimFrames addObject:
         [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:
          [NSString stringWithFormat:@"Holdball_%d.png", i]]];
        
    }
    holdAnim = [CCAnimation animationWithFrames:holdAnimFrames delay:0.1f];
    self.holdballAction = 
    [CCAnimate actionWithAnimation:holdAnim 
              restoreOriginalFrame:NO];
    
    // Animation for shootball
    NSMutableArray *shootAnimFrames = [NSMutableArray array];
    for (int i = 1; i <= 8; ++i) {
        [shootAnimFrames addObject:
         [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:
          [NSString stringWithFormat:@"shootrelease_%d.png", i]]];
    }
    shootAnim = [CCAnimation animationWithFrames:shootAnimFrames delay:0.1f];
    self.shootballAction = 
    [CCAnimate actionWithAnimation:shootAnim 
              restoreOriginalFrame:NO];
    // Set sprite for Jeremy
    holdball = [CCSprite spriteWithSpriteFrameName:@"Holdball_1.png"];
    CGSize screenSize = [[CCDirector sharedDirector] winSize];
    [self addChild:holdball];

    // Animation for net
    NSMutableArray *netAnimFrames = [NSMutableArray array];
    for (int i = 1; i <= 4; ++i) {
        [netAnimFrames addObject:
         [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:
          [NSString stringWithFormat:@"net_%d.png", i]]];
    }
    netAnim = [CCAnimation animationWithFrames:netAnimFrames delay:0.1f];
    self.netAction = 
    [CCAnimate actionWithAnimation:netAnim 
              restoreOriginalFrame:NO];
    
    // Set the net sprite
    netImage = [CCSprite spriteWithSpriteFrameName:@"net_1.png"];
    [netImage setPosition:ccp(screenSize.width * 0.8545f, screenSize.height * 0.582f)];
    [self addChild:netImage z:3];
}

-(void)callSexy {
    // User can still hit pause menu, even after he has won.
    if (pausingMenu) {
        return ;
    }
    [[GameManager sharedGameManager] runSceneWithID:kSexyScene];
}

-(void)callNextLevel {
    
    CGSize screenSize = [CCDirector sharedDirector].winSize;
    CCLabelBMFont *sexyLabel1 = [CCLabelBMFont 
                                 labelWithString:@"Touch THE Sexiness"
                                 fntFile:@"pink23.fnt"];
    [sexyLabel1 setPosition:ccp(screenSize.width * .44,
                                screenSize.height * .7 )];
    [self addChild:sexyLabel1];
    CCLabelBMFont *sexyLabel2 = [CCLabelBMFont 
                                 labelWithString:@"bow chicka wow wow"
                                 fntFile:@"pink23.fnt"];
    [sexyLabel2 setPosition:ccp(screenSize.width * .58,
                                screenSize.height * .38 )];
    [sexyLabel2 setScale:.4];
    [self addChild:sexyLabel2];
    CCLabelBMFont *sexyLabel3 = [CCLabelBMFont 
				labelWithString:@"Please go to iTunes\nto rate this app, Thanks"
                                 fntFile:@"pink23.fnt"];
    [sexyLabel3 setPosition:ccp(screenSize.width * .8,
                                screenSize.height * .05 )];
    [sexyLabel3 setScale:.6];
    [self addChild:sexyLabel3];
    
    // Add Big Sexy Jeremy
    CCSprite *sexyLevel = [CCSprite spriteWithSpriteFrameName:@"BigSexyJeremy.png"];
    CCMenuItemSprite * sexyItem = [CCMenuItemSprite itemFromNormalSprite:sexyLevel selectedSprite:nil target:self selector:@selector(callSexy)];
    [sexyLevel setScale:.75];
    CCMenu *sexyMenu = [CCMenu menuWithItems: sexyItem, nil];
    [sexyMenu setPosition:ccp(screenSize.width * .50, screenSize.height *.4  )];
    [self addChild:sexyMenu];
}

- (void)createBallAtLocation:(CGPoint)location {
    
    ballsprite1 = [[Ball alloc] initWithSpace:space
																		 location:location zombieplayLayer:self] ;
    [spriteSheet addChild:ballsprite1]; 
    [ballsprite1 release];
    // Pass the body from the sprite class to this class
    // so you get set velocity for shooting the ball
    ballBody = ballsprite1.body;  
}

- (void)shootBall: (ccTime)time {
    
    // Creating ball and shooting ball based on round
    CGSize screenSize = [[CCDirector sharedDirector] winSize];
    // FT
    if (shot == 1) {
        [self createBallAtLocation:ccp(screenSize.width * 0.28f, screenSize.height * 0.30f)];
          cpBodySetVel(ballBody, ccp(300  ,480 + time * 200));
    }
    // 15
    else if (shot == 2) {
        [self createBallAtLocation:ccp(screenSize.width * 0.18f, screenSize.height * 0.30f)];
        cpBodySetVel(ballBody, ccp(330,520 + time * 150));
    }
    // 3pt
    else if  (shot == 3) {
        [self createBallAtLocation:ccp(screenSize.width * 0.10f, screenSize.height * 0.30f)];
        cpBodySetVel(ballBody, ccp(350,500 + time * 150));
    }
}

-(void)initializeRounds {
    
    // Make round1 a property value and retain it otherwise when you call it in
    //  some other method it will contain a error calling a dealloc instance.
    
    // Shot numbers 3,5,6,7
    self.roundOne = [NSArray arrayWithObjects: [NSNumber numberWithInt:1],
                     [NSNumber numberWithInt:2],[NSNumber numberWithInt:3],
                     nil];
    
    self.roundTwo = [NSArray arrayWithObjects: [NSNumber numberWithInt:2],
                    [NSNumber numberWithInt:1],[NSNumber numberWithInt:3],
                    [NSNumber numberWithInt:3],[NSNumber numberWithInt:1],
                    nil];
    
  self.roundThree = [NSArray arrayWithObjects: [NSNumber numberWithInt:2],
                    [NSNumber numberWithInt:3],[NSNumber numberWithInt:2],
                    [NSNumber numberWithInt:1], [NSNumber numberWithInt:3],
                    [NSNumber numberWithInt:2],
                    nil];
    
self.championRound= [NSArray arrayWithObjects: [NSNumber numberWithInt:1],
                    [NSNumber numberWithInt:2],[NSNumber numberWithInt:1],
                    [NSNumber numberWithInt:3],[NSNumber numberWithInt:1],
                    [NSNumber numberWithInt:2],[NSNumber numberWithInt:3],
                    nil];
    
    currentRound = 1;
    strike = 0;
}

-(void)updateRound {
    
    //What is the current Round
    if (currentRound == 1) {
        // If Strike is 3, strike out
        if (strike == 3) {
            CCLOG(@"Round 1 Strike out");
            strike = 0;            
            shot = [[self.roundOne objectAtIndex:scoreCounter] integerValue];
            
            // Play audio for strikeout
            [[GameManager sharedGameManager] playFinalMiss];
            
        }else
            // not strike out, iterate through the round 1 array
        {
            // If the scoreCounter is equal to the sum total of array, move
            // to Round 2, and reset counters.
            if (scoreCounter == 3) {
                currentRound = 2;
                scoreCounter = 0;
                strike = 0;
                NSString *score = [NSString stringWithFormat:@"%i",scoreCounter];
                [self.scoreLabel setString:score];
                
            }
            else {
                // not finish with this round, go to the index.
                shot = [[self.roundOne objectAtIndex:scoreCounter] integerValue];
            }
        }
    }
    
    if (currentRound == 2) {
        // Iterate through the array until strikeout
        if (strike == 3) {
            currentRound = 1;
            strike = 0;
            shot = [[self.roundOne objectAtIndex:scoreCounter] integerValue];
            
            // Play audio for strikeout
            [[GameManager sharedGameManager] playFinalMiss];
            
        }else
        {
            if (scoreCounter == 5) {
                currentRound = 3;
                scoreCounter = 0;
                strike = 0;
                NSString *score = [NSString stringWithFormat:@"%i",scoreCounter];
                [self.scoreLabel setString:score];
            }
            else {
                shot = [[self.roundTwo objectAtIndex:scoreCounter] integerValue];
            }
        }
    }
    
    if (currentRound == 3) {
        if (strike == 3) {
            currentRound = 2;
            strike = 0;
            shot = [[self.roundTwo objectAtIndex:scoreCounter] integerValue];
            
            // Play audio for strikeout
            [[GameManager sharedGameManager] playFinalMiss];
            
        }else
        {
            if (scoreCounter == 6) {
                currentRound = 4;
                scoreCounter = 0;
                strike = 0;
                NSString *score = [NSString stringWithFormat:@"%i",scoreCounter];
                [self.scoreLabel setString:score];            }
            else {
                shot = [[self.roundThree objectAtIndex:scoreCounter] integerValue];
            }
        }
    }
    
    // Champion Round
    if (currentRound == 4) {
        if (strike == 3) {
            // Strikeout at Championship round, move back to round 1
            currentRound = 1;
            strike = 0;
            shot = [[self.roundOne objectAtIndex:scoreCounter] integerValue];
            
            // Play audio for strikeout
            [[GameManager sharedGameManager] playFinalMiss];
            
        }else
        {
            if (scoreCounter >= 7) {
                [self.scoreLabel setString:@"WIN"];
                // Audio Play final Win
                [[GameManager sharedGameManager] playFinalScore];
                
                // Unlock layer in NSUserDefaults                
                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"sexy"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                // Show option to go to Sexy
                if (!nextLevelShown) {
                    
                    // Set a time delay to  make the Sprite show at the same
                    // time as the score callback.
                    id myCallFunc = [CCCallFunc actionWithTarget:self selector:@selector(callNextLevel)];
                    id delayTimeAction = [CCDelayTime actionWithDuration:1.5];
                    [self runAction:[CCSequence actions:delayTimeAction,
                                     myCallFunc, nil]];    
                    
                    nextLevelShown = TRUE;    
                }
            }
            else {
                shot = [[self.championRound objectAtIndex:scoreCounter] integerValue];
            }
        }
    }
    
    // Setting the position on Jeremy sprite based on shot type
    CGSize screenSize = [[CCDirector sharedDirector] winSize];
    
    // Shot 1 = FT, Shot 2 = 15 footer, Shot 3 = 3 point.
    if (shot == 1) {
        // Show FT message
        [holdball setPosition:ccp(screenSize.width * 0.26f, screenSize.height * 0.32f)];
        
    } else if (shot == 2) {
        // show 15 ft message
        [holdball setPosition:ccp(screenSize.width * 0.18f, screenSize.height * 0.32f)];
        
    } else if (shot == 3) {
        // 3pt
        [holdball setPosition:ccp(screenSize.width * 0.09f, screenSize.height * 0.32f)];
    }
    
    //Labels
    // Set Label for Goal
    if (currentRound == 1) {
        NSString *goalScore = 
        [NSString stringWithFormat:@"%i",[self.roundOne count]];
        [goalsLabel setString:goalScore];
    }
    else if (currentRound == 2) {
        NSString *goalScore = 
        [NSString stringWithFormat:@"%i",[self.roundTwo count]];
        [goalsLabel setString:goalScore];
        
    }
    else if (currentRound == 3) {
        NSString *goalScore = 
        [NSString stringWithFormat:@"%i",[self.roundThree count]];
        [goalsLabel setString:goalScore];
        
    }
    else if (currentRound == 4) {
        NSString *goalScore = 
        [NSString stringWithFormat:@"%i",[self.championRound count]];
        [goalsLabel setString:goalScore];
    }
    
    // Set Label for Round
    if (currentRound == 1) {
        NSString *roundString = [NSString stringWithFormat:@"Round 1",currentRound]; 
        [roundLabel setString:roundString];
    }
    else if (currentRound == 2) {
        NSString *roundString = [NSString stringWithFormat:@"Round 2",currentRound]; 
        [roundLabel setString:roundString];
    }
    else if (currentRound == 3) {
        NSString *roundString = [NSString stringWithFormat:@"Round 3",currentRound]; 
        [roundLabel setString:roundString];
    }
    else  if (currentRound == 4) {
        NSString *roundString = [NSString stringWithFormat:@"Champion",currentRound]; 
        [roundLabel setString:roundString];
    }     
    
    // Set sprite for Strikeout
    if (strike == 0) {
        zerostrikeSprite.visible = TRUE;
        onestrikeSprite.visible = FALSE;
        twostrikeSprite.visible = FALSE;
    }
    else if (strike == 1) {
        zerostrikeSprite.visible = FALSE;
        onestrikeSprite.visible = TRUE;
        twostrikeSprite.visible = FALSE;
        
    }
    else if (strike == 2) {
        zerostrikeSprite.visible = FALSE;
        onestrikeSprite.visible = FALSE;
        twostrikeSprite.visible = TRUE;
    }
}

- (void)animateNet {
    [netImage stopAction:netAction];
    [netImage runAction:netAction];
}

- (void)animateFangirl {
    [fanImage stopAction:moveAction];
    [fanImage runAction:moveAction];
}

- (void)registerWithTouchDispatcher {
    [[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self
                                                     priority:0 swallowsTouches:NO];
}

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    
    // The pause menu pressed is up so don't run anything
    if (pausingMenu) {
        return YES;
    }
    
    CGPoint touchLocation = [self convertTouchToNodeSpace:touch];
    
    // Prevent user touch from moving infinite bodies (causes bugs
    // ie can't move infinite bodies in chipmunk)
    // rim and board are infinite
    if (touchLocation.x >380 && touchLocation.y > 180)
    {
        CCLOG(@"Touch %.1f %.1f", touchLocation.x, touchLocation.y);
        return NO;
    }
    
    cpMouseGrab(mouse, touchLocation, false);
    
    // Shot release based on time
    jumpStartTime = CACurrentMediaTime();
    [holdball stopAction:shootballAction];
    [holdball runAction:holdballAction];
    return YES;
}

- (void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event {
    
    if (pausingMenu) {
        return ;
    }
    CGPoint touchLocation = [self convertTouchToNodeSpace:touch];
    cpMouseMove(mouse, touchLocation);
}

- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event {
    
    if (pausingMenu) {
        return ;
    }
    
    cpMouseRelease(mouse);
    [holdball stopAction:holdballAction];
    [holdball runAction:shootballAction];
    double endTime = CACurrentMediaTime() - jumpStartTime;
    NSLog(@"%.5f", endTime);
    [self shootBall:endTime];
    jumpStartTime = 0;
}

- (void)createSpace {
    space = cpSpaceNew();
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        space->gravity = ccp(0, -1500); // 2
    } else {
        space->gravity = ccp(0, -1000);
        
    }
    cpSpaceResizeStaticHash(space, 400, 200); // 3
    cpSpaceResizeActiveHash(space, 200, 200);
}

- (void)createGround {
   
    groundBody = cpBodyNew(INFINITY, INFINITY);
    CGSize wins = [[CCDirector sharedDirector] winSize];
    
    // top  - Don't add the top to the space
    shapeTopground = cpSegmentShapeNew(groundBody, ccp(0,wins.height),
                              ccp(wins.width,wins.height), 0.0f); 
    shapeTopground->e = .8f; 
    shapeTopground->u = 0;
    shapeTopground->collision_type = 2;

    // Bottom ground, set it in the under the players feet
    // Have to make the radius super small otherwise the 
    // player can touch the object with infinite mass and program will crash
    shapeBottomground = cpSegmentShapeNew(groundBody, ccp(0, wins.width * .083f), 
                              ccp(wins.width, wins.width * .083f), .000000001f);
    shapeBottomground->e = .8f;
    shapeBottomground->u = 0;
    shapeBottomground->collision_type = 1;
    cpSpaceAddStaticShape(space, shapeBottomground);
    
    // left
    shapeLeftground = cpSegmentShapeNew(groundBody, ccp(0,0), ccp(0,wins.height), 0.0f);
    shapeLeftground->e = .8f; 
    shapeLeftground->u = 0;
    cpSpaceAddStaticShape(space, shapeLeftground);
    
    // right
    shapeRightground = cpSegmentShapeNew(groundBody, ccp(wins.width,0), ccp(wins.width,wins.height), 0.0f);
    shapeRightground->e = .8f; 
    shapeRightground->u = 0;
    cpSpaceAddStaticShape(space, shapeRightground);
}

- (void)createBoard {
    
    CGSize winSize = [CCDirector sharedDirector].winSize;
    // Left rim
    cpVect verts[] = {
        cpv(-winSize.width * .005f, -winSize.width * .005f),
        cpv(-winSize.width * .005f, winSize.width * .005f),
        cpv(winSize.width * .0045f, winSize.width * .005f),
        cpv(winSize.width * .005f, -winSize.width * .005f)
    };
    
    // Setting the restitution/frequency/bounciness of the rims
    // to .8 causes the ball to bounce too much around the rim
    // resulting in the ball to never slide and score around
    // the rim. .7 seems to be the right setting.
    
    shapeBoard1 = cpPolyShapeNew(groundBody, 4, verts,
																 ccp(winSize.width * .82f, winSize.height * .615f));
    shapeBoard1->e = .7;   
    shapeBoard1->u = 0;
    shapeBoard1->collision_type = 3;
    cpSpaceAddShape(space, shapeBoard1);
    
    // Right rim
    cpVect vert[] = {
        cpv(-winSize.width * .005f, -winSize.width * .005f),
        cpv(-winSize.width * .0045f, winSize.width * .005f),
        cpv(winSize.width * .005f, winSize.width * .005f),
        cpv(winSize.width * .005f, -winSize.width * .005f)
    };
    
    shapeBoard2 = cpPolyShapeNew(groundBody, 4, vert,
																 ccp(winSize.width * .89f, winSize.height * .615f));
    shapeBoard2->e = .7;
    shapeBoard2->u = 0;
    shapeBoard2->collision_type = 4;
    cpSpaceAddShape(space, shapeBoard2);
    
    // Back Board    
    cpVect vert1[] = {   //.021
        cpv(-winSize.width * .025f, -winSize.width * .063f),
        cpv(-winSize.width * .021f, winSize.width * .063f),
        cpv(winSize.width * .060f, winSize.width * .0300f),
        cpv(winSize.width * .021f, -winSize.width * .063f)
    };
    shapeBoard3 = cpPolyShapeNew(groundBody, 4, vert1, ccp(winSize.width * .92f,
                                winSize.height * .70f));
    
    // Trick shots
    // You want to set the bounciness of the board to where you can sometimes
    // have the ball stuck on the back
    // shape2->e = 1;  Bounce too high, ball never gets stuck
    //  shape2->e = .7; Bounce too low, ball can stuck too much.
    // .8 is nice where you can sometimes 1 out of 10 hit the board 
    // and the ball bounces into the rim
    
    shapeBoard3->e = .8;
    shapeBoard3->u = 0;
    shapeBoard3->collision_type = 5;
    cpSpaceAddShape(space,shapeBoard3);
}

- (void)createScoreSensor {
    
    CGSize winSize = [CCDirector sharedDirector].winSize;
    cpVect verts[] = {
        cpv(-winSize.width * .03f, -winSize.width * .002f),
        cpv(-winSize.width * .03f, winSize.width * .002f),
        cpv(winSize.width * .03f, winSize.width * .002f),
        cpv(winSize.width * .02f, -winSize.width * .002f)
    };
    
    shapeScore = cpPolyShapeNew(groundBody, 4, verts, ccp(winSize.width * .88f,
                                    winSize.height * .575f));
    shapeScore->collision_type = 10;
    shapeScore->sensor = TRUE;
    // Set self, GameplayLayer to shape so you can use the class
    // to point at the ScoreMenu when you miss or score sensor activate
    shapeScore->data = self;
    cpSpaceAddShape(space, shapeScore);
}

- (void)createMissSensor {
    
    CGSize winSize = [CCDirector sharedDirector].winSize;
    cpVect verts[] = {
        cpv(-winSize.width * 0.50f, -winSize.width * 0.002f),
        cpv(-winSize.width * 0.50f, winSize.width * 0.002f),
        cpv(winSize.width * 0.29f, winSize.width * 0.002f),
        cpv(winSize.width * 0.29f, -winSize.width * 0.002f)
    };
    
    shapeMiss = cpPolyShapeNew(groundBody, 4, verts, 
                                    ccp(winSize.width * .50f,winSize.height * .585f));
    shapeMiss->collision_type = 11;
    shapeMiss->sensor = TRUE;
    shapeMiss->data = self;
    cpSpaceAddShape(space, shapeMiss);
}

- (void)createNetSensor {
    
    CGSize winSize = [CCDirector sharedDirector].winSize;
    cpVect verts[] = {
        cpv(-winSize.width * 0.06f, -winSize.width * 0.002f),
        cpv(-winSize.width * 0.06f, winSize.width * 0.002f),
        cpv(winSize.width * 0.02f, winSize.width * 0.002f),
        cpv(winSize.width * 0.02f, -winSize.width * 0.002f)
    };
    
    shapeNet= cpPolyShapeNew(groundBody, 4, verts, 
                                    ccp(winSize.width * .88f,winSize.height * .585f));
    shapeNet->collision_type = 12;
    shapeNet->sensor = TRUE;
    cpSpaceAddShape(space, shapeNet);
}

// Use a postStepRemove because Chipmunk 
// doesn't allow you to removebodies within 
// a callback
static void postStepRemove(cpSpace *space, cpShape *shape, void *unused)
{
    cpBody *ballBody =  shape->body;
    Ball *ballSprite = ballBody->data;
    cpSpaceRemoveBody(space, shape->body);
    cpBodyFree(shape->body);
    cpSpaceRemoveShape(space, shape);
    cpShapeFree(shape);
    [ballSprite removeFromParentAndCleanup:YES];
}

// Sensor / Callback for ground
static cpBool ground (cpArbiter *arb, cpSpace *space, void *data) {
    
    // Arb is all the shapes involve in the collision
    // ballShape is the first, groundShape is the second
    CP_ARBITER_GET_SHAPES(arb, ballShape, groundShape);
    
		// The Ball sprite set body->data = self, instead
    // of body->shape = self. So get shape to get the body
    // and get the sprite (Ball class)
    cpBody *ballBody =  ballShape->body;
    Ball *ball = ballBody->data;
    
    // Try to set a time delay on destroying the ball, got a little
    // complicated. Used sequence actions but had a problem
    // passing the function through. I used a counter instead
    // ie I destroyed the ball after the ball and ground touches
    // for 5 times, for some reason a bug comes up if I raised
    // the counter to 6 or 10. Maybe too many callbacks or touches.
    if (ball.delayBalldestroy < 6) {
        //  CCLOG(@"Delay at time%d", ball.delayBalldestroy);
        ball.delayBalldestroy++;
        
        // Signal the Ball to destroy its own particle trail 
        // Elimate on the 5th bounce. You don't want to destroy the particle
        // too soon nor do you want to destroy it after the 6th, ie the
        // poststepcallback will trigger and it'll destroy the ball before
        // you even get a chance to elimate the particle.
        if (ball.delayBalldestroy == 5) {
            ball.particleDestroy = TRUE;
        }
    }
    else
    {
        // After the 5th time the ball and ground touched, destroy the
        // ball. Can't delete bodies within a callback, so you must
        // call a postStep method to destroy the ball
        cpSpaceAddPostStepCallback(space, (cpPostStepFunc)postStepRemove, ballShape, data);
    }
    return cpTrue;
}

// Sensor for scored
static cpBool scored (cpArbiter *arb, cpSpace *space, void *ignore) {
    CP_ARBITER_GET_SHAPES(arb, ballShape, groundShape);
    cpVect n = cpArbiterGetNormal(arb, 0);
    
    // ballShape data is used for the info between two bodies.
    ZombieplayLayer *game = (ZombieplayLayer *)groundShape->data;

    // Register only when the ball flies from top to bottom
    if (n.y < 0.0f) {        
        //Update scoreCounter and update round and scorelabel
        game->scoreCounter++;
        CCLOG(@"%i", game->scoreCounter);
        NSString *score = [NSString stringWithFormat:@"%i", game->scoreCounter];
        [game.scoreLabel setString:score];
        [game updateRound];       
        
        //Audio
        [[GameManager sharedGameManager] playScore];
    }    
    return cpTrue;
}

// Sensor for miss
static cpBool miss (cpArbiter *arb, cpSpace *space, void *ignore) {
    CP_ARBITER_GET_SHAPES(arb, ballShape, groundShape);
    cpVect n = cpArbiterGetNormal(arb, 0);
    
    ZombieplayLayer *game = (ZombieplayLayer *)groundShape->data;
    // Unused  GameManager *manager= [GameManager sharedGameManager];
    if (n.y < 0.0f) {
        CCLOG(@"Miss");
        // Update score label
        game->scoreCounter = 0;
        NSString *score = [NSString stringWithFormat:@"%i", game->scoreCounter];
        [game.scoreLabel setString:score];
        
        // Increase strike
        game->strike++;
        [game updateRound];
        
        // Audio
        [[GameManager sharedGameManager] playMiss];
    }
    return cpTrue;
}

// Sensor for net
static cpBool net (cpArbiter *arb, cpSpace *space, void *ignore) {
    CP_ARBITER_GET_SHAPES(arb, ballShape, groundShape);
   // cpVect n = cpArbiterGetNormal(arb, 0);
    
    // Ignore is the "self" that was passed through cpSpaceAddCollisionHandler
    CityplayLayer *game = ignore;
    [game animateNet];
    return cpTrue;
}

// Callback for leftrim
static cpBool leftRim (cpArbiter *arb, cpSpace *space, void *data) {
    CP_ARBITER_GET_SHAPES(arb, ballShape, groundShape);
    
    //Audio
    [[GameManager sharedGameManager] playRim];
    return cpTrue;
}

// Callback for right
static cpBool rightRim (cpArbiter *arb, cpSpace *space, void *data) {
    CP_ARBITER_GET_SHAPES(arb, ballShape, groundShape);
    CCLOG(@"Right Rim");
    
    return cpTrue;
}

// Callback for backboard
static cpBool backBoard (cpArbiter *arb, cpSpace *space, void *data) {
    CP_ARBITER_GET_SHAPES(arb, ballShape, groundShape);
    CCLOG(@"Back Board");
    
    // Audio
    [[GameManager sharedGameManager] playBoard];
    
    return cpTrue;
}

- (void)GoalMessage:(id)sender {
    [self removeChild:goalMenusprite cleanup:YES];
    [self removeChild:goalsMenu cleanup:YES];
    goalScreenUp = FALSE;
}

- (void)pauseMenu {
    
    CGSize screenSize = [[CCDirector sharedDirector] winSize];
    
    CCMenuItem *pauseMenuItem = [CCMenuItemImage 
                                 itemFromNormalImage:@"triangle.png" selectedImage:@"triangleclick.png" 
                                 target:self selector:@selector(PauseButtonTapped:)]; 
    pauseMenuItem.position = ccp(screenSize.width * .065,screenSize.height * .895);
    pauseLayerMenu = [CCMenu menuWithItems:pauseMenuItem, nil];
    pauseLayerMenu.position = CGPointZero;
    [self addChild:pauseLayerMenu z:2];
    
}

-(void)GoalButtonTapped:(id)sender{
    
    // Redundant to the code below
    // if(goalScreenUp)
    // {return;}
    
    if (goalScreenUp == FALSE) {
        goalScreenUp = TRUE;
        CGSize screenSize = [[CCDirector sharedDirector] winSize];
        goalMenusprite = [CCSprite spriteWithFile:@"goalsmenu.png"]; 
        [goalMenusprite setPosition:ccp(screenSize.width * .74, screenSize.height * .50)];
        [goalMenusprite setScale:1.0f];
        [self addChild:goalMenusprite z:10];
        
        GoalMenuItem= [CCMenuItemImage itemFromNormalImage:@"goalsok.png" selectedImage:nil target:self selector:@selector(GoalMessage:)];
        GoalMenuItem.position = ccp(screenSize.width * .74, screenSize.height * .17);
        
        goalsMenu = [CCMenu menuWithItems:GoalMenuItem, nil];
        goalsMenu.position = ccp(0,0);
        [self addChild:goalsMenu z:10];
    }
}

// Leave game and return to main menu
-(void)MainMenuButtonTapped:(id)sender{
    if(goalScreenUp)
    {return;}
    
	//[self removeChild:_pauseScreenMenu cleanup:YES];
	[self removeChild:pauseLayer cleanup:YES];
	[[CCDirector sharedDirector] resume];
	_pauseScreenUp=FALSE;
    
    [[GameManager sharedGameManager] runSceneWithID:kMainMenuScene];
}

-(void)MusicButtonTapped:(id)sender {
    if(goalScreenUp)
    {return;}
    
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

-(void)SoundButtonTapped:(id)sender{
    if(goalScreenUp)
    {return;}
    
    BOOL sound = [GameManager sharedGameManager].isSoundEffectsON;
    
    // If sound is on, turn off otherwise turn on
    if (sound) {
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

// Quit pause menu and return to game
-(void)QuitButtonTapped:(id)sender{
    
    // When the goal menu is up, don't let the user tap the other
    // buttons
    if(goalScreenUp)
    {return;}
    
	[self removeChild:pauseLayer cleanup:YES];
    [self pauseMenu];
    
    // Allow cctouch and update to run again
    pausingMenu = FALSE;
	[[CCDirector sharedDirector] resume];
    
    // Dont need nflag because the pause layer is removed
    // after it's button is pressed
	_pauseScreenUp=FALSE;
}


-(void)PauseButtonTapped:(id)sender
{
    
    [self removeChild:gameBeginLabel cleanup:YES];
    [self removeChild:pauseLayerMenu cleanup:YES];
    
		// You can still hit the pause button, so _pauseScreenUp prevents relaunching
    // Added revision, don't need _pauseScreenUp flag, I removed pauseLayer altogether
	if(_pauseScreenUp == FALSE)
	{
		_pauseScreenUp=TRUE;
		//if you have music uncomment the line bellow
		//[[SimpleAudioEngine sharedEngine] pauseBackgroundMusic];
        
        // Prevents CCTouch and update from running during CCDirector pause
        pausingMenu = TRUE;
        
        [[CCDirector sharedDirector] pause];
        
        //Transparent layer
		CGSize screenSize = [[CCDirector sharedDirector] winSize];
		pauseLayer = [CCLayerColor layerWithColor: ccc4(0, 0, 0, 90) width: screenSize.width height: screenSize.height];
		pauseLayer.position = CGPointZero;
		[self addChild: pauseLayer z:8];
        
        // Big Jeremy
        bigjeremymenu = [CCSprite spriteWithSpriteFrameName:@"JeremyPause.png"]; 
        [bigjeremymenu setPosition:ccp(screenSize.width * .25, screenSize.height * .45)];
        [pauseLayer addChild:bigjeremymenu];
        
        // Pause menu
        CCLabelBMFont *pauseMessage = [CCLabelBMFont labelWithString:@"PAUSE" fntFile:@"lightblue25.fnt"];
        //   CCLabelTTF *pauseMessage = [CCLabelTTF labelWithString:@"PAUSE" fontName:@"Thonburi-Bold" fontSize:20];
        [pauseMessage setColor:ccc3(0,255,255)];
        [pauseMessage setPosition:ccp(screenSize.width * .50, screenSize.height * .90)];
        [pauseLayer addChild:pauseMessage];
        
        // Goals menu
		CCMenuItem *GoalsMenuItem = [CCMenuItemImage itemFromNormalImage:@"goals.png" selectedImage:@"goalsclick.png" target:self selector:@selector(GoalButtonTapped:)];
        GoalsMenuItem.position = ccp(screenSize.width * .75, screenSize.height * .9);
        
        // MainMenu menu
		CCMenuItem *MainMenuItem = [CCMenuItemImage itemFromNormalImage:@"main.png" selectedImage:@"mainclick.png" target:self selector:@selector(MainMenuButtonTapped:)];
        MainMenuItem.position = ccp(screenSize.width * .75, screenSize.height * .7);
        
        // Music on/off toggle menu
        CCMenuItem *MusicOnItem = [CCMenuItemImage itemFromNormalImage:@"musicon.png" selectedImage:@"musicon.png" target:nil selector:nil];
        CCMenuItem *MusicOffItem = [CCMenuItemImage itemFromNormalImage:@"musicoff.png" selectedImage:@"musicoff.png" target:nil selector:nil];
        CCMenuItemToggle *MusicToggleItem = [CCMenuItemToggle itemWithTarget:self 
						selector:@selector(MusicButtonTapped:) items:MusicOnItem, MusicOffItem, nil];
        MusicToggleItem.position = ccp(screenSize.width * .75, screenSize.height * .5);
        
        // Set the state of toggle based on current music state
        BOOL music =  [GameManager sharedGameManager].isMusicON;
        if (music) {
            [MusicToggleItem setSelectedIndex:0];
        }else {
            [MusicToggleItem setSelectedIndex:1];
        }
        
        
        // Sound on/off toggle menu
		CCMenuItem *SoundOnItem = [CCMenuItemImage itemFromNormalImage:@"soundon.png" selectedImage:@"soundon.png" target:nil selector:nil];
        CCMenuItem *SoundOffItem = [CCMenuItemImage itemFromNormalImage:@"soundoff.png" selectedImage:@"soundoff.png" target:nil selector:nil];
        CCMenuItemToggle *SoundToggleItem = [CCMenuItemToggle itemWithTarget:self 
						selector:@selector(SoundButtonTapped:) items:SoundOnItem, SoundOffItem, nil];
        SoundToggleItem.position = ccp(screenSize.width * .75, screenSize.height * .30);
        
        // Set the state of toggle based on current sound state
        BOOL sound =  [GameManager sharedGameManager].isSoundEffectsON;
        if (sound) {
            [SoundToggleItem setSelectedIndex:0];
        }else {
            [SoundToggleItem setSelectedIndex:1];
        }
        
        
        // Exit menu, return to scene
        CCMenuItem *QuitMenuItem = [CCMenuItemImage itemFromNormalImage:@"exit.png" selectedImage:@"exitclick.png" target:self selector:@selector(QuitButtonTapped:)];
        QuitMenuItem.position = ccp(screenSize.width * .75, screenSize.height * .10);
        
        // Overall pause menu items
		_pauseScreenMenu = [CCMenu menuWithItems:GoalsMenuItem,MainMenuItem,MusicToggleItem, SoundToggleItem, QuitMenuItem, nil];
		_pauseScreenMenu.position = ccp(0,0);
        [pauseLayer addChild:_pauseScreenMenu];
		_pauseScreenUp=TRUE;
	}
}

-(void)eraseMessage:(id)sender{
    [self removeChild:gameBeginLabel cleanup:YES];
}

-(void)openMessage {
    
    CGSize screenSize = [[CCDirector sharedDirector] winSize];
    
    gameBeginLabel =
    [CCLabelTTF labelWithString:@"Press Button" fontName:@"Verdana-Bold" fontSize:35];
    [gameBeginLabel setColor:ccc3(255, 160, 255)];
    [gameBeginLabel setPosition:ccp(screenSize.width/2, screenSize.height * .80)];
    [self addChild:gameBeginLabel z:20];
    [self performSelector:@selector(eraseMessage:) withObject:nil afterDelay:5.0];
}

-(void)initLabels {

    CGSize screenSize = [[CCDirector sharedDirector] winSize];
    
    scoreSprite = [CCSprite spriteWithSpriteFrameName:@"ScoreLabel.png"];
    [self addChild:scoreSprite];
    [scoreSprite setPosition:ccp(screenSize.width * 0.182f, screenSize.height * 0.895f)];
    goalSprite = [CCSprite spriteWithSpriteFrameName:@"GoalMenu.png"];
    [self addChild:goalSprite];
    [goalSprite setPosition:ccp(screenSize.width * 0.323f, screenSize.height * 0.895f)];
    zerostrikeSprite = [CCSprite spriteWithSpriteFrameName:@"ZeroStrikeMenu.png"];
    [self addChild:zerostrikeSprite];
    [zerostrikeSprite setPosition:ccp(screenSize.width * 0.90f, screenSize.height * 0.96f)];
    onestrikeSprite = [CCSprite spriteWithSpriteFrameName:@"OneStrikeMenu.png"];
    [self addChild:onestrikeSprite];
    [onestrikeSprite setPosition:ccp(screenSize.width * 0.90f, screenSize.height * 0.96f)];
    twostrikeSprite = [CCSprite spriteWithSpriteFrameName:@"TwoStrikeMenu.png"];
    [self addChild:twostrikeSprite];
    [twostrikeSprite setPosition:ccp(screenSize.width * 0.90f, screenSize.height * 0.96f)];
    
    // Labels
    // Score
    self.scoreLabel = [CCLabelTTF labelWithString:@"0" fontName:@"Helvetica-Bold" fontSize:27];
    [self.scoreLabel setColor:ccc3(0,0,255)];
    [self.scoreLabel setPosition:ccp(screenSize.width *0.182, screenSize.height * .9f)];
    [self addChild:self.scoreLabel];

    // Labels for Goal
    goalsLabel =  
    [CCLabelTTF labelWithString:@"Test Goal" fontName:@"Helvetica-Bold" fontSize:19];
    [goalsLabel setColor:ccc3(0, 0, 255)];
    [goalsLabel setPosition:ccp(screenSize.width * .323, screenSize.height * .895)];
    [self addChild:goalsLabel];
    
    // Label for Round
    NSString *roundString = [NSString stringWithFormat:@"Round %i",currentRound]; 
    roundLabel = [CCLabelBMFont labelWithString:roundString fntFile:@"green23.fnt"];
    [roundLabel setPosition:ccp(screenSize.width * .89, screenSize.height * .87)];
    [self addChild:roundLabel];    
}

-(id) init
{
		if( (self=[super init])) {
        
        [self initBall];
        [self createSpace];
        [self createGround];
        [self createBoard];
        [self createScoreSensor];
        [self createMissSensor];
        [self createNetSensor];
        [self pauseMenu];
        [self initLabels];
        [self initializeRounds];
        [self updateRound];
        [self scheduleUpdate]; 
        
        mouse = cpMouseNew(space);
        self.isTouchEnabled = YES;
		
        // Callback for Ball and score sensor
        cpSpaceAddCollisionHandler(space, 0, 10, scored, NULL, NULL, NULL, NULL);
        
        // Callback for Ball and miss
        cpSpaceAddCollisionHandler(space, 0, 11, miss, NULL, NULL, NULL, NULL);
        
        // Callback for Ball and net
        // 0 is the type for Ball shape, while 12 is the type for net shape (sensor)
        // net is the callback handler method when the two shapes collides
        // self is the data you are passing ie Gameplaylayer
        cpSpaceAddCollisionHandler(space, 0, 12, net, NULL, NULL, NULL, self);
        
        // Callback for Ball and bottom ground, used to destroy the ball
        cpSpaceAddCollisionHandler(space, 0, 1, ground, NULL, NULL, NULL, self);
        
        //Audio callbacks for leftRim, rightRim, and Board
        cpSpaceAddCollisionHandler(space, 0, 3, leftRim, NULL, NULL, NULL, self);
        cpSpaceAddCollisionHandler(space, 0, 4, rightRim, NULL, NULL, NULL, self);
        cpSpaceAddCollisionHandler(space, 0, 5,backBoard,NULL, NULL, NULL, self);
        
        // Load audio
        [[GameManager sharedGameManager] preloadSoundEffects];
    }
    return self;
}

- (void)update:(ccTime)dt {
    
    if (pausingMenu) {
        return;
    }
    
    static double UPDATE_INTERVAL = 1.0f/60.0f;
    static double MAX_CYCLES_PER_FRAME = 5;
    static double timeAccumulator = 0;
    timeAccumulator += dt;
    if (timeAccumulator > (MAX_CYCLES_PER_FRAME * UPDATE_INTERVAL)) {
        timeAccumulator = UPDATE_INTERVAL;
    }
    while (timeAccumulator >= UPDATE_INTERVAL) {
        timeAccumulator -= UPDATE_INTERVAL;
        cpSpaceStep(space, UPDATE_INTERVAL);
    }
    // Tells the children of the spritesheet (children is
    // Balls) to update, ie align their sprite with the ball body
    for (CPSprite *sprite in spriteSheet.children) {
        [sprite update];
    }
    
    /* ballBody hasn't been created at init 
     so the program stops
     */
    BOOL code = FALSE;
    if (code == TRUE) {
        //  if (ballBody)
        // Bug - ball still flies off screen
        // 454 Prevent Ball from going off screen
        
        CGSize winSize = [CCDirector sharedDirector].winSize;
        
        // Make the margin size 10
        float margin = winSize.width * .02f;
        
        // x axis
        // Left side
        if (ballBody->p.x < margin) {
            cpBodySetPos(ballBody, ccp(margin, ballBody->p.y));
        }
        // Right side
        if (ballBody->p.x > winSize.width - margin) {
            cpBodySetPos(ballBody, ccp(winSize.width - margin, ballBody->p.y));
        }
        
        // y axis
        // bottom
        if (ballBody->p.y < margin ) {
            cpBodySetPos(ballBody, ccp(ballBody->p.x, margin));
        }
        // Top
        if (ballBody->p.y > winSize.height - margin + 50) {
            //   cpBodySetPos(ballBody, ccp(ballBody->p.x,winSize.height - margin));
        }   
    }
}

@end













