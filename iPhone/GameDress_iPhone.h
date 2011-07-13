//
//  GameDress_iPhone.h
//  Basho
//
//  Created by Pablo Ruiz on 04/03/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SettingsViewController_iPhone.h"
#import "GameDressScene_iPhone.h"

@class GameDressScene_iPhone;

@interface GameDress_iPhone : UIViewController {

    GameDressScene_iPhone * gameDressLayer;
    SettingsViewController_iPhone * sv;
}

@property (nonatomic,assign) GameDressScene_iPhone * gameDressLayer;

-(void)goToNextGame;
-(void)goToMenu;
-(void)goToSettings;
-(void)removeSettings;
- (void) removeStartupFlicker;

@end
