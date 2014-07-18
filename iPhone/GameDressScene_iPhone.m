//
//  GameDressScene_iPhone.m
//  Basho
//
//  Created by Pablo Ruiz on 04/03/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GameDressScene_iPhone.h"
#import "DDElement_iPhone.h"
#import "GameManager.h"
#import "SimpleAudioEngine.h"
#import "AppDelegate_iPhone.h"

@implementation GameDressScene_iPhone
@synthesize viewController;

+(id) sceneWithDressVC:(GameDress_iPhone *)vc bashoDirected:(BOOL)_bashoDirected playVid:(BOOL)playVid playingAgain:(BOOL)_playingAgain
{
    CCScene *scene = [CCScene node];
    GameDressScene_iPhone *layer = [GameDressScene_iPhone nodeWithDressVC:vc bashoDirected:_bashoDirected playVid:playVid playingAgain:_playingAgain];
    [scene addChild: layer z:1 tag:1000];
    return scene;
}

+(id) nodeWithDressVC:(GameDress_iPhone *)vc bashoDirected:(BOOL)_bashoDirected playVid:(BOOL)playVid playingAgain:(BOOL)_playingAgain
{
	return [[[self alloc] initWithDressVC:vc bashoDirected:_bashoDirected playVid:playVid playingAgain:_playingAgain] autorelease];
}

-(id) initWithDressVC:(GameDress_iPhone *)vc bashoDirected:(BOOL)_bashoDirected playVid:(BOOL)playVid playingAgain:(BOOL)_playingAgain
{
	if( (self=[super init] )) {
        
        middle=240;
        xOffset=0;
        
        if (IS_IPHONE5) {
            middle=284;
            xOffset=44;
        }
        
		self.isTouchEnabled = YES;
		self.isAccelerometerEnabled = YES;
		
        isBackBagSet = NO;
        
		bashoDirected = _bashoDirected;
		viewController = vc;
		
        if ([GameManager sharedGameManager].musicAudioEnabled) {
            if (_playingAgain) {
                [[SimpleAudioEngine sharedEngine] resumeBackgroundMusic];
            }
            else {
                [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"backgroundMusicDress.mp3"];
            }
        }
        
		//[self beginGame];
		AppDelegate_iPhone * app = (AppDelegate_iPhone *)[[UIApplication sharedApplication] delegate];
		
		[app.activityImageView stopAnimating];//01/08/2011
        [app.activityImageView setHidden:YES];//01/08/2011
        [app.backgroundActivity setHidden:YES];//01/08/2011
		if(![GameManager sharedGameManager].playedGame2Video)
		{
			[[GameManager sharedGameManager] setPlayedGame2Video:YES];
            videoFromLoadingScene = YES;
            
			
            
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
    [GameManager sharedGameManager].onPause = YES;
    [[SimpleAudioEngine sharedEngine] pauseBackgroundMusic];
	if (bundle) 
	{
		NSString *moviePath = [bundle pathForResource:[NSString stringWithFormat:@"intro_2_%@_iPhone",[GameManager sharedGameManager].instructionsLanguageString] ofType:@"mov"];
		if (moviePath)
		{
			url = [NSURL fileURLWithPath:moviePath];
		}
	}
    
    int width = 480;
    
    if (IS_IPHONE5) {
        width = 568;
    }
    
    /*
     [curtainL setCenter:CGPointMake(-56, curtainL.center.y)];
     [curtainR setCenter:CGPointMake(625, curtainL.center.y)];
     }
     else {
     [curtainL setCenter:CGPointMake(-56, curtainL.center.y)];
     [curtainR setCenter:CGPointMake(538, curtainL.center.y)];
     */
	
	introVideo = [[MPMoviePlayerController alloc] initWithContentURL:url];
	[[[CCDirector sharedDirector] openGLView] addSubview:introVideo.view];
	[introVideo.view setFrame:CGRectMake(0,0,width,320)];
	[introVideo setControlStyle:MPMovieControlStyleNone];
    
    if (IS_IPHONE5) {
        UIImageView *dot =[[UIImageView alloc] initWithFrame:CGRectMake(0,0,259,328)];
        dot.image=[UIImage imageNamed:@"theatre_left_iPhone-hd.png"];
        [introVideo.view addSubview:dot];
        [dot setCenter:CGPointMake(-63, dot.center.y)];
        [dot release];
        
        UIImageView *dot2 =[[UIImageView alloc] initWithFrame:CGRectMake(0,0,259,328)];
        dot2.image=[UIImage imageNamed:@"theatre_right_iPhone-hd.png"];
        [introVideo.view addSubview:dot2];
        [dot2 setCenter:CGPointMake(632, dot2.center.y)];
        [dot2 release];
    }
    
    [[NSNotificationCenter defaultCenter]
	 addObserver:self
	 selector:@selector(videoPlayerDidFinishLoading:)
     name:MPMoviePlayerLoadStateDidChangeNotification
     object:introVideo];
	
	[[NSNotificationCenter defaultCenter]
	 addObserver:self
	 selector:@selector(videoPlayerDidFinishPlaying:)
						name:MPMoviePlayerPlaybackDidFinishNotification
						object:introVideo];
	
	UIButton * skip = [UIButton buttonWithType:UIButtonTypeCustom];
	[skip setFrame:CGRectMake(0,0,[CCDirector sharedDirector].winSize.width,[CCDirector sharedDirector].winSize.height)];
	[skip addTarget:self action:@selector(skipMovie) forControlEvents:UIControlEventTouchUpInside];
	[introVideo.view addSubview:skip];
	
	videoTaps=0;
	
	[introVideo play];
}

-(void)videoPlayerDidFinishLoading: (NSNotification*)aNotification {
    
    MPMoviePlayerController * introVideo = [aNotification object];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerLoadStateDidChangeNotification object:introVideo];
    
    [introVideo play];
    
}


-(void)replay
{	
	[dressPieces exchangeObjectAtIndex:0 withObjectAtIndex:1];
    CCSprite * backpackBack = [dressPieces lastObject];
    [dressPieces removeLastObject];
    [dressPieces insertObject:backpackBack atIndex:0];
    
    [target begin];

    CCSprite * bag = [dressPieces objectAtIndex:0];
    [bag.parent removeChild:bag cleanup:YES];
    [self addChild:bag];
    [bag visit];
    [dressPieces removeObjectAtIndex:0];
      
    [dino setVisible:YES];
    [dino.parent removeChild:dino cleanup:YES];
	[self addChild:dino];
	[dino visit];
    
    [shirt setVisible:YES];
    [shirt.parent removeChild:shirt cleanup:YES];
    
    int piecePlace = 0;
    
	for(CCSprite * piece in dressPieces)
	{   
		[piece.parent removeChild:piece cleanup:YES];
        if (piecePlace == 1) {
            [self addChild:shirt];
            [self addChild:piece];
            [piece visit];
            [shirt visit];
            
        }
        else {
            [piece visit];
        }
        piecePlace++;
	}
    
	[target end];
	[target saveBuffer:@"pirulo"];
	UIImage * savedImg = [target getUIImageFromBuffer];
    CCTexture2D * text = [[CCTexture2D alloc] initWithImage:savedImg];
    CCSprite * dinoDressed = [CCSprite spriteWithTexture:text];
    [self addChild:dinoDressed z:8];
    [dinoDressed setPosition:ccp(middle,160)];
    [text release];
    [[CCSpriteFrameCache sharedSpriteFrameCache] removeSpriteFramesFromFile:@"dress_iPhone.plist"];
	[[CCSpriteFrameCache sharedSpriteFrameCache] removeUnusedSpriteFrames];
	[[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.5 scene: [GameDressSceneSnapshot_iPhone sceneWithDressVC:viewController dinoImage:savedImg bashoDirected:bashoDirected] withColor:ccWHITE]];

	//[[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.5 scene: [GameDressScene_iPad sceneWithDressVC:viewController bashoDirected:YES playVid:NO] withColor:ccWHITE]];
	
}

-(void)nextGame
{
	[viewController goToNextGame];
}

-(void)beginGame
{
	AppDelegate_iPhone * app = (AppDelegate_iPhone *)[[UIApplication sharedApplication] delegate];
	[app.activityImageView setHidden:NO];//01/08/2011
    [app.backgroundActivity setHidden:NO];//01/08/2011
	[app.activityImageView startAnimating];//01/08/2011
    [app.backgroundActivity setHidden:NO];
	
	[self performSelector:@selector(beginGameAfterDelay) withObject:nil afterDelay:1];
}
-(void)beginGameAfterDelay
{
	AppDelegate_iPhone * app = (AppDelegate_iPhone *)[[UIApplication sharedApplication] delegate];

	//[self loadDeviceType];
	
	self.isTouchEnabled = YES;
	
	[self schedule:@selector(doTimePassedForShake) interval:5];

	[CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_RGB565];
    
    NSString * strSrpite = nil;
    
    if (IS_IPHONE5) {
        strSrpite = @"dress_background_iPhone5.png";
    } else {
        strSrpite = @"dress_background_iPhone.png";
    }
    
	CCSprite * back = [CCSprite spriteWithFile:strSrpite];
	[back setPosition:ccp(middle,160)];
	[self addChild:back];
	[CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_RGBA4444];
	
	bashoSelectedSound = 0;
	ddElements = [[NSMutableArray alloc] initWithCapacity:4];
	dressPieces= [[NSMutableArray alloc] initWithCapacity:8];
	
    int width = 480;
    
    if (IS_IPHONE5) {
        width = 568;
    }
    
	target = [[CCRenderTexture renderTextureWithWidth:width height:320] retain];
	[target setPosition:ccp(middle,160)];
	
	[[ CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"dress_iPhone.plist" textureFile:@"dress_iPhone.png"];
	
	CCSpriteBatchNode * sbn = [CCSpriteBatchNode batchNodeWithFile:@"dress_iPhone.png"];
	[self addChild:sbn z:2 tag:kSPRITEBATCH_ELEMS];
	
	//[self loadScatteredElements];
	
	dino = [[CCSprite spriteWithSpriteFrameName:@"dress_dino_iPhone.png"]retain];
	[sbn addChild:dino z:2 tag:4190]; //DINO = 4190
	[dino setPosition:ccp(middle,160)];
	
	CCSprite * boxers = [CCSprite spriteWithSpriteFrameName:@"dress_boxers_iPhone.png"];
	[sbn addChild:boxers z:2 tag:kBOXERS];
	[boxers setPosition:ccp(middle,160)];
	
	shirt = [[CCSprite spriteWithSpriteFrameName:@"dress_shirt_iPhone.png"]retain];
	[sbn addChild:shirt z:5];
	[shirt setPosition:ccp(middle,160)];
	
	CCMenuItemImage * backBtn = [CCMenuItemImage itemFromNormalImage:@"wheel_home.png" selectedImage:@"wheel_home.png" target:self selector:@selector(goBack)];
	
	CCMenuItemImage * settingsBtn = [CCMenuItemImage itemFromNormalImage:@"wheel_settings_iPhone.png" selectedImage:@"wheel_settings_iPhone.png" target:self selector:@selector(goSettings)];

	CCMenuItemImage * soundOff = [CCMenuItemImage itemFromNormalImage:@"wheel_sound_off_iPhone.png" selectedImage:@"wheel_sound_on_iPhone.png"];
	CCMenuItemImage * soundOn = [CCMenuItemImage itemFromNormalImage:@"wheel_sound_on_iPhone.png" selectedImage:@"wheel_sound_off_iPhone.png"];
	CCMenuItemToggle * soundT = [CCMenuItemToggle itemWithTarget:self selector:@selector(turnSounds) items:soundOn,soundOff,nil];
	
	CCMenuItemImage * bashoOff = [CCMenuItemImage itemFromNormalImage:@"wheel_basho_off_iPhone.png" selectedImage:@"wheel_basho_on_iPhone.png"];
	CCMenuItemImage * bashoOn = [CCMenuItemImage itemFromNormalImage:@"wheel_basho_on_iPhone.png" selectedImage:@"wheel_basho_off_iPhone.png"];
	CCMenuItemToggle * basho = [CCMenuItemToggle itemWithTarget:self selector:@selector(turnBasho) items:bashoOff,bashoOn,nil];
    
    if (bashoDirected) {
        [basho setSelectedIndex:1];
    }
    
    if (![GameManager sharedGameManager].musicAudioEnabled) {
        [soundT setSelectedIndex:1];
    }
	
	CCMenu * menu = [CCMenu menuWithItems:backBtn,soundT,basho,settingsBtn, nil];
	[self addChild:menu];
	[backBtn setPosition:ccp(20,290)];
	[settingsBtn setPosition:ccp(20,25)];
	[soundT setPosition:ccp(20,60)];
	[basho setPosition:ccp(20,100)];
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
	
	[app.activityImageView stopAnimating];//01/08/2011
    [app.activityImageView setHidden:YES];//01/08/2011
    [app.backgroundActivity setHidden:YES];//01/08/2011
    
    //[self loadScore];
	//[self makeScoreAppear:bashoDirected];
}


-(void)createPalabra
{
    CCSprite * palabraBck = [CCSprite spriteWithFile:@"wheel_wordbackground_iPhone.png"];
    [self addChild:palabraBck z:3 tag:kPALABRABCK];
    [palabraBck setPosition:ccp(410+xOffset,30)];
	[palabraBck setOpacity:0];
	CCLabelTTF * palabra = [CCLabelBMFont labelWithString:@"a" fntFile:@"Wheel_text_iPad.fnt"];
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)] == YES && [[UIScreen mainScreen] scale] == 2.00) {
        [palabra setScale:0.70];
    }
    else {
        [palabra setScale:0.35];
    }
	[self addChild:palabra z:3 tag:kPALABRA];
	[palabra setPosition:ccp(410+xOffset,30)];
	[palabra setOpacity:0];
}


-(void)playRandomDinoAnim
{
	int animNum = arc4random() %4+1;
	int animAmount = 0;
	NSString * frameName = nil;
    NSString * typeIphone = nil;
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)] == YES && [[UIScreen mainScreen] scale] == 2.00) {
        
        typeIphone = @"_iPhone4";
    }
    else {
        typeIphone = @"_iPhone";
        
    }
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
    
    frameName = [frameName stringByAppendingString:typeIphone];
	
	[[ CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:[NSString stringWithFormat:@"RumiAnim%d_iPhone.plist",animNum] textureFile:[NSString stringWithFormat:@"RumiAnim%d_iPhone.png",animNum]];
	
	CCSpriteBatchNode * animSbn = [CCSpriteBatchNode batchNodeWithFile:[NSString stringWithFormat:@"RumiAnim%d_iPhone.png",animNum]];
	[self addChild:animSbn z:1 tag:545];
	animSbn.userData = [[NSString stringWithFormat:@"RumiAnim%d_iPhone.plist",animNum]retain];
	
	//[self loadScatteredElements];
	
	CCSprite * dinoAnim = [CCSprite spriteWithSpriteFrameName:[NSString stringWithFormat:@"%@_00000.png",frameName]];
	[animSbn addChild:dinoAnim];
	[dinoAnim setPosition:ccp(middle,160)];
	
	NSMutableArray *animFrames = [NSMutableArray array];
	for(int i = 0; i < animAmount; i++) {
		
		CCSpriteFrame *frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"%@_%05d.png",frameName,i]];
		[animFrames addObject:frame];
	}
	
	CCAnimation *animation = [CCAnimation animationWithFrames:animFrames];
	// 14 frames * 1sec = 14 seconds
	
	CCSpriteBatchNode * sbn = (CCSpriteBatchNode*)[self getChildByTag:kSPRITEBATCH_ELEMS];
	
	CCSprite * dinosp = (CCSprite*)[sbn getChildByTag:4190];
	[dinosp setVisible:NO];
	
    if (!isBackBagSet) {
        [dinoAnim runAction:[CCSequence actions:[CCAnimate actionWithDuration:1 animation:animation restoreOriginalFrame:YES],[CCCallFuncN actionWithTarget:self selector:@selector(removeRandomDinoAnim:)],nil]];
    }
    else {
        [dinoAnim runAction:[CCCallFuncN actionWithTarget:self selector:@selector(removeRandomDinoAnim:)]];
    }
}


-(void)goSettings
{
    [viewController goToSettings];
}


-(void)turnBasho
{
	bashoDirected = !bashoDirected;
	
    viewController.gameDressLayer = nil;
    
    GameDressScene_iPhone * gameDressScene = [GameDressScene_iPhone sceneWithDressVC:viewController bashoDirected:bashoDirected playVid:NO playingAgain:NO];
    
    GameDressScene_iPhone * layer = (GameDressScene_iPhone*)[gameDressScene getChildByTag:1000];
    
    layer.viewController.gameDressLayer = layer;
    
	[[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.5 scene:(CCScene*)gameDressScene  withColor:ccBLACK]];
	
}


-(void)selectItemForBasho
{
	placingElement = NO;
	if(bashoSelectedSound >=8)
	{
		CCSpriteBatchNode * sbn = (CCSpriteBatchNode*)[self getChildByTag:kSPRITEBATCH_ELEMS];
		for(DDElement_iPhone * el in ddElements)
		{
			[sbn removeChild:el.mySprite cleanup:YES];
			[self removeChild:el cleanup:YES];
		}
		[ddElements removeAllObjects];
		
		bashoSelectedSound = 0;
        
		NSString * fileName = nil;
		switch (arc4random() %4) {
            case 0:
				fileName = @"LayeredStars_iPhone_";
				break;
            case 1:
                fileName = @"LayeredDiamonds_iPhone_";
				break;
            case 2:
                fileName = @"LayeredCircles_iPhone_";
				break;
            case 3:
                fileName = @"LayeredTriangles_iPhone_";
				break;
		}
		
		if([GameManager sharedGameManager].soundsEnabled)
		{
			[[SimpleAudioEngine sharedEngine] pauseBackgroundMusic];
			[[SimpleAudioEngine sharedEngine] playEffect:@"game2-alldressed-sfx.mp3"];
		}
		
		//RESET DINO
		CCSprite * gloopbackground = [CCSprite spriteWithFile:[NSString stringWithFormat:@"%@00000.pvr",fileName]];
		[gloopbackground setPosition:ccp(middle,160)];
		[self addChild:gloopbackground];
        
        if (IS_IPHONE5) {
            [gloopbackground setScale:1.2];
        }
        
		//ANIMATION
		gloopFrames = [[NSMutableArray  alloc]init];
		for(int i = 0; i <= 15; i++) {
			CCSprite * sp = [CCSprite spriteWithFile:[NSString stringWithFormat:@"%@%05d.pvr",fileName,i]];
            if (sp != nil) {
                CCSpriteFrame *frame = [CCSpriteFrame frameWithTexture:sp.texture rect:sp.textureRect];
                [gloopFrames addObject:frame];
            }
		}
		
		CCAnimation * gloopAnimation = [CCAnimation animationWithFrames:gloopFrames delay:0.1f];
		[gloopbackground runAction:[CCSequence actions:[CCRepeat actionWithAction:[CCAnimate actionWithAnimation:gloopAnimation restoreOriginalFrame:NO] times:2],[CCCallFuncN actionWithTarget:self selector:@selector(removeAnim:)],[CCCallFunc actionWithTarget:self selector:@selector(replay)],nil]];
		
		return;
	}
	
	
	sound = nil;
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


-(void)dressDino:(GameDressScene_iPhone *)scene data:(void *)data
{	
	DDElement_iPhone * item = (DDElement_iPhone *)data;
	CCSpriteBatchNode * sbn = (CCSpriteBatchNode*)[self getChildByTag:kSPRITEBATCH_ELEMS];
	
	if(item.itemTag == BTN_PANTS_NUM)
	{
		CCSprite * boxers = (CCSprite*)[sbn getChildByTag:kBOXERS];
		[sbn removeChild:boxers cleanup:YES];
	}

	item.mySprite.opacity = 0;
	
	CCSprite * backpack = [CCSprite spriteWithSpriteFrameName:item.dressed];
	[sbn addChild:backpack z:item.desiredZ];
	[backpack setPosition:ccp(middle,160)];
    
    [dressPieces addObject:backpack];
    
    if (item.itemTag == BTN_BACKPACK_NUM) {
        
        isBackBagSet = YES;
        [self unschedule:@selector(playRandomDinoAnim)];
        
        CCSprite * backPack2 = [CCSprite spriteWithSpriteFrameName:item.imagePath2];
        [sbn addChild:backPack2 z:0];
        [backPack2 setPosition:ccp(middle,160)];
        
        [dressPieces addObject:backPack2];
    }
	
}

-(void)loadScatteredElementsForItem:(int)item
{
	CCSpriteBatchNode * sbn = (CCSpriteBatchNode*)[self getChildByTag:kSPRITEBATCH_ELEMS];
	for(DDElement_iPhone * el in ddElements)
	{
		[sbn removeChild:el.mySprite cleanup:YES];
		[self removeChild:el cleanup:YES];
	}
	[ddElements removeAllObjects];
	
	NSString *filePath = [[NSBundle mainBundle] pathForResource:@"DressData_iPhone" ofType:@"plist"];
	
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
	
	NSMutableDictionary * p1 = [NSMutableDictionary dictionaryWithObjects:[NSMutableArray arrayWithObjects:[NSNumber numberWithInt:100+xOffset],[NSNumber numberWithInt:90],nil] forKeys:[NSMutableArray arrayWithObjects:@"x",@"y",nil]];
	NSMutableDictionary * p2 = [NSMutableDictionary dictionaryWithObjects:[NSMutableArray arrayWithObjects:[NSNumber numberWithInt:100+xOffset],[NSNumber numberWithInt:250],nil] forKeys:[NSMutableArray arrayWithObjects:@"x",@"y",nil]];
	NSMutableDictionary * p3 = [NSMutableDictionary dictionaryWithObjects:[NSMutableArray arrayWithObjects:[NSNumber numberWithInt:380+xOffset],[NSNumber numberWithInt:90],nil] forKeys:[NSMutableArray arrayWithObjects:@"x",@"y",nil]];
	NSMutableDictionary * p4 = [NSMutableDictionary dictionaryWithObjects:[NSMutableArray arrayWithObjects:[NSNumber numberWithInt:380+xOffset],[NSNumber numberWithInt:250],nil] forKeys:[NSMutableArray arrayWithObjects:@"x",@"y",nil]];
	
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
				[elem setObject:[NSNumber numberWithInt:3] forKey:@"desiredZ"];
				break;
            case BTN_PANTS_NUM:
				[elem setObject:[NSNumber numberWithInt:4] forKey:@"desiredZ"];
				break;
			default:
				[elem setObject:[NSNumber numberWithInt:6] forKey:@"desiredZ"];
				break;
		}
		
		
		DDElement_iPhone * ddElement = [[DDElement_iPhone alloc] initWithTheGame:self elementDict:elem];
		[ddElements addObject:ddElement];
		
		if (!bashoDirected ||(bashoDirected && [ddElement.itemNumber isEqualToString:itemNeeded] && [ddElement.colorNumber isEqualToString:colorNeeded]))
			[self showPalabra:ddElement.itemText];
		
		
		[ddElement release];
	}

}


-(void)goBack
{
	[[CCSpriteFrameCache sharedSpriteFrameCache] removeSpriteFramesFromFile:@"dress_iPhone.plist"];
	[[CCSpriteFrameCache sharedSpriteFrameCache] removeUnusedSpriteFrames];
    [[SimpleAudioEngine sharedEngine] stopBackgroundMusic];
    [GameManager sharedGameManager].musicAudioEnabled = YES;
	[viewController goToMenu];
}


-(void)onShake
{
	if(timePassedForShake)
	{
		timePassedForShake = NO;
		[[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.5 scene: [GameDressScene_iPhone sceneWithDressVC:viewController bashoDirected:bashoDirected playVid:NO playingAgain:NO] withColor:ccWHITE]];
	}
}

-(void)dealloc
{
	[super dealloc];
}

@end
