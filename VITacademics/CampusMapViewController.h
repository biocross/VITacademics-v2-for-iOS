//
//  CampusMapViewController.h
//  VITacademics
//
//  Created by Siddharth on 19/07/14.
//  Copyright (c) 2014 Siddharth Gupta. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CampusMapViewController : UIViewController <UIScrollViewDelegate>

@property (nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end
