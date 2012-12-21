//
//  HelloWorldLayer.h
//  Hoops
//
//  Created by Mike Chen on 1/5/12.
//  Copyright __MyCompanyName__ 2012. All rights reserved.
//


#import "cocos2d.h"
#import "chipmunk.h"
// HelloWorldLayer
@interface HelloWorldLayer : CCLayerColor
{
	cpSpace *space;
}
// returns a CCScene that contains the HelloWorldLayer as the only child
+(CCScene *) scene;
-(void) step: (ccTime) dt;
-(void) addNewSpriteX:(float)x y:(float)y;

@end
