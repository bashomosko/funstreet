//
//  GameVideo.m
//  Basho
//
//  Created by Pablo Ruiz on 07/03/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GameVideo.h"
#import <MediaPlayer/MediaPlayer.h>

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
	
	NSURL * url;
	NSBundle *bundle = [NSBundle mainBundle];
	if (bundle) 
	{
		NSString *moviePath = [bundle pathForResource:@"ARG" ofType:@"mp4"];
		if (moviePath)
		{
			url = [NSURL fileURLWithPath:moviePath];
		}
	}
	
	MPMoviePlayerController * video = [[MPMoviePlayerController alloc] initWithContentURL:url];
	[self.view addSubview:video.view];
	[video.view setFrame:CGRectMake(0,0,480,320)];
	//[video.view setTransform:CGAffineTransformMakeRotation(M_PI/ 2)];
	[video play];
	
	NSString *filePath = [[NSBundle mainBundle] pathForResource:@"videoLyrics" ofType:@"plist"];
	
	lyricLines = [[NSMutableArray arrayWithContentsOfFile:filePath]retain];
	
	currentLyricLine = 0;
	
	lyrics = [[UILabel alloc] initWithFrame:CGRectMake(0,280,480,40)];
	
	[lyrics setText:@""];
	[lyrics setFont:[UIFont fontWithName:@"Helvetica" size:18]];
	[lyrics setBackgroundColor:[UIColor clearColor]];
	[lyrics setTextColor:[UIColor whiteColor]];
	[lyrics setShadowColor:[UIColor blackColor]];
	[lyrics setShadowOffset:CGSizeMake(1,1)];
	[lyrics setTextAlignment:UITextAlignmentCenter];
	
	[video.view addSubview:lyrics];
	
	[lyrics release];
	
	[self showLyricLine];
	
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


- (void)dealloc {
	[lyricLines release];
    [super dealloc];
}


@end
