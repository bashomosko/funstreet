//
//  InteractiveElement.m
//  Basho
//
//  Created by Pablo Ruiz on 29/03/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "InteractiveElement.h"
#import "SimpleAudioEngine.h"

@implementation InteractiveElement
@synthesize state,mySprite,myPlacedSprite;

-(id) initWithTheGame:(InteractiveSongScene_iPad *)ddm elementDict:(NSMutableDictionary *)element
{
	if( (self=[super init])) {
		
		theGame = ddm;
		
		elemName = [[element objectForKey:@"elemName"] retain];
		
		int xi = [[[element objectForKey:@"coord-initial"] objectForKey:@"x"] intValue];
		int yi = [[[element objectForKey:@"coord-initial"] objectForKey:@"y"] intValue];
		
		initialCoord = ccp(xi,yi);
		
		//soundOkPath = [[NSString stringWithFormat:@"dress_snd_%@_%@.mp3",itemNumber,colorNumber]retain];
		//soundWrongPath = [[NSString stringWithFormat:@"dress_snd_%@_%@_wrong.mp3",itemNumber,colorNumber]retain];
		
		mySprite = [CCSprite spriteWithFile:[element objectForKey:@"file-image"]];
		[self addChild:mySprite];
		[theGame addChild:self];
		[mySprite setPosition:initialCoord];
		
		myPlacedSprite = [CCSprite spriteWithFile:[element objectForKey:@"file-imagePlaced"]];
		[self addChild:myPlacedSprite];
		[myPlacedSprite setPosition:initialCoord];
		[myPlacedSprite setVisible:NO];
		
		[mySprite setScale:0.7];
		
		if([elemName isEqualToString:@"hat"])
		{
			mySprite.rotation = 90;
		}
		
		permissionToTouch = NO;
		
		touchNumber= 0;
		self.state = kStateUngrabbed;
		
	}
	
	return self;
}



-(void)callMeIn
{
	if([elemName isEqualToString:@"jacket"])
	{
		[mySprite runAction:[CCSequence actions:
							 [CCDelayTime actionWithDuration:6.5],
							 [CCCallFunc actionWithTarget:self selector:@selector(permissionToTouchYES)],
							 [CCDelayTime actionWithDuration:0.5],
							 [CCCallFunc actionWithTarget:self selector:@selector(permissionToTouchNO)],
							 [CCDelayTime actionWithDuration:2.5],
							 [CCCallFunc actionWithTarget:self selector:@selector(permissionToTouchYES)],
							 [CCDelayTime actionWithDuration:0.5],
							 [CCCallFunc actionWithTarget:self selector:@selector(permissionToTouchNO)],
							 [CCDelayTime actionWithDuration:1.5],
							 [CCSpawn actions:[CCJumpTo actionWithDuration:1 position:ccp(827,230) height:250 jumps:1],[CCScaleTo actionWithDuration:1 scale:1],nil],
							 [CCCallFunc actionWithTarget:self selector:@selector(permissionToTouchYES)],
							 [CCDelayTime actionWithDuration:2],
							 [CCCallFunc actionWithTarget:self selector:@selector(permissionToTouchNO)],
							 [CCJumpTo actionWithDuration:1 position:ccp(600,360) height:100 jumps:1],
							 [CCCallFunc actionWithTarget:self selector:@selector(permissionToTouchYES)],
							 [CCDelayTime actionWithDuration:2],
							 [CCCallFunc actionWithTarget:self selector:@selector(permissionToTouchNO)],
							 [CCJumpTo actionWithDuration:1 position:ccp(385,250) height:200 jumps:1],
							 [CCCallFunc actionWithTarget:self selector:@selector(permissionToTouchYES)],
							 [CCDelayTime actionWithDuration:2],
							 [CCCallFunc actionWithTarget:self selector:@selector(permissionToTouchNO)],
							 [CCDelayTime actionWithDuration:3],
							 [CCJumpTo actionWithDuration:1 position:ccp(179,380) height:250 jumps:1],
							 [CCCallFunc actionWithTarget:self selector:@selector(showPlacedSprite)],
							 [CCCallFunc actionWithTarget:self selector:@selector(permissionToTouchYES)],
							 [CCDelayTime actionWithDuration:1],
							 [CCCallFunc actionWithTarget:self selector:@selector(permissionToTouchNO)],
							 [CCCallFunc actionWithTarget:theGame selector:@selector(callNextElement)],
							 nil
							 ]];
		
		/*[mySprite runAction:[CCSequence actions:
							 [CCDelayTime actionWithDuration:1],
							 [CCSpawn actions:[CCJumpTo actionWithDuration:1 position:ccp(827,230) height:250 jumps:1],[CCScaleTo actionWithDuration:1 scale:1],nil],
							 [CCDelayTime actionWithDuration:2],
							 [CCJumpTo actionWithDuration:1 position:ccp(600,360) height:100 jumps:1],
							 [CCDelayTime actionWithDuration:2],
							 [CCJumpTo actionWithDuration:1 position:ccp(385,250) height:200 jumps:1],
							 [CCDelayTime actionWithDuration:5],
							 [CCJumpTo actionWithDuration:1 position:ccp(179,380) height:250 jumps:1],
							 [CCCallFunc actionWithTarget:self selector:@selector(showPlacedSprite)],
							 [CCDelayTime actionWithDuration:10.5],
							 [CCCallFunc actionWithTarget:theGame selector:@selector(callNextElement)],
							 nil
							 ]];*/
	}
	
	if([elemName isEqualToString:@"backpack"])
	{
		[mySprite runAction:[CCSequence actions:
							 [CCDelayTime actionWithDuration:6.5],
							 [CCCallFunc actionWithTarget:self selector:@selector(permissionToTouchYES)],
							 [CCDelayTime actionWithDuration:0.5],
							 [CCCallFunc actionWithTarget:self selector:@selector(permissionToTouchNO)],
							 [CCDelayTime actionWithDuration:2.5],
							 [CCCallFunc actionWithTarget:self selector:@selector(permissionToTouchYES)],
							 [CCDelayTime actionWithDuration:0.5],
							 [CCCallFunc actionWithTarget:self selector:@selector(permissionToTouchNO)],
							 [CCDelayTime actionWithDuration:1.5],
							 [CCSpawn actions:[CCJumpTo actionWithDuration:1 position:ccp(827,216) height:250 jumps:1],[CCScaleTo actionWithDuration:1 scale:1],nil],
							 [CCCallFunc actionWithTarget:self selector:@selector(permissionToTouchYES)],
							 [CCDelayTime actionWithDuration:2],
							 [CCCallFunc actionWithTarget:self selector:@selector(permissionToTouchNO)],
							 [CCJumpTo actionWithDuration:1 position:ccp(600,340) height:100 jumps:1],
							 [CCCallFunc actionWithTarget:self selector:@selector(permissionToTouchYES)],
							 [CCDelayTime actionWithDuration:2],
							 [CCCallFunc actionWithTarget:self selector:@selector(permissionToTouchNO)],
							 [CCJumpTo actionWithDuration:1 position:ccp(385,230) height:200 jumps:1],
							 [CCCallFunc actionWithTarget:self selector:@selector(permissionToTouchYES)],
							 [CCDelayTime actionWithDuration:2],
							 [CCCallFunc actionWithTarget:self selector:@selector(permissionToTouchNO)],
							 [CCDelayTime actionWithDuration:3],
							 [CCJumpTo actionWithDuration:1 position:ccp(179,385) height:250 jumps:1],
							 [CCCallFunc actionWithTarget:self selector:@selector(showPlacedSprite)],
							 [CCCallFunc actionWithTarget:self selector:@selector(permissionToTouchYES)],
							 [CCDelayTime actionWithDuration:1],
							 [CCCallFunc actionWithTarget:self selector:@selector(permissionToTouchNO)],
							 [CCCallFunc actionWithTarget:theGame selector:@selector(callNextElement)],
							 nil
							 ]];
		/*[mySprite runAction:[CCSequence actions:
							 [CCDelayTime actionWithDuration:1],
							 [CCSpawn actions:[CCJumpTo actionWithDuration:1 position:ccp(827,216) height:250 jumps:1],[CCScaleTo actionWithDuration:1 scale:1],nil],
							 [CCDelayTime actionWithDuration:2],
							 [CCJumpTo actionWithDuration:1 position:ccp(600,340) height:100 jumps:1],
							 [CCDelayTime actionWithDuration:2],
							 [CCJumpTo actionWithDuration:1 position:ccp(385,230) height:200 jumps:1],
							 [CCDelayTime actionWithDuration:6],
							 [CCJumpTo actionWithDuration:1 position:ccp(179,385) height:250 jumps:1],
							 [CCCallFunc actionWithTarget:self selector:@selector(showPlacedSprite)],
							 [CCDelayTime actionWithDuration:10.5],
							 [CCCallFunc actionWithTarget:theGame selector:@selector(callNextElement)],
							 nil
							 ]];*/
	}
	
	if([elemName isEqualToString:@"hat"])
	{
		[mySprite runAction:[CCSequence actions:
							 [CCDelayTime actionWithDuration:6.5],
							 [CCCallFunc actionWithTarget:self selector:@selector(permissionToTouchYES)],
							 [CCDelayTime actionWithDuration:0.5],
							 [CCCallFunc actionWithTarget:self selector:@selector(permissionToTouchNO)],
							 [CCDelayTime actionWithDuration:2.5],
							 [CCCallFunc actionWithTarget:self selector:@selector(permissionToTouchYES)],
							 [CCDelayTime actionWithDuration:0.5],
							 [CCCallFunc actionWithTarget:self selector:@selector(permissionToTouchNO)],
							 [CCDelayTime actionWithDuration:1.5],
							 [CCSpawn actions:[CCJumpTo actionWithDuration:1 position:ccp(827,190) height:250 jumps:1],[CCScaleTo actionWithDuration:1 scale:1],[CCRotateTo actionWithDuration:1 angle:0],nil],
							 [CCCallFunc actionWithTarget:self selector:@selector(permissionToTouchYES)],
							 [CCDelayTime actionWithDuration:2],
							 [CCCallFunc actionWithTarget:self selector:@selector(permissionToTouchNO)],
							 [CCJumpTo actionWithDuration:1 position:ccp(600,295) height:100 jumps:1],
							 [CCCallFunc actionWithTarget:self selector:@selector(permissionToTouchYES)],
							 [CCDelayTime actionWithDuration:2],
							 [CCCallFunc actionWithTarget:self selector:@selector(permissionToTouchNO)],
							 [CCJumpTo actionWithDuration:1 position:ccp(385,210) height:200 jumps:1],
							 [CCCallFunc actionWithTarget:self selector:@selector(permissionToTouchYES)],
							 [CCDelayTime actionWithDuration:2],
							 [CCCallFunc actionWithTarget:self selector:@selector(permissionToTouchNO)],
							 [CCDelayTime actionWithDuration:3],
							 [CCJumpTo actionWithDuration:1 position:ccp(180,553) height:250 jumps:1],
							 [CCCallFunc actionWithTarget:self selector:@selector(showPlacedSprite)],
							 [CCCallFunc actionWithTarget:self selector:@selector(permissionToTouchYES)],
							 [CCDelayTime actionWithDuration:1],
							 [CCCallFunc actionWithTarget:self selector:@selector(permissionToTouchNO)],
							 [CCDelayTime actionWithDuration:8],
							 [CCCallFunc actionWithTarget:theGame selector:@selector(callNextElement)],
							 nil
							 ]];
		
		/*[mySprite runAction:[CCSequence actions:
							 [CCDelayTime actionWithDuration:1],
							 [CCSpawn actions:[CCJumpTo actionWithDuration:1 position:ccp(827,190) height:250 jumps:1],[CCScaleTo actionWithDuration:1 scale:1],[CCRotateTo actionWithDuration:1 angle:0],nil],
							 [CCDelayTime actionWithDuration:2],
							 [CCJumpTo actionWithDuration:1 position:ccp(600,295) height:100 jumps:1],
							 [CCDelayTime actionWithDuration:2],
							 [CCJumpTo actionWithDuration:1 position:ccp(385,210) height:200 jumps:1],
							 [CCDelayTime actionWithDuration:5],
							 [CCJumpTo actionWithDuration:1 position:ccp(188,553) height:250 jumps:1],
							 [CCCallFunc actionWithTarget:self selector:@selector(showPlacedSprite)],
							 [CCDelayTime actionWithDuration:18],
							 [CCCallFunc actionWithTarget:theGame selector:@selector(callNextElement)],
							 nil
							 ]];*/
	}
	
	if([elemName isEqualToString:@"boots"])
	{
		[mySprite runAction:[CCSequence actions:
							 [CCDelayTime actionWithDuration:8.5],
							 [CCCallFunc actionWithTarget:self selector:@selector(permissionToTouchYES)],
							 [CCDelayTime actionWithDuration:0.5],
							 [CCCallFunc actionWithTarget:self selector:@selector(permissionToTouchNO)],
							 [CCDelayTime actionWithDuration:2.5],
							 [CCCallFunc actionWithTarget:self selector:@selector(permissionToTouchYES)],
							 [CCDelayTime actionWithDuration:0.5],
							 [CCCallFunc actionWithTarget:self selector:@selector(permissionToTouchNO)],
							 [CCDelayTime actionWithDuration:1],
							 [CCSpawn actions:[CCJumpTo actionWithDuration:1 position:ccp(827,190) height:250 jumps:1],[CCScaleTo actionWithDuration:1 scale:1],nil],
							 [CCCallFunc actionWithTarget:self selector:@selector(permissionToTouchYES)],
							 [CCDelayTime actionWithDuration:2],
							 [CCCallFunc actionWithTarget:self selector:@selector(permissionToTouchNO)],
							 [CCJumpTo actionWithDuration:1 position:ccp(600,310) height:100 jumps:1],
							 [CCCallFunc actionWithTarget:self selector:@selector(permissionToTouchYES)],
							 [CCDelayTime actionWithDuration:2],
							 [CCCallFunc actionWithTarget:self selector:@selector(permissionToTouchNO)],
							 [CCJumpTo actionWithDuration:1 position:ccp(385,205) height:200 jumps:1],
							 [CCCallFunc actionWithTarget:self selector:@selector(permissionToTouchYES)],
							 [CCDelayTime actionWithDuration:2],
							 [CCCallFunc actionWithTarget:self selector:@selector(permissionToTouchNO)],
							 [CCDelayTime actionWithDuration:3],
							 [CCJumpTo actionWithDuration:1 position:ccp(180,185) height:250 jumps:1],
							 [CCCallFunc actionWithTarget:self selector:@selector(showPlacedSprite)],
							 [CCCallFunc actionWithTarget:self selector:@selector(permissionToTouchYES)],
							 [CCDelayTime actionWithDuration:1],
							 [CCCallFunc actionWithTarget:self selector:@selector(permissionToTouchNO)],
							 [CCCallFunc actionWithTarget:theGame selector:@selector(callNextElement)],
							 nil
							 ]];
	}
}

-(void)permissionToTouchYES
{
	touchNumber++;
	permissionToTouch = YES;
	mySprite.color = ccRED;
	myPlacedSprite.color = ccRED;
}

-(void)permissionToTouchNO
{
	permissionToTouch = NO;
	mySprite.color = ccWHITE;
	myPlacedSprite.color = ccWHITE;
}

-(void)showPlacedSprite
{
	myPlacedSprite.position = mySprite.position;
	[myPlacedSprite setVisible:YES];
	[mySprite setVisible:NO];
}

-(int)pointForTouchNumber
{
	switch (touchNumber) {
		case 1:
			return 1;
			break;
		case 2:
			return 1;
			break;
		case 3:
			return 1;
			break;
		case 4:
			return 1;
			break;
		case 5:
			return 1;
			break;
		case 6:
			return 5;
			break;
	}
}

- (CGRect)rect
{
	//CGSize s = [self.texture contentSize];
	CGRect c = CGRectMake(mySprite.position.x-(mySprite.textureRect.size.width/2) * mySprite.scaleX ,mySprite.position.y-(mySprite.textureRect.size.height/2)* mySprite.scaleY,mySprite.textureRect.size.width* mySprite.scaleX,mySprite.textureRect.size.height * mySprite.scaleY);
	return c;
}

- (void)onEnter
{
	[[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
	[super onEnter];
}

- (void)onExit
{
	for(CCParticleSystemQuad * p in [self children])
	{
		if([p isKindOfClass:[CCParticleSystemQuad class]])
			[self removeChild:p cleanup:YES];
	}
	
	[[CCTouchDispatcher sharedDispatcher] removeDelegate:self];
	[super onExit];
}	

- (BOOL)containsTouchLocation:(UITouch *)touch
{
	if( CGRectContainsPoint([self rect], [self convertTouchToNodeSpaceAR:touch]))
	{
		return YES;
	}
	
	return NO;
}

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
	if (state != kStateUngrabbed) return NO;
	if ( ![self containsTouchLocation:touch]) return NO;
	
	//if(placed && movableAfterPlaced)
	//	theGame.elementsPlaced--;
	
	
	CGPoint location = [touch locationInView: [touch view]];
	location = [[CCDirector sharedDirector] convertToGL: location];
	
	if(permissionToTouch)
	{
		permissionToTouch = NO;
		[theGame addPoints:[self pointForTouchNumber]];
	}
	state = kStateGrabbed;
	
	
	return YES;
}

- (void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event
{
	CGPoint location = [touch locationInView: [touch view]];
	
	location = [[CCDirector sharedDirector] convertToGL: location];
	
}

- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
	NSAssert(state == kStateGrabbed, @"Unexpected state!");	
	
	CGPoint location = [touch locationInView: [touch view]];
	
	location = [[CCDirector sharedDirector] convertToGL: location];
	
	//[theGame checkWinCondition];
	
	state = kStateUngrabbed;
}

-(void)removeNode:(CCNode *)node
{
	[node.parent removeChild:node cleanup:YES];
}

-(void)dealloc
{
	//[[SimpleAudioEngine sharedEngine] unloadEffect:soundOkPath];
	//[[SimpleAudioEngine sharedEngine] unloadEffect:soundWrongPath];
	
	//[soundOkPath release];
	//[soundWrongPath release];
	[elemName release];
	[super dealloc];
}

@end