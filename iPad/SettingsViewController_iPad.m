    //
//  SettingsViewController_iPad.m
//  Basho
//
//  Created by Pablo Ruiz on 09/05/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SettingsViewController_iPad.h"
#import "GameManager.h"

@implementation SettingsViewController_iPad

@synthesize closeBtn,rootVC,language,instructionLanguage,fxVolume,musicVolume;

 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
    }
    return self;
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	
	GameManager * gm = [GameManager sharedGameManager];
	[language setSelectedSegmentIndex:gm.language];
	[instructionLanguage setSelectedSegmentIndex:gm.instructionsLanguage];
	[fxVolume setSelectedSegmentIndex:gm.fxVolume];
	[musicVolume setSelectedSegmentIndex:gm.musicVolume];
	
    [super viewDidLoad];
}



-(IBAction) closeView
{
	[rootVC removeSettings];
}


-(IBAction) changeLanguage:(UISegmentedControl *)sender
{
	GameManager * gm = [GameManager sharedGameManager];
	[gm setLanguage:sender.selectedSegmentIndex];
}

-(IBAction) changeinstructionLanguage:(UISegmentedControl *)sender
{
	GameManager * gm = [GameManager sharedGameManager];
	[gm setInstructionsLanguage:sender.selectedSegmentIndex];
}

-(IBAction) changeFxVolume:(UISegmentedControl *)sender
{
	GameManager * gm = [GameManager sharedGameManager];
	[gm setFxVolume:sender.selectedSegmentIndex];
}

-(IBAction) changeMusicVolume:(UISegmentedControl *)sender
{
	GameManager * gm = [GameManager sharedGameManager];
	[gm setMusicVolume:sender.selectedSegmentIndex];
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
	[language release];
	[instructionLanguage release];
	[fxVolume release];
	[musicVolume release];
	[closeBtn release];
    [super dealloc];
}


@end
