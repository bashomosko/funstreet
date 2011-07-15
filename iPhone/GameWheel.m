//
//  GameWheel.m
//  Basho
//
//  Created by Pablo Ruiz on 12/02/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GameWheel.h"
#import "cocos2d.h"
#import "AppDelegate_iPhone.h"
#import "GameWheelScene.h"
#import "GameManager.h"
#import "SimpleAudioEngine.h"

@implementation GameWheel

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
    }
    return self;
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	CCDirector *director = [CCDirector sharedDirector];
	
	// Init the View Controller
	self.wantsFullScreenLayout = YES;
	
	AppDelegate_iPhone * app = (AppDelegate_iPhone *)[[UIApplication sharedApplication] delegate];
	UIWindow * window = app.window;
	EAGLView *glView = [EAGLView viewWithFrame:[window bounds]
								   pixelFormat:kEAGLColorFormatRGB565	// kEAGLColorFormatRGBA8
								   depthFormat:0						// GL_DEPTH_COMPONENT16_OES
						];
	
	[director setOpenGLView:glView];
	
	//	// Enables High Res mode (Retina Display) on iPhone 4 and maintains low res on all other devices
		if( ! [director enableRetinaDisplay:YES] )
			CCLOG(@"Retina Display Not supported");
	
#if GAME_AUTOROTATION == kGameAutorotationUIViewController
	[director setDeviceOrientation:kCCDeviceOrientationPortrait];
#else
	[director setDeviceOrientation:kCCDeviceOrientationLandscapeLeft];
#endif
	
	[director setAnimationInterval:1.0/60];
	[director setDisplayFPS:YES];
	
	
	// make the OpenGLView a child of the view controller
	[self setView:glView];
	
	[CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_RGBA8888];
	
	// Removes the startup flicker
	[self removeStartupFlicker];
	
	// Run the intro Scene
	//[[CCDirector sharedDirector] runWithScene: [GameWheelScene sceneWithWheelVC:self]];	
    
    GameWheelScene * gameWheelScene = [GameWheelScene sceneWithWheelVC:self];
    gameWheelLayer = (GameWheelScene*)[gameWheelScene getChildByTag:1000];
	
	[[CCDirector sharedDirector] runWithScene:(CCScene*)gameWheelScene];
}

- (void) removeStartupFlicker
{
	//
	// THIS CODE REMOVES THE STARTUP FLICKER
	//
	// Uncomment the following code if you Application only supports landscape mode
	//
#if GAME_AUTOROTATION == kGameAutorotationUIViewController
	
		CC_ENABLE_DEFAULT_GL_STATES();
		CCDirector *director = [CCDirector sharedDirector];
		CGSize size = [director winSize];
		CCSprite *sprite = [CCSprite spriteWithFile:@"Default.png"];
		sprite.position = ccp(size.width/2, size.height/2);
		sprite.rotation = -90;
		[sprite visit];
		[[director openGLView] swapBuffers];
		CC_ENABLE_DEFAULT_GL_STATES();
	
#endif // GAME_AUTOROTATION == kGameAutorotationUIViewController	
}

-(void)goToMenu
{
	CCDirector *director = [CCDirector sharedDirector];
	[[director openGLView] removeFromSuperview];
	[director end];	
	[[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"backgroundMusic.mp3"];
	AppDelegate_iPhone * app = (AppDelegate_iPhone *)[[UIApplication sharedApplication] delegate];
	
	[app.navController popViewControllerAnimated:NO];
}


-(void)goToSettings
{
	[GameManager sharedGameManager].onPause = YES;
	sv = [[SettingsViewController_iPhone alloc] initWithNibName:@"SettingsViewController_iPhone" bundle:nil];
    
	sv.rootVC = self;
	
	[[[CCDirector sharedDirector] openGLView] addSubview:sv.view];
}

-(void)removeSettings
{
	[GameManager sharedGameManager].onPause = NO;
	[sv.view removeFromSuperview];
	[sv release];
    
    if(![GameManager sharedGameManager].playedGame1Video)
    {
        [[GameManager sharedGameManager] setPlayedGame1Video:YES];
        [gameWheelLayer loadVideo];
    }
    
}


// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    if (interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight)
		return YES;
	
	return NO;
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end
