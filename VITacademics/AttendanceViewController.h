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
#import "DetailViewController.h"


@interface AttendanceViewController : UITableViewController <UIAlertViewDelegate>

@property (strong, nonatomic) DetailViewController *detailViewController;

- (void)startLoadingAttendance:(id)sender;
- (void)completedProcess;

//@property NSString *attendanceCacheString;


@property (nonatomic, strong) NSMutableArray *theorySubjects;
@property (nonatomic, strong) NSMutableArray *labSubjects;


@end
