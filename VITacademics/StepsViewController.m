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
    //halo.position = CGPointMake(35, 31);
    //halo.position = CGPointMake(self.startingImage.frame.origin.x + 35, self.startingImage.frame.origin.y + 31);
    halo.position = CGPointMake(self.view.center.x, self.view.frame.size.height);
    halo.radius = 120;
    [self.view.layer addSublayer:halo];
    
    
    //self.seven.textColor = [UIColor colorWithRed:0.21 green:0.72 blue:0.00 alpha:1.0];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)letsBegin:(id)sender {
    [self.stepsController showNextStep];
    
}

- (IBAction)startUsingVITacademics:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadTimeTable" object:nil];
    [self.stepsController finishedAllSteps];
    
}

// Called every time a chunk of the data is received



-(void)finalSetup{
    
    //[self.activityIndicator startAnimating];
        
    VITxAPI *attendanceManager = [[VITxAPI alloc] init];
    NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
    NSString *registrationNumber = [preferences objectForKey:@"registrationNumber"];
    NSString *dateOfBirth = [preferences objectForKey:@"dateOfBirth"];
    
    
    //Contacting Backend
    PFUser *currentUser = [PFUser currentUser];
    
    self.one.enabled = NO;
    //Saving Data
    self.two.enabled = NO;
    
    
    //Loading Attendance
    dispatch_queue_t downloadQueue = dispatch_queue_create("attendanceLoader", nil);
    dispatch_async(downloadQueue, ^{
        NSString *result = [attendanceManager loadAttendanceWithRegistrationNumber:registrationNumber andDateOfBirth:dateOfBirth];
        NSString *marks = [attendanceManager loadMarksWithRegistrationNumber:registrationNumber andDateOfBirth:dateOfBirth];
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"%@", result);
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
    
    //Creating Binding on Parse
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
                    NSLog(@"Finished Everything");
                    //[self.activityIndicator stopAnimating];
                    /*UIImageView *icon = [[UIImageView alloc] initWithFrame:self.activityIndicator.frame];
                    [icon setImage:[UIImage imageNamed:@"loadingImage.png"]];
                    [self.view addSubview:icon];*/
                    NSLog(@"added image");
                    [[DataManager sharedManager] initializeDataSources];
                }
                else{
                    NSLog(@"Problem saving timetable to server");
                    NSLog(@"%@", [error localizedDescription]);
                    self.six.enabled = NO;
                    self.seven.enabled = YES;
                    
                    [[DataManager sharedManager] initializeDataSources];
                }
            }];
            
            
            
        });
        
    });//end of GCD
    
    
    //Parsing Data (Verification!)
    
    
    
    //All done
    
    
}

- (IBAction)skipFacebook:(id)sender {
    [self.stepsController showNextStep];
    [self finalSetup];
}




@end
