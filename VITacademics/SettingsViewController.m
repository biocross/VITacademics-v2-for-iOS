//
//  SettingsViewController.m
//  VITacademics
//
//  Created by Siddharth on 11/12/13.
//  Copyright (c) 2013 Siddharth Gupta. All rights reserved.
//

#import "SettingsViewController.h"
#import "RMStepsController.h"
#import "VITxAPI.h"

@interface SettingsViewController ()

@end

@implementation SettingsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if(self.navigationController){
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:(@selector(cancel))];
    }
    
}

- (void)cancel{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    if(textField == _dateOfBirth){
        CGRect pickerFrame = CGRectMake(0,250,320,216);
        
        self.myPicker = [[UIDatePicker alloc] initWithFrame:pickerFrame];
        self.myPicker.datePickerMode = UIDatePickerModeDate;
        [self.myPicker addTarget:self action:@selector(pickerChanged:) forControlEvents:UIControlEventValueChanged];
        [self.view addSubview:self.myPicker];
        
        _dateOfBirth.inputView = self.myPicker;
    }
}

- (void)pickerChanged:(id)sender
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"ddMMYYYY"];
    _dateOfBirth.text = [dateFormatter stringFromDate:[self.myPicker date]];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    [_dateOfBirth resignFirstResponder];
    return YES;
    
}


- (IBAction)saveButton:(id)sender {
    //Begin Verification:
    VITxAPI *handler = [[VITxAPI alloc] init];

    
    //show progress
    _buttonOutlet.enabled = NO;
    [_buttonOutlet setTitle:@"Verifying..." forState:UIControlStateNormal];
    [_dateOfBirth resignFirstResponder];
    [_registrationNumber resignFirstResponder];
    
    //verify captcha in the background

    dispatch_queue_t downloadQueue = dispatch_queue_create("attendanceLoader", nil);
    dispatch_async(downloadQueue, ^{
        NSString *result = [handler captchaLessTrasactionWith:_registrationNumber.text andDateOfBirth:_dateOfBirth.text];
        dispatch_async(dispatch_get_main_queue(), ^{
            if([result rangeOfString:@"timedout"].location != NSNotFound){
                
                UIAlertView *new = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Please double check your credentials and try again" delegate:self cancelButtonTitle:@"Okay" otherButtonTitles: nil];
                [new show];
                
                _buttonOutlet.enabled = YES;
                [_buttonOutlet setTitle:@"Sign In (Again)" forState:UIControlStateNormal];
            }
            else if([result rangeOfString:@"captchaerror"].location != NSNotFound){
               //CaptchaError
                _buttonOutlet.enabled = YES;
                [_buttonOutlet setTitle:@"Sign In (Again)" forState:UIControlStateNormal];
                UIAlertView *new = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Please double check your credentials and try again" delegate:self cancelButtonTitle:@"Okay" otherButtonTitles: nil];
                [new show];
            }
            else if([result rangeOfString:@"success"].location != NSNotFound){
                NSLog(@"We're In!");
                [self successHappened];
                
    
            }
            else if([result isEqualToString:@"networkerror"]){
                //Network Error
                UIAlertView *new = [[UIAlertView alloc] initWithTitle:@"Network Error" message:@"Pleas make sure your internet is working and try again" delegate:self cancelButtonTitle:@"Okay" otherButtonTitles: nil];
                [new show];
                
                _buttonOutlet.enabled = YES;
                [_buttonOutlet setTitle:@"Sign In (Again)" forState:UIControlStateNormal];
            }
            
        });
    });//end of GCD
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(void)successHappened{
    NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];

    [preferences removeObjectForKey:@"registrationNumber"];
    [preferences removeObjectForKey:@"dateOfBirth"];
    [preferences setObject:_registrationNumber.text forKey:@"registrationNumber"];
    [preferences setObject:_dateOfBirth.text forKey:@"dateOfBirth"];
    
    [_buttonOutlet setTitle:@"Just one sec!" forState:UIControlStateNormal];
    
    
    
    PFQuery *query = [PFUser query];
    [query whereKey:@"username" equalTo:_registrationNumber.text];
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        if (!object) {
            NSLog(@"User does not already exist!.");
            PFUser *user = [PFUser user];
            user.username = _registrationNumber.text;
            user.password = _dateOfBirth.text;
            user[@"registrationNumber"] = _registrationNumber.text;
            user[@"dateOfBirth"] = _dateOfBirth.text;
            user[@"isSignedIn"] = @"false";
            user[@"platform"] = @"iOS";
            
            [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (!error) {
                    // Hooray! Let them use the app now.
                    [_buttonOutlet setTitle:@"Verified." forState:UIControlStateNormal];
                    
                    [PFUser logInWithUsernameInBackground:_registrationNumber.text password:_dateOfBirth.text
                                                    block:^(PFUser *user, NSError *error) {
                                                        if (user) {
                                                            // Do stuff after successful login.
                                                            NSLog(@"Login Complete");
                                                            [self.stepsController showNextStep];
                                                            [self.sender finalSetup];
                                                        } else {
                                                            // The login failed. Check error to see why.
                                                        }
                                                    }];
                    
                    
                    
                } else {
                    NSString *errorString = [error userInfo][@"error"];
                    NSLog(@"%@", errorString);
                    NSLog(@"some shit happened here");
                    // Show the errorString somewhere and let the user try again.
                    
                }
            }];
            
        } else {
            // The find succeeded.
            [PFUser logInWithUsernameInBackground:_registrationNumber.text password:_dateOfBirth.text block:^(PFUser *user, NSError *error) {
                if(user){
                    [user deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                        if(succeeded){
                            NSLog(@"user logged in and deleted");
                            PFUser *user = [PFUser user];
                            user.username = _registrationNumber.text;
                            user.password = _dateOfBirth.text;
                            user[@"registrationNumber"] = _registrationNumber.text;
                            user[@"dateOfBirth"] = _dateOfBirth.text;
                            user[@"isSignedIn"] = @"false";
                            user[@"platform"] = @"iOS";
                            
                            [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                                if (!error) {
                                    // Hooray! Let them use the app now.
                                    [_buttonOutlet setTitle:@"Verified." forState:UIControlStateNormal];
                                    [PFUser logInWithUsernameInBackground:_registrationNumber.text password:_dateOfBirth.text
                                                                    block:^(PFUser *user, NSError *error) {
                                                                        if (user) {
                                                                            // Do stuff after successful login.
                                                                            NSLog(@"Login Complete");
                                                                            [self.stepsController showNextStep];
                                                                            [self.sender finalSetup];
                                                                        } else {
                                                                        }
                                                                    }];
                                    
                                } else {
                                    NSString *errorString = [error userInfo][@"error"];
                                    NSLog(@"%@", errorString);
                                    
                                }
                            }];
                        }
                        else{
                            NSLog(@"could not delete user");
                        }
                    }];
                }
                else{
                    NSLog(@"Could not login user");
                }
            }];
        }
    }];
}


@end
