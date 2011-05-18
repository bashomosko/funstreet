    //
//  MainMenu_both.m
//  Basho
//
//  Created by Pablo Ruiz on 12/02/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MainMenu_both.h"
#import "SimpleAudioEngine.h"
#import "GameManager.h"

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
    
    [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"backgroundMusic.mp3"];
  //  [self animateDoors];
	if(![GameManager sharedGameManager].playedMenuVideo)
	{
		[GameManager sharedGameManager].playedMenuVideo = YES;
		[self playVideo];
	}else {
		[self animateDoors];
	}

    [super viewDidLoad];
	
}


-(void)playVideo
{
	NSURL * url;
	NSBundle *bundle = [NSBundle mainBundle];
	if (bundle) 
	{
		NSString *moviePath = [bundle pathForResource:[NSString stringWithFormat:@"menu_%@_iPad",[GameManager sharedGameManager].instructionsLanguageString] ofType:@"mov"];
		if (moviePath)
		{
			url = [NSURL fileURLWithPath:moviePath];
		}
	}
	
	introVideo = [[MPMoviePlayerController alloc] initWithContentURL:url];
	[self.view addSubview:introVideo.view];
	[introVideo.view setFrame:CGRectMake(0,0,1024,768)];
	[introVideo setControlStyle:MPMovieControlStyleNone];
	
	[[NSNotificationCenter defaultCenter]
	 addObserver:self
	 selector:@selector(videoPlayerDidFinishPlaying:)
	 name:MPMoviePlayerPlaybackDidFinishNotification
	 object:introVideo];
	
	UIButton * skip = [UIButton buttonWithType:UIButtonTypeCustom];
	[skip setFrame:CGRectMake(0,0,1024,768)];
	[skip addTarget:self action:@selector(skipMovie) forControlEvents:UIControlEventTouchUpInside];
	[introVideo.view addSubview:skip];
	
	
	[introVideo play];
}

-(void)skipMovie
{
	[[NSNotificationCenter defaultCenter] removeObserver:self
													name:MPMoviePlayerPlaybackDidFinishNotification object:introVideo];
	[introVideo stop];
	[introVideo.view removeFromSuperview];
	[introVideo release];
	 [self animateDoors];
}

-(void) videoPlayerDidFinishPlaying: (NSNotification*)aNotification
{
	MPMoviePlayerController * introVideo = [aNotification object];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerPlaybackDidFinishNotification object:introVideo];
	[introVideo stop];
	[introVideo.view removeFromSuperview];
	[introVideo release];
	
	 [self animateDoors];
	//[self beginGame];
}


-(void)animateDoors
{
    NSString* format = @"CityMenu_Page1_GlowingDoors_%05d_iPad";
   /* if([viewController iPad] == FALSE)
    {
        format = @"EyePulseAnim_%05d-iPhone.png";
    }*/
    
	int j = -1;
    NSMutableArray* images = [[NSMutableArray alloc] init];
    for(int i=0; i<=5; i++)
    {
		if (i<=3) {
			j++;
		}else {
			j--;
		}
        NSString* name = [NSString stringWithFormat:format, j];
        NSString *filePath = [[NSBundle mainBundle] pathForResource:name ofType:@"png"];
        UIImage* image = [[UIImage alloc] initWithContentsOfFile:filePath];
        [images addObject:image];
        [image release];
    }
    door1.animationImages = images;
    [images release];
    door1.animationDuration = 0.8;
    door1.animationRepeatCount = 0; //this is a looping animation
    [door1 startAnimating];
    

    NSString* format2 = @"CityMenu_Page2_GlowingDoors_%05d_iPad";
   
    j =-1;
    NSMutableArray* images2 = [[NSMutableArray alloc] init];
    for(int i=0; i<=5; i++)
    {
		if (i<=3) {
			j++;
		}else {
			j--;
		}
        NSString* name = [NSString stringWithFormat:format2, j];
        NSString *filePath = [[NSBundle mainBundle] pathForResource:name ofType:@"png"];
        UIImage* image = [[UIImage alloc] initWithContentsOfFile:filePath];
        [images2 addObject:image];
        [image release];
    }
    door2.animationImages = images2;
    [images2 release];
    door2.animationDuration = 0.8;
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
	[door1 stopAnimating];
	[door2 stopAnimating];
	[btnSong release];
	[btnWheel release];
	[btnVideo release];
	[btnDress release];
    [super dealloc];
}


@end
