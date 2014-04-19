//
//  FriendsViewController.h
//  VITacademics
//
//  Created by Siddharth on 15/12/13.
//  Copyright (c) 2013 Siddharth Gupta. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>

@interface FriendsViewController : UITableViewController

- (IBAction)shareButtonPressed:(id)sender;
- (IBAction)addFriendButtonPressed:(id)sender;

@property (retain, nonatomic) UISearchBar *searchBar;
@property (retain, nonatomic) NSString *searchText;

@end
