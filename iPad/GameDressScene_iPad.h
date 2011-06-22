//
//  GameDressScene_iPad.h
//  Basho
//
//  Created by Pablo Ruiz on 04/03/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "GameDress_iPad.h"
#import <MediaPlayer/MediaPlayer.h>
#import "GameDressSceneSnapshot_iPad.h"
#import "GameDressScene_both.h"


@class GameDress_iPad;

@interface GameDressScene_iPad : GameDressScene_both
{

	GameDress_iPad * viewController;

}

@property(nonatomic,assign) GameDress_iPad * viewController;

@end
