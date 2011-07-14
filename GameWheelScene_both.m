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

@synthesize leverArea,orig;

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
		iPad = @"_iPhone";
	}
	//*************************************************//
}

-(void)loadVideo
{
	
}

-(void)skipMovie
{
	videoTaps++;
	[self performSelector:@selector(reduceVideoTaps) withObject:nil afterDelay:0.5];
	if(videoTaps ==2)
	{
		[GameManager sharedGameManager].onPause = NO;
		[[NSNotificationCenter defaultCenter] removeObserver:self
														name:MPMoviePlayerPlaybackDidFinishNotification object:introVideo];
		[introVideo stop];
		[introVideo.view removeFromSuperview];
		[introVideo release];
        
        if ([GameManager sharedGameManager].musicAudioEnabled) {
            [[SimpleAudioEngine sharedEngine] resumeBackgroundMusic];
        }

        [GameManager sharedGameManager].onPause = NO;
        
        if(videoFromLoadingScene)
        {
            [self beginGame];
            videoFromLoadingScene = NO;
        }
	}
}

-(void)beginGame{
    
}


-(void)reduceVideoTaps
{
	videoTaps =0;
}

-(void) videoPlayerDidFinishPlaying: (NSNotification*)aNotification
{
	[GameManager sharedGameManager].onPause = NO;
	MPMoviePlayerController * introVideoFPly = [aNotification object];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerPlaybackDidFinishNotification object:introVideoFPly];
	[introVideo stop];
	[introVideo.view removeFromSuperview];
	[introVideo release];
    
    if ([GameManager sharedGameManager].musicAudioEnabled) {
        [[SimpleAudioEngine sharedEngine] resumeBackgroundMusic];
    }

    [GameManager sharedGameManager].onPause = NO;
    if(videoFromLoadingScene)
    {
        [self beginGame];
        videoFromLoadingScene = NO;
    }
}

-(void)turnSounds
{
	if([GameManager sharedGameManager].onPause) return; 
	GameManager * gm = [GameManager sharedGameManager];
	[gm turnSounds];
}

-(void)turnBasho
{
	if([GameManager sharedGameManager].onPause) return; 
	bashoDirected = !bashoDirected;
	
	forceApplied = 0;
	dinoSpinning = NO;
	//[self makeScoreAppear:bashoDirected];
	if(bashoDirected)
	{
		friction = 0;
		points = 0;
		CCLabelTTF * scoreLbl = (CCLabelTTF*)[self getChildByTag:kSCORE];
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
		
		[self autoPushLever:NO];
	}else {
		friction =51;
		forceApplied = 0;
		for (CCMenuItemImage * m in [tapButtons children])
		 {
			 [m setIsEnabled:YES];
			 m.opacity =255;
			 
		 }
	}

}

-(void)resetTapButtons
{   
    if ([GameManager sharedGameManager].musicAudioEnabled) {
        [[SimpleAudioEngine sharedEngine] resumeBackgroundMusic];
    }
    
	for (CCMenuItemImage * m in [tapButtons children])
	{
		[m setIsEnabled:YES];
		m.opacity =255;
		
	}
	
	[bashoSelectedItems removeAllObjects];
	[bashoSelectedItems addObject:[NSNumber numberWithInt:0]];
	[bashoSelectedItems addObject:[NSNumber numberWithInt:1]];
	[bashoSelectedItems addObject:[NSNumber numberWithInt:2]];
	[bashoSelectedItems addObject:[NSNumber numberWithInt:3]];
	[bashoSelectedItems addObject:[NSNumber numberWithInt:4]];
	[bashoSelectedItems addObject:[NSNumber numberWithInt:5]];
	[bashoSelectedItems addObject:[NSNumber numberWithInt:6]];
	[bashoSelectedItems addObject:[NSNumber numberWithInt:7]];
	
	[self autoPushLever:NO];
}


-(void)selectItemForBashoAlreadySelected
{	
	GameManager * gm = [GameManager sharedGameManager];
	NSString * sound = [NSString stringWithFormat:@"wheel_snd_%@_where_%@.mp3",[[buttonsData objectAtIndex:bashoSelectedSound] objectForKey:@"image"],[gm languageString]];
	
	if([GameManager sharedGameManager].soundsEnabled)
		[[SimpleAudioEngine sharedEngine] playEffect:sound];
}

-(void)selectItemForBasho
{	
	GameManager * gm = [GameManager sharedGameManager];

	currentAttempts =0;
	
	int indexBashoSelectedSound = arc4random() %[bashoSelectedItems count];
	bashoSelectedSound = [[bashoSelectedItems objectAtIndex:indexBashoSelectedSound] intValue];
    NSString * sound = [NSString stringWithFormat:@"wheel_snd_%@_where_%@.mp3",[[buttonsData objectAtIndex:bashoSelectedSound] objectForKey:@"image"],[gm languageString]];
	[bashoSelectedItems removeObjectAtIndex:indexBashoSelectedSound];
    
    
	if([GameManager sharedGameManager].soundsEnabled)
		[[SimpleAudioEngine sharedEngine] playEffect:sound];
}

-(void)makeScoreAppear:(BOOL)appear
{
	CCLabelTTF * scoreLbl = (CCLabelTTF*)[self getChildByTag:kSCORE];
	if(appear)
		[scoreLbl setOpacity:255];
	else
		[scoreLbl setOpacity:0];
	
}


-(void)loadButtons
{
	bashoSelectedItems = [[NSMutableArray array]retain];
	
	NSMutableArray * btnPos = [self loadBtnPos];
	
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"WheelItems" ofType:@"plist"];
	buttonsData = [[[NSMutableDictionary dictionaryWithContentsOfFile:filePath]objectForKey:@"items"]retain];
    
	//[buttonsData shuffle];
	
	tapButtons = [CCMenu menuWithItems:nil];
	for (int i = 0;i<8;i++)
	{
        NSString * btnName = [[buttonsData objectAtIndex:i] objectForKey:@"image"];
		NSString * btnImg = [NSString stringWithFormat:@"wheel_btn_%@%@.png",btnName,iPad];
		NSString * btnImgSel = [NSString stringWithFormat:@"wheel_btn_%@_dwn%@.png",btnName,iPad];
		
		CCMenuItemImage * btn = [CCMenuItemImage itemFromNormalImage:btnImg selectedImage:btnImgSel disabledImage:btnImgSel target:self selector:@selector(playBtnEffect:)];
		[tapButtons addChild:btn z:1 tag:i];
		btn.position = ccp([[[btnPos objectAtIndex:i] objectForKey:@"x"] intValue],[[[btnPos objectAtIndex:i] objectForKey:@"y"] intValue]);
        btn.userData = [buttonsData objectAtIndex:i];
	}
	[self addChild:tapButtons];
	[tapButtons setPosition:ccp(0,0)];
}

-(void)listenSound:(CCMenuItemImage *)btn withWord:(BOOL)withWord
{
	if([GameManager sharedGameManager].onPause) return; 
	if((playingSound && !bashoDirected) || (dinoSpinning && !bashoDirected)) return;
	
	//[btn setIsEnabled:NO];
	
	NSString * word = nil;
	NSString * bashoDirectedWrongSound = nil;
	NSString * sound = nil;
	NSString * wordSound = nil;
	
	playingSound = YES;
	[self runAction:[CCSequence actions:[CCDelayTime actionWithDuration:2],[CCCallFunc actionWithTarget:self selector:@selector(stopPlayingSound)],nil]];
   
    NSMutableDictionary * userData = (NSMutableDictionary *)btn.userData;
    word =[NSMutableString stringWithFormat:@"%@",[userData objectForKey:[NSString stringWithFormat:@"%@Text",[GameManager sharedGameManager].languageString]]];
    bashoDirectedWrongSound =[NSMutableString stringWithFormat:@"wheel_snd_%@_wrong.mp3",[userData objectForKey:@"image"]];
    //sound =[NSMutableString stringWithFormat:@"wheel_snd_%@_%@.mp3",[userData objectForKey:@"image"],[gm languageString]];
	sound =[NSMutableString stringWithFormat:@"wheel_snd_%@_sfx.mp3",[userData objectForKey:@"image"]];
	
	
	if(withWord)
		wordSound =[[NSMutableString stringWithFormat:@"wheel_snd_%@_%@.mp3",[userData objectForKey:@"image"],[GameManager sharedGameManager].languageString]retain];
	
	if(!bashoDirected)
	{
		[self playAnimForAnimal:btn];
		if([GameManager sharedGameManager].soundsEnabled)
			[[SimpleAudioEngine sharedEngine] playEffect:sound];
		[self showPalabra:word sound:wordSound];
	}else {
		
		if(bashoSelectedSound == selectedSound )
		{
			pressedDinoToHalt = NO;
			[self addPoints:kPointsAwarded - currentAttempts];
			
			if(maxedAttemps)
			{
				maxedAttemps = NO;
				currentAttempts = 0;
			}
			
			if([GameManager sharedGameManager].soundsEnabled)
			{
				if(bashoDirected)
				{
					[self playAnimForAnimal:btn];
					[[SimpleAudioEngine sharedEngine] playEffect:@"RightAnswer.mp3"];
					[[SimpleAudioEngine sharedEngine] playEffect:sound];
				}else {
					[[SimpleAudioEngine sharedEngine] playEffect:sound];
				}

			}
			[self showPalabra:word sound:wordSound];
			
			[btn setIsEnabled:NO];
			[btn setOpacity:90];
			
			if([bashoSelectedItems count]==0)
			{
				//ANIMATE CHARACTERS
				[self runAction:[CCSequence actions:[CCDelayTime actionWithDuration:2],[CCCallFunc actionWithTarget:self selector:@selector(animateAllAnimals)],nil]];
				[self runAction:[CCSequence actions:[CCDelayTime actionWithDuration:5],[CCCallFunc actionWithTarget:self selector:@selector(resetTapButtons)],nil]];
			}else
			{
				dinoSpinning = NO;
				[self runAction:[CCSequence actions:[CCDelayTime actionWithDuration:2.5],[CCCallFunc actionWithTarget:self selector:@selector(autoPushLeverFromAction)],nil]];
			}
		}else {
			[self playAnimForAnimal:btn];
			[[SimpleAudioEngine sharedEngine] playEffect:sound];
			currentAttempts ++;
			if([GameManager sharedGameManager].soundsEnabled)
			{
				[[SimpleAudioEngine sharedEngine] playEffect:@"WrongAnswer.mp3"];
                if (isAnsweredbyButton) {
                    isAnsweredbyButton = NO;
                    [self performSelector:@selector(selectItemForBashoAlreadySelected) withObject:nil afterDelay:2];
                }
				//[[SimpleAudioEngine sharedEngine] playEffect:bashoDirectedWrongSound];
			}
			dinoSpinning = NO;
			//[self autoPushLever:YES];
		}
		
	}
	
}

-(void)playAnimForAnimal:(CCMenuItemImage *)btn
{   
    float posX =512 , posY = 384;
    
    if ([iPad rangeOfString:@"_iPhone"].location != NSNotFound) {
        posX = 240;
        posY = 160;
    }
    
	NSMutableDictionary * userData = (NSMutableDictionary *)btn.userData;
	NSString * animal = [userData objectForKey:@"image"];
	int framesNum = [[userData objectForKey:@"frames"] intValue];
	
	[btn setVisible:NO];
	
	CCSprite * itemAnim = [CCSprite spriteWithSpriteFrameName:[NSString stringWithFormat:@"SeeNSay_%@_ANIM_00000.png",animal]];
	[animalAnimSB addChild:itemAnim];
	[itemAnim setPosition:ccp(posX,posY)];
	
	NSMutableArray *animFrames = [NSMutableArray array];
	for(int i = 0; i <= framesNum; i++) {
		
		CCSpriteFrame *frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"SeeNSay_%@_ANIM_%05d.png",animal,i]];
		[animFrames addObject:frame];
	}
	
	CCAnimation *animation = [CCAnimation animationWithFrames:animFrames];
    
	[itemAnim runAction:[CCSequence actions:[CCAnimate actionWithDuration:1 animation:animation restoreOriginalFrame:NO],[CCCallFuncND actionWithTarget:self selector:@selector(removeAnimalsAnim: data:) data:(void *)btn],nil]];
	
}

-(void)removeAnimalsAnim:(CCNode *)n data:(void*)data
{
	CCMenuItemImage * btn = (CCMenuItemImage *)data;
	[btn setVisible:YES];
	[n.parent removeChild:n cleanup:YES];
}

-(void)animateAllAnimals
{
	if([GameManager sharedGameManager].soundsEnabled)
	{
		[[SimpleAudioEngine sharedEngine] pauseBackgroundMusic];
		[[SimpleAudioEngine sharedEngine] playEffect:@"allanimals-sfx.mp3"];
	}
	
	for(CCMenuItemImage * m in [tapButtons children])
	{   
		[self playAnimForAnimal:m];
	}
}

-(void)addPoints:(int)_points
{
	points += _points;
	CCLabelTTF * scoreLbl = (CCLabelTTF*)[self getChildByTag:kSCORE];
	[scoreLbl setString:[NSString stringWithFormat:@"%d",points]];
}

-(void)showPalabra:(NSString *)word sound:(NSString *)wordSound
{
	if(wordSound)
	{
		CCLabelTTF * palabra = (CCLabelTTF*)[self getChildByTag:kPALABRA];
		[palabra setString:word];
		[palabra runAction:[CCSequence actions:[CCDelayTime actionWithDuration:1.8],[CCFadeIn actionWithDuration:0.8],nil]];
		CCSprite * palabraBck = (CCSprite*)[self getChildByTag:kPALABRABCK];
		[palabraBck runAction:[CCSequence actions:[CCDelayTime actionWithDuration:1.8],[CCFadeIn actionWithDuration:0.8],nil]];
		
		[self runAction:[CCSequence actions:[CCDelayTime actionWithDuration:1.8],[CCCallFuncND actionWithTarget:self selector:@selector(playWordSound: data:)data:(void*)wordSound],nil]];
	}
}

-(void)playWordSound:(CCLayer *)l data:(void *)data
{	
	NSString * wordSound = (NSString *)data;
	if([GameManager sharedGameManager].soundsEnabled && wordSound)
		[[SimpleAudioEngine sharedEngine] playEffect:wordSound];
	[wordSound release];
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
	CCLabelTTF * palabra = (CCLabelTTF*)[self getChildByTag:kPALABRA];
	[palabra runAction:[CCSequence actions:[CCDelayTime actionWithDuration:1.5],[CCFadeTo actionWithDuration:0.5 opacity:0],nil]];
    CCSprite * palabraBck = (CCSprite*)[self getChildByTag:kPALABRABCK];
	[palabraBck runAction:[CCSequence actions:[CCDelayTime actionWithDuration:1.5],[CCFadeTo actionWithDuration:0.5 opacity:0],nil]];

	
	/*if(currentAttempts >=5)
	{
		maxedAttemps = YES;
		[self makeDinoSpin2:bashoSelectedSound];
	}*/
}

-(void)playBtnEffect:(CCMenuItemImage *)btn
{
	stopWhenRotationReached = NO;
	if(stopWhenRotationReached ||playingSound || (dinoSpinning && !bashoDirected)) return;
	
	//[btn setIsEnabled:NO];
	selectedSound = btn.tag;
	
	if(bashoDirected && bashoSelectedSound == selectedSound)
	{
		stopWhenRotationReached = YES;
		//forceApplied = 0;
	}else {
        isAnsweredbyButton = YES;
		[self listenSound:(CCMenuItemImage *)[tapButtons getChildByTag:selectedSound] withWord:NO];
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

-(float)getAngleForButton
{
	float offset = 22.5;
    
	switch (selectedSound) {
		case 0:
			return 1;
			break;
		case 1:
			return 45+offset;
			break;
		case 2:
			return 90+offset;
			break;
		case 3:
			return 135+offset;
			break;
		case 4:
			return 180+offset;
			break;
		case 5:
			return 225+offset;
			break;
		case 6:
			return 270+offset;
			break;
		case 7:
			return 315+offset;
			break;
	}
    
    return 0;
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
	[self listenSound:(CCMenuItemImage*)[tapButtons getChildByTag:selectedSound] withWord:YES];
	
}

-(void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInView: [touch view]];
    location = [[CCDirector sharedDirector] convertToGL: location];	
    
	canDragDino = YES;
	//if (bashoDirected) return;
    if(dinoSpinning)
	{
		if(CGRectContainsPoint([dino boundingBox],location) && !stopWhenRotationReached)
		{
			[self stopLoopSpinEffect];
			canDragDino = NO;
			forceApplied = 0;
			dinoSpinning = NO;
			pressedDinoToHalt = YES;
			if(bashoDirected)
				[self stopSpinning];
		}
		return;
		
	}
	if(playingSound)return;
	if([GameManager sharedGameManager].onPause) return; 
	
	if(CGRectContainsPoint([leverBtn boundingBox], location) && !bashoDirected) 
	{
		couldBeginTouch = YES;
		beganDraggingLever = YES;
		return;
    }
	
	dinoSpinning = YES;
	//[self makeDinoSpin2:-1];
    [self schedule:@selector(updateTime) interval:0.3];
    
	forceApplied=0;
	initPoint=location;
	
	fromMovement=YES;
	
	actualAngle = CC_RADIANS_TO_DEGREES(-(atan2(location.y-dino.position.y,location.x-dino.position.x)));
	
	initialAngle=0;
	
	isDragging=YES;
	wasDragging = YES;
	
	
}

- (void)ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
	//[dino stopAllActions];
	if(dinoSpinning)
	{
		return ;
	}
	UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInView: [touch view]];
    location = [[CCDirector sharedDirector] convertToGL: location];	
	
	if(CGRectContainsPoint(leverArea, location) && beganDraggingLever)
	{
		//leverBtn.position = ccp(leverBtn.position.x, location.y);
		//CGPoint orig = ccp(512,384);
		CGPoint finalVect = ccp(location.x-orig.x,location.y-orig.y);
		
		float angle = atan2(-finalVect.y,finalVect.x);
		
		leverImg.rotation = CC_RADIANS_TO_DEGREES(angle);
		//NSLog(@"%.2f",leverImg.rotation);
		if(leverImg.rotation < -26) leverImg.rotation = -26;
		if(leverImg.rotation > 32) leverImg.rotation = 32;
	}else if(canDragDino && !bashoDirected && !beganDraggingLever){
		float angle = CC_RADIANS_TO_DEGREES(-(atan2(location.y - dino.position.y, location.x - dino.position.x)));
		
		isDragging=YES;
		
		dino.rotation =dino.rotation - (actualAngle-angle);
		
		actualAngle = angle;
	}

	
}


- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{	
	UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInView: [touch view]];
    location = [[CCDirector sharedDirector] convertToGL: location];	
	
	if(pressedDinoToHalt)
	{
		pressedDinoToHalt = NO;
		if(bashoDirected)
			[self autoPushLever:YES];
			
	}
	
	if(!canDragDino)
		return;
		
	if(beganDraggingLever)
	{   
        beganDraggingLever = NO;
		if([GameManager sharedGameManager].soundsEnabled)
			[[SimpleAudioEngine sharedEngine] playEffect:@"lever-sfx.mp3"];
		
		if(leverImg.rotation > -25)
		{
			[self pushLever];
			return;
		}else {
			[leverImg runAction:[CCRotateTo actionWithDuration:0.5 angle:-25]];
			return;
		}

	}
	
	if(dinoSpinning) return;
	if(playingSound)return;
	if([GameManager sharedGameManager].onPause) return;
	
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
		
		forceApplied = forceApplied + (distance*100);
		if(forceApplied > 15000)
			forceApplied =15000;
		if(forceApplied < -15000)
			forceApplied = -15000;
		
	}
	
	[self playLoopSpinEffect];
	[self schedule:@selector(playLoopSpinEffect) interval:8];
	
	[self unschedule:@selector(updateTime)];
	time=0;
	couldBeginTouch = NO;
}


- (void)update:(ccTime)dt
{
    float prevForceApplied = forceApplied;
	
	if(stopWhenRotationReached)
	{
		float rot = [self getAngleForButton];
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
		
		if(realDinoAngle - rot <20 && realDinoAngle - rot >-20)
		{
			forceApplied =0;
			stopWhenRotationReached = NO;
			[self listenSound:(CCMenuItemImage *)[tapButtons getChildByTag:selectedSound] withWord:YES];
		}
	}

	if (forceApplied==0) {
		[self stopLoopSpinEffect];
		dinoSpinning = NO;
		return;
	}else {
		dinoSpinning = YES;
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
    
		if(wasDragging)
		{
			[self stopLoopSpinEffect];
			wasDragging = NO;
			//[self stopSpinning];
		}
    }
}

-(void)pushLever
{
	if([GameManager sharedGameManager].onPause) return; 
	if(!dinoSpinning)
	{   
		dinoSpinning = YES;
		[self stopSpinning];
        if (leverImg.rotation >= 25) {
            [leverImg runAction:[CCSequence actions:[CCCallFunc actionWithTarget:self selector:@selector(pushLever2)],[CCRotateTo actionWithDuration:3 angle:-25],nil]];
        }
        else {
            [leverImg runAction:[CCSequence actions:[CCRotateTo actionWithDuration:0.8 angle:32],[CCCallFunc actionWithTarget:self selector:@selector(pushLever2)],[CCRotateTo actionWithDuration:3 angle:-25],nil]];
        }
	}
}

-(void)autoPushLeverAlready
{
	if([GameManager sharedGameManager].onPause) return; 
	if(!dinoSpinning)
	{
		dinoSpinning = YES;
		[leverImg runAction:[CCSequence actions:[CCRotateTo actionWithDuration:0.8 angle:32],[CCCallFunc actionWithTarget:self selector:@selector(selectItemForBashoAlreadySelected)],[CCCallFunc actionWithTarget:self selector:@selector(autoPushLever2)],[CCRotateTo actionWithDuration:3 angle:-25],nil]];
	}
}

-(void)autoPushLeverFromAction
{
	[self autoPushLever:NO];
}

-(void)autoPushLever:(BOOL)alreadySelected
{
	if([GameManager sharedGameManager].onPause) return; 
	if(!dinoSpinning)
	{
		dinoSpinning = YES;
		if(alreadySelected)
			[leverImg runAction:[CCSequence actions:[CCCallFunc actionWithTarget:self selector:@selector(selectItemForBashoAlreadySelected)],[CCCallFunc actionWithTarget:self selector:@selector(autoPushLever2)],nil]];
		else
			[leverImg runAction:[CCSequence actions:[CCRotateTo actionWithDuration:0.8 angle:32],[CCCallFunc actionWithTarget:self selector:@selector(selectItemForBasho)],[CCCallFunc actionWithTarget:self selector:@selector(autoPushLever2)],[CCRotateTo actionWithDuration:3 angle:-25],nil]];

	}
}

-(void)pushLever2
{
	[self playLoopSpinEffect];
	[self schedule:@selector(playLoopSpinEffect) interval:8];
	forceApplied = 13800 + arc4random() % 2000;
}

-(void)autoPushLever2
{
	//if([GameManager sharedGameManager].soundsEnabled)
	//	[[SimpleAudioEngine sharedEngine] playEffect:@"lever-sfx.mp3"];
	
	[self playLoopSpinEffect];
	[self schedule:@selector(playLoopSpinEffect) interval:8];

	forceApplied = 7000;
	friction = 0;
}

-(void)playLoopSpinEffect
{
	if([GameManager sharedGameManager].soundsEnabled)
	{
		[[SimpleAudioEngine sharedEngine] stopEffect:spinFxId];
		spinFxId = [[SimpleAudioEngine sharedEngine] playEffect:@"spin-sfx3-updated.mp3"];
	}
}

-(void)stopLoopSpinEffect
{
	[self unschedule:@selector(playLoopSpinEffect)];

	if([GameManager sharedGameManager].soundsEnabled)
		[[SimpleAudioEngine sharedEngine] stopEffect:spinFxId];
	
	[[SimpleAudioEngine sharedEngine] unloadEffect:@"spin-sfx3-updated.mp3"];
}

-(void)loadSpinningStuff
{
	dino.rotation = arc4random() % 360;
    friction=0;
    
    time=0;
    
    isDragging=NO;
    
    forceApplied=0;
    clockWise=YES;
    
    fromMovement=YES;
    
    [self startFriction];
    
    [self scheduleUpdate];
    

}

-(void)startFriction {
	friction=51;
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
	//[SimpleAudioEngine end];
	[self unschedule:@selector(playLoopSpinEffect)];
	[[SimpleAudioEngine sharedEngine] unloadEffect:@"RightAnswer.mp3"];
	[[SimpleAudioEngine sharedEngine] unloadEffect:@"spin-sfx3-updated.mp3"];
	[[SimpleAudioEngine sharedEngine] unloadEffect:@"WrongAnswer.mp3"];
	[[SimpleAudioEngine sharedEngine] unloadEffect:@"lever-sfx.mp3"];
	[[SimpleAudioEngine sharedEngine] unloadEffect:@"allanimals-sfx.mp3"];
	
	for(NSDictionary * dt in buttonsData)
	{
		NSString * sEsp = [NSString stringWithFormat:@"wheel_snd_%@_where_%@.mp3",[dt objectForKey:@"image"],@"esp"];
		[[SimpleAudioEngine sharedEngine] unloadEffect:sEsp];
		NSString * sEng = [NSString stringWithFormat:@"wheel_snd_%@_where_%@.mp3",[dt objectForKey:@"image"],@"eng"];
		[[SimpleAudioEngine sharedEngine] unloadEffect:sEng];
		NSString * sSfx = [NSString stringWithFormat:@"wheel_snd_%@_sfx.mp3",[dt objectForKey:@"image"]];
		[[SimpleAudioEngine sharedEngine] unloadEffect:sSfx];
		NSString * sEsp2 = [NSString stringWithFormat:@"wheel_snd_%@_%@.mp3",[dt objectForKey:@"image"],@"esp"];
		[[SimpleAudioEngine sharedEngine] unloadEffect:sEsp2];
		NSString * sEng2 = [NSString stringWithFormat:@"wheel_snd_%@_%@.mp3",[dt objectForKey:@"image"],@"eng"];
		[[SimpleAudioEngine sharedEngine] unloadEffect:sEng2];
	}

	
	[bashoSelectedItems release];
    [buttonsData release];
	[super dealloc];
}

@end
