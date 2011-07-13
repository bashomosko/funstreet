//
//  GameDressScene_iPhone.h
//  Basho
//
//  Created by Pablo Ruiz on 04/03/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "GameDress_iPhone.h"
#import <MediaPlayer/MediaPlayer.h>
#import "GameDressSceneSnapshot_iPhone.h"
#import "GameDressScene_both.h"


@class GameDress_iPhone;

@interface GameDressScene_iPhone : GameDressScene_both
{
	
	GameDress_iPhone * viewController;

}

@property(nonatomic,assign) GameDress_iPhone * viewController;

+(id) sceneWithDressVC:(GameDress_iPhone *)vc bashoDirected:(BOOL)_bashoDirected playVid:(BOOL)playVid playingAgain:(BOOL)_playingAgain;
+(id) nodeWithDressVC:(GameDress_iPhone *)vc bashoDirected:(BOOL)_bashoDirected playVid:(BOOL)playVid playingAgain:(BOOL)_playingAgain;
-(id) initWithDressVC:(GameDress_iPhone *)vc bashoDirected:(BOOL)_bashoDirected playVid:(BOOL)playVid playingAgain:(BOOL)_playingAgain;
-(void)loadVideo;
-(void)createPalabra;
-(void)loadScatteredElementsForItem:(int)item;

@end
