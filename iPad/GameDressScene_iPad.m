//
//  GameDressScene_iPad.m
//  Basho
//
//  Created by Pablo Ruiz on 04/03/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GameDressScene_iPad.h"
#import "DDElement.h"
#import "GameManager.h"
#import "SimpleAudioEngine.h"

@implementation GameDressScene_iPad

@synthesize placingElement;

+(id) sceneWithDressVC:(GameDress_iPad *)vc
{
    CCScene *scene = [CCScene node];
    GameDressScene_iPad *layer = [GameDressScene_iPad nodeWithDressVC:vc];
    [scene addChild: layer];
    return scene;
}

+(id) nodeWithDressVC:(GameDress_iPad *)vc
{
	return [[[self alloc] initWithDressVC:vc] autorelease];
}

-(id) initWithDressVC:(GameDress_iPad *)vc
{
	if( (self=[super init] )) {
		self.isTouchEnabled = YES;
			
			//[self loadDeviceType];
			
			self.isTouchEnabled = YES;
			viewController = vc;
			
			CCSprite * back = [CCSprite spriteWithFile:@"dress_background_iPad.png"];
			[back setPosition:ccp(512,384)];
			[self addChild:back];
			
		bashoSelectedSound = 0;
		ddElements = [[NSMutableArray alloc] initWithCapacity:4];
		dressPieces= [[NSMutableArray alloc] initWithCapacity:8];
		
		[[ CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"dress_iPad.plist" textureFile:@"dress_iPad.png"];
		
		CCSpriteBatchNode * sbn = [CCSpriteBatchNode batchNodeWithFile:@"dress_iPad.png"];
		[self addChild:sbn z:1 tag:kSPRITEBATCH_ELEMS];
		
		//[self loadScatteredElements];
		
		CCSprite * dino = [CCSprite spriteWithSpriteFrameName:@"dress_dino_iPad.png"];
		[sbn addChild:dino];
		[dino setPosition:ccp(512,384)];
		
		CCSprite * boxers = [CCSprite spriteWithSpriteFrameName:@"dress_boxers_iPad.png"];
		[sbn addChild:boxers z:0 tag:kBOXERS];
		[boxers setPosition:ccp(512,384)];
		
		CCSprite * shirt = [CCSprite spriteWithSpriteFrameName:@"dress_shirt_iPad.png"];
		[sbn addChild:shirt];
		[shirt setPosition:ccp(512,384)];
		
			CCMenuItemImage * backBtn = [CCMenuItemImage itemFromNormalImage:@"wheel_home_iPad.png" selectedImage:@"wheel_home_iPad.png" target:self selector:@selector(goBack)];
			
			CCMenuItemImage * soundOff = [CCMenuItemImage itemFromNormalImage:@"wheel_sound_off_iPad.png" selectedImage:@"wheel_sound_on_iPad.png"];
			CCMenuItemImage * soundOn = [CCMenuItemImage itemFromNormalImage:@"wheel_sound_on_iPad.png" selectedImage:@"wheel_sound_off_iPad.png"];
			CCMenuItemToggle * sound = [CCMenuItemToggle itemWithTarget:self selector:@selector(turnSounds) items:soundOn,soundOff,nil];
			
			CCMenuItemImage * bashoOff = [CCMenuItemImage itemFromNormalImage:@"wheel_basho_off_iPad.png" selectedImage:@"wheel_basho_on_iPad.png"];
			CCMenuItemImage * bashoOn = [CCMenuItemImage itemFromNormalImage:@"wheel_basho_on_iPad.png" selectedImage:@"wheel_basho_off_iPad.png"];
			CCMenuItemToggle * basho = [CCMenuItemToggle itemWithTarget:self selector:@selector(turnBasho) items:bashoOff,bashoOn,nil];
			
			
			CCMenu * menu = [CCMenu menuWithItems:backBtn,sound,basho,nil];
			[self addChild:menu];
			[backBtn setPosition:ccp(64,696)];
			[sound setPosition:ccp(43,48)];
			[basho setPosition:ccp(149,72)];
			[menu setPosition:ccp(0,0)];
			
		[self selectItemForBasho];
			
		[self loadScore];
		
		}
		return self;
		
}

-(void)loadScore
{
	CCSprite * back = [CCSprite spriteWithFile:@"wheel_pointsField_iPad.png"];
	[back setPosition:ccp(959,703)];
	[self addChild:back];
	
	CCLabelTTF * scoreLbl = [CCLabelTTF labelWithString:@"0" fontName:@"Verdana" fontSize:60];
	[scoreLbl setColor:ccBLACK];
	[self addChild:scoreLbl z:1 tag:kSCORE];
	[scoreLbl setPosition:ccp(959,703)];
	[scoreLbl setOpacity:0];
}

-(void)turnSounds
{
	GameManager * gm = [GameManager sharedGameManager];
	[gm turnSounds];
}

-(void)turnBasho
{
	bashoDirected = !bashoDirected;
	
	[self makeScoreAppear:bashoDirected];
	
}

-(void)makeScoreAppear:(BOOL)appear
{
	CCLabelTTF * scoreLbl = [self getChildByTag:kSCORE];
	if(appear)
		[scoreLbl setOpacity:255];
	else
		[scoreLbl setOpacity:0];
	
}


-(void)selectItemForBasho
{
	placingElement = NO;
	if(bashoSelectedSound >=8)
	{
		bashoSelectedSound = 0;
		
		//RESET DINO
		CCSprite * gloopbackground = [CCSprite spriteWithFile:@"3DStars_iPad_00000.pvr"];
		[gloopbackground setPosition:ccp(512,384)];
		[self addChild:gloopbackground];
		//ANIMATION
		NSMutableArray * gloopFrames = [[[NSMutableArray  alloc]init]autorelease];
		for(int i = 0; i <= 15; i++) {
			
			CCSprite * sp = [CCSprite spriteWithFile:[NSString stringWithFormat:@"3DStars_iPad_%05d.pvr",i]];
			CCSpriteFrame *frame = [CCSpriteFrame frameWithTexture:sp.texture rect:sp.textureRect];
			[gloopFrames addObject:frame];
		}
		
		CCAnimation * gloopAnimation = [CCAnimation animationWithFrames:gloopFrames delay:0.1f];
		[gloopbackground runAction:[CCRepeatForever actionWithAction: [CCAnimate actionWithAnimation:gloopAnimation restoreOriginalFrame:NO] ]];
		
		
		//[self schedule:@selector(resetDino) interval:3];
		return;
	}
	
	NSString * sound = nil;
	switch (bashoSelectedSound)
	{
		case BTN_BACKPACK_NUM:
			sound =BTN_BACKPACK_SND_WHERE;
			break;
		case BTN_BOOTS_NUM:
			sound =BTN_BOOTS_SND_WHERE;
			break;
		case BTN_HAT_NUM:
			sound =BTN_HAT_SND_WHERE;
			break;
		case BTN_PHONE_NUM:
			sound =BTN_PHONE_SND_WHERE;
			break;
		case BTN_JACKET_NUM:
			sound =BTN_JACKET_SND_WHERE;
			break;
		case BTN_NECKLACE_NUM:
			sound =BTN_NECKLACE_SND_WHERE;
			break;
		case BTN_PANTS_NUM:
			sound =BTN_PANTS_SND_WHERE;
			break;
		case BTN_SUNGLASSES_NUM:
			sound =BTN_SUNGLASSES_SND_WHERE;
			break;
	}
	if([GameManager sharedGameManager].soundsEnabled)
		[[SimpleAudioEngine sharedEngine] playEffect:sound];
	
	[self loadScatteredElementsForItem:bashoSelectedSound];
	
	bashoSelectedSound ++;
	
}

-(void)resetDino
{
	[self unschedule:@selector(resetDino)];
	
	CCSpriteBatchNode * sbn = [self getChildByTag:kSPRITEBATCH_ELEMS];
	for(CCSprite * el in dressPieces)
	{
		[sbn removeChild:el cleanup:YES];
	}
	[dressPieces removeAllObjects];
	
	[self selectItemForBasho ];
	
}
-(void)dressDino:(GameDressScene_iPad *)scene data:(void *)data
{	
	DDElement * item = (DDElement *)data;
	CCSpriteBatchNode * sbn = [self getChildByTag:kSPRITEBATCH_ELEMS];
	
	if(item.itemTag == BTN_PANTS_NUM)
	{
		CCSprite * boxers = [sbn getChildByTag:kBOXERS];
		[sbn removeChild:boxers cleanup:YES];
	}

	item.mySprite.opacity = 0;
	
	CCSprite * backpack = [CCSprite spriteWithSpriteFrameName:item.dressed];
	[sbn addChild:backpack z:item.desiredZ];
	[backpack setPosition:ccp(512,384)];
	
	[dressPieces addObject:backpack];
}

-(void)loadScatteredElementsForItem:(int)item
{
	CCSpriteBatchNode * sbn = [self getChildByTag:kSPRITEBATCH_ELEMS];
	for(DDElement * el in ddElements)
	{
		[sbn removeChild:el.mySprite cleanup:YES];
		[self removeChild:el cleanup:YES];
	}
	[ddElements removeAllObjects];
	
	
	NSMutableArray * btnImgs = [NSMutableArray arrayWithCapacity:8];
	[btnImgs addObject:BTN_PANTS];
	[btnImgs addObject:BTN_BOOTS];
	[btnImgs addObject:BTN_NECKLACE];
	[btnImgs addObject:BTN_JACKET];
	[btnImgs addObject:BTN_SUNGLASSES];
	[btnImgs addObject:BTN_HAT];
	[btnImgs addObject:BTN_PHONE];
	[btnImgs addObject:BTN_BACKPACK];
	
	NSString *filePath = [[NSBundle mainBundle] pathForResource:@"DressData_iPad" ofType:@"plist"];
	
	NSMutableDictionary * elementsFile = [NSMutableDictionary dictionaryWithContentsOfFile:filePath];
	NSMutableDictionary * elements = [elementsFile objectForKey:[btnImgs objectAtIndex:item]];
	
	NSMutableArray * positions = [NSMutableArray array];
	
	NSMutableDictionary * p1 = [NSMutableDictionary dictionaryWithObjects:[NSMutableArray arrayWithObjects:[NSNumber numberWithInt:180],[NSNumber numberWithInt:180],nil] forKeys:[NSMutableArray arrayWithObjects:@"x",@"y",nil]];
	NSMutableDictionary * p2 = [NSMutableDictionary dictionaryWithObjects:[NSMutableArray arrayWithObjects:[NSNumber numberWithInt:180],[NSNumber numberWithInt:580],nil] forKeys:[NSMutableArray arrayWithObjects:@"x",@"y",nil]];
	NSMutableDictionary * p3 = [NSMutableDictionary dictionaryWithObjects:[NSMutableArray arrayWithObjects:[NSNumber numberWithInt:820],[NSNumber numberWithInt:180],nil] forKeys:[NSMutableArray arrayWithObjects:@"x",@"y",nil]];
	NSMutableDictionary * p4 = [NSMutableDictionary dictionaryWithObjects:[NSMutableArray arrayWithObjects:[NSNumber numberWithInt:820],[NSNumber numberWithInt:580],nil] forKeys:[NSMutableArray arrayWithObjects:@"x",@"y",nil]];
	
	[positions addObject:p1];
	[positions addObject:p2];
	[positions addObject:p3];
	[positions addObject:p4];
	
	for(int i =0;i<4;i++)
	{
		
		NSMutableDictionary * elem = [elements objectAtIndex:i];
		
		NSMutableDictionary * po = [positions objectAtIndex:i];
		
		[elem setObject:po forKey:@"coord-initial"];
		[elem setObject:[NSNumber numberWithInt:item] forKey:@"itemTag"];
		
		switch (item) {
			case BTN_BOOTS_NUM:
				[elem setObject:[NSNumber numberWithInt:2] forKey:@"desiredZ"];
				break;
			default:
				[elem setObject:[NSNumber numberWithInt:3] forKey:@"desiredZ"];
				break;
		}
		
		DDElement * ddElement = [[DDElement alloc] initWithTheGame:self elementDict:elem];
		[ddElements addObject:ddElement];
		[ddElement release];
	}

}

-(void)goBack
{
	[viewController goToMenu];
}

-(void)dealloc
{
	[dressPieces release];
	[ddElements release];
	[super dealloc];
}

@end
