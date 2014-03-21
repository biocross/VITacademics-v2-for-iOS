//
//  FullTimeTableTableViewController.h
//  VITacademics
//
//  Created by Siddharth on 21/03/14.
//  Copyright (c) 2014 Siddharth Gupta. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TimeTable.h"

@interface FullTimeTableTableViewController : UITableViewController

@property (nonatomic) NSInteger day;
@property TimeTable *ofToday;
@property NSArray *timeSlots;
@property NSMutableArray *legibleTimeTable;

@end
