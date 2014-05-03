//
//  AddFriendViewController.m
//  VITacademics
//
//  Created by Siddharth on 20/04/14.
//  Copyright (c) 2014 Siddharth Gupta. All rights reserved.
//

#import "AddFriendViewController.h"
#import "CDZQRScanningViewController.h"
#import "VITxAPI.h"
#import "Friend+Operations.h"

@interface AddFriendViewController ()

@end

@implementation AddFriendViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIFont *subtitleFont = [UIFont fontWithName:@"MuseoSans-300" size:12];
    [_subtitle1 setFont:subtitleFont];
    [_subtitle2 setFont:subtitleFont];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)addWithPIN:(id)sender {
    
}

- (IBAction)addManually:(id)sender {
    
}

-(void)getCredentialsFromPIN:(NSString *)PIN{
    [MWKProgressIndicator updateMessage:@"Verifying PIN..."];
    [MWKProgressIndicator show];
    dispatch_queue_t downloadQueue = dispatch_queue_create("attendanceLoader", nil);
    dispatch_async(downloadQueue, ^{
        
        NSString *url = [NSString stringWithFormat:@"http://vitacademicstokensystem.appspot.com/accesstoken/%@", PIN];
        NSURL *finalUrl = [NSURL URLWithString:url];
        NSError* error = nil;
        NSString *result = [NSString stringWithContentsOfURL:finalUrl encoding:NSASCIIStringEncoding error:&error];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if(!result){
                NSLog(@"Result not Valid [Creds from PIN]");
            }
            else{
                NSError* error2 = nil;
                NSData *ttDataFromString = [result dataUsingEncoding:NSUTF8StringEncoding];
                NSDictionary *jsonArray = [NSJSONSerialization JSONObjectWithData: ttDataFromString options: NSJSONReadingMutableContainers error: &error2];
                
                if (!jsonArray) {
                    NSLog(@"Didnt Recive JSON at CredsFromPIN");
                }
                else{
                    NSLog(@"Got Creds");
                    [MWKProgressIndicator dismiss];
                    
                    if([[jsonArray valueForKey:@"status"] isEqualToString:@"success"]){
                       [self addFriendwithRegistrationNumber:[jsonArray valueForKey:@"regno"] andDateOfBirth:[jsonArray valueForKey:@"dob"]];
                    }
                    else{
                        [MWKProgressIndicator showErrorMessage:@"Invalid PIN!"];
                    }
                }
            }
        });
        
    });//end of GCD
}

-(void)addFriendwithRegistrationNumber:(NSString *)registrationNumber andDateOfBirth:(NSString *)dateOfBirth{
    VITxAPI *handler = [[VITxAPI alloc] init];
    DataManager *sharedManager = [DataManager sharedManager];
    
    [MWKProgressIndicator updateMessage:@"Loading Friend's TT"];
    [MWKProgressIndicator show];
    
    dispatch_queue_t downloadQueue = dispatch_queue_create("attendanceLoader", nil);
    dispatch_async(downloadQueue, ^{
        NSString *timeTable = [handler loadTimeTableWithRegistrationNumber:registrationNumber andDateOfBirth:dateOfBirth];
        dispatch_async(dispatch_get_main_queue(), ^{
            [MWKProgressIndicator dismiss];
            if(timeTable){
                [Friend insertFriendWithName:registrationNumber withTimetable:timeTable withPicture:nil withFacebookID:@"sample" withRegistrationNumber:registrationNumber withDateOfBirth:dateOfBirth WithContext:sharedManager.context];
                [MWKProgressIndicator showSuccessMessage:@"Friend Added!"];
            }
            else{
                [MWKProgressIndicator showErrorMessage:@"Error adding friend"];
            }
        });
        
    });//end of GCD

}


- (IBAction)scanCode:(id)sender {
    CDZQRScanningViewController *scanningVC = [CDZQRScanningViewController new];
    UINavigationController *scanningNavVC = [[UINavigationController alloc] initWithRootViewController:scanningVC];
    // configure the scanning view controller:
    scanningVC.resultBlock = ^(NSString *result) {
        NSLog(@"Scanned: %@", result);
        [self getCredentialsFromPIN:result];
        [scanningNavVC dismissViewControllerAnimated:YES completion:nil];
    };
    scanningVC.cancelBlock = ^() {
        [scanningNavVC dismissViewControllerAnimated:YES completion:nil];
    };
    scanningVC.errorBlock = ^(NSError *error) {
        // todo: show a UIAlertView orNSLog the error
        [scanningNavVC dismissViewControllerAnimated:YES completion:nil];
    };
    
    scanningNavVC.modalPresentationStyle = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ? UIModalPresentationFullScreen : UIModalPresentationFormSheet;
    [self presentViewController:scanningNavVC animated:YES completion:nil];
}

- (IBAction)cancelButton:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)addFriendUsingCredentialsPressed:(id)sender {
    if([_regNoTextField.text length] > 7){
        if([_dobTextField.text length] == 8){
            [self addFriendwithRegistrationNumber:_regNoTextField.text andDateOfBirth:_dobTextField.text];
            [self.navigationController popViewControllerAnimated:YES];
        }
        else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Please check the credentials you have entered" delegate:self cancelButtonTitle:@"Okay" otherButtonTitles: nil];
            [alert show];
        }
    }
    else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Please check the credentials you have entered" delegate:self cancelButtonTitle:@"Okay" otherButtonTitles: nil];
        [alert show];
    }
}

- (IBAction)addFriendUsingPINpressed:(id)sender {
    if(_PINTextField.text){
        [self getCredentialsFromPIN:_PINTextField.text];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
@end
