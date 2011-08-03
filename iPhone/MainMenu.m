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
    [scroll setContentSize:CGSizeMake(960,320)];
    widthScreen = 480;
    [super viewDidLoad];
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
	
	GameVideo * gw = [[GameVideo alloc] 
					  initWithNibName:@"GameVideo" bundle:nil];
	
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
