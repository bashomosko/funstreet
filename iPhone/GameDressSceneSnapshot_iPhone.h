//
//  GameDressSceneSnapshot_iPhone.h
//  Basho
//
//  Created by Pablo Ruiz on 19/05/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "GameDress_iPhone.h"
#import "GameDressSceneSnapshot_both.h"

@class GameDress_iPhone;

@interface GameDressSceneSnapshot_iPhone : GameDressSceneSnapshot_both {

	GameDress_iPhone * viewController;
	
}

@end
