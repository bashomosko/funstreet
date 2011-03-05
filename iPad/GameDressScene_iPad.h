//
//  GameDressScene_iPad.h
//  Basho
//
//  Created by Pablo Ruiz on 04/03/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "GameDress_iPad.h"

#define kSPRITEBATCH_ELEMS 1
#define kBOXERS 2

#define BTN_BACKPACK @"backpack"
#define BTN_BOOTS @"boots"
#define BTN_HAT @"hat"
#define BTN_PHONE @"phone"
#define BTN_JACKET @"jacket"
#define BTN_NECKLACE @"necklace"
#define BTN_PANTS @"pants"
#define BTN_SUNGLASSES @"sunglasses"

#define BTN_BACKPACK_NUM 7
#define BTN_BOOTS_NUM 1
#define BTN_HAT_NUM 5
#define BTN_PHONE_NUM 6
#define BTN_JACKET_NUM 3
#define BTN_NECKLACE_NUM 2
#define BTN_PANTS_NUM 0
#define BTN_SUNGLASSES_NUM 4

#define BTN_BACKPACK_SND @"wheel_snd_backpack.m4a"
#define BTN_BOOTS_SND @"wheel_snd_boots.m4a"
#define BTN_HAT_SND @"wheel_snd_hat.m4a"
#define BTN_PHONE_SND @"wheel_snd_phone.m4a"
#define BTN_JACKET_SND @"wheel_snd_jacket.m4a"
#define BTN_NECKLACE_SND @"wheel_snd_necklace.m4a"
#define BTN_PANTS_SND @"wheel_snd_pants.m4a"
#define BTN_SUNGLASSES_SND @"wheel_snd_sunglasses.m4a"

#define BTN_BACKPACK_SND_WHERE @"wheel_snd_backpack_where.m4a"
#define BTN_BOOTS_SND_WHERE @"wheel_snd_boots_where.m4a"
#define BTN_HAT_SND_WHERE @"wheel_snd_hat_where.m4a"
#define BTN_PHONE_SND_WHERE @"wheel_snd_phone_where.m4a"
#define BTN_JACKET_SND_WHERE @"wheel_snd_jacket_where.m4a"
#define BTN_NECKLACE_SND_WHERE @"wheel_snd_necklace_where.m4a"
#define BTN_PANTS_SND_WHERE @"wheel_snd_pants_where.m4a"
#define BTN_SUNGLASSES_SND_WHERE @"wheel_snd_sunglasses_where.m4a"

#define BTN_BACKPACK_SND_WRONG @"wheel_snd_backpack_wrong.m4a"
#define BTN_BOOTS_SND_WRONG @"wheel_snd_boots_wrong.m4a"
#define BTN_HAT_SND_WRONG @"wheel_snd_hat_wrong.m4a"
#define BTN_PHONE_SND_WRONG @"wheel_snd_phone_wrong.m4a"
#define BTN_JACKET_SND_WRONG @"wheel_snd_jacket_wrong.m4a"
#define BTN_NECKLACE_SND_WRONG @"wheel_snd_necklace_wrong.m4a"
#define BTN_PANTS_SND_WRONG @"wheel_snd_pants_wrong.m4a"
#define BTN_SUNGLASSES_SND_WRONG @"wheel_snd_sunglasses_wrong.m4a"

#define BTN_BACKPACK_SPANISH @"Mochila"
#define BTN_BOOTS_SPANISH @"Botas"
#define BTN_HAT_SPANISH @"Sombrero"
#define BTN_PHONE_SPANISH @"Telefono"
#define BTN_JACKET_SPANISH @"Campera"
#define BTN_NECKLACE_SPANISH @"Collar"
#define BTN_PANTS_SPANISH @"Pantalones"
#define BTN_SUNGLASSES_SPANISH @"Anteojos"

@interface GameDressScene_iPad : CCLayer
{
	int bashoSelectedSound;
	GameDress_iPad * viewController;
	NSMutableArray * ddElements;
	NSMutableArray * dressPieces;
	BOOL placingElement;
}

@property (nonatomic,readwrite) BOOL placingElement;

@end
