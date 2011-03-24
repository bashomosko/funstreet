//
//  GameVideo.h
//  Basho
//
//  Created by Pablo Ruiz on 07/03/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>

@interface GameVideo : UIViewController {
	UILabel * lyrics;
	NSMutableArray * lyricLines;
	int currentLyricLine;
	MPMoviePlayerController * video;
}

@end