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

+(id) sceneWithDressVC:(GameDress_iPad *)vc bashoDirected:(BOOL)_bashoDirected
{
    CCScene *scene = [CCScene node];
    GameDressScene_iPad *layer = [GameDressScene_iPad nodeWithDressVC:vc bashoDirected:_bashoDirected];
    [scene addChild: layer];
    return scene;
}

+(id) nodeWithDressVC:(GameDress_iPad *)vc bashoDirected:(BOOL)_bashoDirected
{
	return [[[self alloc] initWithDressVC:vc bashoDirected:_bashoDirected] autorelease];
}

-(id) initWithDressVC:(GameDress_iPad *)vc bashoDirected:(BOOL)_bashoDirected
{
	if( (self=[super init] )) {
		self.isTouchEnabled = YES;
		self.isAccelerometerEnabled = YES;
		
		bashoDirected = _bashoDirected;
		viewController = vc;
		
		//[self loadVideo];
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
		NSString *moviePath = [bundle pathForResource:@"ARG" ofType:@"mp4"];
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
	if(bashoDirected)
	{
		NSURL * url;
		NSBundle *bundle = [NSBundle mainBundle];
		if (bundle) 
		{
			NSString *moviePath = [bundle pathForResource:@"ARG" ofType:@"mp4"];
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
	}else {
		[self resetDino];
	}
	
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
	[[SimpleAudioEngine sharedEngine] playEffect:[NSString stringWithFormat:@"DOMINO %d.mp3",points]];
	[self addFinishMenu];
}

-(void)addFinishMenu
{
	
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
	
	[self selectItemForBasho];
	
	[self loadScore];
	[self makeScoreAppear:bashoDirected];
}


-(void)turnSounds
{
	GameManager * gm = [GameManager sharedGameManager];
	[gm turnSounds];
}

-(void)turnBasho
{
	bashoDirected = !bashoDirected;
	
	[[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.5 scene: [GameDressScene_iPad sceneWithDressVC:viewController bashoDirected:bashoDirected] withColor:ccWHITE]];
	
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
		[gloopbackground runAction:[CCSequence actions:[CCRepeat actionWithAction:[CCAnimate actionWithAnimation:gloopAnimation restoreOriginalFrame:NO] times:2],[CCCallFuncN actionWithTarget:self selector:@selector(removeAnim:)],[CCCallFunc actionWithTarget:self selector:@selector(playFinishVideo)],nil]];
		
		return;
	}
	
	NSString * sound = nil;
	if(!bashoDirected)
	{
		
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
	}else {
		
		itemNeeded = [btnImgs objectAtIndex:bashoSelectedSound];
		colorNeededNumber = arc4random() % 4;
		colorNeeded = [btnColor objectAtIndex:colorNeededNumber];
		
		sound = [NSString stringWithFormat:@"dress_snd_%@_%@_where.mp3",itemNeeded,colorNeeded];
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
	[viewController goToMenu];
}

- (void) onEnter
{
	[super onEnter];
	[[UIAccelerometer sharedAccelerometer] setUpdateInterval:(1.0 / 60)];
	
}

-(void)onShake
{
	[[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.5 scene: [GameDressScene_iPad sceneWithDressVC:viewController bashoDirected:bashoDirected] withColor:ccWHITE]];

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
	[lastAcceleration release];
	[btnImgs release];
	[btnColor release];
	[dressPieces release];
	[ddElements release];
	[super dealloc];
}

@end
