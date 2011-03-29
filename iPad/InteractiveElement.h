//
//  InteractiveElement.h
//  Basho
//
//  Created by Pablo Ruiz on 29/03/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Config.h"
#import "InteractiveSongScene_iPad.h"

@class InteractiveSongScene_iPad;


@interface InteractiveElement : CCNode {
	
	InteractiveSongScene_iPad * theGame;
	
	CCSprite * mySprite;
	CCSprite * myPlacedSprite;
	touchState state;
	
	//FROM THE PLIST FILE
	NSString * imagePath;
	CGPoint initialCoord;
	NSString * soundOkPath;
	NSString * soundWrongPath;
	
	NSString * elemName;
}
@property (nonatomic,readwrite) touchState state;
@property (nonatomic,retain) CCSprite * mySprite;
@property (nonatomic,retain) CCSprite * myPlacedSprite;

@end