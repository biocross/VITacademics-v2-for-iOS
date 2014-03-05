//
//  RootForPageViewController.h
//  VITacademics
//
//  Created by Siddharth on 03/03/14.
//  Copyright (c) 2014 Siddharth Gupta. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Subjects.h"
#import "DetailViewController.h"
#import "MarksViewController.h"
#import "SubjectDetailsViewController.h"


@interface RootForPageViewController : UIViewController

@property (strong, nonatomic) UIPageViewController *pageViewController;
@property (strong, nonatomic) Subjects *subject;
@property (strong, nonatomic) NSArray *subjectMarks;
@property (nonatomic) NSInteger index;
@property DetailViewController *detailsView;
@property SubjectDetailsViewController *subjectDetailsView;
@property MarksViewController *marksView;


@end
