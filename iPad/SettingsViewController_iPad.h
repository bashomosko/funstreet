//
//  SettingsViewController_iPad.h
//  Basho
//
//  Created by Pablo Ruiz on 09/05/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SettingsViewController_iPad : UIViewController {

	IBOutlet UIButton * closeBtn;
	UIViewController * rootVC;
	IBOutlet UISegmentedControl * language;
}


@property (nonatomic,assign) UIViewController * rootVC;
@property (nonatomic,retain)IBOutlet UIButton * closeBtn;
@property (nonatomic,retain)IBOutlet UISegmentedControl * language;

-(IBAction) closeView;
-(IBAction) changeLanguage:(UISegmentedControl *)sender;

@end
