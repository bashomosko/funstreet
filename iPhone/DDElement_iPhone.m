

#import "DDElement_iPhone.h"
#import "GameManager.h"
#import "SimpleAudioEngine.h"

@implementation DDElement_iPhone


-(id) initWithTheGame:(GameDressScene_iPhone *)ddm elementDict:(NSMutableDictionary *)element
{
	if( (self=[super init])) {
		
		theGame = ddm;
		
		imagePath =[[element objectForKey:@"file-image"]retain];
		dressed =[[element objectForKey:@"file-dressed"]retain];
        
        imagePath2 = [[element objectForKey:@"file-dressed2"] retain];
		
		int xr = [[[element objectForKey:@"coord-drop"] objectForKey:@"x"] intValue];
		int yr = [[[element objectForKey:@"coord-drop"] objectForKey:@"y"] intValue];
		
		dropPoint = ccp(xr,yr);
		
		int xi = [[[element objectForKey:@"coord-initial"] objectForKey:@"x"] intValue];
		int yi = [[[element objectForKey:@"coord-initial"] objectForKey:@"y"] intValue];
		
		initialCoord = ccp(xi,yi);
		
		//soundOkPath = [[element objectForKey:@"file-soundOk"]retain];
		//soundWrongPath = [[element objectForKey:@"file-soundWrong"]retain];
		movableAfterPlaced = NO;
		
		desiredZ = [[element objectForKey:@"desiredZ"] intValue];
		itemTag= [[element objectForKey:@"itemTag"] intValue];
		
		itemNumber = [element objectForKey:@"itemNumber"];
		colorNumber = [element objectForKey:@"colorNumber"];
		itemText = [element objectForKey:[NSString stringWithFormat:@"text_%@",[GameManager sharedGameManager].languageString]];
		
		
		soundOkPath = [[NSString stringWithFormat:@"dress_snd_%@_%@.mp3",itemNumber,colorNumber]retain];
		soundWrongPath = [[NSString stringWithFormat:@"dress_snd_%@_%@_wrong.mp3",itemNumber,colorNumber]retain];
		
		CCSpriteBatchNode * sbn = (CCSpriteBatchNode*)[theGame getChildByTag:kSPRITEBATCH_ELEMS];
		mySprite = [CCSprite spriteWithSpriteFrameName:imagePath];
		[sbn addChild:mySprite z:9];
		[theGame addChild:self];
		[mySprite setPosition:initialCoord];
		
		//initialCoord = [GameManager coordToTopLeft:[GameManager realLifeCoords:ccp(x,y)] size:mySprite.contentSize];
		
		self.state = kStateUngrabbed;
		
	}
	
	return self;
}

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
	if (state != kStateUngrabbed) return NO;
	if ( ![self containsTouchLocation:touch]) return NO;
	if(placed && !movableAfterPlaced) return NO;
	if(theGame.placingElement) return NO;
    if([GameManager sharedGameManager].onPause) return NO;
	
	//if(placed && movableAfterPlaced)
	//	theGame.elementsPlaced--;
    
	
	CGPoint location = [touch locationInView: [touch view]];
	location = [[CCDirector sharedDirector] convertToGL: location];
	
	state = kStateGrabbed;
	
	
	return YES;
}


- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
	NSAssert(state == kStateGrabbed, @"Unexpected state!");	
	
	CGPoint location = [touch locationInView: [touch view]];
	
	location = [[CCDirector sharedDirector] convertToGL: location];
	
	if(!(dropPoint.x == 0 && dropPoint.y == 0))
	{   
        CGRect dino = CGRectMake(312, 134, 400, 500);
        
		if(/*ccpDistance(mySprite.position,dropPoint) < 100*/ CGRectIntersectsRect([mySprite boundingBox],dino) &&( !theGame.bashoDirected || ([itemNumber isEqualToString:theGame.itemNeeded] && [colorNumber isEqualToString:theGame.colorNeeded])))
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
            [[SimpleAudioEngine sharedEngine] playEffect:@"CloudTransition.mp3"];
			[smoke runAction:[CCSequence actions:[CCSpawn actions:[CCScaleTo actionWithDuration:1.1 scale:2],
                                                  [CCSequence actions:[CCRotateTo actionWithDuration:0.1 angle:33], 
                                                   [CCRotateTo actionWithDuration:0.1 angle:66],
                                                   [CCRotateTo actionWithDuration:0.1 angle:99],
                                                   [CCRotateTo actionWithDuration:0.1 angle:132],
                                                   [CCRotateTo actionWithDuration:0.1 angle:165],
                                                   [CCRotateTo actionWithDuration:0.1 angle:198],
                                                   [CCRotateTo actionWithDuration:0.1 angle:231],
                                                   [CCRotateTo actionWithDuration:0.1 angle:264],
                                                   [CCRotateTo actionWithDuration:0.1 angle:297],
                                                   [CCRotateTo actionWithDuration:0.1 angle:330],
                                                   [CCRotateTo actionWithDuration:0.1 angle:360],nil],nil],
                             [CCSpawn actions:[CCScaleTo actionWithDuration:0.5 scale:2],
                             [CCFadeOut actionWithDuration:0.5],nil],
                             [CCCallFuncN actionWithTarget:self selector:@selector(removeNode:)],nil]];
			
			if([GameManager sharedGameManager].soundsEnabled)
			{
				if (theGame.bashoDirected) {
                    soundFileName = @"RightAnswer.mp3";
                }
                else {
                    
                    int soundToPlay = (arc4random()%5 + 1);
                    soundFileName = [NSString stringWithFormat:@"DressHit%d.mp3",soundToPlay];
                }
                
				[[SimpleAudioEngine sharedEngine] playEffect:soundFileName];
				[theGame hidePalabra];
				/*if(theGame.bashoDirected)
					[[SimpleAudioEngine sharedEngine] playEffect:@"RightAnswer.mp3"];
				else
					[[SimpleAudioEngine sharedEngine] playEffect:soundOkPath];*/
			}
			placed = YES;
			theGame.placingElement = YES;
			//[theGame addPoints];
			[theGame runAction:[CCSequence actions:[CCCallFuncND actionWithTarget:theGame selector:@selector(dressDino: data:) data:(void*)self],[CCDelayTime actionWithDuration:2.5],[CCCallFunc actionWithTarget:theGame selector:@selector(selectItemForBasho)],nil]];
		}else {
			if([GameManager sharedGameManager].soundsEnabled)
				[[SimpleAudioEngine sharedEngine] playEffect:@"WrongAnswer.mp3"];
			mySprite.position = initialCoord;
			[self shakeMismatch];
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
            

-(void)dealloc
{

	[super dealloc];
}

@end
