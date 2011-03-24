//
//  GameVideo_iPad.h
//  Basho
//
//  Created by Pablo Ruiz on 24/03/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>

@interface GameVideo_iPad : UIViewController {
	UILabel * lyrics;
	NSMutableArray * lyricLines;
	int currentLyricLine;
	MPMoviePlayerController * video;
}

@end
