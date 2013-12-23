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
    
    NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
    
    if([preferences stringForKey:@"dateOfBirth"]){
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"ddMMYYYY"];;
        NSDate *anyDate = [dateFormat dateFromString:[preferences stringForKey:@"dateOfBirth"]];
        @try{
            [self.myPicker setDate:anyDate];
        }
        @catch (NSException *exception) {
            NSLog(@"%@", [exception description]);
        }
    }

    
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
    NSLog(@"value: %@",[sender date]);
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"ddMMYYYY"];
    _dateOfBirth.text = [dateFormatter stringFromDate:[self.myPicker date]];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
    
}


- (IBAction)saveButton:(id)sender {
    
    [_registrationNumber resignFirstResponder];
    [_dateOfBirth resignFirstResponder];
    
    //Begin Verification:
    VITxAPI *handler = [[VITxAPI alloc] init];
    NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];

    
    //show progress
    _buttonOutlet.enabled = NO;
    [_buttonOutlet setTitle:@"Verifying..." forState:UIControlStateNormal];
    
    
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
                [preferences removeObjectForKey:@"registrationNumber"];
                [preferences removeObjectForKey:@"dateOfBirth"];
                [preferences setObject:_registrationNumber.text forKey:@"registrationNumber"];
                [preferences setObject:_dateOfBirth.text forKey:@"dateOfBirth"];
                
                [_buttonOutlet setTitle:@"Successfully Verified" forState:UIControlStateNormal];
                
                [self.stepsController showNextStep];
                [self.sender finalSetup];
                
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


@end
