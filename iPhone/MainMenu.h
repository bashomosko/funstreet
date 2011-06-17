//
//  MainMenu.h
//  Basho
//
//  Created by Pablo Ruiz on 12/02/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainMenu_both.h"
#import "SettingsViewController_iPhone.h"

@class MainMenu_both;

@interface MainMenu : MainMenu_both {
    
    SettingsViewController_iPhone * sv;

}

@end
