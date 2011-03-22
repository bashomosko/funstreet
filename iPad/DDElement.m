

#import "DDElement.h"
#import "GameManager.h"
#import "SimpleAudioEngine.h"

@implementation DDElement
@synthesize state,mySprite,dressed,desiredZ,itemTag;

-(id) initWithTheGame:(GameDress_iPad *)ddm elementDict:(NSMutableDictionary *)element
{
	if( (self=[super init])) {
		
		theGame = ddm;
		
		imagePath =[[element objectForKey:@"file-image"]retain];
		dressed =[[element objectForKey:@"file-dressed"]retain];
		
		int xr = [[[element objectForKey:@"coord-drop"] objectForKey:@"x"] intValue];
		int yr = [[[element objectForKey:@"coord-drop"] objectForKey:@"y"] intValue];
		
		dropPoint = ccp(xr,yr);
		
		int xi = [[[element objectForKey:@"coord-initial"] objectForKey:@"x"] intValue];
		int yi = [[[element objectForKey:@"coord-initial"] objectForKey:@"y"] intValue];
		
		initialCoord = ccp(xi,yi);
		
		soundOkPath = [[element objectForKey:@"file-soundOk"]retain];
		soundWrongPath = [[element objectForKey:@"file-soundWrong"]retain];
		movableAfterPlaced = NO;
		
		desiredZ = [[element objectForKey:@"desiredZ"] intValue];
		itemTag= [[element objectForKey:@"itemTag"] intValue];

		
		CCSpriteBatchNode * sbn = [theGame getChildByTag:kSPRITEBATCH_ELEMS];
		mySprite = [CCSprite spriteWithSpriteFrameName:imagePath];
		[sbn addChild:mySprite z:5];
		[theGame addChild:self];
		[mySprite setPosition:initialCoord];
		
		//initialCoord = [GameManager coordToTopLeft:[GameManager realLifeCoords:ccp(x,y)] size:mySprite.contentSize];
		
		self.state = kStateUngrabbed;
		
	}
	
	return self;
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
	if(placed && !movableAfterPlaced) return NO;
	if(theGame.placingElement) return NO;
	
	//if(placed && movableAfterPlaced)
	//	theGame.elementsPlaced--;

	
	CGPoint location = [touch locationInView: [touch view]];
	location = [[CCDirector sharedDirector] convertToGL: location];
	
	state = kStateGrabbed;
	
	
	return YES;
}

- (void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event
{
	CGPoint location = [touch locationInView: [touch view]];
	
	location = [[CCDirector sharedDirector] convertToGL: location];
	
	mySprite.position = ccp(location.x-mySprite.contentSize.width/2,location.y+mySprite.contentSize.height/2);
	
}

- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
	NSAssert(state == kStateGrabbed, @"Unexpected state!");	
	
	CGPoint location = [touch locationInView: [touch view]];
	
	location = [[CCDirector sharedDirector] convertToGL: location];
	
	
	
	if(!(dropPoint.x == 0 && dropPoint.y == 0))
	{
		if(ccpDistance(mySprite.position,dropPoint) < 100 )
		{
			mySprite.position = dropPoint;
			//theGame.elementsPlaced++;
			/*CCParticleSystemQuad * particles = [CCParticleSystemQuad particleWithFile:particleOkPath];
			[self addChild:particles];
			[particles setPosition:mySprite.position];
			[particles setAutoRemoveOnFinish:YES];*/
			
			CCSprite * smoke = [CCSprite spriteWithFile:@"Poof_iPad.png"];
			[smoke setPosition:ccp(512,384)];
			[theGame addChild:smoke z:20];
			[smoke setScale:0];
			[smoke runAction:[CCSequence actions:[CCScaleTo actionWithDuration:0.5 scale:2],[CCSpawn actions:[CCScaleTo actionWithDuration:0.5 scale:2],[CCFadeOut actionWithDuration:0.5],nil],[CCCallFuncN actionWithTarget:self selector:@selector(removeNode:)],nil]];
			
			if([GameManager sharedGameManager].soundsEnabled)
				[[SimpleAudioEngine sharedEngine] playEffect:soundOkPath];
			placed = YES;
			theGame.placingElement = YES;
			[theGame runAction:[CCSequence actions:[CCCallFuncND actionWithTarget:theGame selector:@selector(dressDino: data:) data:(void*)self],[CCDelayTime actionWithDuration:1],[CCCallFunc actionWithTarget:theGame selector:@selector(selectItemForBasho)],nil]];
		}else {
			mySprite.position = initialCoord;
			/*CCParticleSystemQuad * particles = [CCParticleSystemQuad particleWithFile:particleWrongPath];
			[self addChild:particles];
			[particles setPosition:mySprite.position];
			[particles setAutoRemoveOnFinish:YES];*/
			//if(theGame.kd.soundsEnabled)
			//	[[SimpleAudioEngine sharedEngine] playEffect:soundWrongPath];
			placed = NO;
		}

	}	
	
	//[theGame checkWinCondition];
	
	state = kStateUngrabbed;
}

-(void)removeNode:(CCNode *)node
{
	[node.parent removeChild:node cleanup:YES];
}

-(void)dealloc
{
	[[SimpleAudioEngine sharedEngine] unloadEffect:soundOkPath];
	[[SimpleAudioEngine sharedEngine] unloadEffect:soundWrongPath];
	
	[dressed release];
	[imagePath release];
	[soundOkPath release];
	[soundWrongPath release];
	[super dealloc];
}

@end
