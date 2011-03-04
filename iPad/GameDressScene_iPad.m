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
			
			CCSprite * back = [CCSprite spriteWithFile:@"wheel_background_iPad.png"];
			[back setPosition:ccp(512,384)];
			[self addChild:back];
			
		bashoSelectedSound = 0;
		ddElements = [[NSMutableArray alloc] initWithCapacity:4];
		
		[[ CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"dress_iPad.plist" textureFile:@"dress_iPad.png"];
		
		CCSpriteBatchNode * sbn = [CCSpriteBatchNode batchNodeWithFile:@"dress_iPad.png"];
		[self addChild:sbn z:1 tag:kSPRITEBATCH_ELEMS];
		
		//[self loadScatteredElements];
		
	/*	CCSprite * hat = [CCSprite spriteWithSpriteFrameName:@"BlueHatOn_iPad.png"];
		[sbn addChild:hat];
		[hat setPosition:ccp(512,384)];
		
		CCSprite * backpack = [CCSprite spriteWithSpriteFrameName:@"BlueBackpackStrapOn_iPad.png"];
		[sbn addChild:backpack];
		[backpack setPosition:ccp(512,384)];
		
		CCSprite * boots = [CCSprite spriteWithSpriteFrameName:@"BlueBootsOn_iPad.png"];
		[sbn addChild:boots];
		[boots setPosition:ccp(512,384)];
		
		CCSprite * glasses = [CCSprite spriteWithSpriteFrameName:@"BlueGlassesOn_iPad.png"];
		[sbn addChild:glasses];
		[glasses setPosition:ccp(512,384)];
		
		CCSprite * jacket = [CCSprite spriteWithSpriteFrameName:@"BlueJacketOn_iPad.png"];
		[sbn addChild:jacket];
		[jacket setPosition:ccp(512,384)];
		
		CCSprite * necklace = [CCSprite spriteWithSpriteFrameName:@"BlueNecklaceOn_iPad.png"];
		[sbn addChild:necklace];
		[necklace setPosition:ccp(512,384)];
		
		CCSprite * pants = [CCSprite spriteWithSpriteFrameName:@"BluePantsOn_iPad.png"];
		[sbn addChild:pants];
		[pants setPosition:ccp(512,384)];
		
		CCSprite * phone = [CCSprite spriteWithSpriteFrameName:@"BluePhoneRightHandOn_iPad.png"];
		[sbn addChild:phone];
		[phone setPosition:ccp(512,384)];
		*/
		
			CCMenuItemImage * backBtn = [CCMenuItemImage itemFromNormalImage:@"wheel_home_iPad.png" selectedImage:@"wheel_home_iPad.png" target:self selector:@selector(goBack)];
			
			/*CCMenuItemImage * soundOff = [CCMenuItemImage itemFromNormalImage:@"wheel_sound_off_iPad.png" selectedImage:@"wheel_sound_on_iPad.png"];
			CCMenuItemImage * soundOn = [CCMenuItemImage itemFromNormalImage:@"wheel_sound_on_iPad.png" selectedImage:@"wheel_sound_off_iPad.png"];
			CCMenuItemToggle * sound = [CCMenuItemToggle itemWithTarget:self selector:@selector(turnSounds) items:soundOn,soundOff,nil];
			
			CCMenuItemImage * bashoOff = [CCMenuItemImage itemFromNormalImage:@"wheel_basho_off_iPad.png" selectedImage:@"wheel_basho_on_iPad.png"];
			CCMenuItemImage * bashoOn = [CCMenuItemImage itemFromNormalImage:@"wheel_basho_on_iPad.png" selectedImage:@"wheel_basho_off_iPad.png"];
			CCMenuItemToggle * basho = [CCMenuItemToggle itemWithTarget:self selector:@selector(turnBasho) items:bashoOff,bashoOn,nil];
			*/
			
			CCMenu * menu = [CCMenu menuWithItems:backBtn/*,sound,basho*/,nil];
			[self addChild:menu];
			[backBtn setPosition:ccp(64,696)];
			//[sound setPosition:ccp(43,48)];
			//[basho setPosition:ccp(149,72)];
			[menu setPosition:ccp(0,0)];
			
		[self selectItemForBasho];
			
		}
		return self;
		
}

-(void)selectItemForBasho
{
	
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
	[btnImgs addObject:BTN_BACKPACK];
	[btnImgs addObject:BTN_BOOTS];
	[btnImgs addObject:BTN_HAT];
	[btnImgs addObject:BTN_PHONE];
	[btnImgs addObject:BTN_JACKET];
	[btnImgs addObject:BTN_NECKLACE];
	[btnImgs addObject:BTN_PANTS];
	[btnImgs addObject:BTN_SUNGLASSES];
	
	
	NSString *filePath = [[NSBundle mainBundle] pathForResource:@"DressData_iPad" ofType:@"plist"];
	
	NSMutableDictionary * elementsFile = [NSMutableDictionary dictionaryWithContentsOfFile:filePath];
	NSMutableDictionary * elements = [elementsFile objectForKey:[btnImgs objectAtIndex:item]];
	
	NSMutableArray * positions = [NSMutableArray array];
	
	NSMutableDictionary * p1 = [NSMutableDictionary dictionaryWithObjects:[NSMutableArray arrayWithObjects:[NSNumber numberWithInt:200],[NSNumber numberWithInt:150],nil] forKeys:[NSMutableArray arrayWithObjects:@"x",@"y",nil]];
	NSMutableDictionary * p2 = [NSMutableDictionary dictionaryWithObjects:[NSMutableArray arrayWithObjects:[NSNumber numberWithInt:200],[NSNumber numberWithInt:600],nil] forKeys:[NSMutableArray arrayWithObjects:@"x",@"y",nil]];
	NSMutableDictionary * p3 = [NSMutableDictionary dictionaryWithObjects:[NSMutableArray arrayWithObjects:[NSNumber numberWithInt:800],[NSNumber numberWithInt:150],nil] forKeys:[NSMutableArray arrayWithObjects:@"x",@"y",nil]];
	NSMutableDictionary * p4 = [NSMutableDictionary dictionaryWithObjects:[NSMutableArray arrayWithObjects:[NSNumber numberWithInt:800],[NSNumber numberWithInt:600],nil] forKeys:[NSMutableArray arrayWithObjects:@"x",@"y",nil]];
	
	[positions addObject:p1];
	[positions addObject:p2];
	[positions addObject:p3];
	[positions addObject:p4];
	
	for(int i =0;i<4;i++)
	{
		NSMutableDictionary * elem = [elements objectAtIndex:i];
		
		NSMutableDictionary * po = [positions objectAtIndex:i];
		
		[elem setObject:po forKey:@"coord-initial"];
		
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
	[ddElements release];
	[super dealloc];
}

@end
