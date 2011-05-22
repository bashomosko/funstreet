//
//  GameDressSceneSnapshot_iPad.m
//  Basho
//
//  Created by Pablo Ruiz on 19/05/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GameDressSceneSnapshot_iPad.h"


@implementation GameDressSceneSnapshot_iPad


+(id) sceneWithDressVC:(GameDress_iPad *)vc dinoImage:(UIImage *)img
{
    CCScene *scene = [CCScene node];
    GameDressSceneSnapshot_iPad *layer = [GameDressSceneSnapshot_iPad nodeWithDressVC:vc dinoImage:img];
    [scene addChild: layer];
    return scene;
}

+(id) nodeWithDressVC:(GameDress_iPad *)vc dinoImage:(UIImage *)img
{
	return [[[self alloc] initWithDressVC:vc dinoImage:img] autorelease];
}

-(id) initWithDressVC:(GameDress_iPad *)vc dinoImage:(UIImage *)img
{
	if( (self=[super init] )) {
		self.isTouchEnabled = YES;
		self.isAccelerometerEnabled = YES;

		viewController = vc;
		
		UIImageView * imgView = [[UIImageView alloc] initWithImage:img];
		[[[CCDirector sharedDirector] openGLView] addSubview:imgView];
		
	}
	return self;
	
}
@end
