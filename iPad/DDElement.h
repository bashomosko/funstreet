
#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Config.h"
#import "GameDressScene_iPad.h"


@class GameDress_iPad;

@interface DDElement : CCNode {

	GameDressScene_iPad * theGame;
	
	CCSprite * mySprite;
	touchState state;
	
	//FROM THE PLIST FILE
	NSString * imagePath;
	CGPoint initialCoord;
	CGPoint dropPoint;
	NSString * soundOkPath;
	NSString * soundWrongPath;
	BOOL movableAfterPlaced;
	BOOL placed;
}
@property (nonatomic,readwrite) touchState state;
@property (nonatomic,retain) CCSprite * mySprite;

@end
