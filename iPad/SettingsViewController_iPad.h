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
}


@property (nonatomic,retain) UIViewController * rootVC;
@property (nonatomic,retain)IBOutlet UIButton * closeBtn;

-(IBAction) closeView;

@end
