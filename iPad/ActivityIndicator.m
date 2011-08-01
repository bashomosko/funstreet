

//  01/08/2011
//  Basho
//
//  Created by Pablo Ruiz on 12/02/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ActivityIndicator.h"

@implementation ActivityIndicator

@synthesize statusImage,activityImageView,backgroundActivity;


-(void)loadBackground {
    

}

-(void)loadActivityIndicator {
    
    statusImage = [UIImage imageNamed:@"dinoIndicator_1.png"];//01/08/2011
    activityImageView = [[UIImageView alloc]initWithImage:statusImage];//01/08/2011
    
    activityImageView.animationImages = [NSArray arrayWithObjects:[UIImage imageNamed:@"dinoIndicator_1.png"],
                                         [UIImage imageNamed:@"dinoIndicator_2.png"],
                                         [UIImage imageNamed:@"dinoIndicator_3.png"],
                                         [UIImage imageNamed:@"dinoIndicator_4.png"],
                                         [UIImage imageNamed:@"dinoIndicator_5.png"],
                                         [UIImage imageNamed:@"dinoIndicator_6.png"],
                                         [UIImage imageNamed:@"dinoIndicator_7.png"],
                                         [UIImage imageNamed:@"dinoIndicator_8.png"],
                                         [UIImage imageNamed:@"dinoIndicator_9.png"],
                                         [UIImage imageNamed:@"dinoIndicator_10.png"],
                                         [UIImage imageNamed:@"dinoIndicator_11.png"],
                                         [UIImage imageNamed:@"dinoIndicator_12.png"],
                                         [UIImage imageNamed:@"dinoIndicator_13.png"],
                                         [UIImage imageNamed:@"dinoIndicator_14.png"],
                                         [UIImage imageNamed:@"dinoIndicator_15.png"],
                                         [UIImage imageNamed:@"dinoIndicator_16.png"],nil];//01/08/2011
    
    activityImageView.animationDuration = 0.8;//01/08/2011
    
    [activityImageView setHidden:YES];//01/08/2011

}

- (void)dealloc {
	
    [activityImageView release];
    [super dealloc];
}


@end
