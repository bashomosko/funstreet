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
		
		//[self beginGame];
		[self loadVideo];
		//[self addFinishMenu];
	}
	return self;
	
}

-(void)loadVideo
{
	NSURL * url;
	NSBundle *bundle = [NSBundle mainBundle];
	if (bundle) 
	{
		NSString *moviePath = [bundle pathForResource:@"intro_1_iPad" ofType:@"mov"];
		if (moviePath)
		{
			url = [NSURL fileURLWithPath:moviePath];
		}
	}
	
	introVideo = [[MPMoviePlayerController alloc] initWithContentURL:url];
	[[[CCDirector sharedDirector] openGLView] addSubview:introVideo.view];
	[introVideo.view setFrame:CGRectMake(0,0,1024,768)];
	[introVideo setControlStyle:MPMovieControlStyleNone];
	
	[[NSNotificationCenter defaultCenter]
	 addObserver:self
	 selector:@selector(videoPlayerDidFinishPlaying:)
	 name:MPMoviePlayerPlaybackDidFinishNotification
	 object:introVideo];
	
	
	[introVideo play];
}

-(void) videoPlayerDidFinishPlaying: (NSNotification*)aNotification
{
	MPMoviePlayerController * introVideo = [aNotification object];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerPlaybackDidFinishNotification object:introVideo];
	[introVideo stop];
	[introVideo.view removeFromSuperview];
	[introVideo release];
	
	[self beginGame];
}

-(void)playFinishVideo
{
	
	NSURL * url;
	NSBundle *bundle = [NSBundle mainBundle];
	if (bundle) 
	{
		NSString *moviePath = nil;
		if(points ==40)
		{
			moviePath = [bundle pathForResource:@"Puntostodos_iPad" ofType:@"mov"];
		}else
		{
			moviePath = [bundle pathForResource:@"Puntos_iPad" ofType:@"mov"];
		}
		if (moviePath)
		{
			url = [NSURL fileURLWithPath:moviePath];
		}
	}
	
	finishVideo = [[MPMoviePlayerController alloc] initWithContentURL:url];
	[[[CCDirector sharedDirector] openGLView] addSubview:finishVideo.view];
	[finishVideo.view setFrame:CGRectMake(0,0,1024,768)];
	[finishVideo setControlStyle:MPMovieControlStyleNone];
	
	[[NSNotificationCenter defaultCenter]
	 addObserver:self
	 selector:@selector(finishVideoDidFinishPlaying:)
	 name:MPMoviePlayerPlaybackDidFinishNotification
	 object:finishVideo];
	
	
	[finishVideo play];
	
	[self runAction:[CCSequence actions:[CCDelayTime actionWithDuration:3],[CCCallFunc actionWithTarget:self selector:@selector(showBashoStillImage)],nil]];

	
}

-(void)showBashoStillImage
{
	CCSprite * back = [CCSprite spriteWithFile:@"PuntosEndFrame_iPad.png"];
	[back setPosition:ccp(512,384)];
	[self addChild:back z:20];
}

-(void) finishVideoDidFinishPlaying: (NSNotification*)aNotification
{
	MPMoviePlayerController * finishVideo = [aNotification object];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerPlaybackDidFinishNotification object:finishVideo];
	[finishVideo stop];
	[finishVideo.view removeFromSuperview];
	[finishVideo release];
	
	[self showDinoPoints];
}

-(void)showDinoPoints
{
	//RESET DINO
	CCSprite * gloopbackground = [CCSprite spriteWithFile:[NSString stringWithFormat:@"PuntosDomino_iPad_00000.png.pvr"]];
	[gloopbackground setPosition:ccp(512,384)];
	[self addChild:gloopbackground z:21];
	//ANIMATION
	NSMutableArray * gloopFrames = [[[NSMutableArray  alloc]init]autorelease];
	for(int i = 0; i <= 6; i++) {
		
		CCSprite * sp = [CCSprite spriteWithFile:[NSString stringWithFormat:@"PuntosDomino_iPad_%05d.png.pvr",i]];
		CCSpriteFrame *frame = [CCSpriteFrame frameWithTexture:sp.texture rect:sp.textureRect];
		[gloopFrames addObject:frame];
	}
	
	CCAnimation * gloopAnimation = [CCAnimation animationWithFrames:gloopFrames delay:0.05f];
	[gloopbackground runAction:[CCSequence actions:[CCAnimate actionWithAnimation:gloopAnimation restoreOriginalFrame:NO],[CCDelayTime actionWithDuration:2],[CCCallFunc actionWithTarget:self selector:@selector(addDinoPoints)],nil]];
	
	[[SimpleAudioEngine sharedEngine] playEffect:@"pointsaudiosting.mp3"];
	
}

-(void)addDinoPoints
{
	CCLabelTTF * scoreLbl = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%d",points] fontName:@"Verdana" fontSize:200];
	[scoreLbl setColor:ccBLACK];
	[self addChild:scoreLbl z:22];
	[scoreLbl setPosition:ccp(450,530)];
	
	[[SimpleAudioEngine sharedEngine] playEffect:[NSString stringWithFormat:@"%d.mp3",points]];
	[self addFinishMenu];
}

-(void)addFinishMenu
{
	CCMenuItemImage * home = [CCMenuItemImage itemFromNormalImage:@"btn_home_iPad.png" selectedImage:@"btn_home_dwn_iPad.png" target:self selector:@selector(goBack)];
	CCMenuItemImage * replay = [CCMenuItemImage itemFromNormalImage:@"btn_replay_iPad.png" selectedImage:@"btn_replay_dwn_iPad.png" target:self selector:@selector(replay)];
	CCMenuItemImage * next = [CCMenuItemImage itemFromNormalImage:@"btn_next_iPad.png" selectedImage:@"btn_next_dwn_iPad.png" target:self selector:@selector(nextGame)];
	
	CCMenu * menu = [CCMenu menuWithItems:home,replay,next,nil];
	[self addChild:menu z:23];
	[menu alignItemsHorizontallyWithPadding:20];
	[menu setPosition:ccp(512,150)];
}

-(void)replay
{
	[[SimpleAudioEngine sharedEngine] stopBackgroundMusic];
	[[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.5 scene: [InteractiveSongScene_iPad sceneWithSongVC:viewController] withColor:ccWHITE]];

}

-(void)nextGame
{
	[[SimpleAudioEngine sharedEngine] stopBackgroundMusic];
	[viewController goToNextGame];
}

-(void)beginGame
{
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
	
	
	//LYRICS
	
	NSString *lyricPath = [[NSBundle mainBundle] pathForResource:@"videoLyrics" ofType:@"plist"];
	
	lyricLines = [[NSMutableArray arrayWithContentsOfFile:lyricPath]retain];
	
	currentLyricLine = 0;
	
	lyrics = [CCLabelBMFont bitmapFontAtlasWithString:@"" fntFile:@"interactive_lyrics_iPad.fnt"];
	[self addChild:lyrics];
	[lyrics setPosition:ccp(512,50)];
	
	[self showLyricLine];
	
}

-(void)showLyricLine
{
	if([lyricLines count]>currentLyricLine)
	{
		NSMutableDictionary * line = [lyricLines objectAtIndex:currentLyricLine];
		NSString * text = [line objectForKey:@"lyric"];
		float duration = [[line objectForKey:@"duration"] floatValue];
		
		[lyrics setString:text];
		ccColor3B cOrig = {204,0,106};
		[lyrics setColor:cOrig];
		
		/*if([[lyrics children] count]>5)
		{
			CCSprite * l1 = [[lyrics children] objectAtIndex:5];
			
			ccColor3B c = {255,255,0};
			[l1 setColor:c];
		}*/
		[self performSelector:@selector(showLyricLine) withObject:nil afterDelay:duration];
		currentLyricLine++;
	}
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
	}else {
		[self playFinishVideo];
	}

}

-(void)goBack
{
	
	[[SimpleAudioEngine sharedEngine] stopBackgroundMusic];
	[viewController goToMenu];
}

-(void)dealloc
{
	[lyricLines release];
	[iElements release];
	[super dealloc];
}

@end
