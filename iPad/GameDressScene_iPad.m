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

@synthesize placingElement,colorNeeded,itemNeeded,bashoDirected;

+(id) sceneWithDressVC:(GameDress_iPad *)vc bashoDirected:(BOOL)_bashoDirected playVid:(BOOL)playVid
{
    CCScene *scene = [CCScene node];
    GameDressScene_iPad *layer = [GameDressScene_iPad nodeWithDressVC:vc bashoDirected:_bashoDirected playVid:playVid];
    [scene addChild: layer];
    return scene;
}

+(id) nodeWithDressVC:(GameDress_iPad *)vc bashoDirected:(BOOL)_bashoDirected playVid:(BOOL)playVid
{
	return [[[self alloc] initWithDressVC:vc bashoDirected:_bashoDirected playVid:playVid] autorelease];
}

-(id) initWithDressVC:(GameDress_iPad *)vc bashoDirected:(BOOL)_bashoDirected playVid:(BOOL)playVid
{
	if( (self=[super init] )) {
		self.isTouchEnabled = YES;
		self.isAccelerometerEnabled = YES;
		
		bashoDirected = _bashoDirected;
		viewController = vc;
		
		//[self beginGame];
		if(![GameManager sharedGameManager].playedGame2Video)
		{
			[[GameManager sharedGameManager] setPlayedGame2Video:YES];
			[self loadVideo];
		}
		else
			[self beginGame];
		 
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

-(void)loadVideo
{
	NSURL * url;
	NSBundle *bundle = [NSBundle mainBundle];
	if (bundle) 
	{
		NSString *moviePath = [bundle pathForResource:[NSString stringWithFormat:@"intro_2_%@_iPad",[GameManager sharedGameManager].instructionsLanguageString] ofType:@"mov"];
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
	
	UIButton * skip = [UIButton buttonWithType:UIButtonTypeCustom];
	[skip setFrame:CGRectMake(0,0,[CCDirector sharedDirector].winSize.width,[CCDirector sharedDirector].winSize.height)];
	[skip addTarget:self action:@selector(skipMovie) forControlEvents:UIControlEventTouchUpInside];
	[introVideo.view addSubview:skip];
	
	
	[introVideo play];
}

-(void)skipMovie
{
	[[NSNotificationCenter defaultCenter] removeObserver:self
													name:MPMoviePlayerPlaybackDidFinishNotification object:introVideo];
	[introVideo stop];
	[introVideo.view removeFromSuperview];
	[introVideo release];
	
	[self beginGame];
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
	if(bashoDirected)
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
		
	}else {
		[self replay];
		//[self resetDino];
	}
	
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
	
	[self unschedule:@selector(playRandomDinoAnim)];
	[dino setVisible:YES];
	[target begin];
	[dino.parent removeChild:dino cleanup:YES];
	[self addChild:dino];
	[dino visit];
	
	[dressPieces exchangeObjectAtIndex:0 withObjectAtIndex:1];
	
	for(CCSprite * piece in dressPieces)
	{
		[piece.parent removeChild:piece cleanup:YES];
		[self addChild:piece];
		[piece visit];
	}
	
	[target end];
	[target saveBuffer:@"pirulo"];
	UIImage * savedImg = [target getUIImageFromBuffer];
	[[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.5 scene: [GameDressSceneSnapshot_iPad sceneWithDressVC:viewController dinoImage:savedImg] withColor:ccWHITE]];

	//[[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.5 scene: [GameDressScene_iPad sceneWithDressVC:viewController bashoDirected:YES playVid:NO] withColor:ccWHITE]];
	
}

-(void)nextGame
{
	[viewController goToNextGame];
}

-(void)beginGame
{
	//[self loadDeviceType];
	
	self.isTouchEnabled = YES;

	CCSprite * back = [CCSprite spriteWithFile:@"dress_background_iPad.png"];
	[back setPosition:ccp(512,384)];
	[self addChild:back];
	
	bashoSelectedSound = 0;
	ddElements = [[NSMutableArray alloc] initWithCapacity:4];
	dressPieces= [[NSMutableArray alloc] initWithCapacity:8];
	
	target = [[CCRenderTexture renderTextureWithWidth:1024 height:768] retain];
	[target setPosition:ccp(512,384)];
	
	[[ CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"dress_iPad.plist" textureFile:@"dress_iPad.png"];
	
	CCSpriteBatchNode * sbn = [CCSpriteBatchNode batchNodeWithFile:@"dress_iPad.png"];
	[self addChild:sbn z:1 tag:kSPRITEBATCH_ELEMS];
	
	//[self loadScatteredElements];
	
	dino = [[CCSprite spriteWithSpriteFrameName:@"dress_dino_iPad.png"]retain];
	[sbn addChild:dino z:0 tag:4190]; //DINO = 4190
	[dino setPosition:ccp(512,384)];
	
	CCSprite * boxers = [CCSprite spriteWithSpriteFrameName:@"dress_boxers_iPad.png"];
	[sbn addChild:boxers z:0 tag:kBOXERS];
	[boxers setPosition:ccp(512,384)];
	
	CCSprite * shirt = [CCSprite spriteWithSpriteFrameName:@"dress_shirt_iPad.png"];
	[sbn addChild:shirt];
	[shirt setPosition:ccp(512,384)];
	
	CCMenuItemImage * backBtn = [CCMenuItemImage itemFromNormalImage:@"wheel_home_iPad.png" selectedImage:@"wheel_home_iPad.png" target:self selector:@selector(goBack)];
	
	CCMenuItemImage * settingsBtn = [CCMenuItemImage itemFromNormalImage:@"wheel_settings_iPad.png" selectedImage:@"wheel_settings_iPad.png" target:self selector:@selector(goSettings)];

	CCMenuItemImage * soundOff = [CCMenuItemImage itemFromNormalImage:@"wheel_sound_off_iPad.png" selectedImage:@"wheel_sound_on_iPad.png"];
	CCMenuItemImage * soundOn = [CCMenuItemImage itemFromNormalImage:@"wheel_sound_on_iPad.png" selectedImage:@"wheel_sound_off_iPad.png"];
	CCMenuItemToggle * sound = [CCMenuItemToggle itemWithTarget:self selector:@selector(turnSounds) items:soundOn,soundOff,nil];
	
	CCMenuItemImage * bashoOff = [CCMenuItemImage itemFromNormalImage:@"wheel_basho_off_iPad.png" selectedImage:@"wheel_basho_on_iPad.png"];
	CCMenuItemImage * bashoOn = [CCMenuItemImage itemFromNormalImage:@"wheel_basho_on_iPad.png" selectedImage:@"wheel_basho_off_iPad.png"];
	CCMenuItemToggle * basho = [CCMenuItemToggle itemWithTarget:self selector:@selector(turnBasho) items:bashoOff,bashoOn,nil];
	
	
	CCMenu * menu = [CCMenu menuWithItems:backBtn,sound,basho,settingsBtn, nil];
	[self addChild:menu];
	[backBtn setPosition:ccp(64,696)];
	[settingsBtn setPosition:ccp(50,48)];
	[sound setPosition:ccp(50,120)];
	[basho setPosition:ccp(50,200)];
	[menu setPosition:ccp(0,0)];
	
	btnImgs = [[NSMutableArray arrayWithCapacity:8]retain];
	[btnImgs addObject:BTN_PANTS];
	[btnImgs addObject:BTN_BOOTS];
	[btnImgs addObject:BTN_NECKLACE];
	[btnImgs addObject:BTN_JACKET];
	[btnImgs addObject:BTN_SUNGLASSES];
	[btnImgs addObject:BTN_HAT];
	[btnImgs addObject:BTN_PHONE];
	[btnImgs addObject:BTN_BACKPACK];
	
	btnColor = [[NSMutableArray arrayWithCapacity:4]retain];
	[btnColor addObject:@"Blue"];
	[btnColor addObject:@"Red"];
	[btnColor addObject:@"Purple"];
	[btnColor addObject:@"Yellow"];
	
	[self createPalabra];
	
	[self selectItemForBasho];
	
	[self schedule:@selector(playRandomDinoAnim) interval:arc4random() % 5+5];
	
	
	//[self loadScore];
	//[self makeScoreAppear:bashoDirected];
}


-(void)createPalabra
{
    CCSprite * palabraBck = [CCSprite spriteWithFile:@"wheel_wordbackground_iPad.png"];
    [self addChild:palabraBck z:1 tag:kPALABRABCK];
    [palabraBck setPosition:ccp(870,60)];
	[palabraBck setOpacity:0];
	CCLabelTTF * palabra = [CCLabelBMFont labelWithString:@"a" fntFile:@"Wheel_text_iPad.fnt"];
    [self addChild:palabra z:1 tag:kPALABRA];
	[palabra setPosition:ccp(870,60)];
	[palabra setOpacity:0];
	[palabra setScale:0.7];
}

-(void)showPalabra:(NSString *)word
{
	CCLabelTTF * palabra = [self getChildByTag:kPALABRA];
	[palabra setString:word];
	[palabra runAction:[CCFadeIn actionWithDuration:0.8]];
    CCSprite * palabraBck = [self getChildByTag:kPALABRABCK];
	[palabraBck runAction:[CCFadeIn actionWithDuration:0.8]];
}

-(void)hidePalabra
{
	CCLabelTTF * palabra = [self getChildByTag:kPALABRA];
	[palabra runAction:[CCSequence actions:[CCDelayTime actionWithDuration:1.5],[CCFadeTo actionWithDuration:0.5 opacity:0],nil]];
    CCSprite * palabraBck = [self getChildByTag:kPALABRABCK];
	[palabraBck runAction:[CCSequence actions:[CCDelayTime actionWithDuration:1.5],[CCFadeTo actionWithDuration:0.5 opacity:0],nil]];	
}

-(void)playRandomDinoAnim
{
	int animNum = arc4random() %4+1;
	int animAmount = 0;
	NSString * frameName = nil;
	switch (animNum) {
		case 1:
			frameName = @"Game2_RumiEverythingAnim";
			animAmount = 20;
			break;
		case 2:
			frameName = @"Game2_RumiEyesBlinkAnim";
			animAmount = 8;
			break;
		case 3:
			frameName = @"Game2_RumiMouthAnim";
			animAmount = 8;
			break;
		case 4:
			frameName = @"Game2_RumiTailWagAnim";
			animAmount = 8;
			break;
		default:
			break;
	}
	
	[[ CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:[NSString stringWithFormat:@"RumiAnim%d_iPad.plist",animNum] textureFile:[NSString stringWithFormat:@"RumiAnim%d_iPad.png",animNum]];
	
	CCSpriteBatchNode * animSbn = [CCSpriteBatchNode batchNodeWithFile:[NSString stringWithFormat:@"RumiAnim%d_iPad.png",animNum]];
	[self addChild:animSbn z:0 tag:545];
	animSbn.userData = [[NSString stringWithFormat:@"RumiAnim%d_iPad.plist",animNum]retain];
	
	//[self loadScatteredElements];
	
	CCSprite * dinoAnim = [CCSprite spriteWithSpriteFrameName:[NSString stringWithFormat:@"%@_00000.png",frameName]];
	[animSbn addChild:dinoAnim];
	[dinoAnim setPosition:ccp(512,384)];
	
	NSMutableArray *animFrames = [NSMutableArray array];
	for(int i = 0; i < animAmount; i++) {
		
		CCSpriteFrame *frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"%@_%05d.png",frameName,i]];
		[animFrames addObject:frame];
	}
	
	CCAnimation *animation = [CCAnimation animationWithFrames:animFrames];
	// 14 frames * 1sec = 14 seconds
	
	CCSpriteBatchNode * sbn = [self getChildByTag:kSPRITEBATCH_ELEMS];
	
	CCSprite * dinosp = [sbn getChildByTag:4190];
	[dinosp setVisible:NO];
	
	[dinoAnim runAction:[CCSequence actions:[CCAnimate actionWithDuration:1 animation:animation restoreOriginalFrame:YES],[CCCallFuncN actionWithTarget:self selector:@selector(removeRandomDinoAnim:)],nil]];
	
	
}

-(void)removeRandomDinoAnim:(CCSprite *)sp
{
	CCSpriteBatchNode * sbn = [self getChildByTag:kSPRITEBATCH_ELEMS];
	
	CCSprite * dinosp = [sbn getChildByTag:4190];
	[dinosp setVisible:YES];
	
	CCSpriteBatchNode * animSbn = [self getChildByTag:545];
	NSString * textToRemove = [NSString stringWithString:animSbn.userData];
	[animSbn.userData release];
	[animSbn removeChild:sp cleanup:YES];
	[self removeChild:animSbn cleanup:YES];
	[[CCSpriteFrameCache sharedSpriteFrameCache] removeSpriteFramesFromFile:textToRemove];
	
}

-(void)goSettings
{
    [viewController goToSettings];
}

-(void)turnSounds
{
	GameManager * gm = [GameManager sharedGameManager];
	[gm turnSounds];
}

-(void)turnBasho
{
	bashoDirected = !bashoDirected;
	
	[[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.5 scene: [GameDressScene_iPad sceneWithDressVC:viewController bashoDirected:bashoDirected playVid:NO] withColor:ccWHITE]];
	
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
		CCSpriteBatchNode * sbn = [self getChildByTag:kSPRITEBATCH_ELEMS];
		for(DDElement * el in ddElements)
		{
			[sbn removeChild:el.mySprite cleanup:YES];
			[self removeChild:el cleanup:YES];
		}
		[ddElements removeAllObjects];
		
		bashoSelectedSound = 0;
		
		NSString * fileName = nil;
		switch (arc4random() %4) {
			case 0:
				fileName = @"Arrows_iPad_1024x1024_";
				break;
			case 1:
				fileName = @"Flowers_iPad_1024x1024_";
				break;
			case 2:
				fileName = @"LayeredStars_iPad_1024x1024_";
				break;
			case 3:
				fileName = @"Spirals_iPad_1024x1024_";
				break;
		}
		
		//RESET DINO
		CCSprite * gloopbackground = [CCSprite spriteWithFile:[NSString stringWithFormat:@"%@00000.png.pvr",fileName]];
		[gloopbackground setPosition:ccp(512,384)];
		[self addChild:gloopbackground];
		//ANIMATION
		NSMutableArray * gloopFrames = [[[NSMutableArray  alloc]init]autorelease];
		for(int i = 0; i <= 15; i++) {
			
			CCSprite * sp = [CCSprite spriteWithFile:[NSString stringWithFormat:@"%@%05d.png.pvr",fileName,i]];
			CCSpriteFrame *frame = [CCSpriteFrame frameWithTexture:sp.texture rect:sp.textureRect];
			[gloopFrames addObject:frame];
		}
		
		CCAnimation * gloopAnimation = [CCAnimation animationWithFrames:gloopFrames delay:0.1f];
		[gloopbackground runAction:[CCSequence actions:[CCRepeat actionWithAction:[CCAnimate actionWithAnimation:gloopAnimation restoreOriginalFrame:NO] times:2],[CCCallFuncN actionWithTarget:self selector:@selector(removeAnim:)],[CCCallFunc actionWithTarget:self selector:@selector(replay)],nil]];
		
		return;
	}
	
	
	NSString * sound = nil;
	if(!bashoDirected)
	{
		sound = [NSString stringWithFormat:@"dress_snd_%@_where_%@.mp3",[btnImgs objectAtIndex:bashoSelectedSound],[GameManager sharedGameManager].languageString];
	}else {
		
		itemNeeded = [btnImgs objectAtIndex:bashoSelectedSound];
		colorNeededNumber = arc4random() % 4;
		colorNeeded = [btnColor objectAtIndex:colorNeededNumber];
		
		sound = [NSString stringWithFormat:@"dress_snd_%@_%@_where_%@.mp3",itemNeeded,colorNeeded,[GameManager sharedGameManager].languageString];
	}

	if([GameManager sharedGameManager].soundsEnabled)
		[[SimpleAudioEngine sharedEngine] playEffect:sound];
	
	[self loadScatteredElementsForItem:bashoSelectedSound];
	
	bashoSelectedSound ++;
	
}

-(void)removeAnim:(CCNode *)n
{
	[n.parent removeChild:n cleanup:YES];
}

-(void)addPoints
{
	points += 5;
	CCLabelTTF * scoreLbl = [self getChildByTag:kSCORE];
	[scoreLbl setString:[NSString stringWithFormat:@"%d",points]];
}

-(void)resetDino
{
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
	
	NSString *filePath = [[NSBundle mainBundle] pathForResource:@"DressData_iPad" ofType:@"plist"];
	
	NSMutableDictionary * elementsFile = [NSMutableDictionary dictionaryWithContentsOfFile:filePath];
	NSMutableArray * elements=nil;
	
	if(!bashoDirected)
	{
		for(int q2 = 0;q2 < 4;q2++)
		{
			NSMutableArray * arr =[elementsFile objectForKey:[btnImgs objectAtIndex:item]];
			NSMutableDictionary * d = [arr objectAtIndex:q2];
			[d setObject:[btnImgs objectAtIndex:item] forKey:@"itemNumber"];
			[d setObject:[btnColor objectAtIndex:q2] forKey:@"colorNumber"];
			
			[arr replaceObjectAtIndex:q2 withObject:d];
			[elementsFile setObject:arr forKey:[btnImgs objectAtIndex:item]];
			
		}
		elements = [elementsFile objectForKey:[btnImgs objectAtIndex:item]];
	}else{
	
		NSMutableArray * genElems = [NSMutableArray array];
		
		for(int q = 0;q<8;q++)
		{
			for(int q2 = 0;q2 < 4;q2++)
			{
				NSMutableArray * arr =[elementsFile objectForKey:[btnImgs objectAtIndex:q]];
				NSMutableDictionary * d = [arr objectAtIndex:q2];
				[d setObject:[btnImgs objectAtIndex:q] forKey:@"itemNumber"];
				[d setObject:[btnColor objectAtIndex:q2] forKey:@"colorNumber"];
				
				[arr replaceObjectAtIndex:q2 withObject:d];
				[elementsFile setObject:arr forKey:[btnImgs objectAtIndex:q]];
				
			}
			
			[genElems addObjectsFromArray:[elementsFile objectForKey:[btnImgs objectAtIndex:q]]];
		}
		elements = [NSMutableArray array];
		
		NSMutableDictionary * askedItem = [[elementsFile objectForKey:itemNeeded]objectAtIndex:colorNeededNumber];
		[elements addObject:askedItem];
		[genElems removeObject:askedItem];
		
		for(int i =0;i<3;i++)
		{
			int itemN = arc4random() % [genElems count];
			NSMutableDictionary * ele = [genElems objectAtIndex:itemN];
			[elements addObject:ele];
			[genElems removeObjectAtIndex:itemN];
		}
		
		elements = [self shuffle:elements];
	}
	NSMutableArray * positions = [NSMutableArray array];
	
	NSMutableDictionary * p1 = [NSMutableDictionary dictionaryWithObjects:[NSMutableArray arrayWithObjects:[NSNumber numberWithInt:230],[NSNumber numberWithInt:180],nil] forKeys:[NSMutableArray arrayWithObjects:@"x",@"y",nil]];
	NSMutableDictionary * p2 = [NSMutableDictionary dictionaryWithObjects:[NSMutableArray arrayWithObjects:[NSNumber numberWithInt:230],[NSNumber numberWithInt:580],nil] forKeys:[NSMutableArray arrayWithObjects:@"x",@"y",nil]];
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
		
		if (!bashoDirected ||(bashoDirected && [ddElement.itemNumber isEqualToString:itemNeeded] && [ddElement.colorNumber isEqualToString:colorNeeded]))
			[self showPalabra:ddElement.itemText];
		
		
		[ddElement release];
	}

}

- (NSMutableArray *) shuffle:(NSMutableArray *)array
{
	// create temporary autoreleased mutable array
	NSMutableArray *tmpArray = [NSMutableArray arrayWithCapacity:[array count]];
	
	for (id anObject in array)
	{
		NSUInteger randomPos = arc4random()%([tmpArray count]+1);
		[tmpArray insertObject:anObject atIndex:randomPos];
	}
	
	return [NSArray arrayWithArray:tmpArray];  // non-mutable autoreleased copy
}


-(void)goBack
{
	[[CCSpriteFrameCache sharedSpriteFrameCache] removeSpriteFramesFromFile:@"dress_iPad.plist"];
	[[CCSpriteFrameCache sharedSpriteFrameCache] removeUnusedSpriteFrames];
	[viewController goToMenu];
}

- (void) onEnter
{
	[super onEnter];
	[[UIAccelerometer sharedAccelerometer] setUpdateInterval:(1.0 / 60)];
	
}

-(void)onShake
{
	[[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.5 scene: [GameDressScene_iPad sceneWithDressVC:viewController bashoDirected:bashoDirected playVid:NO] withColor:ccWHITE]];

}

- (void)accelerometer:(UIAccelerometer*)accelerometer didAccelerate:(UIAcceleration*)acceleration
{	
	if (lastAcceleration)
    {
        if (!histeresisExcited && AccelerationIsShaking(lastAcceleration, acceleration, 0.35)) 
        {
            histeresisExcited = YES;
			[self onShake];
        }
        else if (histeresisExcited && !AccelerationIsShaking(lastAcceleration, acceleration, 0.2))
        {
            histeresisExcited = NO;
        }
    }
	
    [lastAcceleration release];
    lastAcceleration = [acceleration retain];
	
}


static BOOL AccelerationIsShaking(UIAcceleration* last, UIAcceleration* current, double threshold) 
{
    double
    deltaX = fabs(last.x - current.x),
    deltaY = fabs(last.y - current.y),
    deltaZ = fabs(last.z - current.z);
	
    return
    (deltaX > threshold && deltaY > threshold) ||
    (deltaX > threshold && deltaZ > threshold) ||
    (deltaY > threshold && deltaZ > threshold);
}


-(void)dealloc
{
	[dino release];
	[target release];
	[lastAcceleration release];
	[btnImgs release];
	[btnColor release];
	[dressPieces release];
	[ddElements release];
	[super dealloc];
}

@end
