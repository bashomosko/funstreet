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
	
	NSURL * url;
	NSBundle *bundle = [NSBundle mainBundle];
	if (bundle) 
	{
		NSString *moviePath = [bundle pathForResource:@"botas-2011" ofType:@"mp3"];
		if (moviePath)
		{
			url = [NSURL fileURLWithPath:moviePath];
		}
	}
	
	video = [[MPMoviePlayerController alloc] initWithContentURL:url];
	[self.view addSubview:video.view];
	[video.view setFrame:CGRectMake(0,0,1024,768)];
	//[video.view setTransform:CGAffineTransformMakeRotation(M_PI/ 2)];
	[video play];	
	NSString *filePath = [[NSBundle mainBundle] pathForResource:@"videoLyrics" ofType:@"plist"];
	
	lyricLines = [[NSMutableArray arrayWithContentsOfFile:filePath]retain];
	
	currentLyricLine = 0;
	
	lyrics = [[UILabel alloc] initWithFrame:CGRectMake(0,680,1024,80)];
	
	[lyrics setText:@""];
	[lyrics setFont:[UIFont fontWithName:@"Helvetica" size:30]];
	[lyrics setBackgroundColor:[UIColor clearColor]];
	[lyrics setTextColor:[UIColor whiteColor]];
	[lyrics setShadowColor:[UIColor blackColor]];
	[lyrics setShadowOffset:CGSizeMake(1,1)];
	[lyrics setTextAlignment:UITextAlignmentCenter];
	
	[video.view addSubview:lyrics];
	
	[lyrics release];
	
	[self showLyricLine];
	
	UIButton * skip = [UIButton buttonWithType:UIButtonTypeCustom];
	[skip setFrame:CGRectMake(0,0,106,106)];
	[skip setImage:[UIImage imageNamed:@"wheel_home_iPad.png"] forState:UIControlStateNormal];
	[skip setImage:[UIImage imageNamed:@"wheel_home_iPad.png"] forState:UIControlStateHighlighted];
	[skip addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
	[video.view addSubview:skip];
	
	
    [super viewDidLoad];
	
	
}

-(void)showLyricLine
{
	if([lyricLines count]>currentLyricLine)
	{
		NSMutableDictionary * line = [lyricLines objectAtIndex:currentLyricLine];
		NSString * text = [line objectForKey:@"lyric"];
		float duration = [[line objectForKey:@"duration"] floatValue];
		
		[lyrics setText:text];
		
		[self performSelector:@selector(showLyricLine) withObject:nil afterDelay:duration];
		currentLyricLine++;
	}
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
	[[NSNotificationCenter defaultCenter] removeObserver:self
													name:MPMoviePlayerPlaybackDidFinishNotification object:video];
	[video stop];
	[video.view removeFromSuperview];
	[self goToMenu];
}

-(void)goToMenu
{
	[self.view removeFromSuperview];
	[self release];
	
	MainMenu_iPad * gw = [[MainMenu_iPad alloc] 
						  initWithNibName:@"MainMenu_iPad" bundle:nil];
	[gw.view setAlpha:0];
	AppDelegate_iPad * app = (AppDelegate_iPad *)[[UIApplication sharedApplication] delegate];
	UIWindow * w = app.window;
	[w addSubview:gw.view];
	
	[UIView beginAnimations:nil context:nil];
	[gw.view setAlpha:1];
	[UIView commitAnimations];
}


- (void)dealloc {
	[video release];
	[lyricLines release];
    [super dealloc];
}


@end

