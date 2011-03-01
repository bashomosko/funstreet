//
//  HelloWorldLayer.m
//  BashoCocos
//
//  Created by Pablo Ruiz on 12/02/11.
//  Copyright __MyCompanyName__ 2011. All rights reserved.
//

// Import the interfaces
#import "GameWheelScene.h"
#import "SimpleAudioEngine.h"
#import "GameManager.h"

#define kPALABRA 1000

#define BTN_BACKPACK @"backpack"
#define BTN_BOOTS @"boots"
#define BTN_HAT @"hat"
#define BTN_PHONE @"phone"
#define BTN_JACKET @"jacket"
#define BTN_NECKLACE @"necklace"
#define BTN_PANTS @"pants"
#define BTN_SUNGLASSES @"sunglasses"

#define BTN_BACKPACK_NUM 0
#define BTN_BOOTS_NUM 1
#define BTN_HAT_NUM 2
#define BTN_PHONE_NUM 3
#define BTN_JACKET_NUM 4
#define BTN_NECKLACE_NUM 5
#define BTN_PANTS_NUM 6
#define BTN_SUNGLASSES_NUM 7

#define BTN_BACKPACK_SND @"wheel_snd_backpack.m4a"
#define BTN_BOOTS_SND @"wheel_snd_boots.m4a"
#define BTN_HAT_SND @"wheel_snd_hat.m4a"
#define BTN_PHONE_SND @"wheel_snd_phone.m4a"
#define BTN_JACKET_SND @"wheel_snd_jacket.m4a"
#define BTN_NECKLACE_SND @"wheel_snd_necklace.m4a"
#define BTN_PANTS_SND @"wheel_snd_pants.m4a"
#define BTN_SUNGLASSES_SND @"wheel_snd_sunglasses.m4a"

#define BTN_BACKPACK_SND_WHERE @"wheel_snd_backpack_where.m4a"
#define BTN_BOOTS_SND_WHERE @"wheel_snd_boots_where.m4a"
#define BTN_HAT_SND_WHERE @"wheel_snd_hat_where.m4a"
#define BTN_PHONE_SND_WHERE @"wheel_snd_phone_where.m4a"
#define BTN_JACKET_SND_WHERE @"wheel_snd_jacket_where.m4a"
#define BTN_NECKLACE_SND_WHERE @"wheel_snd_necklace_where.m4a"
#define BTN_PANTS_SND_WHERE @"wheel_snd_pants_where.m4a"
#define BTN_SUNGLASSES_SND_WHERE @"wheel_snd_sunglasses_where.m4a"

#define BTN_BACKPACK_SND_WRONG @"wheel_snd_backpack_wrong.m4a"
#define BTN_BOOTS_SND_WRONG @"wheel_snd_boots_wrong.m4a"
#define BTN_HAT_SND_WRONG @"wheel_snd_hat_wrong.m4a"
#define BTN_PHONE_SND_WRONG @"wheel_snd_phone_wrong.m4a"
#define BTN_JACKET_SND_WRONG @"wheel_snd_jacket_wrong.m4a"
#define BTN_NECKLACE_SND_WRONG @"wheel_snd_necklace_wrong.m4a"
#define BTN_PANTS_SND_WRONG @"wheel_snd_pants_wrong.m4a"
#define BTN_SUNGLASSES_SND_WRONG @"wheel_snd_sunglasses_wrong.m4a"

#define BTN_BACKPACK_SPANISH @"Mochila"
#define BTN_BOOTS_SPANISH @"Botas"
#define BTN_HAT_SPANISH @"Sombrero"
#define BTN_PHONE_SPANISH @"Telefono"
#define BTN_JACKET_SPANISH @"Campera"
#define BTN_NECKLACE_SPANISH @"Collar"
#define BTN_PANTS_SPANISH @"Pantalones"
#define BTN_SUNGLASSES_SPANISH @"Anteojos"

#define BTN_BACKPACK_POS [NSMutableDictionary dictionaryWithObjects:[NSMutableArray arrayWithObjects:[NSNumber numberWithInt:110],[NSNumber numberWithInt:160],nil] forKeys:[NSMutableArray arrayWithObjects:@"x",@"y",nil]]
#define BTN_BOOTS_POS [NSMutableDictionary dictionaryWithObjects:[NSMutableArray arrayWithObjects:[NSNumber numberWithInt:150],[NSNumber numberWithInt:240],nil] forKeys:[NSMutableArray arrayWithObjects:@"x",@"y",nil]]
#define BTN_HAT_POS [NSMutableDictionary dictionaryWithObjects:[NSMutableArray arrayWithObjects:[NSNumber numberWithInt:240],[NSNumber numberWithInt:280],nil] forKeys:[NSMutableArray arrayWithObjects:@"x",@"y",nil]]
#define BTN_PHONE_POS [NSMutableDictionary dictionaryWithObjects:[NSMutableArray arrayWithObjects:[NSNumber numberWithInt:330],[NSNumber numberWithInt:240],nil] forKeys:[NSMutableArray arrayWithObjects:@"x",@"y",nil]]
#define BTN_JACKET_POS [NSMutableDictionary dictionaryWithObjects:[NSMutableArray arrayWithObjects:[NSNumber numberWithInt:370],[NSNumber numberWithInt:160],nil] forKeys:[NSMutableArray arrayWithObjects:@"x",@"y",nil]]
#define BTN_NECKLACE_POS [NSMutableDictionary dictionaryWithObjects:[NSMutableArray arrayWithObjects:[NSNumber numberWithInt:330],[NSNumber numberWithInt:80],nil] forKeys:[NSMutableArray arrayWithObjects:@"x",@"y",nil]]
#define BTN_PANTS_POS [NSMutableDictionary dictionaryWithObjects:[NSMutableArray arrayWithObjects:[NSNumber numberWithInt:240],[NSNumber numberWithInt:40],nil] forKeys:[NSMutableArray arrayWithObjects:@"x",@"y",nil]]
#define BTN_SUNGLASSES_POS [NSMutableDictionary dictionaryWithObjects:[NSMutableArray arrayWithObjects:[NSNumber numberWithInt:150],[NSNumber numberWithInt:80],nil] forKeys:[NSMutableArray arrayWithObjects:@"x",@"y",nil]]


// HelloWorld implementation
@implementation GameWheelScene

+(id) sceneWithWheelVC:(GameWheel *)vc
{
	CCScene *scene = [CCScene node];
    GameWheelScene *layer = [GameWheelScene nodeWithWheelVC:vc];
    [scene addChild: layer];
    return scene;
}

+(id) nodeWithWheelVC:(GameWheel *)vc
{
	return [[[self alloc] initWithWheelVC:vc] autorelease];
}

-(id) initWithWheelVC:(GameWheel *)vc
{
    if( (self=[super init] )) {
		self.isTouchEnabled = YES;
		// always call "super" init
		// Apple recommends to re-assign "self" with the "super" return value
		if( (self=[super init] )) {
			
			self.isTouchEnabled = YES;
			viewController = vc;
			bashoDirected = NO;
			
			CCSprite * back = [CCSprite spriteWithFile:@"wheel_background.png"];
			[back setPosition:ccp(240,160)];
			[self addChild:back];
			
			dino = [CCSprite spriteWithFile:@"wheel_dino.png"];
			[dino setPosition:ccp(240,160)];
			[self addChild:dino];
			
			CCMenuItemImage * backBtn = [CCMenuItemImage itemFromNormalImage:@"wheel_home.png" selectedImage:@"wheel_home.png" target:self selector:@selector(goBack)];
			
			CCMenuItemImage * soundOff = [CCMenuItemImage itemFromNormalImage:@"wheel_sound_off.png" selectedImage:@"wheel_sound_on.png"];
			CCMenuItemImage * soundOn = [CCMenuItemImage itemFromNormalImage:@"wheel_sound_on.png" selectedImage:@"wheel_sound_off.png"];
			CCMenuItemToggle * sound = [CCMenuItemToggle itemWithTarget:self selector:@selector(turnSounds) items:soundOn,soundOff,nil];
			
			CCMenuItemImage * bashoOff = [CCMenuItemImage itemFromNormalImage:@"wheel_basho_off.png" selectedImage:@"wheel_basho_on.png"];
			CCMenuItemImage * bashoOn = [CCMenuItemImage itemFromNormalImage:@"wheel_basho_on.png" selectedImage:@"wheel_basho_off.png"];
			CCMenuItemToggle * basho = [CCMenuItemToggle itemWithTarget:self selector:@selector(turnBasho) items:bashoOff,bashoOn,nil];
			
			
			CCMenu * menu = [CCMenu menuWithItems:backBtn,sound,basho,nil];
			[self addChild:menu];
			[backBtn setPosition:ccp(30,290)];
			[sound setPosition:ccp(20,20)];
			[basho setPosition:ccp(70,30)];
			[menu setPosition:ccp(0,0)];
			
			[self loadButtons];
			[self createPalabra];
			
		}
		return self;
		
    }
    return self;
}

-(void)turnSounds
{
	GameManager * gm = [GameManager sharedGameManager];
	[gm turnSounds];
}

-(void)turnBasho
{
	bashoDirected = !bashoDirected;
	
	if(bashoDirected)
		[self selectItemForBasho];
}

-(void)selectItemForBasho
{
	bashoSelectedSound = arc4random() %8;
	
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

-(void)createPalabra
{
	CCLabelTTF * palabra = [CCLabelTTF labelWithString:@"MOCHILA" fontName:@"Verdana" fontSize:20];
	[palabra setColor:ccBLACK];
	[self addChild:palabra z:1 tag:kPALABRA];
	[palabra setPosition:ccp(420,20)];
	[palabra setOpacity:0];
}

-(void)loadButtons
{
	NSMutableArray * btnImgs = [NSMutableArray arrayWithCapacity:8];
	[btnImgs addObject:BTN_BACKPACK];
	[btnImgs addObject:BTN_BOOTS];
	[btnImgs addObject:BTN_HAT];
	[btnImgs addObject:BTN_PHONE];
	[btnImgs addObject:BTN_JACKET];
	[btnImgs addObject:BTN_NECKLACE];
	[btnImgs addObject:BTN_PANTS];
	[btnImgs addObject:BTN_SUNGLASSES];
	
	NSMutableArray * btnPos = [NSMutableArray arrayWithCapacity:8];
	[btnPos addObject:BTN_BACKPACK_POS];
	[btnPos addObject:BTN_BOOTS_POS];
	[btnPos addObject:BTN_HAT_POS];
	[btnPos addObject:BTN_PHONE_POS];
	[btnPos addObject:BTN_JACKET_POS];
	[btnPos addObject:BTN_NECKLACE_POS];
	[btnPos addObject:BTN_PANTS_POS];
	[btnPos addObject:BTN_SUNGLASSES_POS];
	
	tapButtons = [CCMenu menuWithItems:nil];
	for (int i = 0;i<8;i++)
	{
		NSString * btnImg = [NSString stringWithFormat:@"wheel_btn_%@.png",[btnImgs objectAtIndex:i]];
		NSString * btnImgSel = [NSString stringWithFormat:@"wheel_btn_%@_dwn.png",[btnImgs objectAtIndex:i]];
		
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
			bashoDirectedWrongSound = BTN_PANTS_SND_WRONG;
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
		if(bashoSelectedSound == selectedSound)
		{
			if([GameManager sharedGameManager].soundsEnabled)
				[[SimpleAudioEngine sharedEngine] playEffect:sound];
			[self showPalabra:word];
			
			[self runAction:[CCSequence actions:[CCDelayTime actionWithDuration:1],[CCCallFunc actionWithTarget:self selector:@selector(selectItemForBasho)],nil]];
			
		}else {
			if([GameManager sharedGameManager].soundsEnabled)
				[[SimpleAudioEngine sharedEngine] playEffect:bashoDirectedWrongSound];
		}

	}

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
		if([m isKindOfClass:[CCMenuItemImage class]])
		{
			[m setIsEnabled:YES];
		}
	}
	CCLabelTTF * palabra = [self getChildByTag:kPALABRA];
	[palabra setOpacity:0];
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

// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children (Label)
	
	// don't forget to call "super dealloc"
	[super dealloc];
}
@end
