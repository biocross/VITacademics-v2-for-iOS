//
//  FullTimeTableTableViewController.m
//  VITacademics
//
//  Created by Siddharth on 21/03/14.
//  Copyright (c) 2014 Siddharth Gupta. All rights reserved.
//

#import "FullTimeTableTableViewController.h"
#import "UpcomingClassCell.h"
#import "PageContainerTimeTableViewController.h"

@interface FullTimeTableTableViewController (){
    NSArray *todaysTimeTable;
}

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
    if(!self.day){
        self.parentViewController.parentViewController.title = @"Monday";
    }
    else if(self.day == 1){
        self.parentViewController.parentViewController.title = @"Tuesday";
    }
    else if(self.day == 2){
        self.parentViewController.parentViewController.title = @"Wednesday";
    }
    else if(self.day == 3){
        self.parentViewController.parentViewController.title = @"Thursday";
    }
    else if(self.day == 4){
        self.parentViewController.parentViewController.title = @"Friday";
    }
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
    
    
    PageContainerTimeTableViewController *parent = (PageContainerTimeTableViewController *)self.parentViewController.parentViewController;
    
    self.legibleTimeTable = [[NSMutableArray alloc] init];
    NSMutableArray *newArray = [[NSMutableArray alloc] init];
    todaysTimeTable = [[NSArray alloc] init];
    if(!self.day){
        todaysTimeTable = _ofToday.monday;
        //parent.title = @"Monday";
    }
    else if(self.day == 1){
        todaysTimeTable = _ofToday.tuesday;
        parent.title = @"Tuesday";
    }
    else if(self.day == 2){
        todaysTimeTable = _ofToday.wednesday;
        parent.title = @"Wednesday";
    }
    else if(self.day == 3){
        todaysTimeTable = _ofToday.thursday;
        parent.title = @"Thursday";
    }
    else if(self.day == 4){
        todaysTimeTable = _ofToday.friday;
        parent.title = @"Friday";
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
    
    return ([self.legibleTimeTable count] + 1) ;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"UpcomingClassCell" owner:self options:nil];
    UpcomingClassCell *cell = [nib objectAtIndex:0];
    
    
    if(indexPath.row == ([self.legibleTimeTable count])){
        
        /*cell.subjectTitle.text = @"swipe to view other days";
        cell.subjectTitle.textAlignment = NSTextAlignmentJustified;
        cell.subjectTitle.textColor = [UIColor colorWithRed:0.1803 green:0.8 blue:0.4431 alpha:1];
        cell.subjectVenue.alpha = 0;
        cell.subjectSlot.alpha = 0;
        cell.subjectStartingIn.alpha = 0;
        cell.subjectPercentage.alpha = 0;*/
        
        NSArray *viewsToRemove = [cell.contentView subviews];
        for (UIView *v in viewsToRemove) {
            [v removeFromSuperview];
        }
        
        UILabel *swipe = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, cell.contentView.frame.size.height)];
        swipe.textAlignment = NSTextAlignmentCenter;
        swipe.text = @"swipe to view other days";
        swipe.textColor = [UIColor colorWithRed:0.1803 green:0.8 blue:0.4431 alpha:1];
        UIFont *titleFont = [UIFont fontWithName:@"MuseoSans-300" size:15];
        swipe.font = titleFont;
        [cell.contentView addSubview:swipe];
    }
    
    else{
    
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
        
        int index = 0;
        for(int i=0; i<12; i++){
            if([todaysTimeTable[i] isKindOfClass:[NSDictionary class]]){
                if([self.legibleTimeTable[indexPath.row] isEqualToDictionary:todaysTimeTable[i]]){
                    index = i;
                    break;
                }
            }
        }
        
        NSString *suffix = @"AM";
        int time = [self.timeSlots[(2*index)+1] hour];
        
        if(time > 12){
            suffix = @"PM";
            time = time - 12;
        }
        if(time == 12){
            suffix = @"PM";
        }
        cell.subjectStartingIn.text = [NSString stringWithFormat:@"Begins at %d %@", time, suffix];
        cell.subjectStartingIn.textColor = [UIColor colorWithRed:0.203 green:0.286 blue:0.386 alpha:1];
        [cell.subjectPercentage setAlpha:0];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}



@end
