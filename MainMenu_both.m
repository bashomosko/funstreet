    //
//  MainMenu_both.m
//  Basho
//
//  Created by Pablo Ruiz on 12/02/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MainMenu_both.h"

@implementation MainMenu_both

@synthesize btnSong,btnDress,btnWheel,btnVideo,scroll,door1,door2;

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


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    
    
    [self animateDoors];
    [super viewDidLoad];
}

-(void)animateDoors
{
    NSString* format = @"CityMenu_Page1_GlowingDoors_%05d_iPad";
   /* if([viewController iPad] == FALSE)
    {
        format = @"EyePulseAnim_%05d-iPhone.png";
    }*/
    
    NSMutableArray* images = [[NSMutableArray alloc] init];
    for(int i=0; i<=11; i++)
    {
        NSString* name = [NSString stringWithFormat:format, i];
        NSString *filePath = [[NSBundle mainBundle] pathForResource:name ofType:@"png"];
        UIImage* image = [[UIImage alloc] initWithContentsOfFile:filePath];
        [images addObject:image];
        [image release];
    }
    door1.animationImages = images;
    [images release];
    door1.animationDuration = 1;
    door1.animationRepeatCount = 0; //this is a looping animation
    [door1 startAnimating];
    
    
    NSString* format2 = @"CityMenu_Page2_GlowingDoors_%05d_iPad";
    /* if([viewController iPad] == FALSE)
     {
     format = @"EyePulseAnim_%05d-iPhone.png";
     }*/
    
    NSMutableArray* images2 = [[NSMutableArray alloc] init];
    for(int i=0; i<=11; i++)
    {
        NSString* name = [NSString stringWithFormat:format2, i];
        NSString *filePath = [[NSBundle mainBundle] pathForResource:name ofType:@"png"];
        UIImage* image = [[UIImage alloc] initWithContentsOfFile:filePath];
        [images2 addObject:image];
        [image release];
    }
    door2.animationImages = images2;
    [images2 release];
    door2.animationDuration = 1;
    door2.animationRepeatCount = 0; //this is a looping animation
    [door2 startAnimating];
    

}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    if (interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight)
		return YES;
	
	return NO;
}

-(IBAction) goToSong:(id)sender
{
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(loadSong)];
	[self.view setAlpha:0];
	[UIView commitAnimations];
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
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(loadVideo)];
	[self.view setAlpha:0];
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
	[btnSong release];
	[btnWheel release];
	[btnVideo release];
	[btnDress release];
    [super dealloc];
}


@end
