//
//  StepsViewController.h
//  VITacademics
//
//  Created by Siddharth on 08/12/13.
//  Copyright (c) 2013 Siddharth Gupta. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StepsViewController : UIViewController <NSURLConnectionDelegate, UITextFieldDelegate>

- (IBAction)letsBegin:(id)sender;
-(IBAction)loginWithFacebook:(id)sender;
-(void)extractUserInfo;
- (IBAction)startUsingVITacademics:(id)sender;

@property (weak, nonatomic) IBOutlet UIImageView *sampleProfilePhoto;
@property (strong) NSMutableData *imageData;

-(void)finalSetup;
- (IBAction)skipFacebook:(id)sender;


@property (strong, nonatomic) IBOutlet UIButton *one;
@property (weak, nonatomic) IBOutlet UIButton *two;
@property (weak, nonatomic) IBOutlet UIButton *three;
@property (weak, nonatomic) IBOutlet UIButton *four;
@property (weak, nonatomic) IBOutlet UIButton *five;
@property (weak, nonatomic) IBOutlet UIButton *six;
@property (weak, nonatomic) IBOutlet UIButton *seven;


@property (weak, nonatomic) IBOutlet UIButton *facebookButton;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UILabel *logginInLabel;

@end
