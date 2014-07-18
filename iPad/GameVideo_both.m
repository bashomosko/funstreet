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

#define VIDEO_1_URL @"https://www.youtube.com/v/vsPH4_ohGYg"
#define VIDEO_2_URL @"https://www.youtube.com/v/9LT9ltzFJTQ"
#define VIDEO_3_URL @"https://www.youtube.com/v/BdLuT_P0OzE"
#define VIDEO_4_URL @"https://www.youtube.com/v/4uzfwLKevUU"
#define VIDEO_5_URL @"https://www.youtube.com/v/0qdlMipcsWQ"
#define VIDEO_6_URL @"https://www.youtube.com/v/h5dRD9U9BsI"


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

-(IBAction)goToYoutubeChannel:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"https://www.youtube.com/user/bashoandfriends"]];
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    
    arrWebView = [[NSMutableArray alloc] init];
    
    [[SimpleAudioEngine sharedEngine] stopBackgroundMusic];

    HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [HUD setLabelText:@"Loading..."];
	[self.navigationController.view addSubview:HUD];
    
    [HUD show:YES];
    
    [super viewDidLoad];
}

-(void)loadGame
{   
    [scrollview setContentSize:CGSizeMake(widthScroll * 6,heightScroll)];
	[scrollview setShowsVerticalScrollIndicator:NO];
	[scrollview setShowsHorizontalScrollIndicator:NO];
	[scrollview setPagingEnabled:YES];
    [scrollPaging setHidden:NO];
    
    videosLoaded=0;
	
	for (int i =1;i<=6;i++)
	{
        NSString * url =nil;
        
        switch (i) {
            case 1:
                url = VIDEO_1_URL;
                break;
            case 2:
                url = VIDEO_2_URL;
                break;
            case 3:
                url = VIDEO_3_URL;
                break;
            case 4:
                url = VIDEO_4_URL;
                break;
            case 5:
                url = VIDEO_5_URL;
                break;
            case 6:
                url = VIDEO_6_URL;
                break;
            default:
                break;
        }
        
        [self embedYouTube:url frame:CGRectMake(widthScroll * (i -1),0,widthScroll,heightScroll)];
	}
    
  
	
	scrollPaging.numberOfPages = 6;
	scrollPaging.currentPage = 0;

}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    if ([[webView stringByEvaluatingJavaScriptFromString:@"document.readyState"] isEqualToString:@"complete"]) {
        videosLoaded++;
    }
    
    if (videosLoaded==6) {
        if (HUD) {
            [HUD removeFromSuperview];
            [HUD release];
            
            [self doAnimation];
        }
    }
}

-(void)doAnimation {
    [UIView beginAnimations:nil context:nil];
	
	[UIView setAnimationDuration:1];
	[UIView setAnimationDelay:0.1];
    if (IS_IPHONE5) {
        [curtainL setCenter:CGPointMake(-56, curtainL.center.y)];
        [curtainR setCenter:CGPointMake(625, curtainL.center.y)];
    }
    else {
        [curtainL setCenter:CGPointMake(-56, curtainL.center.y)];
        [curtainR setCenter:CGPointMake(538, curtainL.center.y)];
    }
    [UIView commitAnimations];
}


- (void)webViewDidFinishLoad:(UIWebView *)webView {
    if ([[webView stringByEvaluatingJavaScriptFromString:@"document.readyState"] isEqualToString:@"complete"]) {
        videosLoaded++;
    }
    
    if (videosLoaded==6) {
        if (HUD) {
            [HUD removeFromSuperview];
            [HUD release];
            
            [self doAnimation];
        }
    }
}

- (void)embedYouTube:(NSString*)url frame:(CGRect)frame {
    NSMutableString *embedHTML = [[NSMutableString alloc] initWithCapacity:1];
    [embedHTML appendString:@"<html><head>"];
    [embedHTML appendString:@"<style type=\"text/css\">"];
    [embedHTML appendString:@"body {"];
    [embedHTML appendString:@"background-color: transparent;"];
    [embedHTML appendString:@"color: white;"];
    [embedHTML appendString:@"}"];
    [embedHTML appendString:@"</style>"];
    [embedHTML appendString:@"</head><body style=\"margin:0\">"];
    [embedHTML appendFormat:@"<embed id=\"yt\" src=\"%@\" type=\"application/x-shockwave-flash\"", url];
    [embedHTML appendFormat:@"width=\"%0.0f\" height=\"%0.0f\"></embed>", frame.size.width, frame.size.height];
    [embedHTML appendString:@"</body></html>"];
    NSString* html = [NSString stringWithFormat:embedHTML, url, frame.size.width, frame.size.height];

    UIWebView * videoView = [[UIWebView alloc] initWithFrame:frame];
    [scrollview addSubview:videoView];
    
    [arrWebView addObject:videoView];
    
    [videoView setOpaque:NO];
    [videoView setBackgroundColor:[UIColor blackColor]];
    
    [videoView setDelegate:self];
    
    videoView.allowsInlineMediaPlayback = NO;
    
    for (id subview in videoView.subviews)
        if ([[subview class] isSubclassOfClass: [UIScrollView class]])
            ((UIScrollView *)subview).bounces = NO;
    
    [videoView loadHTMLString:html baseURL:nil];
    [videoView release];
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
    for (int i=0; i < [arrWebView count]; i++) {
        UIWebView * wView = [arrWebView objectAtIndex:i];
        [wView removeFromSuperview];
    }
 
    [arrWebView removeAllObjects];
    [arrWebView release];
    
	[scrollview release];
	[curtainL release];
	[curtainR release];
    [super dealloc];
}


@end

