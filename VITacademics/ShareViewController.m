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
@end
