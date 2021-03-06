    //
//  GameDress_iPad.m
//  Basho
//
//  Created by Pablo Ruiz on 04/03/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GameDress_iPad.h"
#import "cocos2d.h"
#import "AppDelegate_iPad.h"
#import "MainMenu_iPad.h"
#import "SimpleAudioEngine.h"
#import "GameManager.h"

@implementation GameDress_iPad

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
	
	AppDelegate_iPad * app = (AppDelegate_iPad *)[[UIApplication sharedApplication] delegate];
	UIWindow * window = app.window;
	EAGLView *glView = [EAGLView viewWithFrame:[window bounds]
								   pixelFormat:kEAGLColorFormatRGB565	// kEAGLColorFormatRGBA8
								   depthFormat:0						// GL_DEPTH_COMPONENT16_OES
						];
	
	[director setOpenGLView:glView];
	
	//	// Enables High Res mode (Retina Display) on iPhone 4 and maintains low res on all other devices
	//	if( ! [director enableRetinaDisplay:YES] )
	//		CCLOG(@"Retina Display Not supported");
	
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
	//[self removeStartupFlicker];
	
	// Run the intro Scene
    GameDressScene_iPad * gameDressScene = [GameDressScene_iPad sceneWithDressVC:self bashoDirected:NO playVid:YES playingAgain:NO];
    gameDressLayer = [gameDressScene getChildByTag:1000];
	[[CCDirector sharedDirector] runWithScene:gameDressScene];	
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
	
	[self.view removeFromSuperview];
	[self release];
	
	MainMenu_iPad * gw = [[MainMenu_iPad alloc] 
						  initWithNibName:@"MainMenu_iPad" bundle:nil];
	[gw.view setAlpha:0];
	AppDelegate_iPad * app = (AppDelegate_iPad *)[[UIApplication sharedApplication] delegate];
	UIWindow * w = app.window;
	[w addSubview:gw.view];
	
	[UIView beginAnimations:nil context:nil];
	[gw.view setAlpha:1];
	[UIView commitAnimations];
}

-(void)goToNextGame
{
	[[CCScheduler sharedScheduler] unscheduleAllSelectors];
	[[CCActionManager sharedManager] removeAllActions];
	CCDirector *director = [CCDirector sharedDirector];
	[[director openGLView] removeFromSuperview];
	[director end];	
	
	[self.view removeFromSuperview];
	[self release];
	
	MainMenu_iPad * gw = [[MainMenu_iPad alloc] 
						  initWithNibName:@"MainMenu_iPad" bundle:nil];
	[gw.view setAlpha:0];
	AppDelegate_iPad * app = (AppDelegate_iPad *)[[UIApplication sharedApplication] delegate];
	UIWindow * w = app.window;
	[w addSubview:gw.view];
	
	[UIView beginAnimations:nil context:nil];
	[gw.view setAlpha:0.01];
	[UIView commitAnimations];
	
	[gw goToVideo:nil];
}

-(void)goToSettings
{
	[GameManager sharedGameManager].onPause = YES;
	sv = [[SettingsViewController_iPad alloc] initWithNibName:@"SettingsViewController_iPad" bundle:nil];
	sv.rootVC = self;
	
	[[[CCDirector sharedDirector] openGLView] addSubview:sv.view];
}

-(void)removeSettings
{
	[GameManager sharedGameManager].onPause = NO;
	[sv.view removeFromSuperview];
	[sv release];
    
    if(![GameManager sharedGameManager].playedGame2Video)
    {
        [[GameManager sharedGameManager] setPlayedGame2Video:YES];
        [gameDressLayer loadVideo];
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