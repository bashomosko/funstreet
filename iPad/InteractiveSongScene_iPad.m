//
//  InteractiveSongScene_iPad.m
//  Basho
//
//  Created by Pablo Ruiz on 28/03/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "InteractiveSongScene_iPad.h"


@implementation InteractiveSongScene_iPad

+(id) sceneWithSongVC:(InteractiveSong_iPad *)vc
{
    CCScene *scene = [CCScene node];
    InteractiveSongScene_iPad *layer = [InteractiveSongScene_iPad nodeWithSongVC:vc ];
    [scene addChild: layer];
    return scene;
}

+(id) nodeWithSongVC:(InteractiveSong_iPad *)vc 
{
	return [[[self alloc] initWithSongVC:vc ] autorelease];
}

-(id) initWithSongVC:(InteractiveSong_iPad *)vc
{
	if( (self=[super init] )) {
		self.isTouchEnabled = YES;
		//self.isAccelerometerEnabled = YES;
		viewController = vc;
		
		CCSprite * back = [CCSprite spriteWithFile:@"song_background_iPad.png"];
		[back setPosition:ccp(512,384)];
		[self addChild:back];
		
		CCMenuItemImage * backBtn = [CCMenuItemImage itemFromNormalImage:@"wheel_home_iPad.png" selectedImage:@"wheel_home_iPad.png" target:self selector:@selector(goBack)];
		
		CCMenu * menu = [CCMenu menuWithItems:backBtn,nil];
		[self addChild:menu];
		[backBtn setPosition:ccp(64,696)];
		[menu setPosition:ccp(0,0)];
		
	}
	return self;
	
}

-(void)goBack
{
	[viewController goToMenu];
}

@end
