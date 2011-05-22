//
//  GameWheel_both.h
//  Basho
//
//  Created by Pablo Ruiz on 03/03/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "GameWheel.h"
#import <MediaPlayer/MediaPlayer.h>

#define kPALABRA 1000
#define kPALABRABCK 999
#define kSCORE 1001
#define kPointsAwarded 5

#define BTN_BACKPACK @"backpack"
#define BTN_BOOTS @"boots"
#define BTN_HAT @"hat"
#define BTN_PHONE @"phone"
#define BTN_JACKET @"jacket"
#define BTN_NECKLACE @"necklace"
#define BTN_PANTS @"pants"
#define BTN_SUNGLASSES @"sunglasses"

#define BTN_BACKPACK_NUM 0
#define BTN_BOOTS_NUM 1
#define BTN_HAT_NUM 2
#define BTN_PHONE_NUM 3
#define BTN_JACKET_NUM 4
#define BTN_NECKLACE_NUM 5
#define BTN_PANTS_NUM 6
#define BTN_SUNGLASSES_NUM 7

#define BTN_BACKPACK_SND @"wheel_snd_backpack.mp3"
#define BTN_BOOTS_SND @"wheel_snd_boots.mp3"
#define BTN_HAT_SND @"wheel_snd_hat.mp3"
#define BTN_PHONE_SND @"wheel_snd_phone.mp3"
#define BTN_JACKET_SND @"wheel_snd_jacket.mp3"
#define BTN_NECKLACE_SND @"wheel_snd_necklace.mp3"
#define BTN_PANTS_SND @"wheel_snd_pants.mp3"
#define BTN_SUNGLASSES_SND @"wheel_snd_sunglasses.mp3"

#define BTN_BACKPACK_SND_WHERE @"wheel_snd_backpack_where.mp3"
#define BTN_BOOTS_SND_WHERE @"wheel_snd_boots_where.mp3"
#define BTN_HAT_SND_WHERE @"wheel_snd_hat_where.mp3"
#define BTN_PHONE_SND_WHERE @"wheel_snd_phone_where.mp3"
#define BTN_JACKET_SND_WHERE @"wheel_snd_jacket_where.mp3"
#define BTN_NECKLACE_SND_WHERE @"wheel_snd_necklace_where.mp3"
#define BTN_PANTS_SND_WHERE @"wheel_snd_pants_where.mp3"
#define BTN_SUNGLASSES_SND_WHERE @"wheel_snd_sunglasses_where.mp3"

#define BTN_BACKPACK_SND_WRONG @"wheel_snd_backpack_wrong.mp3"
#define BTN_BOOTS_SND_WRONG @"wheel_snd_boots_wrong.mp3"
#define BTN_HAT_SND_WRONG @"wheel_snd_hat_wrong.mp3"
#define BTN_PHONE_SND_WRONG @"wheel_snd_phone_wrong.mp3"
#define BTN_JACKET_SND_WRONG @"wheel_snd_jacket_wrong.mp3"
#define BTN_NECKLACE_SND_WRONG @"wheel_snd_necklace_wrong.mp3"
#define BTN_PANTS_SND_WRONG @"wheel_snd_pants_wrong.mp3"
#define BTN_SUNGLASSES_SND_WRONG @"wheel_snd_sunglasses_wrong.mp3"

#define BTN_BACKPACK_SPANISH @"Mochila"
#define BTN_BOOTS_SPANISH @"Botas"
#define BTN_HAT_SPANISH @"Sombrero"
#define BTN_PHONE_SPANISH @"Telefono"
#define BTN_JACKET_SPANISH @"Campera"
#define BTN_NECKLACE_SPANISH @"Collar"
#define BTN_PANTS_SPANISH @"Pantalones"
#define BTN_SUNGLASSES_SPANISH @"Anteojos"


@interface NSMutableArray (Shuffling)
- (void)shuffle;
@end


@interface GameWheelScene_both : CCLayer {

	GameWheel * viewController;
	CCSprite * dino;
	BOOL dinoSpinning;
	BOOL playingSound;
	int selectedSound;
	int bashoSelectedSound;
	CCMenu * tapButtons;
	
	BOOL bashoDirected;
	NSMutableArray * bashoSelectedItems ;
	
	int points;
	
	BOOL isInIpad;
	NSString * iPad;
	
	int currentAttempts;
	BOOL maxedAttemps;
	
	MPMoviePlayerController * introVideo;
	MPMoviePlayerController * finishVideo;
    
    float forceApplied;
    CGPoint initPoint;
    BOOL fromMovement;
    float actualAngle;
    float initialAngle;
    BOOL isDragging;
    float time;
    float friction;
    BOOL clockWise;
    
    NSMutableArray * buttonsData;
	
	CCSprite * leverImg;
	CCSprite * leverBtn;
	
	BOOL beganDraggingLever;
	BOOL wasDragging;
	BOOL couldBeginTouch;
	BOOL stopWhenRotationReached;
	BOOL canDragDino;
	
}

@end
