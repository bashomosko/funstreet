//
//  HelloWorldLayer.h
//  BashoCocos
//
//  Created by Pablo Ruiz on 12/02/11.
//  Copyright __MyCompanyName__ 2011. All rights reserved.
//


// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"
#import "GameWheel.h"

// HelloWorld Layer
@interface GameWheelScene : CCLayer
{
	GameWheel * viewController;
	CCSprite * dino;
	BOOL dinoSpinning;
}

// returns a Scene that contains the HelloWorld as the only child
+(id) scene;

@end
