//
//  InitView.m
//  VITacademics
//
//  Created by Siddharth on 08/12/13.
//  Copyright (c) 2013 Siddharth Gupta. All rights reserved.
//

#import "InitView.h"
#import "SettingsViewController.h"

@interface InitView ()

@end

@implementation InitView

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
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark RMStepMethods

- (NSArray *)stepViewControllers {
    UIViewController *firstStep = [self.storyboard instantiateViewControllerWithIdentifier:@"TutFirst"];
    firstStep.step.title = @"Welcome";
    
    SettingsViewController *secondStep = [self.storyboard instantiateViewControllerWithIdentifier:@"TutThird"];
    secondStep.step.title = @"Credentials";
    
    UIViewController *thirdStep = [self.storyboard instantiateViewControllerWithIdentifier:@"TutSecond"];
    thirdStep.step.title = @"Facebook";
    
    StepsViewController *fourthStep = [self.storyboard instantiateViewControllerWithIdentifier:@"TutFourth"];
    fourthStep.step.title = @"Good To Go!";
    
    return @[firstStep, secondStep, thirdStep, fourthStep];
}

- (void)finishedAllSteps {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)canceled {
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
