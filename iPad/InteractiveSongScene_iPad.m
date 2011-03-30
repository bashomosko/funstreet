//
//  InteractiveSongScene_iPad.m
//  Basho
//
//  Created by Pablo Ruiz on 28/03/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "InteractiveSongScene_iPad.h"
#import "InteractiveElement.h"
#import "SimpleAudioEngine.h"

#define kSCORE 1

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
		
		[[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"botas-2011.mp3" loop:NO];
		
		CCSprite * back = [CCSprite spriteWithFile:@"song_background_iPad.png"];
		[back setPosition:ccp(512,384)];
		[self addChild:back];
		
		CCSprite * basho = [CCSprite spriteWithFile:@"song_basho_iPad.png"];
		[basho setPosition:ccp(512,384)];
		[self addChild:basho];
		
		CCMenuItemImage * backBtn = [CCMenuItemImage itemFromNormalImage:@"wheel_home_iPad.png" selectedImage:@"wheel_home_iPad.png" target:self selector:@selector(goBack)];
		
		CCMenu * menu = [CCMenu menuWithItems:backBtn,nil];
		[self addChild:menu];
		[backBtn setPosition:ccp(64,696)];
		[menu setPosition:ccp(0,0)];
		
		iElements = [[NSMutableArray alloc] init];
		
		NSString *filePath = [[NSBundle mainBundle] pathForResource:@"songItems_iPad" ofType:@"plist"];
		
		NSMutableArray * elementsFile = [NSMutableArray arrayWithContentsOfFile:filePath];
		
		for(int i = 0; i<4;i++)
		{
			NSMutableDictionary * elem = [elementsFile objectAtIndex:i];
			InteractiveElement * iElement = [[InteractiveElement alloc] initWithTheGame:self elementDict:elem];
			[iElements addObject:iElement];
			[iElement release];
		}
		
		currentElem = 0;
		
		InteractiveElement * iel = [iElements objectAtIndex:currentElem];
		[iel runAction:[CCSequence actions:[CCDelayTime actionWithDuration:0],[CCCallFunc actionWithTarget:iel selector:@selector(callMeIn)],nil]];
		
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
	//[scoreLbl setOpacity:0];
}

-(void)addPoints:(int)p
{
	points += p;
	CCLabelTTF * scoreLbl = [self getChildByTag:kSCORE];
	[scoreLbl setString:[NSString stringWithFormat:@"%d",points]];
}

-(void)callNextElement
{
	if(currentElem < [iElements count]-1)
	{
		currentElem ++;
	
		InteractiveElement * iel = [iElements objectAtIndex:currentElem];
		[iel callMeIn];
	}
}

-(void)goBack
{
	
	[[SimpleAudioEngine sharedEngine] stopBackgroundMusic];
	[viewController goToMenu];
}

-(void)dealloc
{
	[iElements release];
	[super dealloc];
}

@end
