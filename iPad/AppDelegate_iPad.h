//
//  AppDelegate_iPad.h
//  Basho
//
//  Created by Pablo Ruiz on 12/02/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate_iPad : NSObject <UIApplicationDelegate> {
    UIWindow *window;
	IBOutlet UINavigationController * navController;
	UIActivityIndicatorView * loading;
}

@property (nonatomic,retain) UIActivityIndicatorView * loading;
@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic,retain) IBOutlet UINavigationController * navController;

@end

