//
//  GameDressScene_both.m
//  Basho
//
//  Created by Pablo Ruiz on 04/03/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GameDressScene_both.h"
#import "GameManager.h"
#import "SimpleAudioEngine.h"

@implementation GameDressScene_both

@synthesize placingElement,colorNeeded,itemNeeded,bashoDirected,dino,isBackBagSet,shirt,sound,gloopFrames;

-(void)loadScore
{

}

-(void)loadVideo
{
	
}

-(void)skipMovie
{
	videoTaps++;
	[self performSelector:@selector(reduceVideoTaps) withObject:nil afterDelay:0.5];
	if(videoTaps ==2)
	{
	
		[[NSNotificationCenter defaultCenter] removeObserver:self
													name:MPMoviePlayerPlaybackDidFinishNotification object:introVideo];
		[introVideo stop];
		[introVideo.view removeFromSuperview];
		[introVideo release];
	
        [GameManager sharedGameManager].onPause = NO;
        if ([GameManager sharedGameManager].musicAudioEnabled) {
            [[SimpleAudioEngine sharedEngine] resumeBackgroundMusic];
        }

        if(videoFromLoadingScene)
        {
            [self beginGame];
            videoFromLoadingScene = NO;
        }
	}
}

-(void)reduceVideoTaps
{
	videoTaps =0;
}

-(void) videoPlayerDidFinishPlaying: (NSNotification*)aNotification
{
	MPMoviePlayerController * introVideo = [aNotification object];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerPlaybackDidFinishNotification object:introVideo];
	[introVideo stop];
	[introVideo.view removeFromSuperview];
	[introVideo release];
	
    [GameManager sharedGameManager].onPause = NO;
    
    if ([GameManager sharedGameManager].musicAudioEnabled) {
        [[SimpleAudioEngine sharedEngine] resumeBackgroundMusic];
    }
    if(videoFromLoadingScene)
    {
        [self beginGame];
        videoFromLoadingScene = NO;
    }
}


-(void)replay
{	
		
}

-(void)nextGame
{
	
}

-(void)beginGame
{
	//[self loadDeviceType];
	
}


-(void)createPalabra
{
    
}

-(void)showPalabra:(NSString *)word
{
	CCLabelTTF * palabra = [self getChildByTag:kPALABRA];
	[palabra setString:word];
	[palabra runAction:[CCFadeIn actionWithDuration:0.8]];
    CCSprite * palabraBck = [self getChildByTag:kPALABRABCK];
	[palabraBck runAction:[CCFadeIn actionWithDuration:0.8]];
}

-(void)hidePalabra
{
	CCLabelTTF * palabra = [self getChildByTag:kPALABRA];
	[palabra runAction:[CCSequence actions:[CCDelayTime actionWithDuration:1.5],[CCFadeTo actionWithDuration:0.5 opacity:0],nil]];
    CCSprite * palabraBck = [self getChildByTag:kPALABRABCK];
	[palabraBck runAction:[CCSequence actions:[CCDelayTime actionWithDuration:1.5],[CCFadeTo actionWithDuration:0.5 opacity:0],nil]];	
}

-(void)playRandomDinoAnim
{
	
}

-(void)removeRandomDinoAnim:(CCSprite *)sp
{
	CCSpriteBatchNode * sbn = [self getChildByTag:kSPRITEBATCH_ELEMS];
	
	CCSprite * dinosp = [sbn getChildByTag:4190];
	[dinosp setVisible:YES];
	
	CCSpriteBatchNode * animSbn = [self getChildByTag:545];
	NSString * textToRemove = [NSString stringWithString:animSbn.userData];
	[animSbn.userData release];
	[animSbn removeChild:sp cleanup:YES];
	[self removeChild:animSbn cleanup:YES];
	[[CCSpriteFrameCache sharedSpriteFrameCache] removeSpriteFramesFromFile:textToRemove];
	
}

-(void)goSettings
{

}

-(void)turnSounds
{
	GameManager * gm = [GameManager sharedGameManager];
	[gm turnSounds];
}

-(void)turnBasho
{
	
	
}

-(void)makeScoreAppear:(BOOL)appear
{
	CCLabelTTF * scoreLbl = [self getChildByTag:kSCORE];
	if(appear)
		[scoreLbl setOpacity:255];
	else
		[scoreLbl setOpacity:0];
	
}


-(void)selectItemForBasho
{
		
}

-(void)removeAnim:(CCNode *)n
{
	[n.parent removeChild:n cleanup:YES];
}

-(void)addPoints
{
	points += 5;
	CCLabelTTF * scoreLbl = [self getChildByTag:kSCORE];
	[scoreLbl setString:[NSString stringWithFormat:@"%d",points]];
}

-(void)resetDino
{
	CCSpriteBatchNode * sbn = [self getChildByTag:kSPRITEBATCH_ELEMS];
	for(CCSprite * el in dressPieces)
	{
		[sbn removeChild:el cleanup:YES];
	}
	[dressPieces removeAllObjects];
	
	[self selectItemForBasho];
	
}
-(void)dressDino:(GameDressScene_both *)scene data:(void *)data
{	
		
}

-(void)loadScatteredElementsForItem:(int)item
{
	
}

- (NSMutableArray *) shuffle:(NSMutableArray *)array
{
	// create temporary autoreleased mutable array
	NSMutableArray *tmpArray = [NSMutableArray arrayWithCapacity:[array count]];
	
	for (id anObject in array)
	{
		NSUInteger randomPos = arc4random()%([tmpArray count]+1);
		[tmpArray insertObject:anObject atIndex:randomPos];
	}
	
	return [NSArray arrayWithArray:tmpArray];  // non-mutable autoreleased copy
}


-(void)goBack
{

}

- (void) onEnter
{
	[super onEnter];
	[[UIAccelerometer sharedAccelerometer] setUpdateInterval:(1.0 / 60)];
	
}

-(void)doTimePassedForShake
{
	[self unschedule:@selector(timePassedForShake)];
	timePassedForShake = YES;
}

-(void)onShake
{

}

- (void)accelerometer:(UIAccelerometer*)accelerometer didAccelerate:(UIAcceleration*)acceleration
{	
	if (lastAcceleration)
    {
        if (!histeresisExcited && AccelerationIsShaking(lastAcceleration, acceleration, 0.35))
        {
            histeresisExcited = YES;
			[self onShake];
        }
        else if (histeresisExcited && !AccelerationIsShaking(lastAcceleration, acceleration, 0.2))
        {
            histeresisExcited = NO;
        }
    }
	
    [lastAcceleration release];
    lastAcceleration = [acceleration retain];
	
}


static BOOL AccelerationIsShaking(UIAcceleration* last, UIAcceleration* current, double threshold) 
{
    double
    deltaX = fabs(last.x - current.x),
    deltaY = fabs(last.y - current.y),
    deltaZ = fabs(last.z - current.z);
	
    return
    (deltaX > threshold && deltaY > threshold) ||
    (deltaX > threshold && deltaZ > threshold) ||
    (deltaY > threshold && deltaZ > threshold);
}


-(void)dealloc
{
	[[SimpleAudioEngine sharedEngine] unloadEffect:@"game2-alldressed-sfx.mp3"];
   	[dino release];
    [shirt release];
	[target release];
	[lastAcceleration release];
	[btnImgs release];
	[btnColor release];
	[dressPieces release];
	[ddElements release];
    gloopFrames = nil;
    [gloopFrames release];
	[super dealloc];
}

@end
