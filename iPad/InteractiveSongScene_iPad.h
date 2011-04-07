//
//  InteractiveSongScene_iPad.h
//  Basho
//
//  Created by Pablo Ruiz on 28/03/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import <MediaPlayer/MediaPlayer.h>
#import "InteractiveSong_iPad.h"

@class InteractiveSong_iPad;

@interface InteractiveSongScene_iPad : CCLayer {

	InteractiveSong_iPad * viewController;
	NSMutableArray * iElements;
	
	int currentElem;
	
	int points;
	
	MPMoviePlayerController * introVideo;
	MPMoviePlayerController * finishVideo;
	
	CCLabelBMFont * lyrics;
	NSMutableArray * lyricLines;
	int currentLyricLine;
}

@end
