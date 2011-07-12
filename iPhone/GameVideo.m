//
//  GameVideo.m
//  Basho
//
//  Created by Pablo Ruiz on 07/03/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GameVideo.h"
#import "SimpleAudioEngine.h"
#import "MainMenu.h"
#import "AppDelegate_iPhone.h"


@implementation GameVideo

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
    
    widthScroll = 300;
    heightScroll= 169;
    
    widthVideo = 480;
    heightVideo = 320;
	
    UIButton * skip = [UIButton buttonWithType:UIButtonTypeCustom];
	[skip setFrame:CGRectMake(0,0,53,53)];
	[skip setImage:[UIImage imageNamed:@"wheel_home.png"] forState:UIControlStateNormal];
	[skip setImage:[UIImage imageNamed:@"wheel_home.png"] forState:UIControlStateHighlighted];
	[skip addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:skip];
    
    [scrollPaging setHidden:YES];
    
	[UIView beginAnimations:nil context:nil];
	
	[UIView setAnimationDuration:1];
	[UIView setAnimationDelay:1];
	[curtainL setCenter:CGPointMake(-56, curtainL.center.y)];
	[curtainR setCenter:CGPointMake(538, curtainL.center.y)];
    [self performSelector:@selector(loadGame) withObject:nil afterDelay:0.8];
	
	[UIView commitAnimations];

    [super viewDidLoad];
	
}

-(void)goBack
{
	[self goToMenu];
}

-(void)goToMenu
{
	[self.view removeFromSuperview];
	[self release];
	
	MainMenu * gw = [[MainMenu alloc] 
						  initWithNibName:@"MainMenu" bundle:nil];
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
    return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight);
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
