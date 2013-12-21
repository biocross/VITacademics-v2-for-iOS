//
//  SettingsViewController.h
//  VITacademics
//
//  Created by Siddharth on 11/12/13.
//  Copyright (c) 2013 Siddharth Gupta. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StepsViewController.h"

@interface SettingsViewController : UITableViewController

@property (weak, nonatomic) IBOutlet UITextField *registrationNumber;
@property (weak, nonatomic) IBOutlet UITextField *dateOfBirth;
- (IBAction)saveButton:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *buttonOutlet;
@property (strong) StepsViewController *sender;

@end
