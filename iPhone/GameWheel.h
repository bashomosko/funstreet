//
//  GameWheel.h
//  Basho
//
//  Created by Pablo Ruiz on 12/02/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "SettingsViewController_iPhone.h"

@class GameWheelScene,SettingsViewController_iPhone;

@interface GameWheel : UIViewController {
    
    SettingsViewController_iPhone * sv;
    GameWheelScene * gameWheelLayer;
}

-(void) removeStartupFlicker;
-(void)goToMenu;
-(void)goToSettings;
-(void)removeSettings;

@end
