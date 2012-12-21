//
//  OptionsScene.m
//  Hoops
//
//  Created by Mike Chen on 4/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "OptionsScene.h"
@implementation OptionsScene
-(id)init {
	self = [super init];
	if (self != nil) {
		OptionsLayer *myLayer = [OptionsLayer node];
		[self addChild:myLayer];
	}
	return self;
}
@end
