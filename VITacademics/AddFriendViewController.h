//
//  AddFriendViewController.h
//  VITacademics
//
//  Created by Siddharth on 20/04/14.
//  Copyright (c) 2014 Siddharth Gupta. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface AddFriendViewController : UIViewController <UITextFieldDelegate>


- (IBAction)addWithPIN:(id)sender;
- (IBAction)addManually:(id)sender;
- (IBAction)scanCode:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *subtitle1;
@property (weak, nonatomic) IBOutlet UITextField *PINTextField;
@property (weak, nonatomic) IBOutlet UITextField *regNoTextField;
@property (weak, nonatomic) IBOutlet UITextField *dobTextField;
@property (weak, nonatomic) IBOutlet UILabel *subtitle2;
- (IBAction)cancelButton:(id)sender;

- (IBAction)addFriendUsingCredentialsPressed:(id)sender;
- (IBAction)addFriendUsingPINpressed:(id)sender;
@end
