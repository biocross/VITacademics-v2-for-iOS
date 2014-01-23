//
//  AttendanceViewController.h
//  VITacademics
//
//  Created by Siddharth on 04/01/14.
//  Copyright (c) 2014 Siddharth Gupta. All rights reserved.
//

//
//  MasterViewController.h
//  Test2
//
//  Created by Siddharth Gupta on 5/7/13.
//  Copyright (c) 2013 Siddharth Gupta. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "CaptchaViewController.h"
#import "Subjects.h"
#import "CSNotificationView.h"


@interface AttendanceViewController : UITableViewController <UIAlertViewDelegate>

//@property (strong, nonatomic) DetailViewController *detailViewController;

- (void)startLoadingAttendance:(id)sender;
- (void)completedProcess;
- (void)processMarks;

@property NSString *attendanceCacheString;
@property NSString *marksCacheString;
@property CSNotificationView *notificationController;


@property (nonatomic, strong) Subjects *theorySubjects;
@property (nonatomic, strong) Subjects *labSubjects;


@end
