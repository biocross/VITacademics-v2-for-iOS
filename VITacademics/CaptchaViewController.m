//
//  CaptchaViewController.m
//  VITacademics
//
//  Created by Siddharth on 31/01/14.
//  Copyright (c) 2014 Siddharth Gupta. All rights reserved.
//

#import "CaptchaViewController.h"
#import "VITxAPI.h"

@interface CaptchaViewController ()

@end

@implementation CaptchaViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _captchaText.returnKeyType = UIReturnKeyGo;
    _captchaText.delegate = self;
    [self startLoadingCaptcha];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)startLoadingCaptcha{
    [_progressDot startAnimating];
    VITxAPI *handler = [[VITxAPI alloc] init];
    dispatch_queue_t downloadQueue = dispatch_queue_create("captcha", nil);
    dispatch_async(downloadQueue, ^{
        UIImage *img = [handler loadCaptchaIntoImageView];
        dispatch_async(dispatch_get_main_queue(), ^{
            [_captchaImage setImage:img];
            [_progressDot stopAnimating];
            [_progressDot setAlpha:0];
            [_captchaText becomeFirstResponder];
        });
    });//end of GCD
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(indexPath.row == 2){

            [_captchaText resignFirstResponder];
            
            if([_captchaText.text length] == 6){
                [self beginCaptchaVerification];
            }
            else{
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Oops" message:@"Please enter exactly 6 characters" delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil, nil];
                [alert show];
                [_captchaImage becomeFirstResponder];
            }
            
        
    }
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}


- (BOOL)textFieldShouldReturn:(UITextField *)captchaText {
    
    if (_captchaText == self.captchaText) {
        [_captchaText resignFirstResponder];
        
        if([_captchaText.text length] == 6){
            [self beginCaptchaVerification];
        }
        else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Oops" message:@"Please enter exactly 6 characters" delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil, nil];
            [alert show];
            [_captchaImage becomeFirstResponder];
        }
        
    }
    return YES;
}

- (IBAction)cancelrefresh:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
    //[self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)beginCaptchaVerification{
    
    VITxAPI *handler = [[VITxAPI alloc] init];
    
    NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
    NSString *registrationNumber = [preferences objectForKey:@"registrationNumber"];
    NSString *dateOfBirth = [preferences objectForKey:@"dateOfBirth"];
    
    //show progress
    
    
    double delayInSeconds = 0.05f;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        
        [MWKProgressIndicator updateMessage:@"Submitting Captcha..."];
        [MWKProgressIndicator show];
    });
    
    
    
    //verify captcha in the background
    dispatch_queue_t downloadQueue = dispatch_queue_create("attendanceLoader", nil);
    dispatch_async(downloadQueue, ^{
        NSString *result = [handler verifyCaptchaWithRegistrationNumber:registrationNumber andDateOfBirth:dateOfBirth andCaptcha:_captchaText.text];
        dispatch_async(dispatch_get_main_queue(), ^{
            [MWKProgressIndicator dismiss];
            
            if([result rangeOfString:@"timedout"].location != NSNotFound){
                
                NSString *notificationName = @"captchaError";
                [[NSNotificationCenter defaultCenter] postNotificationName:notificationName object:nil userInfo:nil];
            }
            else if([result rangeOfString:@"captchaerror"].location != NSNotFound){
                NSString *notificationName = @"captchaError";
                [[NSNotificationCenter defaultCenter] postNotificationName:notificationName object:nil userInfo:nil];
            }
            else if([result rangeOfString:@"success"].location != NSNotFound){
                NSLog(@"We're In!");
                NSString *notificationName = @"captchaDidVerify";
                [[NSNotificationCenter defaultCenter] postNotificationName:notificationName object:nil userInfo:nil];
            }
            else if([result isEqualToString:@"networkerror"]){
                [[NSNotificationCenter defaultCenter] postNotificationName:@"networkError" object:nil userInfo:nil];
            }
            [self.navigationController popViewControllerAnimated:YES];
            
        });
    });//end of GCD
}

- (IBAction)verifyCaptcha:(id)sender {
    if (_captchaText == self.captchaText) {
        [_captchaText resignFirstResponder];
        
        if([_captchaText.text length] == 6){
            [self beginCaptchaVerification];
        }
        else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Oops" message:@"Please enter exactly 6 characters" delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil];
            [alert show];
            [_captchaImage becomeFirstResponder];
        }
        
    }
}

@end
