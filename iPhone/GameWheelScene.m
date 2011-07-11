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

#define BTN_BACKPACK_POS [NSMutableDictionary dictionaryWithObjects:[NSMutableArray arrayWithObjects:[NSNumber numberWithInt:96],[NSNumber numberWithInt:155],nil] forKeys:[NSMutableArray arrayWithObjects:@"x",@"y",nil]]
#define BTN_BOOTS_POS [NSMutableDictionary dictionaryWithObjects:[NSMutableArray arrayWithObjects:[NSNumber numberWithInt:127],[NSNumber numberWithInt:233],nil] forKeys:[NSMutableArray arrayWithObjects:@"x",@"y",nil]]
#define BTN_HAT_POS [NSMutableDictionary dictionaryWithObjects:[NSMutableArray arrayWithObjects:[NSNumber numberWithInt:211],[NSNumber numberWithInt:269],nil] forKeys:[NSMutableArray arrayWithObjects:@"x",@"y",nil]]
#define BTN_PHONE_POS [NSMutableDictionary dictionaryWithObjects:[NSMutableArray arrayWithObjects:[NSNumber numberWithInt:293],[NSNumber numberWithInt:231],nil] forKeys:[NSMutableArray arrayWithObjects:@"x",@"y",nil]]
#define BTN_JACKET_POS [NSMutableDictionary dictionaryWithObjects:[NSMutableArray arrayWithObjects:[NSNumber numberWithInt:324],[NSNumber numberWithInt:153],nil] forKeys:[NSMutableArray arrayWithObjects:@"x",@"y",nil]]
#define BTN_NECKLACE_POS [NSMutableDictionary dictionaryWithObjects:[NSMutableArray arrayWithObjects:[NSNumber numberWithInt:288],[NSNumber numberWithInt:78],nil] forKeys:[NSMutableArray arrayWithObjects:@"x",@"y",nil]]
#define BTN_PANTS_POS [NSMutableDictionary dictionaryWithObjects:[NSMutableArray arrayWithObjects:[NSNumber numberWithInt:212],[NSNumber numberWithInt:42],nil] forKeys:[NSMutableArray arrayWithObjects:@"x",@"y",nil]]
#define BTN_SUNGLASSES_POS [NSMutableDictionary dictionaryWithObjects:[NSMutableArray arrayWithObjects:[NSNumber numberWithInt:128],[NSNumber numberWithInt:80],nil] forKeys:[NSMutableArray arrayWithObjects:@"x",@"y",nil]]


// HelloWorld implementation
@implementation GameWheelScene

+(id) sceneWithWheelVC:(GameWheel *)vc
{
	CCScene *scene = [CCScene node];
    GameWheelScene *layer = [GameWheelScene nodeWithWheelVC:vc];
    [scene addChild: layer z:1 tag:1000];
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
			
			points = 0;
            [GameManager sharedGameManager].musicAudioEnabled = YES;
			[[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"backgroundMusicAnimales.mp3"];
            
            leverArea = CGRectMake(375, 0, 105, 320);
            orig = ccp(240,160);
			
			[self loadDeviceType];
			
			self.isTouchEnabled = YES;
			viewController = vc;
			
			if(![GameManager sharedGameManager].playedGame1Video)
			{
				[[GameManager sharedGameManager] setPlayedGame1Video:YES];
                videoFromLoadingScene = YES;
				[self loadVideo];
			}else
				[self beginGame];
			
		}
		return self;
		
    }
    return self;
}

-(void)loadVideo
{
	[GameManager sharedGameManager].onPause = YES;
    [[SimpleAudioEngine sharedEngine] pauseBackgroundMusic];
	NSURL * url;
	NSBundle *bundle = [NSBundle mainBundle];
	if (bundle) 
	{
		NSString *moviePath = [bundle pathForResource:[NSString stringWithFormat:@"intro_1_%@_iPhone",[GameManager sharedGameManager].instructionsLanguageString] ofType:@"mov"];
		if (moviePath)
		{
			url = [NSURL fileURLWithPath:moviePath];
		}
	}
	
	introVideo = [[MPMoviePlayerController alloc] initWithContentURL:url];
	[[[CCDirector sharedDirector] openGLView] addSubview:introVideo.view];
	[introVideo.view setFrame:CGRectMake(0,0,480,320)];
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
	
	videoTaps = 0;
	
	[introVideo play];
}


-(void)goBack
{
	if([GameManager sharedGameManager].onPause) return;
    [GameManager sharedGameManager].musicAudioEnabled = YES;
	[viewController goToMenu];
}

-(void)goSettings
{
	if([GameManager sharedGameManager].onPause) return; 
	[GameManager sharedGameManager].onPause = YES;
    [viewController goToSettings];
}


-(void)beginGame
{
	points = 0;
	
	bashoDirected = NO;
	
    [CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_RGB565];
	CCSprite * back = [CCSprite spriteWithFile:@"wheel_background_iPhone.png"];
	[back setPosition:ccp(240,160)];
	[self addChild:back];
    
    [CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_RGBA4444];
    
    leverImg = [CCSprite spriteWithFile:@"lever_iPhone.png"];
	[self addChild:leverImg];
	[leverImg setPosition:ccp(153,170)];
	[leverImg setAnchorPoint:ccp(0,0.5)];
	[leverImg setRotation:-25];
	
	leverBtn= [CCSprite spriteWithFile:@"leverBtn_iPhone.png"];
	[self addChild:leverBtn];
	leverBtn.opacity = 0;
	[leverBtn setPosition:ccp(400,260)];
    
    [CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_RGBA8888];
	
	CCSprite * wheelwheel = [CCSprite spriteWithFile:@"wheel_wheel_iPhone.png"];
	[wheelwheel setPosition:ccp(240,160)];
	[self addChild:wheelwheel];
	
    [CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_RGBA4444];
    
	dino = [CCSprite spriteWithFile:@"wheel_dino_iPhone.png"];
	[dino setPosition:ccp(210,160)];
	[self addChild:dino];
	
	backBtn = [CCMenuItemImage itemFromNormalImage:@"wheel_home.png" selectedImage:@"wheel_home.png" target:self selector:@selector(goBack)];
	
	CCMenuItemImage * soundOff = [CCMenuItemImage itemFromNormalImage:@"wheel_sound_off_iPhone.png" selectedImage:@"wheel_sound_on_iPhone.png"];
	CCMenuItemImage * soundOn = [CCMenuItemImage itemFromNormalImage:@"wheel_sound_on_iPhone.png" selectedImage:@"wheel_sound_off_iPhone.png"];
	CCMenuItemToggle * sound = [CCMenuItemToggle itemWithTarget:self selector:@selector(turnSounds) items:soundOn,soundOff,nil];
    
    CCMenuItemImage * settingsBtn = [CCMenuItemImage itemFromNormalImage:@"wheel_settings_iPhone.png" selectedImage:@"wheel_settings_iPhone.png" target:self selector:@selector(goSettings)];
	
	CCMenuItemImage * bashoOff = [CCMenuItemImage itemFromNormalImage:@"wheel_basho_off_iPhone.png" selectedImage:@"wheel_basho_on_iPhone.png"];
	CCMenuItemImage * bashoOn = [CCMenuItemImage itemFromNormalImage:@"wheel_basho_on_iPhone.png" selectedImage:@"wheel_basho_off_iPhone.png"];
	CCMenuItemToggle * basho = [CCMenuItemToggle itemWithTarget:self selector:@selector(turnBasho) items:bashoOff,bashoOn,nil];
	
	
	CCMenu * menu = [CCMenu menuWithItems:backBtn,sound,basho,settingsBtn,nil];
	[self addChild:menu];
	[backBtn setPosition:ccp(20,290)];
    [settingsBtn setPosition:ccp(20,25)];
	[sound setPosition:ccp(20,60)];
	[basho setPosition:ccp(20,100)];
	[menu setPosition:ccp(0,0)];
	
	//[self loadScore];
	[self loadButtons];
    
    [[ CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"animalsAnims_iPhone.plist" textureFile:@"animalsAnims_iPhone.png"];
	animalAnimSB = [CCSpriteBatchNode batchNodeWithFile:@"animalsAnims_iPhone.png"];
    
    [self addChild:animalAnimSB z:0];
	[self createPalabra];
    [self loadSpinningStuff];
}


-(void)createPalabra
{
    CCSprite * palabraBck = [CCSprite spriteWithFile:@"wheel_wordbackground_iPhone.png"];
    [self addChild:palabraBck z:1 tag:kPALABRABCK];
    [palabraBck setPosition:ccp(410,30)];
	[palabraBck setOpacity:0];
	CCLabelTTF * palabra = [CCLabelBMFont labelWithString:@"a" fntFile:@"Wheel_text_iPad.fnt"];
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)] == YES && [[UIScreen mainScreen] scale] == 2.00) {
        [palabra setScale:0.70];
    }
    else {
        [palabra setScale:0.35];
    }
	[self addChild:palabra z:1 tag:kPALABRA];
	[palabra setPosition:ccp(410,30)];
	[palabra setOpacity:0];
}

-(void)loadScore
{
	CCSprite * back = [CCSprite spriteWithFile:@"wheel_pointsField.png"];
	[back setPosition:ccp(450,293)];
	[self addChild:back];
	
	CCLabelTTF * scoreLbl = [CCLabelTTF labelWithString:@"0" fontName:@"Verdana" fontSize:30];
	[scoreLbl setColor:ccBLACK];
	[self addChild:scoreLbl z:1 tag:kSCORE];
	[scoreLbl setPosition:ccp(450,293)];
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
