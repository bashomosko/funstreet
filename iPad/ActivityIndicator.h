//
//  01/08/2011
//  Basho
//
//  Created by Pablo Ruiz on 12/02/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ActivityIndicator : NSObject {
    UIImage * statusImage;//01/08/2011
    UIImageView * activityImageView;//01/08/2011
    UIImageView * backgroundActivity;//01/08/2011
}

@property (nonatomic,retain) UIImage * statusImage;//01/08/2011
@property (nonatomic,retain) UIImageView * activityImageView;//01/08/2011
@property (nonatomic,retain) UIImageView * backgroundActivity;

-(void)loadActivityIndicator;//01/08/2011
-(void)loadBackground;//01/08/2011

@end

