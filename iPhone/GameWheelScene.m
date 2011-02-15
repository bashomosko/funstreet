//
//  HelloWorldLayer.m
//  BashoCocos
//
//  Created by Pablo Ruiz on 12/02/11.
//  Copyright __MyCompanyName__ 2011. All rights reserved.
//

// Import the interfaces
#import "GameWheelScene.h"

// HelloWorld implementation
@implementation GameWheelScene

+(id) sceneWithWheelVC:(GameWheel *)vc
{
    CCScene *scene = [CCScene node];
    GameWheelScene *layer = [GameWheelScene nodeWithWheelVC:vc];
    [scene addChild: layer];
    return scene;
}

+(id) nodeWithWheelVC:(GameWheel *)vc
{
	return [[[self alloc] initWithWheelVC:vc] autorelease];
}

-(id) initWithWheelVC:(GameWheel *)vc
{
    if( (self=[super init] )) {
		self.isTouchEnabled = YES;
		// always call "super" init
		// Apple recommends to re-assign "self" with the "super" return value
		if( (self=[super init] )) {
			
			viewController = vc;
			
			CCSprite * back = [CCSprite spriteWithFile:@"mm_background.png"];
			[back setPosition:ccp(240,160)];
			[self addChild:back];
			
			CCMenuItemImage * backBtn = [CCMenuItemImage itemFromNormalImage:@"mm_logo.png" selectedImage:@"mm_logo.png" target:self selector:@selector(goBack)];
			CCMenu * menu = [CCMenu menuWithItems:backBtn,nil];
			[self addChild:menu];
			[menu setPosition:ccp(240,160)];
			
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
