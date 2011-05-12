//
//  MainMenu_both.h
//  Basho
//
//  Created by Pablo Ruiz on 12/02/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>

@interface MainMenu_both : UIViewController {
	
	IBOutlet UIButton * btnSong;
	IBOutlet UIButton * btnWheel;
	IBOutlet UIButton * btnDress;
	IBOutlet UIButton * btnVideo;
    IBOutlet UIScrollView * scroll;
    IBOutlet UIImageView * door1;
    IBOutlet UIImageView * door2;
	
	MPMoviePlayerController * introVideo;

}

@property (nonatomic,retain) IBOutlet UIButton * btnSong;
@property (nonatomic,retain) IBOutlet UIButton * btnWheel;
@property (nonatomic,retain) IBOutlet UIButton * btnDress;
@property (nonatomic,retain) IBOutlet UIButton * btnVideo;
@property (nonatomic,retain) IBOutlet UIScrollView * scroll;
@property (nonatomic,retain) IBOutlet UIImageView * door1;
@property (nonatomic,retain) IBOutlet UIImageView * door2;

-(IBAction) goToSong:(id)sender;
-(IBAction) goToWheel:(id)sender;
-(IBAction) goToDress:(id)sender;
-(IBAction) goToVideo:(id)sender;
-(IBAction) goToSettings;

@end
