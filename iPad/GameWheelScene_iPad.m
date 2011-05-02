    //
//  GameWheelScene_iPad.m
//  Basho
//
//  Created by Pablo Ruiz on 12/02/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

// Import the interfaces
#import "GameWheelScene_iPad.h"
#import "GameWheel_iPad.h"

#import "SimpleAudioEngine.h"
#import "GameManager.h"

#define BTN_BACKPACK_POS [NSMutableDictionary dictionaryWithObjects:[NSMutableArray arrayWithObjects:[NSNumber numberWithInt:(1024 *110) /480],[NSNumber numberWithInt:(768 *160) /320],nil] forKeys:[NSMutableArray arrayWithObjects:@"x",@"y",nil]]
#define BTN_BOOTS_POS [NSMutableDictionary dictionaryWithObjects:[NSMutableArray arrayWithObjects:[NSNumber numberWithInt:(1024 *150) /480],[NSNumber numberWithInt:(768 *240) /320],nil] forKeys:[NSMutableArray arrayWithObjects:@"x",@"y",nil]]
#define BTN_HAT_POS [NSMutableDictionary dictionaryWithObjects:[NSMutableArray arrayWithObjects:[NSNumber numberWithInt:(1024 *240) /480],[NSNumber numberWithInt:(768 *280) /320],nil] forKeys:[NSMutableArray arrayWithObjects:@"x",@"y",nil]]
#define BTN_PHONE_POS [NSMutableDictionary dictionaryWithObjects:[NSMutableArray arrayWithObjects:[NSNumber numberWithInt:(1024 *330) /480],[NSNumber numberWithInt:(768 *240) /320],nil] forKeys:[NSMutableArray arrayWithObjects:@"x",@"y",nil]]
#define BTN_JACKET_POS [NSMutableDictionary dictionaryWithObjects:[NSMutableArray arrayWithObjects:[NSNumber numberWithInt:(1024 *370) /480],[NSNumber numberWithInt:(768 *160) /320],nil] forKeys:[NSMutableArray arrayWithObjects:@"x",@"y",nil]]
#define BTN_NECKLACE_POS [NSMutableDictionary dictionaryWithObjects:[NSMutableArray arrayWithObjects:[NSNumber numberWithInt:(1024 *330) /480],[NSNumber numberWithInt:(768 *80) /320],nil] forKeys:[NSMutableArray arrayWithObjects:@"x",@"y",nil]]
#define BTN_PANTS_POS [NSMutableDictionary dictionaryWithObjects:[NSMutableArray arrayWithObjects:[NSNumber numberWithInt:(1024 *240) /480],[NSNumber numberWithInt:(768 *40) /320],nil] forKeys:[NSMutableArray arrayWithObjects:@"x",@"y",nil]]
#define BTN_SUNGLASSES_POS [NSMutableDictionary dictionaryWithObjects:[NSMutableArray arrayWithObjects:[NSNumber numberWithInt:(1024 *150) /480],[NSNumber numberWithInt:(768 *80) /320],nil] forKeys:[NSMutableArray arrayWithObjects:@"x",@"y",nil]]




// HelloWorld implementation
@implementation GameWheelScene_iPad

+(id) sceneWithWheelVC:(GameWheel_iPad *)vc
{
    CCScene *scene = [CCScene node];
    GameWheelScene_iPad *layer = [GameWheelScene_iPad nodeWithWheelVC:vc];
    [scene addChild: layer];
    return scene;
}

+(id) nodeWithWheelVC:(GameWheel_iPad *)vc
{
	return [[[self alloc] initWithWheelVC:vc] autorelease];
}

-(id) initWithWheelVC:(GameWheel_iPad *)vc
{
	if( (self=[super init] )) {
		self.isTouchEnabled = YES;
		// always call "super" init
		// Apple recommends to re-assign "self" with the "super" return value
		if( (self=[super init] )) {
			
			points = 0;
			
			[self loadDeviceType];
			
			self.isTouchEnabled = YES;
			viewController = vc;
			bashoDirected = NO;
			
			CCSprite * back = [CCSprite spriteWithFile:@"wheel_background_iPad.png"];
			[back setPosition:ccp(512,384)];
			[self addChild:back];
			
			dino = [CCSprite spriteWithFile:@"wheel_dino_iPad.png"];
			[dino setPosition:ccp(512,384)];
			[self addChild:dino];
			
			CCMenuItemImage * backBtn = [CCMenuItemImage itemFromNormalImage:@"wheel_home_iPad.png" selectedImage:@"wheel_home_iPad.png" target:self selector:@selector(goBack)];
            
            CCMenuItemImage * settingsBtn = [CCMenuItemImage itemFromNormalImage:@"wheel_settings_iPad.png" selectedImage:@"wheel_settings_iPad.png" target:self selector:@selector(goSettings)];
			
			CCMenuItemImage * soundOff = [CCMenuItemImage itemFromNormalImage:@"wheel_sound_off_iPad.png" selectedImage:@"wheel_sound_on_iPad.png"];
			CCMenuItemImage * soundOn = [CCMenuItemImage itemFromNormalImage:@"wheel_sound_on_iPad.png" selectedImage:@"wheel_sound_off_iPad.png"];
			CCMenuItemToggle * sound = [CCMenuItemToggle itemWithTarget:self selector:@selector(turnSounds) items:soundOn,soundOff,nil];
			
			CCMenuItemImage * bashoOff = [CCMenuItemImage itemFromNormalImage:@"wheel_basho_off_iPad.png" selectedImage:@"wheel_basho_on_iPad.png"];
			CCMenuItemImage * bashoOn = [CCMenuItemImage itemFromNormalImage:@"wheel_basho_on_iPad.png" selectedImage:@"wheel_basho_off_iPad.png"];
			CCMenuItemToggle * basho = [CCMenuItemToggle itemWithTarget:self selector:@selector(turnBasho) items:bashoOff,bashoOn,nil];
			
			
			CCMenu * menu = [CCMenu menuWithItems:backBtn,sound,basho,settingsBtn,nil];
			[self addChild:menu];
			[backBtn setPosition:ccp(64,696)];
            [settingsBtn setPosition:ccp(50,48)];
			[sound setPosition:ccp(50,120)];
			[basho setPosition:ccp(50,200)];
			[menu setPosition:ccp(0,0)];
			
			[self loadScore];
			[self loadButtons];
			[self createPalabra];
            [self loadSpinningStuff];
			
		}
		return self;
		
    }
    return self;
}

-(void)replay
{
	[[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.5 scene: [GameWheelScene_iPad sceneWithWheelVC:viewController] withColor:ccWHITE]];
	
}

-(void)createPalabra
{
    CCSprite * palabraBck = [CCSprite spriteWithFile:@"wheel_wordbackground_iPad.png"];
    [self addChild:palabraBck z:1 tag:kPALABRABCK];
    [palabraBck setPosition:ccp(870,60)];
	[palabraBck setOpacity:0];
	CCLabelTTF * palabra = [CCLabelTTF labelWithString:@"MOCHILA" fontName:@"Verdana" fontSize:40];
	[palabra setColor:ccBLACK];
	[self addChild:palabra z:1 tag:kPALABRA];
	[palabra setPosition:ccp(870,60)];
	[palabra setOpacity:0];
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

-(NSMutableArray *)loadBtnPos
{
	NSMutableArray * btnPos = [NSMutableArray arrayWithCapacity:8];
	[btnPos addObject:BTN_BACKPACK_POS];
	[btnPos addObject:BTN_BOOTS_POS];
	[btnPos addObject:BTN_HAT_POS];
	[btnPos addObject:BTN_PHONE_POS];
	[btnPos addObject:BTN_JACKET_POS];
	[btnPos addObject:BTN_NECKLACE_POS];
	[btnPos addObject:BTN_PANTS_POS];
	[btnPos addObject:BTN_SUNGLASSES_POS];
	
	return btnPos;
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
