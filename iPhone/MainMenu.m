//
//  MainMenu.m
//  Basho
//
//  Created by Pablo Ruiz on 12/02/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MainMenu.h"
#import "AppDelegate_iPhone.h"
#import "GameWheel.h"
#import "GameVideo.h"
#import "GameManager.h"
#import "SimpleAudioEngine.h"
#import "GameDress_iPhone.h"

@implementation MainMenu

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
       
    }
    return self;
}



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    
    AppDelegate_iPhone * app = (AppDelegate_iPhone *)[[UIApplication sharedApplication] delegate];
    
    //[app.loading stopAnimating];
    
    if(![GameManager sharedGameManager].playedMenuVideo)
	{
		[[GameManager sharedGameManager] setPlayedMenuVideo:YES];
		[self playVideo:@"iPhone"];
	}else {
        [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"backgroundMusic.mp3"];
		[self animateDoors:@"_iPhone"];
	}
    doorsSuffix = @"_iPhone";
    [scroll setContentSize:CGSizeMake(960,scroll.frame.size.height)];
    
    float width = 480;
    
    if (IS_IPHONE5) {
        width = 568;
    }
    
    [scroll setFrame:CGRectMake(scroll.frame.origin.x, scroll.frame.origin.y, width, scroll.frame.size.height)];
    

    widthScreen = 480;
    
    if (IS_IPHONE5) {
        widthScreen = 392;
    }
    
 //   [scroll setFrame:CGRectMake(0, 0, widthScreen, 320)];
    [btnPreviousScreen setAlpha:0];
    [btnPreviousScreen setEnabled:NO];
    
    //widthScreen = 480;
    [super viewDidLoad];
}

- (BOOL)shouldAutorotate{
    return YES;
}
-(NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskLandscape;
}
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
    return UIInterfaceOrientationLandscapeLeft;
}

-(void)loadDress
{
	AppDelegate_iPhone * app = (AppDelegate_iPhone *)[[UIApplication sharedApplication] delegate];
    
	[app.activityImageView setHidden:NO];//01/08/2011
    [app.backgroundActivity setHidden:NO];//01/08/2011
    [app.activityImageView startAnimating];//01/08/2011
    
    [btnDress setEnabled:NO];//01/08/2011
	
	[self performSelector:@selector(startLoadDress) withObject:nil afterDelay:1];

}

-(void)startLoadDress
{
	AppDelegate_iPhone * app = (AppDelegate_iPhone *)[[UIApplication sharedApplication] delegate];

	GameDress_iPhone * gw = [[GameDress_iPhone alloc] 
							 initWithNibName:@"GameDress_iPhone" bundle:nil];
    
    [btnDress setEnabled:YES];//01/08/2011
	
	[app.navController pushViewController:gw animated:NO];
	
	[gw release];
}


-(IBAction)goToSettings
{
	[GameManager sharedGameManager].onPause = YES;
	sv = [[SettingsViewController_iPhone alloc] initWithNibName:@"SettingsViewController_iPhone" bundle:nil];
	sv.rootVC = self;
    
    
    if (IS_IPHONE5) {
        [sv.view setFrame:CGRectMake(0, 0, 568, 320)];
    } else {
        [sv.view setFrame:CGRectMake(0, 0, 480, 320)];
    }
	
	[self.view addSubview:sv.view];
}

-(void)removeSettings
{
	[GameManager sharedGameManager].onPause = NO;
	[sv.view removeFromSuperview];
	[sv release];
    
    if(![GameManager sharedGameManager].playedMenuVideo)
    {
        [[GameManager sharedGameManager] setPlayedMenuVideo:YES];
        [self playVideo:@"iPhone"];
    }
}

-(void)loadVideo
{
	
    NSString * strScreen;
    
    if (IS_IPHONE5) {
        strScreen = @"GameVideo5";
    }
    else {
        strScreen = @"GameVideo";
    }
    
	GameVideo * gw = [[GameVideo alloc] 
					  initWithNibName:strScreen bundle:nil];
	
	AppDelegate_iPhone * app = (AppDelegate_iPhone *)[[UIApplication sharedApplication] delegate];
	
	[app.navController pushViewController:gw animated:NO];
	
	[gw release];
}

-(void)loadWheel
{   
    AppDelegate_iPhone * app = (AppDelegate_iPhone *)[[UIApplication sharedApplication] delegate];
    
	[app.activityImageView setHidden:NO];//01/08/2011
    [app.backgroundActivity setHidden:NO];//01/08/2011
    [app.activityImageView startAnimating];//01/08/2011
    
    [btnWheel setEnabled:NO];//01/08/2011
	
	[self performSelector:@selector(startLoadWheel) withObject:nil afterDelay:1];
}

-(void)startLoadWheel
{ 
    AppDelegate_iPhone * app = (AppDelegate_iPhone *)[[UIApplication sharedApplication] delegate];
	
	GameWheel * gw = [[GameWheel alloc] 
					  initWithNibName:@"GameWheel" bundle:nil];
	
    [btnWheel setEnabled:YES];//01/08/2011
    
	[app.navController pushViewController:gw animated:NO];
	
	[gw release];
}

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    if (interfaceOrientation == UIInterfaceOrientationLandscapeRight || interfaceOrientation == UIInterfaceOrientationLandscapeLeft)
		return YES;
	
	return NO;
}

-(IBAction) goToNextScreen:(id)sender
{
    [scroll setContentOffset:CGPointMake(widthScreen, 0) animated:YES];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.1];
	[btnPreviousScreen setAlpha:1];
    [btnNextScreen setEnabled:NO];
    [btnPreviousScreen setEnabled:YES];
    [btnNextScreen setAlpha:0];
	[UIView commitAnimations];
}

-(IBAction) goToPreviousScreen:(id)sender
{
    [scroll setContentOffset:CGPointMake(0, 0) animated:YES];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.1];
	[btnPreviousScreen setAlpha:0];
    [btnNextScreen setEnabled:YES];
    [btnPreviousScreen setEnabled:NO];
    [btnNextScreen setAlpha:1];
	[UIView commitAnimations];
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
