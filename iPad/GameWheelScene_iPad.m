    //
//  GameWheelScene_iPad.m
//  Basho
//
//  Created by Pablo Ruiz on 12/02/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

// Import the interfaces
#import "AppDelegate_iPad.h"
#import "GameWheelScene_iPad.h"
#import "GameWheel_iPad.h"

#import "SimpleAudioEngine.h"
#import "GameManager.h"

#define BTN_BACKPACK_POS [NSMutableDictionary dictionaryWithObjects:[NSMutableArray arrayWithObjects:[NSNumber numberWithInt:(1024 *95) /480],[NSNumber numberWithInt:(768 *160) /320],nil] forKeys:[NSMutableArray arrayWithObjects:@"x",@"y",nil]]//Cat
#define BTN_BOOTS_POS [NSMutableDictionary dictionaryWithObjects:[NSMutableArray arrayWithObjects:[NSNumber numberWithInt:(1024 *129) /480],[NSNumber numberWithInt:(768 *236.5) /320],nil] forKeys:[NSMutableArray arrayWithObjects:@"x",@"y",nil]]//Duck
#define BTN_HAT_POS [NSMutableDictionary dictionaryWithObjects:[NSMutableArray arrayWithObjects:[NSNumber numberWithInt:(1024 *224) /480],[NSNumber numberWithInt:(768 *273) /320],nil] forKeys:[NSMutableArray arrayWithObjects:@"x",@"y",nil]]//Horse
#define BTN_PHONE_POS [NSMutableDictionary dictionaryWithObjects:[NSMutableArray arrayWithObjects:[NSNumber numberWithInt:(1024 *315.5) /480],[NSNumber numberWithInt:(768 *236) /320],nil] forKeys:[NSMutableArray arrayWithObjects:@"x",@"y",nil]]//Bee
#define BTN_JACKET_POS [NSMutableDictionary dictionaryWithObjects:[NSMutableArray arrayWithObjects:[NSNumber numberWithInt:(1024 *349.5) /480],[NSNumber numberWithInt:(768 *157.5) /320],nil] forKeys:[NSMutableArray arrayWithObjects:@"x",@"y",nil]]//Dog
#define BTN_NECKLACE_POS [NSMutableDictionary dictionaryWithObjects:[NSMutableArray arrayWithObjects:[NSNumber numberWithInt:(1024 *309.5) /480],[NSNumber numberWithInt:(768 *82.5) /320],nil] forKeys:[NSMutableArray arrayWithObjects:@"x",@"y",nil]]//Chicken
#define BTN_PANTS_POS [NSMutableDictionary dictionaryWithObjects:[NSMutableArray arrayWithObjects:[NSNumber numberWithInt:(1024 *225) /480],[NSNumber numberWithInt:(768 *46.5) /320],nil] forKeys:[NSMutableArray arrayWithObjects:@"x",@"y",nil]]//Cow
#define BTN_SUNGLASSES_POS [NSMutableDictionary dictionaryWithObjects:[NSMutableArray arrayWithObjects:[NSNumber numberWithInt:(1024 *130) /480],[NSNumber numberWithInt:(768 *84.5) /320],nil] forKeys:[NSMutableArray arrayWithObjects:@"x",@"y",nil]]//Pig




// HelloWorld implementation
@implementation GameWheelScene_iPad

+(id) sceneWithWheelVC:(GameWheel_iPad *)vc
{
    CCScene *scene = [CCScene node];
    GameWheelScene_iPad *layer = [GameWheelScene_iPad nodeWithWheelVC:vc];
    [scene addChild: layer z:1 tag:1000];
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
            [GameManager sharedGameManager].musicAudioEnabled = YES;
			[[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"backgroundMusicAnimales.mp3"];
            
            leverArea = CGRectMake(800, 0, 224, 768);
            
            orig = ccp(512,384);
			
			[self loadDeviceType];
			
			self.isTouchEnabled = YES;
			viewController = vc;
			hasFinishPlayingAnim = YES;
            currentSound = -10;
			
			AppDelegate_iPad * app = (AppDelegate_iPad *)[[UIApplication sharedApplication] delegate];
			[app.loading stopAnimating];
			
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


-(void)beginGame{
	AppDelegate_iPad * app = (AppDelegate_iPad *)[[UIApplication sharedApplication] delegate];
	[app.loading setHidden:NO];
	[app.loading startAnimating];
	
	[self performSelector:@selector(beginGameAfterDelay) withObject:nil afterDelay:1];
}

-(void)beginGameAfterDelay
{
	
	bashoDirected = NO;
	
    [CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_RGB565];
	CCSprite * back = [CCSprite spriteWithFile:@"wheel_background_iPad.png"];
	[back setPosition:ccp(512,384)];
	[self addChild:back];
	
    [CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_RGBA4444];
	
    [CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_RGBA8888];
    
	leverImg = [CCSprite spriteWithFile:@"lever_iPad.png"];
	[self addChild:leverImg];
	[leverImg setPosition:ccp(390,420)];
	[leverImg setAnchorPoint:ccp(0,0.5)];
	[leverImg setRotation:-25];
	
    [CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_RGBA4444];
    
	leverBtn= [CCSprite spriteWithFile:@"leverBtn_iPad.png"];
	[self addChild:leverBtn];
	leverBtn.opacity = 0;
	[leverBtn setPosition:ccp(860,620)];
	
    [CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_RGBA8888];
	CCSprite * wheelwheel = [CCSprite spriteWithFile:@"wheel_wheel_iPad.png"];
	[wheelwheel setPosition:ccp(512,384)];
	[self addChild:wheelwheel];
    
	dino = [CCSprite spriteWithFile:@"wheel_dino_iPad.png"];
	[dino setPosition:ccp(475,384)];
	[self addChild:dino];
    
    [CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_RGBA4444];
	
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
	
	
	
	//[self loadScore];
	
	
	[[ CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"animalsAnims_iPad.plist" textureFile:@"animalsAnims_iPad.png"];
	animalAnimSB = [CCSpriteBatchNode batchNodeWithFile:@"animalsAnims_iPad.png"];
	
	[self addChild:animalAnimSB z:0];
    [self loadButtons];
	[self createPalabra];
	[self loadSpinningStuff];
	
	AppDelegate_iPad * app = (AppDelegate_iPad *)[[UIApplication sharedApplication] delegate];
	[app.loading stopAnimating];
}

-(void)loadVideo
{
	[GameManager sharedGameManager].onPause = YES;
    [[SimpleAudioEngine sharedEngine] pauseBackgroundMusic];
	NSURL * url;
	NSBundle *bundle = [NSBundle mainBundle];
	if (bundle) 
	{
		NSString *moviePath = [bundle pathForResource:[NSString stringWithFormat:@"intro_1_%@_iPad",[GameManager sharedGameManager].instructionsLanguageString] ofType:@"mov"];
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
	CCLabelTTF * palabra = [CCLabelBMFont labelWithString:@"a" fntFile:@"Wheel_text_iPad.fnt"];
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
