//
//  CurrentClassTableViewCell.h
//  VITacademics
//
//  Created by Siddharth on 14/12/13.
//  Copyright (c) 2013 Siddharth Gupta. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SFRoundProgressCounterView.h"

@interface CurrentClassTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *subjectSlot;
@property (weak, nonatomic) IBOutlet UILabel *subjectTitle;
@property (weak, nonatomic) IBOutlet UILabel *subjectPercentage;
@property (weak, nonatomic) IBOutlet UILabel *subjectVenue;
@property (weak, nonatomic) IBOutlet UILabel *subjectFaculty;
@property (weak, nonatomic) IBOutlet UILabel *greyedText;
@property (weak, nonatomic) IBOutlet UILabel *ifYou;
@property (weak, nonatomic) IBOutlet UILabel *calculatedLabels;
@property (weak, nonatomic) IBOutlet UILabel *missToday;
@property (weak, nonatomic) IBOutlet UILabel *attendToday;
@property (weak, nonatomic) IBOutlet SFRoundProgressCounterView *timeView;

@end
