//
//  StepsViewController.m
//  VITacademics
//
//  Created by Siddharth on 08/12/13.
//  Copyright (c) 2013 Siddharth Gupta. All rights reserved.
//

#import "StepsViewController.h"
#import "RMStepsController.h"
#import <Parse/Parse.h>
#import "PulsingHaloLayer.h"
#import "VITxAPI.h"

@interface StepsViewController ()

@end

@implementation StepsViewController

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
    PulsingHaloLayer *halo = [PulsingHaloLayer layer];
    halo.position = self.sampleProfilePhoto.center;
    [self.view.layer insertSublayer:halo below:self.sampleProfilePhoto.layer];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)letsBegin:(id)sender {
    [self.stepsController showNextStep];
    
}

-(IBAction)loginWithFacebook:(id)sender{
    
    NSArray *permissionsArray = @[ @"user_about_me", @"email"];
    [_activityIndicator startAnimating];
    [_logginInLabel setAlpha:1];
    // Login PFUser using Facebook
    [PFFacebookUtils logInWithPermissions:permissionsArray block:^(PFUser *user, NSError *error) {
        
        if (!user) {
            if (!error) {
                NSLog(@"Uh oh. The user cancelled the Facebook login.");
            } else {
                NSLog(@"Uh oh. An error occurred: %@", error);
            }
        } else if (user.isNew) {
            NSLog(@"User with facebook signed up and logged in!");
            [self extractUserInfo];
            
            
        } else {
            NSLog(@"User with facebook logged in!");
            [self extractUserInfo];
            
        }
    }];
    
}

-(void)extractUserInfo{
    FBRequest *request = [FBRequest requestForMe];
    
    // Send request to Facebook
    [request startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        if (!error) {
            // result is a dictionary with the user's Facebook data
            NSDictionary *userData = (NSDictionary *)result;
            
            NSString *facebookID = userData[@"id"];
            NSString *name = userData[@"name"];
            
            NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
            
            [preferences removeObjectForKey:@"facebookID"];
            [preferences removeObjectForKey:@"facebookName"];
            [preferences setObject:facebookID forKey:@"facebookID"];
            [preferences setObject:name forKey:@"facebookName"];
            
            
            // Download the user's facebook profile picture
            self.imageData = [[NSMutableData alloc] init]; // the data will be loaded in here
            
            // URL should point to https://graph.facebook.com/{facebookId}/picture?type=large&return_ssl_resources=1
            NSURL *pictureURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large&return_ssl_resources=1", facebookID]];
            
            NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:pictureURL
                                                                      cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                                  timeoutInterval:2.0f];
            // Run network request asynchronously
            NSURLConnection *urlConnection = [[NSURLConnection alloc] initWithRequest:urlRequest delegate:self];
            [urlConnection start];
            
            [_logginInLabel setText:@"Done!"];
            [_activityIndicator stopAnimating];
            
            [self.stepsController showNextStep];
            
            
        }
    }];
    
    
}

- (IBAction)startUsingVITacademics:(id)sender {
    [self.stepsController finishedAllSteps];
}

// Called every time a chunk of the data is received
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [self.imageData appendData:data]; // Build the image
}

// Called when the entire image is finished downloading
- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    // Set the image in the header imageView
    self.sampleProfilePhoto.image = [UIImage imageWithData:self.imageData];
}


-(void)finalSetup{
    
    VITxAPI *attendanceManager = [[VITxAPI alloc] init];
    NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
    NSString *registrationNumber = [preferences objectForKey:@"registrationNumber"];
    NSString *dateOfBirth = [preferences objectForKey:@"dateOfBirth"];
    NSString *name = [preferences objectForKey:@"facebookName"];
    
    //Contacting Backend
    PFUser *currentUser = [PFUser currentUser];
    if (currentUser) {
            currentUser[@"facebookName"] = name;
            currentUser[@"registrationNumber"] = registrationNumber;
            currentUser[@"dateOfBirth"] = dateOfBirth;
            [currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if(succeeded){
                    NSLog(@"Saved credentials to currentUser");
                    self.one.enabled = NO;
                }
                else{
                    NSLog(@"There was a problem saving to current user");
                    [self.one setTitle:@"Error saving to backend, Nevermind." forState:UIControlStateNormal];
                }
            }];
        }
    else {
        // show the signup or login screen
        NSLog(@"An error has occured while querying the current user, did you log in?");
        [self.one setTitle:@"You didn't login with facebook." forState:UIControlStateNormal];
        self.one.enabled = NO;
    }
    
    //Saving Data
    self.two.enabled = NO;
    
    
    //Loading Attendance
    dispatch_queue_t downloadQueue = dispatch_queue_create("attendanceLoader", nil);
    dispatch_async(downloadQueue, ^{
        NSString *result = [attendanceManager loadAttendanceWithRegistrationNumber:registrationNumber andDateOfBirth:dateOfBirth];
        NSString *marks = [attendanceManager loadMarksWithRegistrationNumber:registrationNumber andDateOfBirth:dateOfBirth];
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [preferences removeObjectForKey:[preferences objectForKey:@"registrationNumber"]];
            [preferences setObject:result forKey:[preferences objectForKey:@"registrationNumber"]];
            NSString *marksKey = [NSString stringWithFormat:@"MarksOf%@", [preferences objectForKey:@"registrationNumber"]];
            [preferences removeObjectForKey:marksKey];
            [preferences setObject:marks forKey:marksKey];
            NSDate *date = [[NSDate alloc] init];
            [preferences setObject:date forKey:@"lastUpdated"];
            
            self.three.enabled = NO;
        });
        
    });//end of GCD
    
    
    //Loading Marks
    self.four.enabled = NO;
    
    //Loading Time Table
    dispatch_queue_t secondQueue = dispatch_queue_create("attendanceLoader", nil);
    dispatch_async(secondQueue, ^{
        NSString *timetable = [attendanceManager loadTimeTableWithRegistrationNumber:registrationNumber andDateOfBirth:dateOfBirth];
        dispatch_async(dispatch_get_main_queue(), ^{
            
            NSString *ttKey = [NSString stringWithFormat:@"TTOf%@", [preferences objectForKey:@"registrationNumber"]];
            [preferences removeObjectForKey:ttKey];
            [preferences setObject:timetable forKey:ttKey];
            
            self.five.enabled = NO;
            currentUser[@"timeTable"] = timetable;
            [currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if(succeeded){
                    NSLog(@"Saved timetable to server!");
                    self.six.enabled = NO;
                    self.seven.enabled = YES;
                }
                else{
                    NSLog(@"Problem saving timetable to server");
                    NSLog(@"%@", [error localizedDescription]);
                    self.six.enabled = NO;
                    self.seven.enabled = YES;
                }
            }];
            
            
            
        });
        
    });//end of GCD
    
    
    //Parsing Data (Verificastion!)
    
    
    
    //All done
    
    
}




@end
