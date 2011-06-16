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
    
    if(![GameManager sharedGameManager].playedMenuVideo)
	{
		[[GameManager sharedGameManager] setPlayedMenuVideo:YES];
		[self playVideo:@"iPad"];
	}else {
        [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"backgroundMusic.mp3"];
		[self animateDoors:@"_iPhone"];
	}
    doorsSuffix = @"_iPhone";
    [scroll setContentSize:CGSizeMake(960,320)];
    
    [super viewDidLoad];
}


-(void)loadVideo
{
	[self.view removeFromSuperview];
	[self release];
	
	GameVideo * gw = [[GameVideo alloc] 
					  initWithNibName:@"GameVideo" bundle:nil];
	[gw.view setAlpha:0];
	AppDelegate_iPhone * app = (AppDelegate_iPhone *)[[UIApplication sharedApplication] delegate];
	UIWindow * w = app.window;
	[w addSubview:gw.view];
	
	[UIView beginAnimations:nil context:nil];
	[gw.view setAlpha:1];
	[UIView commitAnimations];
}

-(void)loadWheel
{
	[self.view removeFromSuperview];
	[self release];
	
	GameWheel * gw = [[GameWheel alloc] 
					 initWithNibName:@"GameWheel" bundle:nil];
	[gw.view setAlpha:0];
	AppDelegate_iPhone * app = (AppDelegate_iPhone *)[[UIApplication sharedApplication] delegate];
	UIWindow * w = app.window;
	[w addSubview:gw.view];
	
	[UIView beginAnimations:nil context:nil];
	[gw.view setAlpha:1];
	[UIView commitAnimations];
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
