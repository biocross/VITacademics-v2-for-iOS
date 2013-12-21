//
//  UpcomingClassCell.h
//  VITacademics
//
//  Created by Siddharth on 21/12/13.
//  Copyright (c) 2013 Siddharth Gupta. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UpcomingClassCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *subjectTitle;
@property (weak, nonatomic) IBOutlet UILabel *subjectVenue;
@property (weak, nonatomic) IBOutlet UILabel *subjectStartingIn;
@property (weak, nonatomic) IBOutlet UILabel *subjectPercentage;
@property (weak, nonatomic) IBOutlet UILabel *subjectSlot;
@property (weak, nonatomic) IBOutlet UILabel *greyedText;

@end
