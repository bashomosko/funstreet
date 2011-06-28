
#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Config.h"
#import "GameDressScene_iPad.h"
#import "DDElement_both.h"


@class GameDress_iPad;

@interface DDElement : DDElement_both {

	GameDressScene_iPad * theGame;
	
}

-(id) initWithTheGame:(GameDressScene_iPad *)ddm elementDict:(NSMutableDictionary *)element;
-(void)shakeMismatch;

@end
