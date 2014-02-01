//
//  TodayViewController.m
//  VITacademics
//
//  Created by Siddharth on 14/12/13.
//  Copyright (c) 2013 Siddharth Gupta. All rights reserved.
//

#import "TodayViewController.h"
#import "TimeTable.h"
#import "RMStepsController.h"
#import "CurrentClassTableViewCell.h"
#import "UpcomingClassCell.h"


#warning Bugs
/*
 Bugs / TODO:
 - [FIXED] [was due to no upload] Last Updated Label in detail View is sometime colored, and sometimes not.
 - [FIXED] Resign First Reponder in the settings screen when user click "Verify!"
 - [FIXED] Slot in Today View is getting truncated if it's more than one slot long - Labs!
 - Set 1990 date in date picker
 - Remove the string from Setting View saying facebook thingy
 - [CRITICAL] Now view shows classes on weekends also!
  
 
 - I can actually set Change Credentials to reset the app.
 */
@interface TodayViewController (){
    TimeTable *ofToday;
    NSDictionary *currentClass;
}

@end

@implementation TodayViewController

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
    
    NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
    
    if([preferences objectForKey:@"registrationNumber"]){
        
        NSString *ttKey = [NSString stringWithFormat:@"TTOf%@", [preferences objectForKey:@"registrationNumber"]];
        
        ofToday = [[TimeTable alloc] initWithTTString:[preferences objectForKey:ttKey]];
        self.todaysTimeTable = [ofToday getTodaysTimeTable];
        currentClass = [[ofToday getCurrentClass] isKindOfClass:[NSDictionary class]] ? [ofToday getCurrentClass] : 0;
        
        self.legibleTimeTable = [[NSMutableArray alloc] init];
        
        NSInteger length = [self.todaysTimeTable count];
        for(int i = 0 ; i<length ; i++){
            if([self.todaysTimeTable[i] isKindOfClass:[NSDictionary class]]){
                [self.legibleTimeTable addObject:self.todaysTimeTable[i]];
            }
        }
        
        self.timeSlots = [ofToday getTimeSlotArray];
        
        [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(refreshTable) userInfo:nil repeats:YES];
    }
    
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(reloadSelf)
     name:@"reloadTimeTable"
     object:nil];

    //self.tabBarItem.badgeValue = [NSString stringWithFormat:@"%lu", (unsigned long)[self.todaysTimeTable count]];
    
}

-(void)refreshTable{
    NSIndexSet *new = [[NSIndexSet alloc] initWithIndex:0];
    [self.tableView reloadSections:new withRowAnimation:UITableViewRowAnimationFade];
}

-(void)reloadSelf{
    NSLog(@"NotificationRcvd");
    [self viewDidLoad];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{    
    if(self.notificationReceived){
        return 3;
    }
    else{
        return 2;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section{
    
    NSString *string = @"";
    
    if(section == 1){
        string = @"Information here might be errornous, please verify atleast once with actual time table.";
    }
    
    return string;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    NSString *string = @"Others";
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"EEEE"];
    NSString *todaysDay = [dateFormatter stringFromDate:[NSDate date]];
    
    string = @"Today";
    
    if(section == 0){
        string = @"Right Now";
    }
    
    if(section == 1){
        if([todaysDay isEqualToString:@"Monday"]){
        }
        else if([todaysDay isEqualToString:@"Tuesday"]){
        }
        else if([todaysDay isEqualToString:@"Wednesday"]){
        }
        else if([todaysDay isEqualToString:@"Thursday"]){
            
        }
        else if([todaysDay isEqualToString:@"Friday"]){
        }
        else{
            string = @"Coming Up - On Monday";
        }
    }

    if(section == 2){
        string = @"Notifications";
    }
    
    return string;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger rows = 1;
    
    
    if(section == 1){
        rows = [self.legibleTimeTable count];
    }
    
    return rows;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    int height = 183;

    if(indexPath.section == 1){
        height = 91;
    }
    
    return height;
    
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0){
    
    
        @try {
            currentClass = [[ofToday getCurrentClass] isKindOfClass:[NSDictionary class]] ? [ofToday getCurrentClass] : 0;
        }
        @catch (NSException *exception) {
            NSLog(@"%@", [exception description]);
        }

        
        
    
        if(currentClass){
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CurrentClassTableViewCell" owner:self options:nil];
        CurrentClassTableViewCell *cell = [nib objectAtIndex:0];
        cell.subjectTitle.text = [currentClass objectForKey:@"title"];
        cell.subjectSlot.text = [currentClass objectForKey:@"slot"];
        cell.subjectVenue.text = [currentClass objectForKey:@"venue"];
        cell.subjectFaculty.text = [currentClass objectForKey:@"faculty"];
        
        UIFont *titleFont = [UIFont fontWithName:@"MuseoSans-300" size:21];
        [cell.subjectTitle setFont:titleFont];
        [cell.subjectVenue setFont:titleFont];
        
        UIFont *percentageFont = [UIFont fontWithName:@"MuseoSans-300" size:37];
        [cell.subjectPercentage setFont:percentageFont];
        [cell.ifYou setAlpha:0.4];
        
        UIFont *greyedFont = [UIFont fontWithName:@"MuseoSans-300" size:13];
        [cell.greyedText setFont:greyedFont];
        
        UIFont *facultyFont = [UIFont fontWithName:@"MuseoSans-300" size:16];
        [cell.subjectFaculty setFont:facultyFont];
        
        UIFont *ifYouFont = [UIFont fontWithName:@"MuseoSans-300" size:30];
        [cell.ifYou setFont:ifYouFont];
        
        UIFont *calculatedFont = [UIFont fontWithName:@"MuseoSans-300" size:15];
        [cell.calculatedLabels setFont:calculatedFont];
        
        return cell;
        
    }
    else{
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"NoClassRightNow" owner:self options:nil];
        UITableViewCell *cell = [nib objectAtIndex:0];
        return cell;
        }
    

    }
    
    if(indexPath.section == 1){
        
        //find the index of the subject
        int index = 0;
        for(int i=0; i<12; i++){
            if([self.todaysTimeTable[i] isKindOfClass:[NSDictionary class]]){
                if([self.legibleTimeTable[indexPath.row] isEqualToDictionary:self.todaysTimeTable[i]]){
                    index = i;
                    break;
                }
            }
            
        }
        
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"UpcomingClassCell" owner:self options:nil];
        UpcomingClassCell *cell = [nib objectAtIndex:0];
        
        cell.subjectTitle.text = [self.legibleTimeTable[indexPath.row] objectForKey:@"title"];
        cell.subjectVenue.text = [self.legibleTimeTable[indexPath.row] objectForKey:@"venue"];
        cell.subjectSlot.text = [self.legibleTimeTable[indexPath.row] objectForKey:@"slot"];
        
        UIFont *titleFont = [UIFont fontWithName:@"MuseoSans-300" size:15];
        [cell.subjectTitle setFont:titleFont];
        
        UIFont *venueFont = [UIFont fontWithName:@"MuseoSans-300" size:19];
        [cell.subjectVenue setFont:venueFont];
        
        UIFont *slotFont = [UIFont fontWithName:@"MuseoSans-300" size:13];
        [cell.subjectSlot setFont:slotFont];
        
        UIFont *greyedFont = [UIFont fontWithName:@"MuseoSans-300" size:13];
        [cell.greyedText setFont:greyedFont];
        
        //UIFont *percentageFont = [UIFont fontWithName:@"MuseoSans-300" size:23];
        [cell.subjectPercentage setFont:greyedFont];
        cell.subjectPercentage.text = @"attendance not yet available";
        
        NSDateComponents *rightNow = [[NSCalendar currentCalendar] components:NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit fromDate:[NSDate date]];
        
        NSString *suffix = @"AM";
        int time = [self.timeSlots[index] hour];
        
        if([rightNow hour] > time /*&& [rightNow minute] > 50*/){
            cell.subjectStartingIn.text = @"class finished";
            cell.subjectStartingIn.textColor = [UIColor colorWithRed:0.203 green:0.286 blue:0.386 alpha:1];
        }
        else{
            if(time > 12){
                suffix = @"PM";
                time = time - 12;
            }
            cell.subjectStartingIn.text = [NSString stringWithFormat:@"Begins at %d %@", time, suffix];
            cell.subjectStartingIn.textColor = [UIColor colorWithRed:0.203 green:0.286 blue:0.386 alpha:1];
        }
        return cell;
    }
    
    else{
        UITableViewCell *cell = [[UITableViewCell alloc] init];
        return cell;
    }
    
}


@end
