//
//  GameWheel_iPad.h
//  Basho
//
//  Created by Pablo Ruiz on 12/02/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SettingsViewController_iPad.h"

@class GameWheelScene_iPad,SettingsViewController_iPad;

@interface GameWheel_iPad : UIViewController {

	SettingsViewController_iPad * sv;
    GameWheelScene_iPad * gameWheelLayer;
}

-(void)goToNextGame;
-(void)goToSettings;
-(void)removeSettings;
-(void)goToMenu;


@end
