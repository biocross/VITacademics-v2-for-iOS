//
//  DetailViewController.h
//  Test2
//
//  Created by Siddharth Gupta on 5/7/13.
//  Copyright (c) 2013 Siddharth Gupta. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Subject.h"
#import "Subjects.h"
#import "PNChart.h"

@interface DetailViewController : UIViewController <UISplitViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *staticElevenLabel;
@property (strong, nonatomic) id detailItem;
@property (strong, nonatomic) Subjects *subject;
@property (strong, nonatomic) NSArray *subjectMarks;
@property (weak, nonatomic) IBOutlet UILabel *lastUpdatedLabel;
@property (strong, nonatomic) PNCircleChart *circleChart;


@property (weak, nonatomic) IBOutlet UILabel *staticFourteenLabel;

- (void)setDetailItem:(id)newDetailItem;
- (void)recalculateAttendance;

@property (weak, nonatomic) IBOutlet UILabel *subjectName;
@property (weak, nonatomic) IBOutlet UILabel *subjectType;
@property (weak, nonatomic) IBOutlet UILabel *subjectSlot;
@property (weak, nonatomic) IBOutlet UILabel *subjectAttended;
@property (weak, nonatomic) IBOutlet UILabel *subjectConducted;

- (IBAction)missPlus:(id)sender;
- (IBAction)missMinus:(id)sender;
- (IBAction)attendPlus:(id)sender;
- (IBAction)attendMinus:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *missLabel;
@property (weak, nonatomic) IBOutlet UILabel *attendLabel;

- (IBAction)subjectDetailsButton:(id)sender;
- (IBAction)marksButton:(id)sender;

@end
