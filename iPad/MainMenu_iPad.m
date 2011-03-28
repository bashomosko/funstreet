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
#import "InteractiveSong_iPad.h"

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

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/


// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    if (interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight)
		return YES;
	
	return NO;
}

-(void)loadSong
{
	[self.view removeFromSuperview];
	[self release];
	
	InteractiveSong_iPad * gw = [[InteractiveSong_iPad alloc] 
						   initWithNibName:@"InteractiveSong_iPad" bundle:nil];
	[gw.view setAlpha:0];
	AppDelegate_iPad * app = (AppDelegate_iPad *)[[UIApplication sharedApplication] delegate];
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
	
	GameWheel_iPad * gw = [[GameWheel_iPad alloc] 
						   initWithNibName:@"GameWheel_iPad" bundle:nil];
	[gw.view setAlpha:0];
	AppDelegate_iPad * app = (AppDelegate_iPad *)[[UIApplication sharedApplication] delegate];
	UIWindow * w = app.window;
	[w addSubview:gw.view];
	
	[UIView beginAnimations:nil context:nil];
	[gw.view setAlpha:1];
	[UIView commitAnimations];
}

-(void)loadDress
{
	[self.view removeFromSuperview];
	[self release];
	
	GameDress_iPad * gw = [[GameDress_iPad alloc] 
						   initWithNibName:@"GameDress_iPad" bundle:nil];
	[gw.view setAlpha:0];
	AppDelegate_iPad * app = (AppDelegate_iPad *)[[UIApplication sharedApplication] delegate];
	UIWindow * w = app.window;
	[w addSubview:gw.view];
	
	[UIView beginAnimations:nil context:nil];
	[gw.view setAlpha:1];
	[UIView commitAnimations];
}

-(void)loadVideo
{
	[self.view removeFromSuperview];
	[self release];
	
	GameVideo_iPad * gw = [[GameVideo_iPad alloc] 
					  initWithNibName:@"GameVideo_iPad" bundle:nil];
	[gw.view setAlpha:0];
	AppDelegate_iPad * app = (AppDelegate_iPad *)[[UIApplication sharedApplication] delegate];
	UIWindow * w = app.window;
	[w addSubview:gw.view];
	
	[UIView beginAnimations:nil context:nil];
	[gw.view setAlpha:1];
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
