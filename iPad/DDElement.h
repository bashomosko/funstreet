
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
	NSString * dressed;
	BOOL movableAfterPlaced;
	BOOL placed;
	int desiredZ;
	int itemTag;
	
	NSString * itemNumber;
	NSString * colorNumber;
	NSString * itemText;
}
@property (nonatomic,readwrite) touchState state;
@property (nonatomic,retain) CCSprite * mySprite;
@property (nonatomic,retain) NSString * dressed;
@property (nonatomic,readwrite)int desiredZ;
@property (nonatomic,readwrite)int itemTag;
@property (nonatomic,retain) NSString * itemNumber;
@property (nonatomic,retain) NSString * colorNumber;
@property (nonatomic,retain) NSString * itemText;

@end
