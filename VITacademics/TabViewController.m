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
    
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
        if([preferences objectForKey:@"registrationNumber"]){
            //[self setSelectedIndex:2];
            
        }
        else{
            RMStepsController *firstStep = [self.storyboard instantiateViewControllerWithIdentifier:@"TutNav"];
            firstStep.modalPresentationStyle = UIModalPresentationFormSheet;
            [self presentViewController:firstStep animated:YES completion:nil];
            
        }
    });
    
    
    
}

-(void)viewDidAppear:(BOOL)animated{
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
