//
//  GameDressSceneSnapshot_iPad.m
//  Basho
//
//  Created by Pablo Ruiz on 19/05/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GameDressSceneSnapshot_iPad.h"
#import "GameManager.h"
#import "SimpleAudioEngine.h"


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
		
		CCSprite* background = [CCSprite spriteWithFile:@"snapshot_background_iPad.png"];
		[self addChild:background];
		[background setPosition:ccp(512,384)];
		
		[self addDinoOnPosition:ccp(252,544) dinoImage:img num:1];
		[self addDinoOnPosition:ccp(302,224) dinoImage:img num:2];
		[self addDinoOnPosition:ccp(752,384) dinoImage:img num:3];
		
		
	}
	return self;
	
}

-(void)addDinoOnPosition:(CGPoint)pos dinoImage:(UIImage *)img num:(int)num
{
	CCSprite * photo = [CCSprite spriteWithFile:[NSString stringWithFormat:@"snapshot_polaroid%d_iPad.png",num]];
	[self addChild:photo];
	[photo setPosition:pos];
	
	CCSprite * dino1 = [CCSprite spriteWithCGImage:[img CGImage]];
	[photo addChild:dino1];
	[dino1 setPosition:ccp([photo boundingBox].size.width/2,[photo boundingBox].size.height/2 +10)];
	[dino1 setScale:0.3];
	
	if(num==1)
		[dino1 setRotation:-10];
	else if(num==2)
		[dino1 setRotation:20];
	else if(num==3)
		[dino1 setRotation:5];
	
	[photo setScale:2];
	[photo setVisible:NO];
	[photo runAction:[CCSequence actions:[CCDelayTime actionWithDuration:(num-(0.5*num))],[CCToggleVisibility action],[CCCallFunc actionWithTarget:self selector:@selector(playSnd)],[CCScaleTo actionWithDuration:0.3 scale:1],nil]];
}

-(void)playSnd
{
	if([GameManager sharedGameManager].soundsEnabled)
		[[SimpleAudioEngine sharedEngine] playEffect:@"Camera_SFX.mp3"];
}

-(void)dealloc
{
	[[SimpleAudioEngine sharedEngine] unloadEffect:@"Camera_SFX.mp3"];
	[super dealloc];
}

@end
