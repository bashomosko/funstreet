    //
//  GameVideo_iPad.m
//  Basho
//
//  Created by Pablo Ruiz on 24/03/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GameVideo_iPad.h"
#import "MainMenu_iPad.h"
#import "AppDelegate_iPad.h"
#import "SimpleAudioEngine.h"

@implementation GameVideo_iPad

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
	
    widthScroll = 640;
    heightScroll= 360;
    
    widthVideo = 1024;
    heightVideo = 768;
    
    
    UIButton * skip = [UIButton buttonWithType:UIButtonTypeCustom];
	[skip setFrame:CGRectMake(0,0,106,106)];
	[skip setImage:[UIImage imageNamed:@"wheel_home_iPad.png"] forState:UIControlStateNormal];
	[skip setImage:[UIImage imageNamed:@"wheel_home_iPad.png"] forState:UIControlStateHighlighted];
	[skip addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:skip];
    
    [scrollPaging setHidden:YES];
    

    [self performSelector:@selector(loadGame) withObject:nil afterDelay:0.8];
	

	
    [super viewDidLoad];
	
	
}

-(void)doAnimation {
    [UIView beginAnimations:nil context:nil];
	
	[UIView setAnimationDuration:1];
	[UIView setAnimationDelay:0.1];
	[curtainL setCenter:CGPointMake(-112, curtainL.center.y)];
	[curtainR setCenter:CGPointMake(1136, curtainL.center.y)];
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

-(void)goBack
{
	[self goToMenu];
}

-(void)goToMenu
{
	AppDelegate_iPad * app = (AppDelegate_iPad *)[[UIApplication sharedApplication] delegate];
	
	[app.navController popViewControllerAnimated:NO];
    
}


- (void)dealloc {
	//[scrollview release];
	//[curtainL release];
	//[curtainR release];
    [super dealloc];
}


@end

