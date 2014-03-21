//
//  FullTimeTableTableViewController.m
//  VITacademics
//
//  Created by Siddharth on 21/03/14.
//  Copyright (c) 2014 Siddharth Gupta. All rights reserved.
//

#import "FullTimeTableTableViewController.h"

@interface FullTimeTableTableViewController ()

@end

@implementation FullTimeTableTableViewController

- (void) viewDidLoad
{
    [super viewDidLoad];
    //self.day = 0;
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.parentViewController.title = [NSString stringWithFormat:@"Day %ld",(long)self.day];
}

- (void) setDay:(NSInteger)day
{
    _day = day;
    [self.tableView reloadData];
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 12;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"timeTableSlotCell"];
    if(!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"timeTableSlotCell"];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"Slot: %ld",(long)[indexPath row]+1];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"Day %ld",(long)self.day];
    return cell;
}



@end
