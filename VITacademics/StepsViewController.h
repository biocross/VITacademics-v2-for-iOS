//
//  StepsViewController.h
//  VITacademics
//
//  Created by Siddharth on 08/12/13.
//  Copyright (c) 2013 Siddharth Gupta. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StepsViewController : UIViewController <NSURLConnectionDelegate, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIView *progressFrame;
- (IBAction)letsBegin:(id)sender;
- (IBAction)startUsingVITacademics:(id)sender;

-(void)finalSetup;

@property (weak, nonatomic) IBOutlet UIImageView *startingImage;


@property (strong, nonatomic) IBOutlet UIButton *one;
@property (weak, nonatomic) IBOutlet UIButton *two;
@property (weak, nonatomic) IBOutlet UIButton *three;
@property (weak, nonatomic) IBOutlet UIButton *four;
@property (weak, nonatomic) IBOutlet UIButton *five;
@property (weak, nonatomic) IBOutlet UIButton *six;
@property (weak, nonatomic) IBOutlet UIButton *seven;

@end
