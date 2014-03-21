//
//  PageContainerTimeTableViewController.m
//  VITacademics
//
//  Created by Siddharth on 21/03/14.
//  Copyright (c) 2014 Siddharth Gupta. All rights reserved.
//

#import "PageContainerTimeTableViewController.h"
#import "FullTimeTableTableViewController.h"

@interface PageContainerTimeTableViewController () <UIPageViewControllerDataSource>

@end

@implementation PageContainerTimeTableViewController

- (void) viewDidLoad
{
    [super viewDidLoad];
    self.pageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"TimeTablePager"];
    self.currentlyDisplayedDay = 0;
    self.pageViewController.dataSource = self;
    NSArray *viewControllers = @[[self.storyboard instantiateViewControllerWithIdentifier:@"FullTimeTableTableViewController"]];
    [self.pageViewController setViewControllers:viewControllers
                                      direction:UIPageViewControllerNavigationDirectionForward
                                       animated:NO
                                     completion:nil];
    [self addChildViewController:self.pageViewController];
    CGRect pageFrame = CGRectMake(0, 70, self.view.frame.size.width, self.view.frame.size.height - 70);
    self.pageViewController.view.frame = pageFrame;
    [self.view addSubview:self.pageViewController.view];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSUInteger index = ((FullTimeTableTableViewController*) viewController).day;
    
    if ((index == 0) || (index == NSNotFound)) {
        return nil;
    }
    
    index--;
    return [self viewControllerAtIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSUInteger index = ((FullTimeTableTableViewController*) viewController).day;
    
    if (index == NSNotFound) {
        return nil;
    }
    
    index++;
    if (index == 5) {
        return nil;
    }
    return [self viewControllerAtIndex:index];
}
- (FullTimeTableTableViewController *)viewControllerAtIndex:(NSInteger)index
{
    if (index >= 5 || index < 0)
    {
        return nil;
    }
    FullTimeTableTableViewController *FullTimeTableTableViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"FullTimeTableTableViewController"];
    [FullTimeTableTableViewController setDay:index];
    return FullTimeTableTableViewController;
}
@end
