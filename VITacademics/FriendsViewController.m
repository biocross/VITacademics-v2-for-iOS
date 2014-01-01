//
//  FriendsViewController.m
//  VITacademics
//
//  Created by Siddharth on 15/12/13.
//  Copyright (c) 2013 Siddharth Gupta. All rights reserved.
//

#import "FriendsViewController.h"

@interface FriendsViewController ()

@end

@implementation FriendsViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}

-(void)pickFriend:(id)sender{
    PFUser *currentUser = [PFUser currentUser];
    NSMutableDictionary* params =   [NSMutableDictionary dictionaryWithObjectsAndKeys:nil];
    
    [FBWebDialogs presentRequestsDialogModallyWithSession:nil
                                                  message:[NSString stringWithFormat:@"%@ has just requested access to your timetable on VITacademics", currentUser[@"facebookName"]]
                                                    title:@"TimeTable Request"
                                               parameters:params
                                                  handler:^(FBWebDialogResult result, NSURL *resultURL, NSError *error) {
                                                      if (error) {
                                                          // Case A: Error launching the dialog or sending request.
                                                          NSLog(@"Error sending request.");
                                                      } else {
                                                          if (result == FBWebDialogResultDialogNotCompleted) {
                                                              // Case B: User clicked the "x" icon
                                                              NSLog(@"User canceled request.");
                                                          } else {
                                                              NSLog(@"Request Sent.");
                                                          }
                                                      }}
                                              friendCache:nil];
}


@end
