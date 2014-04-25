//
//  FacebookViewController.h
//  VITacademics
//
//  Created by Siddharth on 24/04/14.
//  Copyright (c) 2014 Siddharth Gupta. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FacebookViewController : UIViewController

- (IBAction)loginWithFacebook:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *subtitle;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UILabel *loadingLabel;
@property (weak, nonatomic) IBOutlet UIImageView *profilePhoto;
@property NSMutableData* imageData;

- (IBAction)cancelButton:(id)sender;

@end
