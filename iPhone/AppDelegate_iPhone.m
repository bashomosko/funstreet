//
//  AppDelegate_iPhone.m
//  Basho
//
//  Created by Pablo Ruiz on 12/02/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate_iPhone.h"
#import "cocos2d.h"
#import "SimpleAudioEngine.h"

@implementation AppDelegate_iPhone

@synthesize window,navController,loading;


#pragma mark -
#pragma mark Application lifecycle



- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    
	[SimpleAudioEngine sharedEngine];
	
	// Try to use CADisplayLink director
	// if it fails (SDK < 3.1) use the default director
	if( ! [CCDirector setDirectorType:kCCDirectorTypeDisplayLink] )
		[CCDirector setDirectorType:kCCDirectorTypeDefault];
    
    /*loading = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    
    [loading setCenter:CGPointMake(160, 240)];
    
    //loading.hidesWhenStopped=NO;
    
    [loading stopAnimating];*/
    
    
    [self loadActivityIndicator];
    
    
    

    
    [activityImageView setHidden:YES];
	

    [self loadBackground];
    
	[window addSubview:navController.view];
    [window addSubview:backgroundActivity];
    
    activityImageView.frame = CGRectMake(navController.view.frame.size.width/2 - statusImage.size.width/2 + 90,
                                         navController.view.frame.size.height/2 - statusImage.size.height/2 - 65,
                                         statusImage.size.width,
                                         statusImage.size.height);
    
    if (IS_IPHONE5) {
        activityImageView.frame = CGRectMake(navController.view.frame.size.width/2 - statusImage.size.width/2 + 130,
                                             navController.view.frame.size.height/2 - statusImage.size.height/2 - 105,
                                             statusImage.size.width,
                                             statusImage.size.height);
    }
    

    //[window addSubview:loading];
    //[window addSubview:activityImageView];
    
	[self.window makeKeyAndVisible];
	
    return YES;
}

-(void)loadBackground {
    
    UIImage * background = [UIImage imageNamed:@"SpinningRumiBackground_iPhone.png"];
    backgroundActivity = [[UIImageView alloc] initWithImage:background];
    [backgroundActivity addSubview:activityImageView];
    [backgroundActivity setHidden:YES];
    
    
     backgroundActivity.frame = CGRectMake(-80,80, 480,320);
    
    if (IS_IPHONE5) {
         backgroundActivity.frame = CGRectMake(-124,124, 568,320);
    }
    
   
    backgroundActivity.transform = CGAffineTransformMakeRotation(-M_PI / 2);
    //[backgroundActivity setCenter:CGPointMake(160, 240)];
    
}

- (void)applicationWillResignActive:(UIApplication *)application {
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, called instead of applicationWillTerminate: when the user quits.
     */
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    /*
     Called as part of  transition from the background to the inactive state: here you can undo many of the changes made on entering the background.
     */
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}


- (void)applicationWillTerminate:(UIApplication *)application {
    /*
     Called when the application is about to terminate.
     See also applicationDidEnterBackground:.
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
    [backgroundActivity release];
    [loading release];
	[navController release];
    [window release];
    [super dealloc];
}


@end
