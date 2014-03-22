//
//  PageContainerTimeTableViewController.h
//  VITacademics
//
//  Created by Siddharth on 21/03/14.
//  Copyright (c) 2014 Siddharth Gupta. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PageContainerTimeTableViewController : UIViewController

@property (nonatomic, strong) UIPageViewController *pageViewController;
@property (nonatomic) NSInteger currentlyDisplayedDay;
@end
