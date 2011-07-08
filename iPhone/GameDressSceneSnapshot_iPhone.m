//
//  GameDressSceneSnapshot_iPhone.m
//  Basho
//
//  Created by Pablo Ruiz on 19/05/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GameDressSceneSnapshot_iPhone.h"
#import "GameManager.h"
#import "SimpleAudioEngine.h"
#import "GameDressScene_iPhone.h"


@implementation GameDressSceneSnapshot_iPhone


+(id) sceneWithDressVC:(GameDress_iPhone *)vc dinoImage:(UIImage *)img bashoDirected:(BOOL)_bashoDirected
{
    CCScene *scene = [CCScene node];
    GameDressSceneSnapshot_iPhone *layer = [GameDressSceneSnapshot_iPhone nodeWithDressVC:vc dinoImage:img bashoDirected:_bashoDirected];
    [scene addChild: layer];
    return scene;
}

+(id) nodeWithDressVC:(GameDress_iPhone *)vc dinoImage:(UIImage *)img bashoDirected:(BOOL)_bashoDirected
{
	return [[[self alloc] initWithDressVC:vc dinoImage:img bashoDirected:_bashoDirected] autorelease];
}

-(id) initWithDressVC:(GameDress_iPhone *)vc dinoImage:(UIImage *)img bashoDirected:(BOOL)_bashoDirected
{
	if( (self=[super init] )) {
		self.isTouchEnabled = YES;
		self.isAccelerometerEnabled = YES;
        
        bashoDirected = _bashoDirected;
		
        if ([GameManager sharedGameManager].musicAudioEnabled) {
            [[SimpleAudioEngine sharedEngine] resumeBackgroundMusic];
        }
		
		viewController = vc;
		
		moveOutActivated = NO;
		        
        [CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_RGBA8888];

		CCSprite* background = [CCSprite spriteWithFile:@"snapshot_background_iPhone.png"];
		[self addChild:background];
		[background setPosition:ccp(240,160)];
        
        [CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_RGBA4444];
		
		[self addDinoOnPosition:ccp(126,240) dinoImage:img num:1];
		[self addDinoOnPosition:ccp(151,100) dinoImage:img num:2];
		[self addDinoOnPosition:ccp(350,160) dinoImage:img num:3];
		
		[self runAction:[CCSequence actions:[CCDelayTime actionWithDuration:3],[CCCallFunc actionWithTarget:self selector:@selector(tapToCont)],nil]];
		
	}
	return self;
	
}

-(void)tapToCont
{
	moveOutActivated = YES;
	CCLabelTTF * palabra = [CCLabelBMFont labelWithString:@"Tap to return to the game" fntFile:@"Wheel_text_iPad.fnt"];
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)] == YES && [[UIScreen mainScreen] scale] == 2.00) {
        [palabra setScale:0.70];
    }
    else {
        [palabra setScale:0.25];
    }
    [self addChild:palabra];
	[palabra setPosition:ccp(240,10)];
	[palabra setScale:0.3];
	[palabra runAction:[CCRepeatForever actionWithAction:[CCSequence actions:[CCFadeIn actionWithDuration:0.5],[CCDelayTime actionWithDuration:1],[CCFadeOut actionWithDuration:0.5],nil]]];
}


-(void)moveOut
{
	moveOutActivated = NO;
	[[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.5 scene: [GameDressScene_iPhone sceneWithDressVC:viewController bashoDirected:bashoDirected playVid:NO playingAgain:YES] withColor:ccWHITE]];

}

-(void)addDinoOnPosition:(CGPoint)pos dinoImage:(UIImage *)img num:(int)num
{
	CCSprite * photo = [CCSprite spriteWithFile:[NSString stringWithFormat:@"snapshot_polaroid%d_iPhone.png",num]];
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


-(void)dealloc
{
	[[SimpleAudioEngine sharedEngine] unloadEffect:@"Camera_SFX.mp3"];
	[super dealloc];
}

@end
