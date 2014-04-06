//
//  MasterViewController.m
//  Test2
//
//  Created by Siddharth Gupta on 5/7/13.
//  Copyright (c) 2013 Siddharth Gupta. All rights reserved.
//

#import "AttendanceViewController.h"
#import "Subject.h"
#import "DetailViewController.h"
#import "VITxAPI.h"
#import "iPhoneTableViewCell.h"
#import "NSDate+TimeAgo.h"
#import "RootForPageViewController.h"

@interface AttendanceViewController () {
    NSMutableArray *MTheorySubjects;
    NSMutableArray *MLabSubjects;
    NSArray *marksArray;
    NSMutableArray *refreshedArray;
    
    
}
@property (strong, nonatomic) NSArray *subjects;
@end

@implementation AttendanceViewController

/*
-(Subjects *)subjects {
    if(! _subjects){
        _subjects = [[Subjects alloc] init];
    }
    return _subjects;
}
*/



- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)didMoveToParentViewController:(UITableViewController *)parent
{
    // parent is nil if this view controller was removed
}

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refreshAttendance:) forControlEvents:UIControlEventValueChanged];
    [self setRefreshControl:refreshControl];
    
    
    /*
     id tracker = [[GAI sharedInstance] defaultTracker];
     [tracker set:kGAIScreenName
     value:@"Home View (Table)"];
     [tracker send:[[GAIDictionaryBuilder createAppView] build]];
     */
    
    
    //Load Attendance from cache
    NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
    if([preferences stringForKey:@"registrationNumber"]){
        if([preferences stringForKey:[preferences stringForKey:@"registrationNumber"]]){
            //NSLog(@"Loading attendance from cache! Yay!");
            
            //NSString *marksKey = [NSString stringWithFormat:@"MarksOf%@", [preferences objectForKey:@"registrationNumber"]];
            //self.marksCacheString = [preferences objectForKey:marksKey];
            //[self completedProcess];
        }
        else{
            NSLog(@"Attendance is not cached currently for this user");
            UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"No Data Here"
                                                              message:@"It time to load/refresh your attendance!"
                                                             delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                                    otherButtonTitles:@"Refresh", nil];
            
            [message show];
        }
    }
    
    self.subjects = [[DataManager sharedManager] getAllSubjects];
    
    
#pragma mark - Observers
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(startLoadingAttendance:)
     name:@"captchaDidVerify"
     object:nil];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(beginLoadingAttendance)
     name:@"settingsDidChange"
     object:nil];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(showCaptchaError)
     name:@"captchaError"
     object:nil];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(showNetworkError)
     name:@"networkError"
     object:nil];
    
}


-(void)refreshAttendance:(id)sender{
    UIViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"CaptchaView"];
    [self.navigationController pushViewController:vc animated:YES];
    [(UIRefreshControl *)sender endRefreshing];
    
}

-(void)showCaptchaError{
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1f * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        
        [CSNotificationView showInViewController:self style:CSNotificationViewStyleError message:@"Incorrect captcha/credentials"];
        
    });
    
    
}

-(void)showNetworkError{
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1f * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        
        [CSNotificationView showInViewController:self style:CSNotificationViewStyleError message:@"Network Error, Please check your internet connectivity."];
        
    });
}

-(void)beginLoadingAttendance{
    
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Credential Change Detected"
                                                      message:@"Looks like you changed your details. Let's refresh your attendance to reflect this."
                                                     delegate:self
                                            cancelButtonTitle:@"Cancel"
                                            otherButtonTitles:@"Yup", nil];
    [message show];
    
}

#pragma mark - New User Handling
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    if([title isEqualToString:@"Okay"])
    {
        NSLog(@"New user clicked on Okay, now opening Settings.");
        
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
        UIViewController *vc = [sb instantiateViewControllerWithIdentifier:@"SettingsViewNav"];
        [self presentViewController:vc animated:YES completion:NULL];
        
    }
    else if([title isEqualToString:@"Refresh"]){
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
        UIViewController *vc = [sb instantiateViewControllerWithIdentifier:@"CaptchaViewNav"];
        [self presentViewController:vc animated:YES completion:NULL];
    }
    
    else if([title isEqualToString:@"Yup"]){
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
        UIViewController *vc = [sb instantiateViewControllerWithIdentifier:@"CaptchaViewNav"];
        [self presentViewController:vc animated:YES completion:NULL];
    }
    
    
    else if([title isEqualToString:@"Oh Yeah!"]){
        NSLog(@"Opening Google+ Group");
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://plus.google.com/u/0/communities/112543766365145422569"]];
    }
    
    else if([title isEqualToString:@"Not Now"]){
        
        [CSNotificationView showInViewController:self style:CSNotificationViewStyleError message:@"Some other time, then :)"];
        
        
    }
    
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //int subjectsLength = [_subjects count];
    
    //Sort the subjects:
    MTheorySubjects = [[NSMutableArray alloc] init];
    MLabSubjects = [[NSMutableArray alloc] init];
    
    for(Subject *subject in self.subjects){
        if ([subject.attendance.type rangeOfString:@"Theory"].location != NSNotFound){
            [MTheorySubjects addObject:subject];
        }
        else if([subject.attendance.type rangeOfString:@"Lab"].location != NSNotFound){
            [MLabSubjects addObject:subject];
        }
    }
    
    self.theorySubjects = [[NSMutableArray alloc] init];
    self.labSubjects = [[NSMutableArray alloc] init];
    
    [self.theorySubjects setArray:MTheorySubjects];
    [self.labSubjects setArray:MLabSubjects];
    
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int returnValue = 0;
    
    if(section == 0){
        returnValue = [self.theorySubjects count];
    }
    else if(section == 1){
        returnValue = [self.labSubjects count];
    }
    
    return returnValue;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *returnString = @"Others";
    
    if(section == 0)
        returnString = @"Theory";
    if(section == 1)
        returnString = @"Lab";
    
    return returnString;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"iPhoneCellNib" owner:self options:nil];
    iPhoneTableViewCell *cell = [nib objectAtIndex:0];
    
    if(indexPath.section == 0){
        
        Subject *subjectAtRow = self.theorySubjects[indexPath.row];
        cell.subjectTitle.text = subjectAtRow.title;
        cell.subjectTypeAndSlot.text = [NSString stringWithFormat:@"%@ - %@", subjectAtRow.attendance.type, subjectAtRow.slot];
        [cell.subjectTypeAndSlot setTextColor:[UIColor grayColor]];
        
        float calculatedPercentage = (float) [subjectAtRow.attendance.attended intValue] / [subjectAtRow.attendance.conducted intValue];
        float displayPercentageInteger = ceil(calculatedPercentage * 100);
        NSString *displayPercentage = [NSString stringWithFormat:@"%1.0f",displayPercentageInteger];
        cell.percentage.text = [displayPercentage stringByAppendingString:@"%"];
        
        if(displayPercentageInteger < 75){
            //rgb(231, 76, 60)
            cell.percentage.textColor = [UIColor colorWithRed:0.9058 green:0.2980 blue:0.2352 alpha:1];
        }
        else if (displayPercentageInteger >= 75 && displayPercentageInteger < 80){
            cell.percentage.textColor = [UIColor orangeColor];
        }
        else{
            //rgb(46, 204, 113)
            //cell.percentage.textColor = [UIColor colorWithRed:0.21 green:0.72 blue:0.00 alpha:1.0];
            cell.percentage.textColor = [UIColor colorWithRed:0.1803 green:0.8 blue:0.4431 alpha:1];
        }
        
    }
    else{
        Subject *labSubjectAtRow = self.labSubjects[indexPath.row];
        cell.subjectTitle.text = labSubjectAtRow.title;
        cell.subjectTypeAndSlot.text = [NSString stringWithFormat:@"%@ - %@", labSubjectAtRow.attendance.type, labSubjectAtRow.slot];
        [cell.subjectTypeAndSlot setTextColor:[UIColor grayColor]];
        
        float calculatedPercentage =(float) [labSubjectAtRow.attendance.attended intValue] / [labSubjectAtRow.attendance.conducted intValue];
        float displayPercentageInteger = ceil(calculatedPercentage * 100);
        NSString *displayPercentage = [NSString stringWithFormat:@"%1.0f",displayPercentageInteger];
        cell.percentage.text = [displayPercentage stringByAppendingString:@"%"];
        
        if(displayPercentageInteger < 75){
            cell.percentage.textColor = [UIColor redColor];
        }
        else if (displayPercentageInteger >= 75 && displayPercentageInteger < 80){
            cell.percentage.textColor = [UIColor orangeColor];
        }
        else{
            cell.percentage.textColor = [UIColor colorWithRed:0.1803 green:0.8 blue:0.4431 alpha:1];
        }
    }//end of sections clause
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 58;
}



- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    /*
     NSIndexPath *selectedRowIndex = indexPath;
     //UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main_iPad" bundle:nil];
     RootForPageViewController *detailViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"rootForPageView"];
     [self.navigationController pushViewController:detailViewController animated:YES];
     
     if(selectedRowIndex.section == 0){
         int indexOfMatchedSubject = -1;
         int i = 0;
         for(NSArray *item in marksArray){
             if([item[1] isEqualToString:self.theorySubjects[selectedRowIndex.row].classNumber]){
             indexOfMatchedSubject = i;
                 break;
             }
             i += 1;
         }
     
     detailViewController.subject = self.theorySubjects[selectedRowIndex.row];
     
     if(indexOfMatchedSubject < [marksArray count] && indexOfMatchedSubject != -1){
         detailViewController.subjectMarks = marksArray[indexOfMatchedSubject];
     }
     else{
         detailViewController.subjectMarks = [[NSArray alloc] init];
     }
     
     }
     else{
         detailViewController.subject = self.labSubjects[selectedRowIndex.row];
         detailViewController.subjectMarks = [[NSArray alloc] init];
     }
    */
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

#pragma mark - VITx API Calls

- (void)startLoadingAttendance:(id)sender {
    
    
    
    self.notificationController = [CSNotificationView notificationViewWithParentViewController:self tintColor:[UIColor orangeColor] image:nil message:@"Loading Attendance..."];
    [self.notificationController setShowingActivity:YES];
    [self.notificationController setVisible:YES animated:YES completion:nil];
    
    
    
    //getting the regno, dob from preferences.
    NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
    NSString *registrationNumber = [preferences stringForKey:@"registrationNumber"];
    NSString *dateOfBirth = [preferences stringForKey:@"dateOfBirth"];
    
    VITxAPI *attendanceManager = [[VITxAPI alloc] init];
    
    
    dispatch_queue_t downloadQueue = dispatch_queue_create("attendanceLoader", nil);
    dispatch_async(downloadQueue, ^{
        NSString *result = [attendanceManager loadAttendanceWithRegistrationNumber:registrationNumber andDateOfBirth:dateOfBirth];
        NSString *marks = [attendanceManager loadMarksWithRegistrationNumber:registrationNumber andDateOfBirth:dateOfBirth];
        dispatch_async(dispatch_get_main_queue(), ^{
            //update table here!"
            //[alert dismissWithClickedButtonIndex:0 animated:YES];
            [self.notificationController setVisible:NO animated:YES completion:nil];
            
            
            //self.attendanceCacheString = result;
            self.marksCacheString = marks;
            
            [preferences removeObjectForKey:[preferences objectForKey:@"registrationNumber"]];
            [preferences setObject:result forKey:[preferences objectForKey:@"registrationNumber"]];
            NSString *marksKey = [NSString stringWithFormat:@"MarksOf%@", [preferences objectForKey:@"registrationNumber"]];
            [preferences removeObjectForKey:marksKey];
            [preferences setObject:marks forKey:marksKey];
            NSDate *date = [[NSDate alloc] init];
            [preferences setObject:date forKey:@"lastUpdated"];
            
            [self completedProcess];
        });
        
    });//end of GCD
    
}

-(void)completedProcess{
    
        DataManager *sharedManager = [DataManager sharedManager];
        [sharedManager parseAttendanceString];
        self.subjects = [sharedManager getAllSubjects];
        [self.tableView reloadData];
    
        NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
        if([preferences objectForKey:@"lastUpdated"]){
            NSDate *lastUpdated = [preferences objectForKey:@"lastUpdated"];
            NSString *cardMessage = [@"Last Updated: " stringByAppendingString:[lastUpdated timeAgo]];
            
            //Bug Fix fix for Empty Card -> Delay
            double delayInSeconds = 0.05f;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
           
                
                [CSNotificationView showInViewController:self tintColor:[UIColor redColor] image:[UIImage imageNamed:@"CSNotificationView_checkmarkIcon"] message:cardMessage duration:2.5f];
            });
            
            
        }
        [self processMarks];
        
    } //end of else

- (void)processMarks{
    
    NSError *e = nil;
    NSData *attendanceDataFromString = [self.marksCacheString dataUsingEncoding:NSUTF8StringEncoding];
    NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData: attendanceDataFromString options: NSJSONReadingMutableContainers error: &e];
    
    marksArray = jsonArray[0];
    
}

@end
