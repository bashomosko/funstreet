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

@synthesize btnSong,btnDress,btnWheel,btnVideo,scroll,door1,door2,internetReachability;

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
    
  //  [self animateDoors];
	/*if(![GameManager sharedGameManager].playedMenuVideo)
	{
		[[GameManager sharedGameManager] setPlayedMenuVideo:YES];
		[self playVideo];
	}else {
		 [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"backgroundMusic.mp3"];
		[self animateDoors];
	}*/
    
    [self configureReachability];

    [super viewDidLoad];
	
}

-(void) configureReachability {
    /*
     Observe the kNetworkReachabilityChangedNotification. When that notification is posted, the method reachabilityChanged will be called.
     */
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
    
    //Change the host name here to change the server you want to monitor.
 
    self.internetReachability = [Reachability reachabilityWithHostName:@"www.google.com"];
	[self.internetReachability startNotifier];
}

- (void) reachabilityChanged:(NSNotification *)note
{
	Reachability* curReach = [note object];
	NSParameterAssert([curReach isKindOfClass:[Reachability class]]);
}


-(void)playVideo:(NSString *) suffix
{   
	NSURL * url;
	NSBundle *bundle = [NSBundle mainBundle];
    
    float width = 1024,height = 768;
    
    
    if ([suffix rangeOfString:@"iPhone"].location != NSNotFound)
    {
        width = 480;
        if (IS_IPHONE5) {
            width = 568;
        }
        
        height = 320;
    }
        
    
    [[SimpleAudioEngine sharedEngine] pauseBackgroundMusic];
	if (bundle) 
	{   
        NSString * path = [NSString stringWithFormat:@"menu_%@_",[GameManager sharedGameManager].instructionsLanguageString];
		NSString *moviePath = [bundle pathForResource:[path stringByAppendingString:suffix] ofType:@"mov"];
		if (moviePath)
		{
			url = [NSURL fileURLWithPath:moviePath];
		}
	}
	
	introVideo = [[MPMoviePlayerController alloc] initWithContentURL:url];
	[self.view addSubview:introVideo.view];
	[introVideo.view setFrame:CGRectMake(0,0,width,height)];
	[introVideo setControlStyle:MPMovieControlStyleNone];
    
    if (IS_IPHONE5) {
        UIImageView *dot =[[UIImageView alloc] initWithFrame:CGRectMake(0,0,259,328)];
        dot.image=[UIImage imageNamed:@"theatre_left_iPhone-hd.png"];
        [introVideo.view addSubview:dot];
        [dot setCenter:CGPointMake(-63, dot.center.y)];
        [dot release];
        
        UIImageView *dot2 =[[UIImageView alloc] initWithFrame:CGRectMake(0,0,259,328)];
        dot2.image=[UIImage imageNamed:@"theatre_right_iPhone-hd.png"];
        [introVideo.view addSubview:dot2];
        [dot2 setCenter:CGPointMake(632, dot2.center.y)];
        [dot2 release];
    }
	
	[[NSNotificationCenter defaultCenter]
	 addObserver:self
	 selector:@selector(videoPlayerDidFinishPlaying:)
	 name:MPMoviePlayerPlaybackDidFinishNotification
	 object:introVideo];
	
	UIButton * skip = [UIButton buttonWithType:UIButtonTypeCustom];
	[skip setFrame:CGRectMake(0,0,width,height)];
	[skip addTarget:self action:@selector(skipMovie) forControlEvents:UIControlEventTouchUpInside];
	[introVideo.view addSubview:skip];
	
	videoTaps = 0;
	
	[introVideo play];
}

-(void)skipMovie
{
	videoTaps++;
	[self performSelector:@selector(reduceVideoTaps) withObject:nil afterDelay:0.5];
	if(videoTaps ==2)
	{
		[[NSNotificationCenter defaultCenter] removeObserver:self
														name:MPMoviePlayerPlaybackDidFinishNotification object:introVideo];
		[introVideo stop];
		[introVideo.view removeFromSuperview];
		[introVideo release];
		
		[[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"backgroundMusic.mp3"];
        
        if(videoFromLoadingScene)
        {
            videoFromLoadingScene = NO;
        }
        [self animateDoors:doorsSuffix];
	}
}

-(void)reduceVideoTaps
{
	videoTaps =0;
}

-(void) videoPlayerDidFinishPlaying: (NSNotification*)aNotification
{
	MPMoviePlayerController * introVideoFply = [aNotification object];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerPlaybackDidFinishNotification object:introVideoFply];
	[introVideo stop];
	[introVideo.view removeFromSuperview];
	[introVideo release];
	
	 [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"backgroundMusic.mp3"];
    if(videoFromLoadingScene)
    {
        videoFromLoadingScene = NO;
    }
    [self animateDoors:doorsSuffix];
	//[self beginGame];
}


-(void)animateDoors:(NSString*)suffix
{   
    
    NSString* string = @"CityMenu_Page1_GlowingDoors_%05d";
    
    NSString * format = [string stringByAppendingString:suffix];
    
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
    

    NSString* string2 = @"CityMenu_Page2_GlowingDoors_%05d";
    
    NSString * format2 = [string2 stringByAppendingString:suffix];
   
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

- (BOOL)shouldAutorotate{
    return YES;
}
-(NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskLandscape;
}
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
    return UIInterfaceOrientationLandscapeLeft;
}

-(IBAction) goToSong:(id)sender
{/*
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(loadSong)];
	[self.view setAlpha:0];
	[UIView commitAnimations];*/
	[self loadSong];
}

-(IBAction) goToWheel:(id)sender
{
	/*[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(loadWheel)];
	[self.view setAlpha:0];
	[UIView commitAnimations];*/
	
	[self loadWheel];
}

-(IBAction) goToDress:(id)sender
{
	/*[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(loadDress)];
	[self.view setAlpha:0];
	[UIView commitAnimations];*/
	[self loadDress];
}

-(IBAction) goToVideo:(id)sender
{
/*	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(loadVideo)];
	[self.view setAlpha:0];
	[UIView commitAnimations];*/
    NetworkStatus netStatus = [internetReachability currentReachabilityStatus];

    if (netStatus == NotReachable) {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"Basho - Language Fun"
                              message:@"An Internet connection is required to watch my videos."
                              delegate:self
                              cancelButtonTitle:@"Ok"
                              otherButtonTitles: nil];
        [alert show];
        return;
    }
    
	[self loadVideo];
}

-(IBAction) goToNextScreen:(id)sender
{
    [scroll setContentOffset:CGPointMake(widthScreen, 0) animated:YES];
}

-(IBAction) goToPreviousScreen:(id)sender
{
    [scroll setContentOffset:CGPointMake(0, 0) animated:YES];
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
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kReachabilityChangedNotification object:nil];
    
	[door1 stopAnimating];
	[door2 stopAnimating];
	[btnSong release];
	[btnWheel release];
	[btnVideo release];
	[btnDress release];
    [super dealloc];
}


@end
