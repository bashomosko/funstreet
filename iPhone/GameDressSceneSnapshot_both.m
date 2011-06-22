//
//  GameDressSceneSnapshot_both.m
//  Basho
//
//  Created by Pablo Ruiz on 19/05/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GameManager.h"
#import "SimpleAudioEngine.h"
#import "GameDressSceneSnapshot_both.h"


@implementation GameDressSceneSnapshot_both


-(void)tapToCont
{

}

-(void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInView: [touch view]];
    location = [[CCDirector sharedDirector] convertToGL: location];	
	
	if(moveOutActivated)
		[self moveOut];
	
	
}

-(void)moveOut
{

}

-(void)addDinoOnPosition:(CGPoint)pos dinoImage:(UIImage *)img num:(int)num
{
	
}

-(void)playSnd
{
	if([GameManager sharedGameManager].soundsEnabled)
		[[SimpleAudioEngine sharedEngine] playEffect:@"Camera_SFX.mp3"];
}

-(void)dealloc
{
	[[SimpleAudioEngine sharedEngine] unloadEffect:@"Camera_SFX.mp3"];
	[super dealloc];
}

@end
