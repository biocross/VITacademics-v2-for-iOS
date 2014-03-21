//
//  FullTimeTableTableViewController.m
//  VITacademics
//
//  Created by Siddharth on 21/03/14.
//  Copyright (c) 2014 Siddharth Gupta. All rights reserved.
//

#import "FullTimeTableTableViewController.h"
#import "UpcomingClassCell.h"

@interface FullTimeTableTableViewController ()

@end

@implementation FullTimeTableTableViewController

- (void) viewDidLoad
{
    [super viewDidLoad];
    
    
    NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
    if([preferences objectForKey:@"registrationNumber"]){
        
        NSString *ttKey = [NSString stringWithFormat:@"TTOf%@", [preferences objectForKey:@"registrationNumber"]];
        _ofToday = [[TimeTable alloc] initWithTTString:[preferences objectForKey:ttKey]];
        _timeSlots = [self.ofToday getTimeSlotArray];
    }
    
    
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

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 79;
}


- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    self.legibleTimeTable = [[NSMutableArray alloc] init];
    NSMutableArray *newArray = [[NSMutableArray alloc] init];
    NSArray *todaysTimeTable = [[NSArray alloc] init];
    if(!self.day){
        todaysTimeTable = _ofToday.monday;
    }
    else if(self.day == 1){
        todaysTimeTable = _ofToday.tuesday;
    }
    else if(self.day == 2){
        todaysTimeTable = _ofToday.wednesday;
    }
    else if(self.day == 3){
        todaysTimeTable = _ofToday.thursday;
    }
    else if(self.day == 4){
        todaysTimeTable = _ofToday.friday;
    }
    
    //DataSource Creation
    NSInteger length = [todaysTimeTable count];
    for(int i = 0 ; i<length ; i++){
        if([todaysTimeTable[i] isKindOfClass:[NSDictionary class]]){
            [self.legibleTimeTable addObject:todaysTimeTable[i]];
        }
    }
    
    //Duplicate Removal
    for (int i=0 ; i < [self.legibleTimeTable count] ; i++){
        if(i!= [self.legibleTimeTable count]-1 && [self.legibleTimeTable[i] isEqualToDictionary:self.legibleTimeTable[i+1]]){
        }
        else{
            [newArray addObject:self.legibleTimeTable[i]];
        }
    }
    
    self.legibleTimeTable = newArray;
    
    
    return [self.legibleTimeTable count];
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"UpcomingClassCell" owner:self options:nil];
    UpcomingClassCell *cell = [nib objectAtIndex:0];
    
    cell.subjectTitle.text = [self.legibleTimeTable[indexPath.row] objectForKey:@"title"];
    cell.subjectVenue.text = [self.legibleTimeTable[indexPath.row] objectForKey:@"venue"];
    cell.subjectSlot.text = [self.legibleTimeTable[indexPath.row] objectForKey:@"slot"];
    
    UIFont *titleFont = [UIFont fontWithName:@"MuseoSans-300" size:15];
    [cell.subjectTitle setFont:titleFont];
    
    UIFont *venueFont = [UIFont fontWithName:@"MuseoSans-300" size:20];
    [cell.subjectVenue setFont:venueFont];
    
    UIFont *slotFont = [UIFont fontWithName:@"MuseoSans-300" size:18];
    [cell.subjectSlot setFont:slotFont];
    
    UIFont *greyedFont = [UIFont fontWithName:@"MuseoSans-300" size:13];
    [cell.greyedText setFont:greyedFont];
    
    [cell.subjectPercentage setAlpha:0];
    [cell.subjectStartingIn setAlpha:0];
    
    return cell;
    
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}



@end
