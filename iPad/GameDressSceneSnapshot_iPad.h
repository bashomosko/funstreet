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
#import "GameDressSceneSnapshot_both.h"

@class GameDress_iPad;

@interface GameDressSceneSnapshot_iPad : GameDressSceneSnapshot_both {

	GameDress_iPad * viewController;
	
}

+(id) sceneWithDressVC:(GameDress_iPad *)vc dinoImage:(UIImage *)img bashoDirected:(BOOL)_bashoDirected;
+(id) nodeWithDressVC:(GameDress_iPad *)vc dinoImage:(UIImage *)img bashoDirected:(BOOL)_bashoDirected;
-(id) initWithDressVC:(GameDress_iPad *)vc dinoImage:(UIImage *)img bashoDirected:(BOOL)_bashoDirected;
-(void)addDinoOnPosition:(CGPoint)pos dinoImage:(UIImage *)img num:(int)num;

@end
