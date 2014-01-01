//
//  TabViewController.m
//  VITacademics
//
//  Created by Siddharth on 14/12/13.
//  Copyright (c) 2013 Siddharth Gupta. All rights reserved.
//

#import "TabViewController.h"
#import "RMStepsController.h"

@interface TabViewController ()

@end

@implementation TabViewController

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
    
}

-(void)viewDidAppear:(BOOL)animated{
    NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
    if([preferences objectForKey:@"registrationNumber"]){
    }
    else{
        
        NSLog(@"%@", [preferences objectForKey:@"registrationNumber"]);
        
         RMStepsController *firstStep = [self.storyboard instantiateViewControllerWithIdentifier:@"TutNav"];
        [self presentViewController:firstStep animated:YES completion:nil];
        
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
