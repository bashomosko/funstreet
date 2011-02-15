    //
//  GameWheelScene_iPad.m
//  Basho
//
//  Created by Pablo Ruiz on 12/02/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

// Import the interfaces
#import "GameWheelScene_iPad.h"

// HelloWorld implementation
@implementation GameWheelScene_iPad

+(id) sceneWithWheelVC:(GameWheel_iPad *)vc
{
    CCScene *scene = [CCScene node];
    GameWheelScene_iPad *layer = [GameWheelScene_iPad nodeWithWheelVC:vc];
    [scene addChild: layer];
    return scene;
}

+(id) nodeWithWheelVC:(GameWheel_iPad *)vc
{
	return [[[self alloc] initWithWheelVC:vc] autorelease];
}

-(id) initWithWheelVC:(GameWheel_iPad *)vc
{
    if( (self=[super init] )) {
		self.isTouchEnabled = YES;
		// always call "super" init
		// Apple recommends to re-assign "self" with the "super" return value
		if( (self=[super init] )) {
			
			viewController = vc;
			
			CCSprite * back = [CCSprite spriteWithFile:@"mm_background_iPad.png"];
			[back setPosition:ccp(1024/2,768/2)];
			[self addChild:back];
			
			CCMenuItemImage * backBtn = [CCMenuItemImage itemFromNormalImage:@"mm_logo_iPad.png" selectedImage:@"mm_logo_iPad.png" target:self selector:@selector(goBack)];
			CCMenu * menu = [CCMenu menuWithItems:backBtn,nil];
			[self addChild:menu];
			[menu setPosition:ccp(1024/2,768/2)];
			
		}
		return self;
		
    }
    return self;
}



-(void)goBack
{
	[viewController goToMenu];
}

// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children (Label)
	
	// don't forget to call "super dealloc"
	[super dealloc];
}

@end
