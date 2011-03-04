    //
//  MainMenu_both.m
//  Basho
//
//  Created by Pablo Ruiz on 12/02/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MainMenu_both.h"

@implementation MainMenu_both

@synthesize btnSong,btnDress,btnWheel,btnVideo;

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
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    if (interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight)
		return YES;
	
	return NO;
}

-(IBAction) goToSong:(id)sender
{
}

-(IBAction) goToWheel:(id)sender
{
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(loadWheel)];
	[self.view setAlpha:0];
	[UIView commitAnimations];
	
}

-(IBAction) goToDress:(id)sender
{
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(loadDress)];
	[self.view setAlpha:0];
	[UIView commitAnimations];
}

-(IBAction) goToVideo:(id)sender
{
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
	[btnSong release];
	[btnWheel release];
	[btnVideo release];
	[btnDress release];
    [super dealloc];
}


@end
