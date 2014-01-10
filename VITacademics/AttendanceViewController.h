//
//  AttendanceViewController.h
//  VITacademics
//
//  Created by Siddharth on 04/01/14.
//  Copyright (c) 2014 Siddharth Gupta. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AttendanceViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *notificationLabel;
@property BOOL notificationReceived;
@end
