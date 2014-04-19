//
//  DetailViewController.m
//  Test2
//
//  Created by Siddharth Gupta on 5/7/13.
//  Copyright (c) 2013 Siddharth Gupta. All rights reserved.
//

#import "DetailViewController.h"
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
        //self.title = @"";
        self.subjectName.text = self.subject.title;
        self.subjectSlot.text = self.subject.slot;
        self.subjectType.text = self.subject.attendance.type;
        self.subjectAttended.text = [NSString stringWithFormat:@"%ld",(long) [self.subject.attendance.attended intValue]];
        self.subjectConducted.text = [NSString stringWithFormat:@"%ld",(long)[self.subject.attendance.conducted intValue]];
        
        NSData *newdata = [NSData dataWithData:_subject.attendance.attendanceDetails];
        NSMutableArray *detailsArray = [NSMutableArray arrayWithArray: [NSKeyedUnarchiver unarchiveObjectWithData:newdata]];
        
        int length = [detailsArray count];
        if(length != 0){
            if([[detailsArray lastObject] isEqualToString:@"Absent"]){
                [self.lastUpdatedLabel setTextColor:[UIColor redColor]];
            }
            else{
                [self.lastUpdatedLabel setTextColor:[UIColor colorWithRed:0.05 green:0.52 blue:0.99 alpha:1]];
            }
            self.lastUpdatedLabel.text = [detailsArray objectAtIndex:length - 2];
        }
        
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
        [self.shakeToResetLabel setFont:[UIFont fontWithName:@"MuseoSans-300" size:10]];
        [self.swipeLabel setFont:[UIFont fontWithName:@"MuseoSans-300" size:10]];
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

-(void)viewDidAppear:(BOOL)animated{
     [self becomeFirstResponder];
}



-(void)resetCalculations{
    self.subjectAttended.text = [NSString stringWithFormat:@"%ld",  (long)[self.subject.attendance.attended intValue]];
    self.subjectConducted.text = [NSString stringWithFormat:@"%ld", (long)[self.subject.attendance.conducted intValue]];
    
    self.attendLabel.text = @"0";
    self.missLabel.text = @"0";
    
    [self recalculateAttendance];
}

- (void)recalculateAttendance{
    float calculatedPercentage =(float) [self.subjectAttended.text intValue] / [self.subjectConducted.text intValue];
    float displayPercentageInteger = ceil(calculatedPercentage * 100);
    NSString *displayPercentage = [NSString stringWithFormat:@"%1.0f",displayPercentageInteger];
    
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
    
    
    if([self.missLabel.text integerValue] != 0 || [self.attendLabel.text integerValue] != 0){
        self.shakeToResetLabel.alpha = 1;
    }
    else{
        self.shakeToResetLabel.alpha = 0;
    }
    
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

-(void)detailsButtonPressed:(id)sender{
    
}


@end
