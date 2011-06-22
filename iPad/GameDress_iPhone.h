//
//  GameDress_iPad.h
//  Basho
//
//  Created by Pablo Ruiz on 04/03/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SettingsViewController_iPad.h"
#import "GameDressScene_iPad.h"

@class GameDressScene_iPad;

@interface GameDress_iPad : UIViewController {

    GameDressScene_iPad * gameDressLayer;
    SettingsViewController_iPad * sv;
}

@end