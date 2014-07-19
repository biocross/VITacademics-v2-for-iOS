//
//  CampusMapViewController.m
//  VITacademics
//
//  Created by Siddharth on 19/07/14.
//  Copyright (c) 2014 Siddharth Gupta. All rights reserved.
//

#import "CampusMapViewController.h"

@interface CampusMapViewController ()

@end

@implementation CampusMapViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Campus Map";

    self.imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"vit-university-map-no-numbers.jpg"]];
    
    [self.scrollView addSubview:self.imageView];
    self.scrollView.contentSize = self.imageView.image.size;
    self.scrollView.scrollEnabled = YES;
    self.scrollView.clipsToBounds = YES;
    self.scrollView.delegate = self;
    self.scrollView.minimumZoomScale = 0.1;
    self.scrollView.maximumZoomScale = 5;
    
    self.scrollView.zoomScale = 0.4;
    
    
    
}

-(UIView *) viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    // return which subview we want to zoom
    return self.imageView;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
