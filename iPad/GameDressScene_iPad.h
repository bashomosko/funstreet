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

+(id) sceneWithDressVC:(GameDress_iPad *)vc bashoDirected:(BOOL)_bashoDirected playVid:(BOOL)playVid playingAgain:(BOOL)_playingAgain;
+(id) nodeWithDressVC:(GameDress_iPad *)vc bashoDirected:(BOOL)_bashoDirected playVid:(BOOL)playVid playingAgain:(BOOL)_playingAgain;
-(id) initWithDressVC:(GameDress_iPad *)vc bashoDirected:(BOOL)_bashoDirected playVid:(BOOL)playVid playingAgain:(BOOL)_playingAgain;
-(void)loadVideo;
-(void)replay;
-(void)nextGame;
-(void)createPalabra;
-(void)goSettings;
-(void)selectItemForBasho;
-(void)loadScatteredElementsForItem:(int)item;

@end
