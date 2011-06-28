
#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Config.h"
#import "GameDressScene_iPhone.h"
#import "DDElement_both.h"


@interface DDElement_iPhone : DDElement_both {

	GameDressScene_iPhone * theGame;
	
}

-(id) initWithTheGame:(GameDressScene_iPhone *)ddm elementDict:(NSMutableDictionary *)element;

@end
