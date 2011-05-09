//
//  GameWheel_both.m
//  Basho
//
//  Created by Pablo Ruiz on 03/03/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GameWheelScene_both.h"

#import "SimpleAudioEngine.h"
#import "GameManager.h"


@implementation NSMutableArray (Shuffling)

- (void)shuffle
{
    
    NSUInteger count = [self count];
    for (NSUInteger i = 0; i < count; ++i) {
        // Select a random element between i and end of array to swap with.
        int nElements = count - i;
        int n = (arc4random() % nElements) + i;
        [self exchangeObjectAtIndex:i withObjectAtIndex:n];
    }
}

@end


@implementation GameWheelScene_both

-(void)loadDeviceType
{
	//******** Iphone / iPad conditionals ************//
	isInIpad = NO;
#ifdef UI_USER_INTERFACE_IDIOM
	isInIpad = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad);
#endif	
	if(isInIpad)
	{
		iPad = @"_iPad";
	}else {
		iPad = @"";
	}
	//*************************************************//
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
		NSString *moviePath = [bundle pathForResource:@"Puntos_iPad" ofType:@"mov"];
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

-(void)nextGame
{
	[viewController goToNextGame];
}


-(void)turnSounds
{
	GameManager * gm = [GameManager sharedGameManager];
	[gm turnSounds];
}

-(void)turnBasho
{
	bashoDirected = !bashoDirected;
	
	//[self makeScoreAppear:bashoDirected];
	if(bashoDirected)
	{
		points = 0;
		CCLabelTTF * scoreLbl = [self getChildByTag:kSCORE];
		[scoreLbl setString:@"0"];
		[bashoSelectedItems removeAllObjects];
		[bashoSelectedItems addObject:[NSNumber numberWithInt:0]];
		[bashoSelectedItems addObject:[NSNumber numberWithInt:1]];
		[bashoSelectedItems addObject:[NSNumber numberWithInt:2]];
		[bashoSelectedItems addObject:[NSNumber numberWithInt:3]];
		[bashoSelectedItems addObject:[NSNumber numberWithInt:4]];
		[bashoSelectedItems addObject:[NSNumber numberWithInt:5]];
		[bashoSelectedItems addObject:[NSNumber numberWithInt:6]];
		[bashoSelectedItems addObject:[NSNumber numberWithInt:7]];
		
		[self selectItemForBasho];
	}else {
		for (CCMenuItemImage * m in [tapButtons children])
		{
			[m setIsEnabled:YES];
			m.opacity =255;
			
		}
	}

}

-(void)showPoints
{
	[self playFinishVideo];
	/*CCMenuItemImage * backBtn2 = [CCMenuItemImage itemFromNormalImage:@"wheel_home_iPad.png" selectedImage:@"wheel_home_iPad.png" target:self selector:@selector(goBack)];
	[backBtn2 setScale:5];
		
	CCMenu * menu = [CCMenu menuWithItems:backBtn2,nil];
	[self addChild:menu];
	[backBtn2 setPosition:ccp(500,500)];
	[menu setPosition:ccp(0,0)];*/
	
	//[self goBack];
}

-(void)selectItemForBasho
{	
	currentAttempts =0;
	
	int indexBashoSelectedSound = arc4random() %[bashoSelectedItems count];
	bashoSelectedSound = [[bashoSelectedItems objectAtIndex:indexBashoSelectedSound] intValue];
    NSString * sound = [NSString stringWithFormat:@"wheel_snd_%@_where.mp3",[[buttonsData objectAtIndex:bashoSelectedSound] objectForKey:@"image"]];
	[bashoSelectedItems removeObjectAtIndex:indexBashoSelectedSound];
    
    
	if([GameManager sharedGameManager].soundsEnabled)
		[[SimpleAudioEngine sharedEngine] playEffect:sound];
}

-(void)makeScoreAppear:(BOOL)appear
{
	CCLabelTTF * scoreLbl = [self getChildByTag:kSCORE];
	if(appear)
		[scoreLbl setOpacity:255];
	else
		[scoreLbl setOpacity:0];
	
}

-(void)loadButtons
{
	bashoSelectedItems = [[NSMutableArray array]retain];
		
	/*NSMutableArray * btnImgs = [NSMutableArray arrayWithCapacity:8];
	[btnImgs addObject:BTN_BACKPACK];
	[btnImgs addObject:BTN_BOOTS];
	[btnImgs addObject:BTN_HAT];
	[btnImgs addObject:BTN_PHONE];
	[btnImgs addObject:BTN_JACKET];
	[btnImgs addObject:BTN_NECKLACE];
	[btnImgs addObject:BTN_PANTS];
	[btnImgs addObject:BTN_SUNGLASSES];
	*/
	
	NSMutableArray * btnPos = [self loadBtnPos];
	
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"WheelItems" ofType:@"plist"];
	buttonsData = [[[NSMutableDictionary dictionaryWithContentsOfFile:filePath]objectForKey:@"items"]retain];
    
    [buttonsData shuffle];
	
	tapButtons = [CCMenu menuWithItems:nil];
	for (int i = 0;i<8;i++)
	{
        NSString * btnName = [[buttonsData objectAtIndex:i] objectForKey:@"image"];
		NSString * btnImg = [NSString stringWithFormat:@"wheel_btn_%@%@.png",btnName,iPad];
		NSString * btnImgSel = [NSString stringWithFormat:@"wheel_btn_%@_dwn%@.png",btnName,iPad];
		
		CCMenuItemImage * btn = [CCMenuItemImage itemFromNormalImage:btnImg selectedImage:btnImgSel disabledImage:btnImgSel target:self selector:@selector(makeDinoSpin:)];
		[tapButtons addChild:btn z:1 tag:i];
		btn.position = ccp([[[btnPos objectAtIndex:i] objectForKey:@"x"] intValue],[[[btnPos objectAtIndex:i] objectForKey:@"y"] intValue]);
        btn.userData = [buttonsData objectAtIndex:i];
	}
	[self addChild:tapButtons];
	[tapButtons setPosition:ccp(0,0)];
}

-(void)listenSound:(CCMenuItemImage *)btn
{
	if(playingSound || dinoSpinning) return;
	
	
	[btn setIsEnabled:NO];
	
	NSString * word = nil;
	NSString * bashoDirectedWrongSound = nil;
	NSString * sound = nil;
	
	playingSound = YES;
	[self runAction:[CCSequence actions:[CCDelayTime actionWithDuration:2.5],[CCCallFunc actionWithTarget:self selector:@selector(stopPlayingSound)],nil]];
   
    NSMutableDictionary * userData = (NSMutableDictionary *)btn.userData;
    word =[NSMutableString stringWithFormat:@"%@",[userData objectForKey:@"espText"]];
    bashoDirectedWrongSound =[NSMutableString stringWithFormat:@"wheel_snd_%@_wrong.mp3",[userData objectForKey:@"image"]];
    sound =[NSMutableString stringWithFormat:@"wheel_snd_%@.mp3",[userData objectForKey:@"image"]];
    
	if(!bashoDirected)
	{
		if([GameManager sharedGameManager].soundsEnabled)
			[[SimpleAudioEngine sharedEngine] playEffect:sound];
		[self showPalabra:word];
	}else {
		
		if(bashoSelectedSound == selectedSound )
		{
			[self addPoints:kPointsAwarded - currentAttempts];
			
			if(maxedAttemps)
			{
				maxedAttemps = NO;
				currentAttempts = 0;
			}
			
			if([GameManager sharedGameManager].soundsEnabled)
				[[SimpleAudioEngine sharedEngine] playEffect:sound];
			[self showPalabra:word];
			
			[btn setIsEnabled:NO];
			[btn setOpacity:90];
			
			if([bashoSelectedItems count]==0)
			{
				[[GameManager sharedGameManager] unlockGame:3];
				[self runAction:[CCSequence actions:[CCDelayTime actionWithDuration:1],[CCCallFunc actionWithTarget:self selector:@selector(showPoints)],nil]];
			}else
				[self runAction:[CCSequence actions:[CCDelayTime actionWithDuration:1],[CCCallFunc actionWithTarget:self selector:@selector(selectItemForBasho)],nil]];
			
		}else {
			currentAttempts ++;
			if([GameManager sharedGameManager].soundsEnabled)
				[[SimpleAudioEngine sharedEngine] playEffect:bashoDirectedWrongSound];
		}
		
	}
	
}

-(void)addPoints:(int)_points
{
	points += _points;
	CCLabelTTF * scoreLbl = [self getChildByTag:kSCORE];
	[scoreLbl setString:[NSString stringWithFormat:@"%d",points]];
}

-(void)showPalabra:(NSString *)word
{
	CCLabelTTF * palabra = [self getChildByTag:kPALABRA];
	[palabra setString:word];
	[palabra runAction:[CCFadeIn actionWithDuration:0.8]];
    CCSprite * palabraBck = [self getChildByTag:kPALABRABCK];
	[palabraBck runAction:[CCFadeIn actionWithDuration:0.8]];
}

-(void)stopPlayingSound
{
	playingSound = NO;
	for (CCMenuItemImage * m in [tapButtons children])
	{
		if(m.opacity ==255 && [m isKindOfClass:[CCMenuItemImage class]])
		{
			[m setIsEnabled:YES];
		}
	}
	CCLabelTTF * palabra = [self getChildByTag:kPALABRA];
	[palabra setOpacity:0];
    CCSprite * palabraBck = [self getChildByTag:kPALABRABCK];
	[palabraBck setOpacity:0];
	
	if(currentAttempts >=5)
	{
		maxedAttemps = YES;
		[self makeDinoSpin2:bashoSelectedSound];
	}
}


-(void)makeDinoSpin:(CCMenuItemImage *)btn
{
	if(playingSound || dinoSpinning) return;
	
	[btn setIsEnabled:NO];
	selectedSound = btn.tag;
	[self makeDinoSpin2:selectedSound];
}

-(void)makeDinoSpin2:(int)_selectedSound
{	
	int rotTime = 3;
	int rotAngle =720;
	if(_selectedSound == -1)
	{
		selectedSound = arc4random() %8;
	}else
	{
		rotTime = 1;
		rotAngle = 360;
		selectedSound= _selectedSound;
	}
	int randAngle = rotAngle + (45 *(selectedSound));
	
	if(!dinoSpinning && !playingSound)
	{
		[dino runAction:[CCSequence actions:[CCEaseSineInOut actionWithAction:[CCRotateTo actionWithDuration:rotTime angle:randAngle]],[CCCallFunc actionWithTarget:self selector:@selector(stopSpinning)],nil]];
		dinoSpinning = YES;
	}
}

-(void)stopSpinning
{
    float offset = 22.5;
    float angle = dino.rotation;
    int loops = 0;
    
    float realDinoAngle = 0;
    if(angle >= 0)
    {
        loops = (int)floor(angle / 360);
        realDinoAngle = angle - (loops * 360);
    }else
    {
        loops = (int)ceil(angle / 360);
        realDinoAngle = 360 + (angle - (loops * 360));
    }
    NSLog(@"realAngle %.2f",realDinoAngle);
    if((realDinoAngle >0 && realDinoAngle <=offset) || (realDinoAngle<360 && realDinoAngle >360-offset))
        selectedSound =0;
    else if(realDinoAngle >45-offset && realDinoAngle <=90-offset)
        selectedSound =1;
    if(realDinoAngle >90-offset && realDinoAngle <=135-offset)
        selectedSound =2;
    if(realDinoAngle >135-offset && realDinoAngle <=180-offset)
        selectedSound =3;
    if(realDinoAngle >180-offset && realDinoAngle <=225-offset)
        selectedSound =4;
    if(realDinoAngle >225-offset && realDinoAngle <=270-offset)
        selectedSound =5;
    if(realDinoAngle >270-offset && realDinoAngle <=315-offset)
        selectedSound =6;
    if(realDinoAngle >315-offset && realDinoAngle <=360-offset)
        selectedSound =7;
    
	dinoSpinning = NO;
	[self listenSound:[tapButtons getChildByTag:selectedSound]];
	
}

-(void)goBack
{
	[viewController goToMenu];
}

-(void)goSettings
{
    [viewController goToSettings];
}

-(void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInView: [touch view]];
    location = [[CCDirector sharedDirector] convertToGL: location];	
	//if (bashoDirected) return;
    if(dinoSpinning) return;
    
	dinoSpinning = YES;
	//[self makeDinoSpin2:-1];
    [self schedule:@selector(updateTime) interval:0.3];
    
	forceApplied=0;
	initPoint=location;
	
	fromMovement=YES;
	
	actualAngle = CC_RADIANS_TO_DEGREES(-(atan2(location.y-dino.position.y,location.x-dino.position.x)));
	
	initialAngle=0;
	
	isDragging=YES;
}

/*- (void)ccTouchesMoved:(UITouch *)touches withEvent:(UIEvent *)event
{
	[dino stopAllActions];
	
	UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInView: [touch view]];
    location = [[CCDirector sharedDirector] convertToGL: location];	
	
	float angle = CC_RADIANS_TO_DEGREES(-(atan2(location.y - dino.position.y, location.x - dino.position.x)));
	
	isDragging=YES;
	
	dino.rotation =dino.rotation - (actualAngle-angle);
	
	actualAngle = angle;
	
}*/

- (void)ccTouchesEnded:(UITouch *)touches withEvent:(UIEvent *)event
{		
	UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInView: [touch view]];
    location = [[CCDirector sharedDirector] convertToGL: location];	
	
	isDragging=NO;
	
	float distance = abs((initPoint.x-location.x) + (initPoint.y-location.y));
    
	CGPoint aux = ccpNormalize(ccp(location.x-initPoint.x,location.y-initPoint.y));
    
	int dir=0;
    
	if (fabsl(aux.x) >= fabsl(aux.y))
	{
		if (aux.x>=0) {
			dir=1;
		}
		else {
			dir=2;
		}
	}
	else {
		if (aux.y>=0) {
			dir=3;
		}
		else {
			dir=4;
		}
	}
    
	if (dir==1)
	{
		distance=-distance;
	}	
	
	if ((dir==1||dir==2)&&(initPoint.y>=dino.position.y)) {
		distance=-distance;
	}
	
	if (dir==3)
	{
		distance=-distance;
	}	
	
	if ((dir==3||dir==4)&&(initPoint.x<=dino.position.x)) {
		distance=-distance;
	}
	
	if (abs(forceApplied)<5000&&time==0) {
		
		if (abs(forceApplied)<abs(forceApplied + (distance*10))&&abs(distance)>10) {
			//[[PhantomAppDelegate get] playSound:@"fizz.caf"];
		}
		
		forceApplied = forceApplied + (distance*20);
		
	}
	
	[self unschedule:@selector(updateTime)];
	time=0;
	
}


- (void)update:(ccTime)dt
{
    float prevForceApplied = forceApplied;

	if (forceApplied==0) {
		return;
	}
	
	if (forceApplied>0) {
		forceApplied=forceApplied-friction;
		
		if (forceApplied==0&&fromMovement) {
			forceApplied=forceApplied-800;
			fromMovement=NO;
		}
	}
	else {
		forceApplied=forceApplied+friction;
		
		if (forceApplied==0&&fromMovement) {
			forceApplied=forceApplied+800;
			fromMovement=NO;
		}
	}	
	
	dino.rotation=dino.rotation+(0.001*forceApplied);
	
    if((prevForceApplied >0 && forceApplied <0) || (prevForceApplied<0 && forceApplied >0))
    {
        forceApplied = 0;
        NSLog(@"stopped at %.2f !",dino.rotation);
    
        [self stopSpinning];
    }
}

-(void)pushLever
{
	forceApplied = 13800 + arc4random() % 6000;;
}

-(void)loadSpinningStuff
{
    friction=0;
    
    time=0;
    
    isDragging=NO;
    
    forceApplied=0;
    clockWise=YES;
    
    fromMovement=YES;
    
    [self schedule:@selector(startFriction) interval:2];
    
    [self scheduleUpdate];
    

}

-(void)startFriction {
	[self unschedule:@selector(startFriction)];
	friction=201;
}

-(void)updateTime {
	time++;
}

- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children (Label)
	
	// don't forget to call "super dealloc"
	[bashoSelectedItems release];
    [buttonsData release];
	[super dealloc];
}

@end
