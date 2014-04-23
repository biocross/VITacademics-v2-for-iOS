//
//  FriendsTableViewCell.h
//  VITacademics
//
//  Created by Siddharth on 21/04/14.
//  Copyright (c) 2014 Siddharth Gupta. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Friend.h"

@interface FriendsTableViewCell : UITableViewCell

@property (strong) Friend *friend;
- (void) initCellData;

@property (weak, nonatomic) IBOutlet UILabel *friendname;
@property (weak, nonatomic) IBOutlet UILabel *friendClassStatus;
@end
