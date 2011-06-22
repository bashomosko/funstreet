

#import "DDElement_both.h"
#import "GameManager.h"
#import "SimpleAudioEngine.h"

@implementation DDElement_both
@synthesize state,mySprite,dressed,desiredZ,itemTag,itemText,itemNumber,colorNumber,imagePath2;


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

}

- (void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event
{
	CGPoint location = [touch locationInView: [touch view]];
	
	location = [[CCDirector sharedDirector] convertToGL: location];
	
	mySprite.position = ccp(location.x-mySprite.contentSize.width/2,location.y+mySprite.contentSize.height/2);
	
}

- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{

}
            

-(void)shakeMismatch
{
    CGPoint initPos = mySprite.position;
    
	[mySprite runAction:[CCSequence actions:[CCRepeat actionWithAction:[CCSequence actions:
																		[CCMoveBy actionWithDuration:0.05 position:ccp(5,5)],
																		[CCMoveBy actionWithDuration:0.05 position:ccp(-5,-5)],
																		[CCMoveBy actionWithDuration:0.05 position:ccp(5,5)],
																		[CCMoveBy actionWithDuration:0.05 position:ccp(-5,-5)],
																		[CCMoveBy actionWithDuration:0.05 position:ccp(5,5)],
																		[CCMoveBy actionWithDuration:0.05 position:ccp(-5,-5)],
																		[CCMoveBy actionWithDuration:0.05 position:ccp(5,5)],
																		[CCMoveBy actionWithDuration:0.05 position:ccp(-5,-5)],
																		[CCMoveBy actionWithDuration:0.05 position:ccp(5,5)],
																		[CCMoveBy actionWithDuration:0.05 position:ccp(-5,-5)],nil]
																 times:2],[CCPlace actionWithPosition:initPos],nil]];
}

-(void)removeNode:(CCNode *)node
{
	[node.parent removeChild:node cleanup:YES];
}

-(void)dealloc
{
	[[SimpleAudioEngine sharedEngine] unloadEffect:soundOkPath];
	[[SimpleAudioEngine sharedEngine] unloadEffect:soundWrongPath];
	[[SimpleAudioEngine sharedEngine] unloadEffect:@"RightAnswer.mp3"];
	[[SimpleAudioEngine sharedEngine] unloadEffect:@"WrongAnswer.mp3"];
    [[SimpleAudioEngine sharedEngine] unloadEffect:@"CloudTransition.mp3"];
	
	[dressed release];
	[imagePath release];
	[soundOkPath release];
	[soundWrongPath release];
    [imagePath2 release];
	[super dealloc];
}

@end
