//
//  GameWheelScene_iPad.h
//  Basho
//
//  Created by Pablo Ruiz on 12/02/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"
#import "GameWheelScene_both.h"

@class GameWheelScene_both,GameWheel_iPad;
// HelloWorld Layer
@interface GameWheelScene_iPad : GameWheelScene_both
{
    GameWheel_iPad * viewController;
}

+(id) sceneWithWheelVC:(GameWheel_iPad *)vc;
+(id) nodeWithWheelVC:(GameWheel_iPad *)vc;
-(id) initWithWheelVC:(GameWheel_iPad *)vc;
-(void)createPalabra;
-(NSMutableArray *)loadBtnPos;


@end