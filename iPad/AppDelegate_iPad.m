//
//  AppDelegate_iPad.m
//  Basho
//
//  Created by Pablo Ruiz on 12/02/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate_iPad.h"
#import "MainMenu_iPad.h"
#import "SimpleAudioEngine.h"

@implementation AppDelegate_iPad

@synthesize window,navController,loading/*,statusImage,activityImageView*/;


#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    
	[SimpleAudioEngine sharedEngine];
    // Override point for customization after application launch.
    
    /*statusImage = [UIImage imageNamed:@"dinoIndicator_1.png"];
    activityImageView = [[UIImageView alloc]initWithImage:statusImage];
    
    activityImageView.animationImages = [NSArray arrayWithObjects:[UIImage imageNamed:@"dinoIndicator_1.png"],
                                         [UIImage imageNamed:@"dinoIndicator_2.png"],[UIImage imageNamed:@"dinoIndicator_3.png"],[UIImage imageNamed:@"dinoIndicator_4.png"],[UIImage imageNamed:@"dinoIndicator_5.png"],[UIImage imageNamed:@"dinoIndicator_6.png"],[UIImage imageNamed:@"dinoIndicator_7.png"],[UIImage imageNamed:@"dinoIndicator_8.png"],[UIImage imageNamed:@"dinoIndicator_9.png"], nil];
    
    activityImageView.animationDuration = 0.8;*/
    
    
    [self loadActivityIndicator];
    
    
    activityImageView.frame = CGRectMake(window.frame.size.width/2 - statusImage.size.width/2 + 150,
                                         window.frame.size.height/2 - statusImage.size.height/2 - 120,
                                         statusImage.size.width, 
                                         statusImage.size.height);
    
	//loading = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    
    //[loading setCenter:CGPointMake(384, 512)];
    
    //loading.hidesWhenStopped=NO;
    
    //[loading stopAnimating];
    
    [activityImageView setHidden:YES];
	
    [self loadBackground];
    
	[window addSubview:navController.view];
    [window addSubview:backgroundActivity];
    //[window addSubview:loading];
    //[window addSubview:activityImageView];
	
    [self.window makeKeyAndVisible];
    
    return YES;
}

-(void)loadBackground {
    
    backgroundActivity = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"SpinningRumiBackground_iPad.png"]];
    [window addSubview:backgroundActivity];
    [backgroundActivity addSubview:activityImageView];
    [backgroundActivity setHidden:YES];
    backgroundActivity.frame = CGRectMake(-129,128, 1024,768);
    backgroundActivity.transform = CGAffineTransformMakeRotation(-M_PI / 2);
    
}


- (void)applicationWillResignActive:(UIApplication *)application {
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive.
     */
}


- (void)applicationWillTerminate:(UIApplication *)application {
    /*
     Called when the application is about to terminate.
     */
}


#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
}



- (void)dealloc {
	[loading release];
    [window release];
    [super dealloc];
}


@end
