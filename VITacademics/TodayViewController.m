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

    NSString *sampleTTString = @"valid%[{\"sl_no\": \"1\", \"slot\": \"C1\", \"code\": \"ECE201\", \"ltpc\": \"3 0 0 3\", \"bl\": \"CBL\", \"title\": \"Probability Theory and Random Process\", \"venue\": \"TT631\", \"class_nbr\": \"2203\", \"status\": \"Registered and Approved\", \"faculty\": \"CHRISTOPHER CLEMENT J - SENSE\", \"bill_date\": \"NIL / NIL\"}, {\"sl_no\": \"2\", \"slot\": \"F1\", \"code\": \"ECE202\", \"ltpc\": \"3 0 0 3\", \"bl\": \"CBL\", \"title\": \"Transmission Lines and Fields\", \"venue\": \"TT523\", \"class_nbr\": \"2221\", \"status\": \"Registered and Approved\", \"faculty\": \"LAVANYA N - SENSE\", \"bill_date\": \"NIL / NIL\"}, {\"sl_no\": \"3\", \"slot\": \"E1\", \"code\": \"ECE203\", \"ltpc\": \"3 0 0 3\", \"bl\": \"CBL\", \"title\": \"Modulation Techniques\", \"venue\": \"TT332\", \"class_nbr\": \"2232\", \"status\": \"Registered and Approved\", \"faculty\": \"CHRISTINA JOSEPHINE MALATHI A - SENSE\", \"bill_date\": \"NIL / NIL\"}, {\"sl_no\": \"-\", \"slot\": \"L29+L30\", \"code\": \"ECE203\", \"ltpc\": \"0 0 2 1\", \"bl\": \"LBC\", \"title\": \"Modulation Techniques\", \"venue\": \"TT135\", \"class_nbr\": \"3609\", \"status\": \"Registered and Approved\", \"faculty\": \"VINOTH BABU K - SENSE\", \"bill_date\": \"NIL / NIL\"}, {\"sl_no\": \"4\", \"slot\": \"D1\", \"code\": \"ECE204\", \"ltpc\": \"3 0 0 3\", \"bl\": \"PBL\", \"title\": \"Analog Circuit Design\", \"venue\": \"TT630\", \"class_nbr\": \"2252\", \"status\": \"Registered and Approved\", \"faculty\": \"RAJEEV PANKAJ NELAPATI - SENSE\", \"bill_date\": \"NIL / NIL\"}, {\"sl_no\": \"-\", \"slot\": \"L41+L42\", \"code\": \"ECE204\", \"ltpc\": \"0 0 2 1\", \"bl\": \"LBC\", \"title\": \"Analog Circuit Design\", \"venue\": \"TT238\", \"class_nbr\": \"3668\", \"status\": \"Registered and Approved\", \"faculty\": \"SUCHENDRANATH POPURI - SENSE\", \"bill_date\": \"NIL / NIL\"}, {\"sl_no\": \"5\", \"slot\": \"A2+TA2\", \"code\": \"ECE205\", \"ltpc\": \"3 0 0 3\", \"bl\": \"CBL\", \"title\": \"Electrical and Electronic Measurements\", \"venue\": \"TT716\", \"class_nbr\": \"2341\", \"status\": \"Registered and Approved\", \"faculty\": \"KATHIRVELAN J - SENSE\", \"bill_date\": \"NIL / NIL\"}, {\"sl_no\": \"6\", \"slot\": \"B1\", \"code\": \"ENG102\", \"ltpc\": \"2 0 0 2\", \"bl\": \"CBL\", \"title\": \"English for Engineers - II\", \"venue\": \"SMV122\", \"class_nbr\": \"1832\", \"status\": \"Registered and Approved by Academics\", \"faculty\": \"PREETHA R - SSL\", \"bill_date\": \"72228 / 18-Jan-2013\"}, {\"sl_no\": \"-\", \"slot\": \"L51+L52\", \"code\": \"ENG102\", \"ltpc\": \"0 0 2 1\", \"bl\": \"LBC\", \"title\": \"English for Engineers - II\", \"venue\": \"SJT720\", \"class_nbr\": \"3368\", \"status\": \"Registered and Approved by Academics\", \"faculty\": \"PREETHA R - SSL\", \"bill_date\": \"72228 / 18-Jan-2013\"}, {\"sl_no\": \"7\", \"slot\": \"G2\", \"code\": \"HUM121\", \"ltpc\": \"2 0 0 2\", \"bl\": \"PBL\", \"title\": \"Ethics and Values\", \"venue\": \"TT531\", \"class_nbr\": \"1386\", \"status\": \"Registered and Approved\", \"faculty\": \"RAJA RAJESWARI G - SSL\", \"bill_date\": \"NIL / NIL\"}, {\"sl_no\": \"-\", \"slot\": \"L10+L11\", \"code\": \"HUM121\", \"ltpc\": \"0 0 2 1\", \"bl\": \"LBC\", \"title\": \"Ethics and Values\", \"venue\": \"TT335\", \"class_nbr\": \"3534\", \"status\": \"Registered and Approved\", \"faculty\": \"VIJAYARAJ K - SSL\", \"bill_date\": \"NIL / NIL\"}]";
    
    if([preferences objectForKey:@"registrationNumber"]){
        //NSString *ttKey = [NSString stringWithFormat:@"TTOf%@", [preferences objectForKey:@"registrationNumber"]];
        ofToday = [[TimeTable alloc] initWithTTString:sampleTTString];
        

        self.todaysTimeTable = [ofToday getTodaysTimeTable];
        [self.tableView registerClass:[CurrentClassTableViewCell class] forCellReuseIdentifier:@"iPhoneTodayCell"];
        currentClass = [[ofToday getCurrentClass] isKindOfClass:[NSDictionary class]] ? [ofToday getCurrentClass] : 0;
    }
    

    self.tabBarItem.badgeValue = [NSString stringWithFormat:@"%d", [self.todaysTimeTable count]];
    

    
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

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    NSString *string = @"Others";
    
    if(section == 0){
        string = @"Right Now";
    }
    if(section == 1){
        string = @"Coming Up";
    }
    if(section == 2){
        string = @"Notifications";
    }
    
    
    return string;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int rows = 1;
    
    if(section == 1){
        rows = [self.todaysTimeTable count];
    }
    
    return rows;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    int height = 50;
    if(indexPath.section == 0){
        height = 183;
    }
    if(indexPath.section == 1){
        height = 91;
    }
    
    return height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0){
        
    
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CurrentClassTableViewCell" owner:self options:nil];
    CurrentClassTableViewCell *cell = [nib objectAtIndex:0];
    
    if(currentClass){
#warning Harcoded Values
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
        
        
        
        
    }
    else{
        cell.subjectTitle.text = @"No Class right now";
        cell.subjectSlot.text = @"Next one begins in 42 minutes...";
        
        UIFont *titleFont = [UIFont fontWithName:@"MuseoSans-300" size:21];
        [cell.subjectTitle setFont:titleFont];
        
        [cell.greyedText setAlpha:0];
        [cell.ifYou setAlpha:0];
        
        
        
        }
        
    return cell;

    }
    
    else if(indexPath.section == 1){
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"UpcomingClassCell" owner:self options:nil];
        UpcomingClassCell *cell = [nib objectAtIndex:0];
        
        cell.subjectTitle.text = [self.todaysTimeTable[1] objectForKey:@"title"];
        cell.subjectVenue.text = [self.todaysTimeTable[1] objectForKey:@"venue"];
        cell.subjectSlot.text = [self.todaysTimeTable[1] objectForKey:@"slot"];
        
        UIFont *titleFont = [UIFont fontWithName:@"MuseoSans-300" size:15];
        [cell.subjectTitle setFont:titleFont];
        
        UIFont *venueFont = [UIFont fontWithName:@"MuseoSans-300" size:19];
        [cell.subjectVenue setFont:venueFont];
        
        UIFont *slotFont = [UIFont fontWithName:@"MuseoSans-300" size:13];
        [cell.subjectSlot setFont:slotFont];
        
        UIFont *greyedFont = [UIFont fontWithName:@"MuseoSans-300" size:13];
        [cell.greyedText setFont:greyedFont];
        
        UIFont *percentageFont = [UIFont fontWithName:@"MuseoSans-300" size:23];
        [cell.subjectPercentage setFont:percentageFont];
        
        return cell;
    }
    
    else{
        UITableViewCell *cell = [[UITableViewCell alloc] init];
        return cell;
    }
    
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

@end
