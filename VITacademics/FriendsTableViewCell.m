//
//  FriendsTableViewCell.m
//  VITacademics
//
//  Created by Siddharth on 21/04/14.
//  Copyright (c) 2014 Siddharth Gupta. All rights reserved.
//

#import "FriendsTableViewCell.h"

@implementation FriendsTableViewCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)initCellData{
    
    [self.friendname setFont:[UIFont fontWithName:@"MuseoSans-300" size:16]];
    [self.friendClassStatus setFont:[UIFont fontWithName:@"MuseoSans-300" size:14]];
}

@end
