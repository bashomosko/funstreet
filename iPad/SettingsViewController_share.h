//
//  SettingsViewController_iPad.h
//  Basho
//
//  Created by Pablo Ruiz on 09/05/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SettingsViewController_share : UIViewController {

	IBOutlet UIButton * closeBtn;
	UIViewController * rootVC;
	IBOutlet UISegmentedControl * language;
	IBOutlet UISegmentedControl * instructionLanguage;
	IBOutlet UISegmentedControl * fxVolume;
	IBOutlet UISegmentedControl * musicVolume;
    int originalLanguageSelected;
}


@property (nonatomic,assign) UIViewController * rootVC;
@property (nonatomic,retain)IBOutlet UIButton * closeBtn;
@property (nonatomic,retain)IBOutlet UISegmentedControl * language;
@property (nonatomic,retain)IBOutlet UISegmentedControl * instructionLanguage;
@property (nonatomic,retain)IBOutlet UISegmentedControl * fxVolume;
@property (nonatomic,retain)IBOutlet UISegmentedControl * musicVolume;

-(IBAction) closeView;
-(IBAction) changeLanguage:(UISegmentedControl *)sender;
-(IBAction) changeinstructionLanguage:(UISegmentedControl *)sender;
-(IBAction) changeFxVolume:(UISegmentedControl *)sender;
-(IBAction) changeMusicVolume:(UISegmentedControl *)sender;

@end
