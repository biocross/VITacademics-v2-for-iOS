//
//  DetailViewController.h
//  Test2
//
//  Created by Siddharth Gupta on 5/7/13.
//  Copyright (c) 2013 Siddharth Gupta. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Subject.h"
#import "DPMeterView.h"

@interface DetailViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *shakeToResetLabel;

@property (weak, nonatomic) IBOutlet UILabel *staticElevenLabel;
@property (strong, nonatomic) id detailItem;
@property (strong, nonatomic) Subject *subject;
@property (strong, nonatomic) NSArray *subjectMarks;
@property (weak, nonatomic) IBOutlet UILabel *lastUpdatedLabel;

- (IBAction)detailsButtonPressed:(id)sender;

@property (strong) DPMeterView *progressView;
@property (weak, nonatomic) IBOutlet UILabel *staticFourteenLabel;
@property (weak, nonatomic) IBOutlet UILabel *swipeLabel;

- (void)setDetailItem:(id)newDetailItem;
- (void)recalculateAttendance;
- (void)resetCalculations;

@property (weak, nonatomic) IBOutlet UILabel *subjectName;
@property (weak, nonatomic) IBOutlet UILabel *subjectType;
@property (weak, nonatomic) IBOutlet UILabel *subjectSlot;
@property (weak, nonatomic) IBOutlet UILabel *subjectAttended;
@property (weak, nonatomic) IBOutlet UILabel *subjectConducted;
@property UILabel *subjectPercentage;

@property (weak, nonatomic) IBOutlet UIView *progressFrame;

- (IBAction)missPlus:(id)sender;
- (IBAction)missMinus:(id)sender;
- (IBAction)attendPlus:(id)sender;
- (IBAction)attendMinus:(id)sender;

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *roundButton;

@property (weak, nonatomic) IBOutlet UILabel *missLabel;
@property (weak, nonatomic) IBOutlet UILabel *attendLabel;


@end
