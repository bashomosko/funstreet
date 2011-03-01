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

#define BTN_BACKPACK_POS [NSMutableDictionary dictionaryWithObjects:[NSMutableArray arrayWithObjects:[NSNumber numberWithInt:30],[NSNumber numberWithInt:200],nil] forKeys:[NSMutableArray arrayWithObjects:@"x",@"y",nil]]
#define BTN_BOOTS_POS [NSMutableDictionary dictionaryWithObjects:[NSMutableArray arrayWithObjects:[NSNumber numberWithInt:90],[NSNumber numberWithInt:200],nil] forKeys:[NSMutableArray arrayWithObjects:@"x",@"y",nil]]
#define BTN_HAT_POS [NSMutableDictionary dictionaryWithObjects:[NSMutableArray arrayWithObjects:[NSNumber numberWithInt:150],[NSNumber numberWithInt:200],nil] forKeys:[NSMutableArray arrayWithObjects:@"x",@"y",nil]]
#define BTN_PHONE_POS [NSMutableDictionary dictionaryWithObjects:[NSMutableArray arrayWithObjects:[NSNumber numberWithInt:210],[NSNumber numberWithInt:200],nil] forKeys:[NSMutableArray arrayWithObjects:@"x",@"y",nil]]
#define BTN_JACKET_POS [NSMutableDictionary dictionaryWithObjects:[NSMutableArray arrayWithObjects:[NSNumber numberWithInt:270],[NSNumber numberWithInt:200],nil] forKeys:[NSMutableArray arrayWithObjects:@"x",@"y",nil]]
#define BTN_NECKLACE_POS [NSMutableDictionary dictionaryWithObjects:[NSMutableArray arrayWithObjects:[NSNumber numberWithInt:330],[NSNumber numberWithInt:200],nil] forKeys:[NSMutableArray arrayWithObjects:@"x",@"y",nil]]
#define BTN_PANTS_POS [NSMutableDictionary dictionaryWithObjects:[NSMutableArray arrayWithObjects:[NSNumber numberWithInt:390],[NSNumber numberWithInt:200],nil] forKeys:[NSMutableArray arrayWithObjects:@"x",@"y",nil]]
#define BTN_SUNGLASSES_POS [NSMutableDictionary dictionaryWithObjects:[NSMutableArray arrayWithObjects:[NSNumber numberWithInt:450],[NSNumber numberWithInt:200],nil] forKeys:[NSMutableArray arrayWithObjects:@"x",@"y",nil]]


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
			
			CCSprite * back = [CCSprite spriteWithFile:@"wheel_background.png"];
			[back setPosition:ccp(240,160)];
			[self addChild:back];
			
			dino = [CCSprite spriteWithFile:@"wheel_dino.png"];
			[dino setPosition:ccp(240,160)];
			[self addChild:dino];
			
			CCMenuItemImage * backBtn = [CCMenuItemImage itemFromNormalImage:@"wheel_home.png" selectedImage:@"wheel_home.png" target:self selector:@selector(goBack)];
			CCMenu * menu = [CCMenu menuWithItems:backBtn,nil];
			[self addChild:menu];
			[menu setPosition:ccp(30,290)];
			
			[self loadButtons];
			
		}
		return self;
		
    }
    return self;
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
	
	playingSound = YES;
	[btn setIsEnabled:NO];
	[self runAction:[CCSequence actions:[CCDelayTime actionWithDuration:1],[CCCallFunc actionWithTarget:self selector:@selector(stopPlayingSound)],nil]];
	switch (btn.tag)
	{
		case BTN_BACKPACK_NUM:
			[[SimpleAudioEngine sharedEngine] playEffect:BTN_BACKPACK_SND];
			break;
		case BTN_BOOTS_NUM:
			[[SimpleAudioEngine sharedEngine] playEffect:BTN_BOOTS_SND];
			break;
		case BTN_HAT_NUM:
			[[SimpleAudioEngine sharedEngine] playEffect:BTN_HAT_SND];
			break;
		case BTN_PHONE_NUM:
			[[SimpleAudioEngine sharedEngine] playEffect:BTN_PHONE_SND];
			break;
		case BTN_JACKET_NUM:
			[[SimpleAudioEngine sharedEngine] playEffect:BTN_JACKET_SND];
			break;
		case BTN_NECKLACE_NUM:
			[[SimpleAudioEngine sharedEngine] playEffect:BTN_NECKLACE_SND];
			break;
		case BTN_PANTS_NUM:
			[[SimpleAudioEngine sharedEngine] playEffect:BTN_PANTS_SND];
			break;
		case BTN_SUNGLASSES_NUM:
			[[SimpleAudioEngine sharedEngine] playEffect:BTN_SUNGLASSES_SND];
			break;
	}
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
}

-(void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	UITouch *touch = [touches anyObject];
	
	[self makeDinoSpin2:-1];
}

-(void)makeDinoSpin:(CCMenuItemImage *)btn
{
	selectedSound = btn.tag;
	[self makeDinoSpin2:selectedSound];
}

-(void)makeDinoSpin2:(int)_selectedSound
{
	int rotTime = 4;
	int rotAngle =900;
	if(_selectedSound == -1)
	{
		selectedSound = arc4random() %8;
	}else
	{
		rotTime = 2;
		rotAngle = 360;
		selectedSound= _selectedSound;
	}
	int randAngle = rotAngle + (45 *(selectedSound));
	
	if(!dinoSpinning && !playingSound)
	{
		[dino runAction:[CCSequence actions:[CCEaseSineInOut actionWithAction:[CCRotateBy actionWithDuration:rotTime angle:randAngle]],[CCCallFunc actionWithTarget:self selector:@selector(stopSpinning)],nil]];
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
