//
//  CaptchaViewController.h
//  VITacademics
//
//  Created by Siddharth on 31/01/14.
//  Copyright (c) 2014 Siddharth Gupta. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CaptchaViewController : UITableViewController <UITextFieldDelegate>


- (IBAction)cancelrefresh:(id)sender;
- (IBAction)verifyCaptcha:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *captchaImage;
@property (weak, nonatomic) IBOutlet UITextField *captchaText;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *progressDot;

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end
