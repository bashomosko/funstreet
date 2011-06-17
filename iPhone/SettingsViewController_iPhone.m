    //
//  SettingsViewController_iPhone.m
//  Basho
//
//  Created by Pablo Ruiz on 09/05/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SettingsViewController_iPhone.h"

@implementation SettingsViewController_iPhone


 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.

/*- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
       

    }
    return self;
}*/



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    
    language.frame = CGRectMake(language.frame.origin.x, language.frame.origin.y + 10, 150, 25);
    instructionLanguage.frame = CGRectMake(instructionLanguage.frame.origin.x, instructionLanguage.frame.origin.y - 5, 150, 25);
    fxVolume.frame = CGRectMake(fxVolume.frame.origin.x, fxVolume.frame.origin.y - 22, 230, 25);
    musicVolume.frame = CGRectMake(musicVolume.frame.origin.x, musicVolume.frame.origin.y -40, 230, 25);
 
    
    [super viewDidLoad];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Overriden to allow any orientation.
    return YES;
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}


- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end
