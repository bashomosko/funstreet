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

	MPMoviePlayerController * video;
	
	IBOutlet UIImageView * curtainL;
	IBOutlet UIImageView * curtainR;
}

@property (nonatomic,retain) IBOutlet UIImageView * curtainL;
@property (nonatomic,retain)IBOutlet UIImageView * curtainR;

@end
