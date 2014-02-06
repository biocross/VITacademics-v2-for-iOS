//
//  DetailViewController.m
//  Test2
//
//  Created by Siddharth Gupta on 5/7/13.
//  Copyright (c) 2013 Siddharth Gupta. All rights reserved.
//

#import "DetailViewController.h"
#import "Subject.h"
#import "CSNotificationView.h"
#import "DPMeterView.h"
#import "UIBezierPath+BasicShapes.h"
#import "PNColor.h"
#import "SubjectDetailsViewController.h"

#define   DEGREES_TO_RADIANS(degrees)  ((3.14159265359 * degrees)/ 180)


@interface DetailViewController ()



@property (strong, nonatomic) UIPopoverController *masterPopoverController;

- (void)configureView;

@end

@implementation DetailViewController

#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem
{
    
        _subject = newDetailItem;
    
        [self configureView];
    
    

    if (self.masterPopoverController != nil) {
        [self.masterPopoverController dismissPopoverAnimated:YES];
    }        
}


- (void)configureView
{
    // Update the user interface for the detail item.
    if (self.subject) {
        self.title = @"";
        self.subjectName.text = _subject.subjectTitle;
        self.subjectSlot.text = _subject.subjectSlot;
        self.subjectType.text = _subject.subjectType;
        self.subjectAttended.text = [NSString stringWithFormat:@"%ld",(long)_subject.attendedClasses];
        self.subjectConducted.text = [NSString stringWithFormat:@"%ld",(long)_subject.conductedClasses];
        
        self.progressView = [[DPMeterView alloc] init];
        [self.progressView setFrame:self.progressFrame.frame];
        [self.progressView setMeterType:DPMeterTypeLinearVertical];
        [self.progressView setShape:[self createArcPath].CGPath];
        [self.progressView setProgressTintColor:PNFreshGreen];
        
        [self.progressView startGravity];
        [self.progressView setTrackTintColor:[UIColor colorWithRed:0.9254 green:0.9411 blue:0.9450 alpha:1]];
        [self.view addSubview:self.progressView];
        
        self.subjectPercentage = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
        [self.subjectPercentage setTextAlignment:NSTextAlignmentCenter];
        self.subjectPercentage.textColor = [UIColor whiteColor];
        [self.subjectPercentage setCenter:self.progressView.center];
        [self.view addSubview:self.subjectPercentage];
        
        
        for(UIButton *item in self.roundButton){
            
            if([item.titleLabel.text isEqualToString:@"+"]){
                [item.layer setBorderColor:[[UIColor colorWithRed:0.1803 green:0.8 blue:0.4431 alpha:1] CGColor]];
            }
            else{
                [item.layer setBorderColor:[[UIColor colorWithRed:0.9058 green:0.2980 blue:0.2352 alpha:1] CGColor]];
            }
            
            [item.layer setBorderWidth:1];
            
        }

        [self recalculateAttendance];
    }
    
}

- (UIBezierPath *)createArcPath
{
    UIBezierPath *aPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(60, 60)
                                                         radius:50
                                                     startAngle:0
                                                       endAngle:DEGREES_TO_RADIANS(359)
                                                      clockwise:YES];
    return aPath;
}



- (void)recalculateAttendance{
    float calculatedPercentage =(float) [self.subjectAttended.text intValue] / [self.subjectConducted.text intValue];
    float displayPercentageInteger = ceil(calculatedPercentage * 100);
    NSString *displayPercentage = [NSString stringWithFormat:@"%1.0f",displayPercentageInteger];
    
    
    
    int length = [_subject.subjectDetails count];
    if(length != 0){
        if([[_subject.subjectDetails lastObject] isEqualToString:@"Absent"]){
            [self.lastUpdatedLabel setTextColor:[UIColor redColor]];
        }
        else{
            [self.lastUpdatedLabel setTextColor:[UIColor colorWithRed:0.05 green:0.52 blue:0.99 alpha:1]];
        }
        self.lastUpdatedLabel.text = [_subject.subjectDetails objectAtIndex:length - 2];
    }

    
    if(displayPercentageInteger >= 80){
        [self.progressView setProgressTintColor:[UIColor colorWithRed:0.1803 green:0.8 blue:0.4431 alpha:1]];
    }
    else if(displayPercentageInteger >= 75 && displayPercentageInteger < 80){
        [self.progressView setProgressTintColor:[UIColor orangeColor]];
    }
    else{
        [self.progressView setProgressTintColor:[UIColor colorWithRed:0.9058 green:0.2980 blue:0.2352 alpha:1]];
    }

    displayPercentageInteger = displayPercentageInteger/100;
    [self.progressView setProgress:displayPercentageInteger animated:YES];

    
    if(self.subject.subjectCode){
        self.title = self.subject.subjectCode;
    }
    else{
      self.title = @"Subject Details";
    }
    
    UIFont *codeFont = [UIFont fontWithName:@"MuseoSans-300" size:11];
    [self.lastUpdatedLabel setFont:codeFont];
    [self.staticElevenLabel setFont:codeFont];
    
    UIFont *subjectNameFont = [UIFont fontWithName:@"MuseoSans-300" size:23];
    [self.subjectName setFont:subjectNameFont];
    
    UIFont *subjectTypeFont = [UIFont fontWithName:@"MuseoSans-300" size:14];
    [self.subjectType setFont:subjectTypeFont];
    [self.subjectSlot setFont:subjectTypeFont];
    
    UIFont *thirteenFont = [UIFont fontWithName:@"MuseoSans-300" size:14];
    [self.subjectAttended  setFont:thirteenFont];
    [self.subjectConducted setFont:thirteenFont];
    [self.staticFourteenLabel setFont:thirteenFont];
    
    
    self.subjectPercentage.text = [displayPercentage stringByAppendingString:@"%"];

    
    UIFont *subjectPerFont = [UIFont fontWithName:@"MuseoSans-300" size:20];
    [self.subjectPercentage setFont:subjectPerFont];
    
    
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self configureView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Attendance Manipulations

- (IBAction)missPlus:(id)sender {
    int missPlusLabel = [_missLabel.text intValue] + 1;
    [_missLabel setText:[NSString stringWithFormat:@"%d", missPlusLabel]];
    
    NSError *error = NULL;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"L" options:NSRegularExpressionCaseInsensitive error:&error];
    NSUInteger numberOfMatches = [regex numberOfMatchesInString:self.subjectSlot.text options:0 range:NSMakeRange(0, [self.subjectSlot.text length])];
    
    int numberOfSlots = 1;
    if(numberOfMatches){
        numberOfSlots = numberOfMatches;
    }

    
    int currentSubjectConducted = [self.subjectConducted.text intValue];
    [self.subjectConducted setText:[NSString stringWithFormat:@"%d", currentSubjectConducted + numberOfSlots ]];
    [self recalculateAttendance];
    
}

- (IBAction)missMinus:(id)sender {
    int missPlusLabel = [_missLabel.text intValue];
    if(missPlusLabel > 0){
        [_missLabel setText:[NSString stringWithFormat:@"%d", missPlusLabel - 1 ]];
        
        NSError *error = NULL;
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"L" options:NSRegularExpressionCaseInsensitive error:&error];
        NSUInteger numberOfMatches = [regex numberOfMatchesInString:self.subjectSlot.text options:0 range:NSMakeRange(0, [self.subjectSlot.text length])];
        
        int numberOfSlots = 1;
        if(numberOfMatches){
            numberOfSlots = numberOfMatches;
        }
        
        int currentSubjectConducted = [self.subjectConducted.text intValue];
        [self.subjectConducted setText:[NSString stringWithFormat:@"%d", currentSubjectConducted - numberOfSlots ]];
        [self recalculateAttendance];
    }
}

- (IBAction)attendPlus:(id)sender {
    int attendPlusLabel = [_attendLabel.text intValue];
    [_attendLabel setText:[NSString stringWithFormat:@"%d", attendPlusLabel + 1 ]];
    
    NSError *error = NULL;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"L" options:NSRegularExpressionCaseInsensitive error:&error];
    NSUInteger numberOfMatches = [regex numberOfMatchesInString:self.subjectSlot.text options:0 range:NSMakeRange(0, [self.subjectSlot.text length])];
    
    int numberOfSlots = 1;
    if(numberOfMatches){
        numberOfSlots = numberOfMatches;
    }
    
    int currentSubjectAttended = [self.subjectAttended.text intValue];
    [self.subjectAttended setText:[NSString stringWithFormat:@"%d", currentSubjectAttended + numberOfSlots]];
    
    int currentSubjectConducted = [self.subjectConducted.text intValue];
    [self.subjectConducted setText:[NSString stringWithFormat:@"%d", currentSubjectConducted + numberOfSlots ]];
    
    [self recalculateAttendance];
    
}

- (IBAction)attendMinus:(id)sender {
    int attendPlusLabel = [_attendLabel.text intValue];
    if(attendPlusLabel > 0){
        [_attendLabel setText:[NSString stringWithFormat:@"%d", attendPlusLabel - 1 ]];
        
        NSError *error = NULL;
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"L" options:NSRegularExpressionCaseInsensitive error:&error];
        NSUInteger numberOfMatches = [regex numberOfMatchesInString:self.subjectSlot.text options:0 range:NSMakeRange(0, [self.subjectSlot.text length])];
        
        int numberOfSlots = 1;
        if(numberOfMatches){
            numberOfSlots = numberOfMatches;
        }
        
        int currentSubjectAttended = [self.subjectAttended.text intValue];
        [self.subjectAttended setText:[NSString stringWithFormat:@"%d", currentSubjectAttended - numberOfSlots]];
        
        int currentSubjectConducted = [self.subjectConducted.text intValue];
        [self.subjectConducted setText:[NSString stringWithFormat:@"%d", currentSubjectConducted - numberOfSlots]];
        
        [self recalculateAttendance];
    }
}

- (IBAction)subjectDetailsButton:(id)sender {
    
    /*
    if([_subject.subjectDetails count] > 0){
        SubjectDetailsViewController *forThisSubject = [[SubjectDetailsViewController alloc] init];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:forThisSubject];
        [self presentViewController:nav animated:YES completion:nil];
        [forThisSubject setDetailsArray:_subject.subjectDetails];
        [forThisSubject viewDidLoad];
    }
    else{
        if(NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_6_1){
            [CSNotificationView showInViewController:self style:CSNotificationViewStyleError message:@"Not Uploaded Yet"];
        }
        
        else{
            [SVProgressHUD showErrorWithStatus:@"Not Uploaded Yet"];
        }
    }
    
    */

    
}

- (IBAction)marksButton:(id)sender {
    /*
    if([self.subjectMarks count] < 16){
        
        
            [CSNotificationView showInViewController:self style:CSNotificationViewStyleError message:@"PBL/Lab not supported (yet)"];
        
    }
    else{
        MarksViewController *forThisSubject = [[MarksViewController alloc] init];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:forThisSubject];
        [self presentViewController:nav animated:YES completion:nil];
        [forThisSubject setMarksArray:self.subjectMarks];
    }
    
    */
    
}



/*
    UIView *checkView = [self viewWithImageName:@"check"];
    UIColor *greenColor = [UIColor colorWithRed:85.0 / 255.0 green:213.0 / 255.0 blue:80.0 / 255.0 alpha:1.0];
    
    UIView *crossView = [self viewWithImageName:@"cross"];
    UIColor *redColor = [UIColor colorWithRed:232.0 / 255.0 green:61.0 / 255.0 blue:14.0 / 255.0 alpha:1.0];
    
    UIView *clockView = [self viewWithImageName:@"clock"];
    UIColor *yellowColor = [UIColor colorWithRed:254.0 / 255.0 green:217.0 / 255.0 blue:56.0 / 255.0 alpha:1.0];
    
    UIView *listView = [self viewWithImageName:@"list"];
    UIColor *brownColor = [UIColor colorWithRed:206.0 / 255.0 green:149.0 / 255.0 blue:98.0 / 255.0 alpha:1.0];
    
    // Setting the default inactive state color to the tableView background color
*/


- (IBAction)detailsButtonPressed:(id)sender {
    
    if([_subject.subjectDetails count] > 0){
        SubjectDetailsViewController *forThisSubject = [[SubjectDetailsViewController alloc] init];
        [self.navigationController pushViewController:forThisSubject animated:YES];
        forThisSubject.detailsArray = _subject.subjectDetails;
    }
    else{
        [CSNotificationView showInViewController:self style:CSNotificationViewStyleError message:@"Not Uploaded Yet"];
        
    }
}
@end
