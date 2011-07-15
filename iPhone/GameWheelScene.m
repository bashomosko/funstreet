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
            
            leverArea = CGRectMake(300, 0, 105, 320);
            orig = ccp(240,160);
			
			[self loadDeviceType];
			
			self.isTouchEnabled = YES;
			viewController = vc;
			hasFinishPlayingAnim = YES;
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
    
    [CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_RGBA8888];
    
    leverImg = [CCSprite spriteWithFile:@"lever_iPhone.png"];
	[self addChild:leverImg];
	[leverImg setPosition:ccp(153,170)];
	[leverImg setAnchorPoint:ccp(0,0.5)];
	[leverImg setRotation:-25];
	
    [CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_RGBA4444];
    
	leverBtn= [CCSprite spriteWithFile:@"leverBtn_iPhone.png"];
	[self addChild:leverBtn];
	leverBtn.opacity = 0;
	[leverBtn setPosition:ccp(400,260)];
    
    [CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_RGBA8888];
	
	CCSprite * wheelwheel = [CCSprite spriteWithFile:@"wheel_wheel_iPhone.png"];
	[wheelwheel setPosition:ccp(240,160)];
	[self addChild:wheelwheel];
    
	dino = [CCSprite spriteWithFile:@"wheel_dino_iPhone.png"];
	[dino setPosition:ccp(210,160)];
	[self addChild:dino];
	
    [CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_RGBA4444];
    
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
    
    nSheetToLoad = 0;
    
    //[self loadSpriteSheets];
    
    [[ CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"animalsAnims_iPhone.plist" textureFile:@"animalsAnims_iPhone.png"];
	animalAnimSB = [CCSpriteBatchNode batchNodeWithFile:@"animalsAnims_iPhone.png"];
    
    [self addChild:animalAnimSB z:0];
	[self createPalabra];
    [self loadSpinningStuff];
}

-(void)loadSpriteSheets {
    
    switch (nSheetToLoad) {
        case 0:
            [[ CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"animalsAnimsBee_iPhone.plist" textureFile:@"animalsAnimsBee_iPhone.png"];
            animalAnimSBBee = [CCSpriteBatchNode batchNodeWithFile:@"animalsAnimsBee_iPhone.png"];
            [self addChild:animalAnimSBBee z:0];
            break;
        case 1:
            [[ CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"animalsAnimsCat_iPhone.plist" textureFile:@"animalsAnimsCat_iPhone.png"];
            animalAnimSBCat = [CCSpriteBatchNode batchNodeWithFile:@"animalsAnimsCat_iPhone.png"];
            [self addChild:animalAnimSBCat z:0];
            break;
        case 2:
            [[ CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"animalsAnimsDuck_iPhone.plist" textureFile:@"animalsAnimsDuck_iPhone.png"];
            animalAnimSBDuck = [CCSpriteBatchNode batchNodeWithFile:@"animalsAnimsDuck_iPhone.png"];
            [self addChild:animalAnimSBDuck z:0];
            break;
        case 3:
            [[ CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"animalsAnimsDog_iPhone.plist" textureFile:@"animalsAnimsDog_iPhone.png"];
            animalAnimSBDog = [CCSpriteBatchNode batchNodeWithFile:@"animalsAnimsDog_iPhone.png"];
            [self addChild:animalAnimSBDog z:0];
            break;
        case 4:
            [[ CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"animalsAnimsChicken_iPhone.plist" textureFile:@"animalsAnimsChicken_iPhone.png"];
            animalAnimSBChicken = [CCSpriteBatchNode batchNodeWithFile:@"animalsAnimsChicken_iPhone.png"];
            [self addChild:animalAnimSBChicken z:0];
            break;
        case 5:
            [[ CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"animalsAnimsPig_iPhone.plist" textureFile:@"animalsAnimsPig_iPhone.png"];
            animalAnimSBPig = [CCSpriteBatchNode batchNodeWithFile:@"animalsAnimsPig_iPhone.png"];
            [self addChild:animalAnimSBPig z:0];
            break;
        case 6:
            [[ CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"animalsAnimsCow_iPhone.plist" textureFile:@"animalsAnimsCow_iPhone.png"];
            animalAnimSBCow = [CCSpriteBatchNode batchNodeWithFile:@"animalsAnimsCow_iPhone.png"];
            [self addChild:animalAnimSBCow z:0];
            break;
        case 7:
            [[ CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"animalsAnimsHorse_iPhone.plist" textureFile:@"animalsAnimsHorse_iPhone.png"];
            animalAnimSBHorse = [CCSpriteBatchNode batchNodeWithFile:@"animalsAnimsHorse_iPhone.png"];
            [self addChild:animalAnimSBHorse z:0];
            [self unschedule:@selector(loadSpriteSheets)];
            return;
            break;
        default:
            break;
    }
    
    nSheetToLoad ++;
    [self schedule:@selector(loadSpriteSheets) interval:0.05];
}

/*-(void)playAnimForAnimal:(CCMenuItemImage *)btn
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
    
    if ([animal rangeOfString:@"cat"].location != NSNotFound) {
        [animalAnimSBCat addChild:itemAnim];
    }
    else if ([animal rangeOfString:@"dog"].location != NSNotFound) {
        [animalAnimSBDog addChild:itemAnim];
    }
    else if ([animal rangeOfString:@"bee"].location != NSNotFound) {
        [animalAnimSBBee addChild:itemAnim];
    }
    else if ([animal rangeOfString:@"chicken"].location != NSNotFound) {
        [animalAnimSBChicken addChild:itemAnim];
    }
    else if ([animal rangeOfString:@"horse"].location != NSNotFound) {
        [animalAnimSBHorse addChild:itemAnim];
    }
    else if ([animal rangeOfString:@"cow"].location != NSNotFound) {
        [animalAnimSBCow addChild:itemAnim];
    }
    else if ([animal rangeOfString:@"duck"].location != NSNotFound) {
        [animalAnimSBDuck addChild:itemAnim];
    }
    else {
        [animalAnimSBPig addChild:itemAnim];
    }
	//[animalAnimSB addChild:itemAnim];
	[itemAnim setPosition:ccp(posX,posY)];
	
	NSMutableArray *animFrames = [NSMutableArray array];
	for(int i = 0; i <= framesNum; i++) {
		
		CCSpriteFrame *frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"SeeNSay_%@_ANIM_%05d.png",animal,i]];
		[animFrames addObject:frame];
	}
	
	CCAnimation *animation = [CCAnimation animationWithFrames:animFrames];
    
	[itemAnim runAction:[CCSequence actions:[CCAnimate actionWithDuration:1 animation:animation restoreOriginalFrame:NO],[CCCallFuncND actionWithTarget:self selector:@selector(removeAnimalsAnim: data:) data:(void *)btn],nil]];
	
}*/


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
