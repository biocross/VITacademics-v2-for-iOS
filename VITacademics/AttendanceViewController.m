//
//  AttendanceViewController.m
//  VITacademics
//
//  Created by Siddharth on 04/01/14.
//  Copyright (c) 2014 Siddharth Gupta. All rights reserved.
//

#import "AttendanceViewController.h"

@interface AttendanceViewController ()

@end

@implementation AttendanceViewController

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
    
    self.notificationReceived = NO;
    
    if(self.notificationReceived){
        self.notificationLabel.text = @"There's an update available to the app, please update to activate attendance.";
    }
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
