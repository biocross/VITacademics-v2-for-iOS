//
//  FriendsTableViewCell.m
//  VITacademics
//
//  Created by Siddharth on 21/04/14.
//  Copyright (c) 2014 Siddharth Gupta. All rights reserved.
//

#import "FriendsTableViewCell.h"
#import "OLDTimeTable.h"

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
    [self.friendClassStatus setTextColor:[UIColor colorWithRed:0.1803 green:0.8 blue:0.4431 alpha:1]];
    
    self.friendname.text = self.friend.name;
    NSDictionary *currentClass;
    
    OLDTimeTable *ofFriend = [[OLDTimeTable alloc] initWithTTString:self.friend.timetable];
    
    
    @try {
        currentClass = [[ofFriend getCurrentClass] isKindOfClass:[NSDictionary class]] ? [ofFriend getCurrentClass] : 0;
    }
    @catch (NSException *exception) {
        NSLog(@"%@", [exception description]);
    }
    
    
    if(currentClass){
        self.friendClassStatus.text = [NSString stringWithFormat:@"has a class at %@", [currentClass objectForKey:@"venue"]];
    }
    else{
        self.friendClassStatus.text = @"is free right now.";
    }

}

@end
