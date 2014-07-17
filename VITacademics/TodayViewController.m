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
#import "Subject.h"
#import "NotificationViewController.h"






/*
 Bugs / TODO:
 - [FIXED] [was due to no upload] Last Updated Label in detail View is sometime colored, and sometimes not.
 - [FIXED] Resign First Responder in the settings screen when user clicks "Verify!"
 - [FIXED] Slot in Today View is getting truncated if it's more than one slot long - Labs!
 - [FIXED] Remove the string from Setting View saying facebook thingy
 - [FIXED] [PROBLEM] Submit button in CaptchaView should work on CellTouch
 - [FIXED] [CRITICAL] Add full check of all JSON strings in AppDelegate to avoid "Data parameteR" crashes.
 - [FIXED] [CRITICAL] Add PercentageAttendance Label to Detail View OMG!
 - [FIXED - Partially - Pull to refresh] Make Upcoming classes also reactive cells.
 - [FIXED] [CRITICAL] Now view shows classes on weekends also!
 - [FIXED] Go Button on keyboard is not working - CaptchaViewController
 - [FIXED] ADD NETWORK ERROR IMAGE
 - [FIXED] shows Class finished on weekends
 - [FIXED] I can actually set Change Credentials to reset the app.
 - [FIXED] viewDidAppear
 - [FIXED][ADD] Analytics, Helpshift, Crittercism
 - [FIXED] disable share button in friends
 - [FIXED] Marks View
 - [FIXED] Shake to Reset, Swipe for Marks.
 - [FIXED] Added Rating Dailog - Appirater
 - [FIXED] dateOfBirth Picker resign first responder
 - [FIXED] a bug in today upcoming class for showning "in xx time".
 - [CANCELLED] New Captcha View Controller
 - [FIXED] Full Swipeable timeTable
 - [FIXED - added Reset PIN Option] Check PIN validity everytime Share Launches
 - [FIXED] Toolbar jugaad in FriendsSubViews
 - [DEFERRED] Add enable all, disable all toggle in NotificationView
 - [FIXED] Remove timeTable string from today - TimeTable.h call.
 - [DERERRED] Set Default notifications as YES to all
 - [DEFERRED] Notifications System
 - [DEFERRED] Fix Notification Model Type (Bool, NSNumber, or what?)
 - [FIXED] Remove Transparency from cell to increase performance
 - [FIXED] Add Friends Deletion Feature.
 - [DEFERRED] Add Blocked list on Parse for those who have privacy concerns.
 - [FIXED] add days to details view (like thursday etc)
 - [FIXED] Fix iPad Crash
 - [FIXED] Check server status - See iOS Documentaion for response.code
 - [FIXED] Make Marks compaitable with 3.5 inch screens
 - [FIXED] Fix Misalignment in DetailsViewController
 - [DEFERRED] In-App Purchase
 - [FIXED] AutoRefresh Friends view

 
 [CRITICAL]
 - Clear CoreData on "Reset VITacademics"
 
 [IMPORTANT]
 - When runs for the first time from old version, timetable is empty.
 - Share URL

 
 [LOW PRIORITY]
 - Fix Alignment in Steps INIT

 
 */
@interface TodayViewController (){
    TimeTable *ofToday;
    Subject *currentClass;
    NSMutableArray *attendanceArray;
}

@end

@implementation TodayViewController

-(void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    [self.tableView reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
    
    if([preferences objectForKey:@"registrationNumber"]){
        [self initData];
        [NSTimer scheduledTimerWithTimeInterval:20.0 target:self selector:@selector(refreshTable) userInfo:nil repeats:YES];
    }
    
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(reloadSelf)
     name:@"reloadTimeTable"
     object:nil];

    [self parentViewController].tabBarItem.badgeValue = [NSString stringWithFormat:@"%lu", (unsigned long)[self.legibleTimeTable count]];
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refreshTableView:) forControlEvents:UIControlEventValueChanged];
    [self setRefreshControl:refreshControl];
    
}

-(void)initData{
    ofToday = [[TimeTable alloc] initWithTTString:@""];
    self.todaysTimeTable = [ofToday getTodaysTimeTable];
    self.legibleTimeTable = [[NSMutableArray alloc] init];
    NSMutableArray *newArray = [[NSMutableArray alloc] init];
    
    //DataSource Creation
    NSInteger length = [self.todaysTimeTable count];
    for(int i = 0 ; i<length ; i++){
        if([self.todaysTimeTable[i] isKindOfClass:[Subject class]]){
            [self.legibleTimeTable addObject:self.todaysTimeTable[i]];
        }
    }
    
    //Duplicate Removal
    for (int i=0 ; i < [self.legibleTimeTable count] ; i++){
        if(i!= [self.legibleTimeTable count]-1 && [self.legibleTimeTable[i] isEqual:self.legibleTimeTable[i+1]]){
        }
        else{
            [newArray addObject:self.legibleTimeTable[i]];
        }
    }
    
    self.legibleTimeTable = newArray;
    self.timeSlots = [ofToday getTimeSlotArray];
}

- (void)refreshTableView:(id)sender{
    [self.tableView reloadData];
    [(UIRefreshControl *)sender endRefreshing];
}

- (void)refreshTable{
    NSLog(@"refreshing table");

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
    
    int height = 192;

    if(indexPath.section == 1){
        height = 79;
    }
    
    return height;
    
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0){
        
        @try {
            currentClass = [[ofToday getCurrentClass] isKindOfClass:[Subject class]] ? [ofToday getCurrentClass] : 0;
        }
        @catch (NSException *exception) {
            NSLog(@"%@", [exception description]);
        }
        
        
        if(currentClass){
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CurrentClassTableViewCell" owner:self options:nil];
            CurrentClassTableViewCell *cell = [nib objectAtIndex:0];
            cell.subjectTitle.text = currentClass.title;
            cell.subjectSlot.text = currentClass.slot;
            cell.subjectVenue.text = currentClass.venue;
            cell.subjectFaculty.text = currentClass.faculty;
            
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
            
            @try {
                    
                    float calculatedPercentage = (float) [currentClass.attendance.attended floatValue] / [currentClass.attendance.conducted floatValue];
                    float displayPercentageInteger = ceil(calculatedPercentage * 100);
                    NSString *displayPercentage = [NSString stringWithFormat:@"%1.0f",displayPercentageInteger];
                    cell.subjectPercentage.text = [displayPercentage stringByAppendingString:@"%"];
                    
                    
                    if(displayPercentageInteger < 75){
                        cell.subjectPercentage.textColor = [UIColor colorWithRed:0.9058 green:0.2980 blue:0.2352 alpha:1];
                    }
                    else if (displayPercentageInteger >= 75 && displayPercentageInteger < 80){
                        cell.subjectPercentage.textColor = [UIColor orangeColor];
                    }
                    else{
                        cell.subjectPercentage.textColor = [UIColor colorWithRed:0.1803 green:0.8 blue:0.4431 alpha:1];
                    }
                    
                    //Miss Today
                    float calculatedPercentageMiss = (float) [currentClass.attendance.attended floatValue] / ([currentClass.attendance.conducted floatValue] + 1);
                    float displayPercentageIntegerMiss = ceil(calculatedPercentageMiss * 100);
                    NSString *displayPercentageMiss = [NSString stringWithFormat:@"%1.0f",displayPercentageIntegerMiss];
                    cell.missToday.text = [displayPercentageMiss stringByAppendingString:@"%"];
                    
                    
                    if(displayPercentageIntegerMiss < 75){
                        cell.missToday.textColor = [UIColor colorWithRed:0.9058 green:0.2980 blue:0.2352 alpha:1];
                    }
                    else if (displayPercentageIntegerMiss >= 75 && displayPercentageIntegerMiss < 80){
                        cell.missToday.textColor = [UIColor orangeColor];
                    }
                    else{
                        cell.missToday.textColor = [UIColor colorWithRed:0.1803 green:0.8 blue:0.4431 alpha:1];
                    }
                    
                    //Attend Today
                    float calculatedPercentageAttend = (float) ([currentClass.attendance.attended floatValue] + 1) / ([currentClass.attendance.conducted floatValue] + 1);
                    float displayPercentageIntegerAttend = ceil(calculatedPercentageAttend * 100);
                    NSString *displayPercentageAttend = [NSString stringWithFormat:@"%1.0f",displayPercentageIntegerAttend];
                    cell.attendToday.text = [displayPercentageAttend stringByAppendingString:@"%"];
                    
                    
                    if(displayPercentageIntegerAttend < 75){
                        cell.attendToday.textColor = [UIColor colorWithRed:0.9058 green:0.2980 blue:0.2352 alpha:1];
                    }
                    else if (displayPercentageIntegerAttend >= 75 && displayPercentageIntegerAttend < 80){
                        cell.attendToday.textColor = [UIColor orangeColor];
                    }
                    else{
                        cell.attendToday.textColor = [UIColor colorWithRed:0.1803 green:0.8 blue:0.4431 alpha:1];
                    }
                
            }
            @catch (NSException *exception) {
                NSLog(@"Error at 2: %@", [exception description]);
            }

            
        
        
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
            if([self.todaysTimeTable[i] isKindOfClass:[Subject class]]){
                if([self.legibleTimeTable[indexPath.row] isEqual:self.todaysTimeTable[i]]){
                    index = i;
                    break;
                }
            }
            
        }
        
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"UpcomingClassCell" owner:self options:nil];
        UpcomingClassCell *cell = [nib objectAtIndex:0];
        
        Subject *theSubject =  self.legibleTimeTable[indexPath.row];
        
        cell.subjectTitle.text = theSubject.title;
        cell.subjectVenue.text = theSubject.venue;
        cell.subjectSlot.text = theSubject.slot;
        
        UIFont *titleFont = [UIFont fontWithName:@"MuseoSans-300" size:15];
        [cell.subjectTitle setFont:titleFont];
        
        UIFont *venueFont = [UIFont fontWithName:@"MuseoSans-300" size:20];
        [cell.subjectVenue setFont:venueFont];
        
        UIFont *slotFont = [UIFont fontWithName:@"MuseoSans-300" size:18];
        [cell.subjectSlot setFont:slotFont];
        
        UIFont *greyedFont = [UIFont fontWithName:@"MuseoSans-300" size:13];
        [cell.greyedText setFont:greyedFont];
        
        
        
        NSDateComponents *rightNow = [[NSCalendar currentCalendar] components:NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit fromDate:[NSDate date]];
        
        NSString *suffix = @"AM";
        int time = [self.timeSlots[(2*index)+1] hour];
        
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"EEEE"];
        NSString *todaysDay = [dateFormatter stringFromDate:[NSDate date]];
        
        BOOL weekend = NO;
        
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
            weekend = YES;
        }
        
        
        if(!weekend){
            if([rightNow hour] > time /*&& [rightNow minute] > 50*/){
                cell.subjectStartingIn.text = @"class finished";
                cell.subjectStartingIn.textColor = [UIColor colorWithRed:0.203 green:0.286 blue:0.386 alpha:1];
            }
            else{
                if(time > 12){
                    suffix = @"PM";
                    time = time - 12;
                }
                if(time == 12){
                    suffix = @"PM";
                }
                cell.subjectStartingIn.text = [NSString stringWithFormat:@"Begins at %d %@", time, suffix];
                cell.subjectStartingIn.textColor = [UIColor colorWithRed:0.203 green:0.286 blue:0.386 alpha:1];
            }
        }
        else{
            if(time > 12){
                suffix = @"PM";
                time = time - 12;
            }
            if(time == 12){
                suffix = @"PM";
            }
            cell.subjectStartingIn.text = [NSString stringWithFormat:@"Begins at %d %@", time, suffix];
            cell.subjectStartingIn.textColor = [UIColor colorWithRed:0.203 green:0.286 blue:0.386 alpha:1];
        }
        
        @try {
            if([self.legibleTimeTable[indexPath.row] isEqual:currentClass]){
                cell.subjectStartingIn.text = @"in progress";
                cell.subjectStartingIn.textColor = [UIColor colorWithRed:0.1803 green:0.8 blue:0.4431 alpha:1];
            }
        }
        @catch (NSException *exception) {
            NSLog(@"Exception in writing 'in progress': %@", [exception description]);
        }

        
        
        
        
        @try {
            //Attendance Part:
            
                float calculatedPercentage = (float) [theSubject.attendance.attended floatValue] / [theSubject.attendance.conducted floatValue];
                float displayPercentageInteger = ceil(calculatedPercentage * 100);
                NSString *displayPercentage = [NSString stringWithFormat:@"%1.0f",displayPercentageInteger];
                cell.subjectPercentage.text = [displayPercentage stringByAppendingString:@"%"];
                
                
                if(displayPercentageInteger < 75){
                    cell.subjectPercentage.textColor = [UIColor colorWithRed:0.9058 green:0.2980 blue:0.2352 alpha:1];
                }
                else if (displayPercentageInteger >= 75 && displayPercentageInteger < 80){
                    cell.subjectPercentage.textColor = [UIColor orangeColor];
                }
                else{
                    cell.subjectPercentage.textColor = [UIColor colorWithRed:0.1803 green:0.8 blue:0.4431 alpha:1];
                }
                
                UIFont *percentageFont = [UIFont fontWithName:@"MuseoSans-300" size:18];
                [cell.subjectPercentage setFont:percentageFont];
            }
            /*else{
                [cell.subjectPercentage setFont:greyedFont];
                cell.subjectPercentage.text = @"attendance not yet available";
            }*/

        @catch (NSException *exception) {
            NSLog(@"Error at 3: %@", [exception description]);
        }

    
        return cell;
    }
    
    else{
        UITableViewCell *cell = [[UITableViewCell alloc] init];
        return cell;
    }
    
}


- (IBAction)notificationButtonPressed:(id)sender {
    
    // Abandoning Notifcations until I find a better solution.
    /*
    NotificationViewController *notificationController = [[NotificationViewController alloc] init];
    UINavigationController *temp = [[UINavigationController alloc] init];
    
    temp.viewControllers = @[notificationController];
    [self.navigationController presentViewController:temp animated:YES completion:nil];
    notificationController.subjects = [[DataManager sharedManager] getAllSubjects];
     */
    
}
@end
