//
//  GameVideo_both.h
//  Basho
//
//  Created by Pablo Ruiz on 24/03/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>

@interface GameVideo_both : UIViewController {

	MPMoviePlayerController * video;
	
	IBOutlet UIImageView * curtainL;
	IBOutlet UIImageView * curtainR;
	IBOutlet UIScrollView *scrollview;
	IBOutlet UIPageControl * scrollPaging;
    
    float widthVideo;
    float heightVideo;
    float widthScroll;
    float heightScroll;
    
}

@property (nonatomic,retain) IBOutlet UIImageView * curtainL;
@property (nonatomic,retain)IBOutlet UIImageView * curtainR;
@property (nonatomic,retain) IBOutlet UIScrollView *scrollview;
@property (nonatomic,retain)IBOutlet UIPageControl * scrollPaging;
@property (nonatomic,readwrite) float widthVideo;
@property (nonatomic,readwrite) float heightVideo;
@property (nonatomic,readwrite) float widthScroll;
@property (nonatomic,readwrite) float heightScroll;

-(void)playVid:(int)videoNumber;

@end
