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
    int middle;
    int xOffset;
}

+(id) sceneWithDressVC:(GameDress_iPhone *)vc dinoImage:(UIImage *)img bashoDirected:(BOOL)_bashoDirected;
+(id) nodeWithDressVC:(GameDress_iPhone *)vc dinoImage:(UIImage *)img bashoDirected:(BOOL)_bashoDirected;
-(id) initWithDressVC:(GameDress_iPhone *)vc dinoImage:(UIImage *)img bashoDirected:(BOOL)_bashoDirected;
-(void)addDinoOnPosition:(CGPoint)pos dinoImage:(UIImage *)img num:(int)num;

@end
