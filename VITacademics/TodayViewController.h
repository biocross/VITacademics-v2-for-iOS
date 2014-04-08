//
//  TodayViewController.h
//  VITacademics
//
//  Created by Siddharth on 14/12/13.
//  Copyright (c) 2013 Siddharth Gupta. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TodayViewController : UITableViewController

@property (strong) NSMutableArray *todaysTimeTable;
@property NSDictionary *temporaryComparator;
@property bool notificationReceived;
@property NSMutableArray *legibleTimeTable;
@property NSMutableArray *timeSlots;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *notificationButtonPressed;
@end
