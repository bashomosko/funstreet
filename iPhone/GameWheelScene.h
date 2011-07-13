//
//  HelloWorldLayer.h
//  BashoCocos
//
//  Created by Pablo Ruiz on 12/02/11.
//  Copyright __MyCompanyName__ 2011. All rights reserved.
//


// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"
#import "GameWheelScene_both.h"

@class GameWheelScene_both;

// HelloWorld Layer
@interface GameWheelScene : GameWheelScene_both
{
	CCMenuItemImage * backBtn;
    GameWheel * viewController;
}

// returns a Scene that contains the HelloWorld as the only child

+(id) sceneWithWheelVC:(GameWheel *)vc;
+(id) nodeWithWheelVC:(GameWheel *)vc;
-(id) initWithWheelVC:(GameWheel *)vc;
-(void)beginGame;
-(void)createPalabra;
-(NSMutableArray *)loadBtnPos;

@end
