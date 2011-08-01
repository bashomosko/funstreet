    //
//  MainMenu_iPad.m
//  Basho
//
//  Created by Pablo Ruiz on 12/02/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MainMenu_iPad.h"
#import "AppDelegate_iPad.h"
#import "GameWheel_iPad.h"
#import "GameDress_iPad.h"
#import "GameVideo_iPad.h"
#import "GameManager.h"
#import "SimpleAudioEngine.h"

@implementation MainMenu_iPad

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
    
    if(![GameManager sharedGameManager].playedMenuVideo)
	{
		[[GameManager sharedGameManager] setPlayedMenuVideo:YES];
		[self playVideo:@"iPad"];
	}else {
        [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"backgroundMusic.mp3"];
		[self animateDoors:@"_iPad"];
	}
    [scroll setContentSize:CGSizeMake(2048,768)];
    doorsSuffix = @"_iPad";
    widthScreen = 1024;
    [super viewDidLoad];
}



// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    if (interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight)
		return YES;
	
	return NO;
}

-(void)loadWheel
{
	AppDelegate_iPad * app = (AppDelegate_iPad *)[[UIApplication sharedApplication] delegate];
    
    [app.backgroundActivity setHidden:NO];
	[app.activityImageView setHidden:NO];//01/08/2011
    [app.activityImageView startAnimating];//01/08/2011
    
    [btnWheel setEnabled:NO];//01/08/2011
	
	[self performSelector:@selector(startLoadWheel) withObject:nil afterDelay:1];
	
}

-(void)startLoadWheel
{
	GameWheel_iPad * gw = [[GameWheel_iPad alloc] 
						   initWithNibName:@"GameWheel_iPad" bundle:nil];
	
	AppDelegate_iPad * app = (AppDelegate_iPad *)[[UIApplication sharedApplication] delegate];
    
    [btnWheel setEnabled:YES];//01/08/2011
	
	[app.navController pushViewController:gw animated:NO];
	
	[gw release];
}

-(void)loadDress
{
	AppDelegate_iPad * app = (AppDelegate_iPad *)[[UIApplication sharedApplication] delegate];
    
    [app.backgroundActivity setHidden:NO];
	[app.activityImageView setHidden:NO];//01/08/2011
    [app.activityImageView startAnimating];//01/08/2011
    
    [btnDress setEnabled:NO];//01/08/2011
	
	[self performSelector:@selector(startLoadDress) withObject:nil afterDelay:1];
	
}

-(void)startLoadDress
{
	GameDress_iPad * gw = [[GameDress_iPad alloc] 
						   initWithNibName:@"GameDress_iPad" bundle:nil];
	
	AppDelegate_iPad * app = (AppDelegate_iPad *)[[UIApplication sharedApplication] delegate];
    
    [btnDress setEnabled:YES];//01/08/2011
	
	[app.navController pushViewController:gw animated:NO];
	
	[gw release];
}

-(void)loadVideo
{
	GameVideo_iPad * gw = [[GameVideo_iPad alloc] 
					  initWithNibName:@"GameVideo_iPad" bundle:nil];
	
	AppDelegate_iPad * app = (AppDelegate_iPad *)[[UIApplication sharedApplication] delegate];
	
	[app.navController pushViewController:gw animated:NO];
	
	[gw release];
}

-(IBAction)goToSettings
{
	[GameManager sharedGameManager].onPause = YES;
	sv = [[SettingsViewController_iPad alloc] initWithNibName:@"SettingsViewController_iPad" bundle:nil];
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
        [self playVideo:@"iPad"];
    }
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
