//
//  AppDelegate_iPhone.h
//  Basho
//
//  Created by Pablo Ruiz on 12/02/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainMenu.h"

@interface AppDelegate_iPhone : NSObject <UIApplicationDelegate> {
    UIWindow *window;
	MainMenu * mm;
	IBOutlet UINavigationController * navController;
    UIActivityIndicatorView * loading;
    
}

@property (nonatomic,retain) UIActivityIndicatorView * loading;
@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic,retain) IBOutlet UINavigationController * navController;

@end

