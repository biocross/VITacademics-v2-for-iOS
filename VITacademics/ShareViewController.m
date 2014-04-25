//
//  ShareViewController.m
//  VITacademics
//
//  Created by Siddharth on 02/02/14.
//  Copyright (c) 2014 Siddharth Gupta. All rights reserved.
//

#import "ShareViewController.h"

@interface ShareViewController ()

@end

@implementation ShareViewController

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
    
    UIFont *PINFont = [UIFont fontWithName:@"MuseoSans-300" size:27];
    [_token setFont:PINFont];
    
    UIFont *subtitleFont = [UIFont fontWithName:@"MuseoSans-300" size:12];
    [_subtitle1 setFont:subtitleFont];
    [_subtitle2 setFont:subtitleFont];
    [_subtitle3 setFont:subtitleFont];
    [_tokenValidity setFont:subtitleFont];
    
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    if(![prefs stringForKey:@"currentPIN"]){
        
    }
    else{
        [self initUI];
    }
    
}

-(void)initUI{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    self.token.text = [prefs stringForKey:@"currentPIN"];
}
    


-(NSString *)getNewPINwithRegistrationNumber:(NSString *)registrationNumber andDateOfBirth:(NSString *)dateOfBirth{
    NSString *url = [NSString stringWithFormat:@"http://vitacademicstokensystem.appspot.com/getnewtoken/%@/%@", registrationNumber, dateOfBirth];
    NSURL *finalUrl = [NSURL URLWithString:url];
    NSError* error = nil;
    NSString *result = [NSString stringWithContentsOfURL:finalUrl encoding:NSASCIIStringEncoding error:&error];
    
    if(!result){
        return nil;
    }
    else{
        NSData *ttDataFromString = [result dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *jsonArray = [NSJSONSerialization JSONObjectWithData: ttDataFromString options: NSJSONReadingMutableContainers error: &error];
        
        if (!jsonArray) {
            NSLog(@"Didnt Recive JSON at PIN");
        }
        else{
            NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
            [prefs setObject:[jsonArray valueForKey:@"token"] forKey:@"currentPIN"];
            [prefs setObject:[jsonArray valueForKey:@"expiry"] forKey:@"PINExpiry"];
        }
    }
    
    return result;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)cancelButtonPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)addWithPINpressed:(id)sender {
}

- (IBAction)addManuallyPressed:(id)sender {
}

- (IBAction)cancelButton:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
