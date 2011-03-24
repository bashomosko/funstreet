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

-(void)turnSounds
{
	GameManager * gm = [GameManager sharedGameManager];
	[gm turnSounds];
}

-(void)turnBasho
{
	bashoDirected = !bashoDirected;
	
	[self makeScoreAppear:bashoDirected];
	if(bashoDirected)
	{
		score = 0;
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
	CCMenuItemImage * backBtn2 = [CCMenuItemImage itemFromNormalImage:@"wheel_home_iPad.png" selectedImage:@"wheel_home_iPad.png" target:self selector:@selector(goBack)];
	[backBtn2 setScale:5];
		
	CCMenu * menu = [CCMenu menuWithItems:backBtn2,nil];
	[self addChild:menu];
	[backBtn2 setPosition:ccp(500,500)];
	[menu setPosition:ccp(0,0)];
	
	//[self goBack];
}

-(void)selectItemForBasho
{	
	currentAttempts =0;
	
	int indexBashoSelectedSound = arc4random() %[bashoSelectedItems count];
	bashoSelectedSound = [[bashoSelectedItems objectAtIndex:indexBashoSelectedSound] intValue];
	[bashoSelectedItems removeObjectAtIndex:indexBashoSelectedSound];
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
		
	NSMutableArray * btnImgs = [NSMutableArray arrayWithCapacity:8];
	[btnImgs addObject:BTN_BACKPACK];
	[btnImgs addObject:BTN_BOOTS];
	[btnImgs addObject:BTN_HAT];
	[btnImgs addObject:BTN_PHONE];
	[btnImgs addObject:BTN_JACKET];
	[btnImgs addObject:BTN_NECKLACE];
	[btnImgs addObject:BTN_PANTS];
	[btnImgs addObject:BTN_SUNGLASSES];
	
	
	NSMutableArray * btnPos = [self loadBtnPos];
	
	
	tapButtons = [CCMenu menuWithItems:nil];
	for (int i = 0;i<8;i++)
	{
		NSString * btnImg = [NSString stringWithFormat:@"wheel_btn_%@%@.png",[btnImgs objectAtIndex:i],iPad];
		NSString * btnImgSel = [NSString stringWithFormat:@"wheel_btn_%@_dwn%@.png",[btnImgs objectAtIndex:i],iPad];
		
		CCMenuItemImage * btn = [CCMenuItemImage itemFromNormalImage:btnImg selectedImage:btnImgSel disabledImage:btnImgSel target:self selector:@selector(makeDinoSpin:)];
		[tapButtons addChild:btn z:1 tag:i];
		btn.position = ccp([[[btnPos objectAtIndex:i] objectForKey:@"x"] intValue],[[[btnPos objectAtIndex:i] objectForKey:@"y"] intValue]);
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
	[self runAction:[CCSequence actions:[CCDelayTime actionWithDuration:1],[CCCallFunc actionWithTarget:self selector:@selector(stopPlayingSound)],nil]];
	switch (btn.tag)
	{
		case BTN_BACKPACK_NUM:
			word = BTN_BACKPACK_SPANISH;
			sound =BTN_BACKPACK_SND;
			bashoDirectedWrongSound = BTN_BACKPACK_SND_WRONG;
			break;
		case BTN_BOOTS_NUM:
			word = BTN_BOOTS_SPANISH;
			sound =BTN_BOOTS_SND;
			bashoDirectedWrongSound = BTN_BOOTS_SND_WRONG;
			break;
		case BTN_HAT_NUM:
			word = BTN_HAT_SPANISH;
			sound =BTN_HAT_SND;
			bashoDirectedWrongSound = BTN_HAT_SND_WRONG;
			break;
		case BTN_PHONE_NUM:
			word = BTN_PHONE_SPANISH;
			sound =BTN_PHONE_SND;
			bashoDirectedWrongSound = BTN_PHONE_SND_WRONG;
			break;
		case BTN_JACKET_NUM:
			word = BTN_JACKET_SPANISH;
			sound =BTN_JACKET_SND;
			bashoDirectedWrongSound = BTN_JACKET_SND_WRONG;
			break;
		case BTN_NECKLACE_NUM:
			word = BTN_NECKLACE_SPANISH;
			sound =BTN_NECKLACE_SND;
			bashoDirectedWrongSound = BTN_NECKLACE_SND_WRONG;
			break;
		case BTN_PANTS_NUM:
			word = BTN_PANTS_SPANISH;
			sound =BTN_PANTS_SND;
			bashoDirectedWrongSound = BTN_PANTS_SND_WRONG;
			break;
		case BTN_SUNGLASSES_NUM:
			word = BTN_SUNGLASSES_SPANISH;
			sound =BTN_SUNGLASSES_SND;
			bashoDirectedWrongSound = BTN_SUNGLASSES_SND_WRONG;
			break;
	}
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
				[self showPoints];
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
	score += _points;
	CCLabelTTF * scoreLbl = [self getChildByTag:kSCORE];
	[scoreLbl setString:[NSString stringWithFormat:@"%d",score]];
}

-(void)showPalabra:(NSString *)word
{
	CCLabelTTF * palabra = [self getChildByTag:kPALABRA];
	[palabra setString:word];
	[palabra runAction:[CCFadeIn actionWithDuration:0.8]];
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
	
	if(currentAttempts >=5)
	{
		maxedAttemps = YES;
		[self makeDinoSpin2:bashoSelectedSound];
	}
}

-(void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	UITouch *touch = [touches anyObject];
	if (bashoDirected) return;
	
	[self makeDinoSpin2:-1];
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
	dinoSpinning = NO;
	[self listenSound:[tapButtons getChildByTag:selectedSound]];
	
}

-(void)goBack
{
	[viewController goToMenu];
}

- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children (Label)
	
	// don't forget to call "super dealloc"
	[bashoSelectedItems release];
	[super dealloc];
}

@end