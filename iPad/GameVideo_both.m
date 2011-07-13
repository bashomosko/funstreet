    //
//  GameVideo_both.m
//  Basho
//
//  Created by Pablo Ruiz on 24/03/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GameVideo_both.h"
#import "MainMenu_iPad.h"
#import "AppDelegate_iPad.h"
#import "SimpleAudioEngine.h"

@implementation GameVideo_both

@synthesize curtainL,curtainR,scrollview,scrollPaging,widthVideo,heightVideo,widthScroll,heightScroll;

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
	
    [super viewDidLoad];
}

-(void)loadGame
{   
    [scrollview setContentSize:CGSizeMake(widthScroll * 6,heightScroll)];
	[scrollview setShowsVerticalScrollIndicator:NO];
	[scrollview setShowsHorizontalScrollIndicator:NO];
	[scrollview setPagingEnabled:YES];
    [scrollPaging setHidden:NO];
	
	for (int i =1;i<=6;i++)
	{
		UIButton * img = [UIButton buttonWithType:UIButtonTypeCustom];
		img.tag = i;
		[img addTarget:self action:@selector(selectVideo:) forControlEvents:UIControlEventTouchUpInside];
		[img setImage:[UIImage imageNamed:[NSString stringWithFormat:@"theatreThumb_%d_iPad.png",i]] forState:UIControlStateNormal];
		[img setFrame:CGRectMake(widthScroll * (i -1),0,widthScroll,heightScroll)];
		[scrollview addSubview:img];
		
	}
	
	scrollPaging.numberOfPages = 6;
	scrollPaging.currentPage = 0;

}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    int page = floor((scrollView.contentOffset.x - widthScroll / 2) / widthScroll) + 1;
    scrollPaging.currentPage = page;
}

-(void)selectVideo:(UIButton *)btn
{
	[[SimpleAudioEngine sharedEngine] stopBackgroundMusic];
	int videoNumber = btn.tag;
	[self playVid:videoNumber];

}

-(void)playVid:(int)videoNumber
{
	NSURL * url;
	NSBundle *bundle = [NSBundle mainBundle];
	if (bundle) 
	{
		NSString *moviePath = [bundle pathForResource:[NSString stringWithFormat:@"theatre_video%d_iPad",videoNumber] ofType:@"mov"];
		if (moviePath)
		{
			url = [NSURL fileURLWithPath:moviePath];
		}
	}
	
	video = [[MPMoviePlayerController alloc] initWithContentURL:url];
	[video setControlStyle:MPMovieControlStyleFullscreen];
	[self.view addSubview:video.view];
	[video.view setFrame:CGRectMake(0,0,widthVideo,heightVideo)];
	//[video.view setTransform:CGAffineTransformMakeRotation(M_PI/ 2)];
	[video play];
	[[NSNotificationCenter defaultCenter]
	 addObserver:self
	 selector:@selector(videoPlayerDidFinishPlaying:)
	 name:MPMoviePlayerPlaybackDidFinishNotification
	 object:video];
}

-(void) videoPlayerDidFinishPlaying: (NSNotification*)aNotification
{   
	MPMoviePlayerController * introVideo = [aNotification object];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerPlaybackDidFinishNotification object:introVideo];
	[video stop];
	[video.view removeFromSuperview];
	[video release];
	[[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
	[[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"backgroundMusic.mp3"];
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
	[scrollview release];
	[curtainL release];
	[curtainR release];
    [super dealloc];
}


@end

