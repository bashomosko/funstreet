//
//  GameDressSceneSnapshot_iPad.h
//  Basho
//
//  Created by Pablo Ruiz on 19/05/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "GameDress_iPad.h"

@class GameDress_iPad;

@interface GameDressSceneSnapshot_iPad : CCLayer {

	GameDress_iPad * viewController;
	BOOL moveOutActivated;
    BOOL bashoDirected;
}

@end
