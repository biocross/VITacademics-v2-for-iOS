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
    
    if(![prefs objectForKey:@"PINObject"]){
        dispatch_queue_t downloadQueue = dispatch_queue_create("attendanceLoader", nil);
        dispatch_async(downloadQueue, ^{
            
            [self getNewPINwithRegistrationNumber:[prefs objectForKey:@"registrationNumber"] andDateOfBirth:[prefs objectForKey:@"dateOfBirth"]];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self initUI];
                
            });
            
        });//end of GCD

    }
    else{
        if([[NSDate date] isEarlierThan:[self formattedExpiryDate]]){
            [self initUI];
        }
        else{
            dispatch_queue_t downloadQueue = dispatch_queue_create("attendanceLoader", nil);
            dispatch_async(downloadQueue, ^{
                
                [self getNewPINwithRegistrationNumber:[prefs objectForKey:@"registrationNumber"] andDateOfBirth:[prefs objectForKey:@"dateOfBirth"]];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self initUI];
                    
                });
                
            });//end of GCD
        }
        
    }
    
}

-(NSDate *)formattedExpiryDate{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSDictionary *PINObject = [prefs objectForKey:@"PINObject"];
    NSDate *expiryDate = [dateFormatter dateFromString:[PINObject valueForKey:@"expiry"]];
    return expiryDate;
}

-(void)initUI{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSDictionary *PINObject = [prefs objectForKey:@"PINObject"];
    self.token.text = [PINObject valueForKey:@"token"];
    self.tokenValidity.text = [NSString stringWithFormat:@"PIN valid until: %1.0f hours", [[self formattedExpiryDate] hoursUntil]];
}
    


-(void)getNewPINwithRegistrationNumber:(NSString *)registrationNumber andDateOfBirth:(NSString *)dateOfBirth{
    NSString *url = [NSString stringWithFormat:@"http://vitacademicstokensystem.appspot.com/getnewtoken/%@/%@", registrationNumber, dateOfBirth];
    NSURL *finalUrl = [NSURL URLWithString:url];
    NSError* error = nil;
    NSString *result = [NSString stringWithContentsOfURL:finalUrl encoding:NSASCIIStringEncoding error:&error];
    
    
    if(!result){
        NSLog(@"Result not Valid [PIN]");
    }
    else{
        NSData *ttDataFromString = [result dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *jsonArray = [NSJSONSerialization JSONObjectWithData: ttDataFromString options: NSJSONReadingMutableContainers error: &error];
        
        if (!jsonArray) {
            NSLog(@"Didnt Recive JSON at PIN");
        }
        else{
            NSLog(@"PIN Object SET");
            NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
            [prefs setObject:jsonArray forKey:@"PINObject"];
        }
    }
    
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
