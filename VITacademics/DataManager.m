//
//  DataManager.m
//  VITacademics
//
//  Created by Siddharth on 02/02/14.
//  Copyright (c) 2014 Siddharth Gupta. All rights reserved.
//

#import "DataManager.h"
#import "Subject+Operations.h"
#import "Attendance+Operations.h"
#import "Marks+Operations.h"

@implementation DataManager


+ (id)sharedManager{
    static DataManager *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];

    });
    return sharedMyManager;
}

- (id)init {
    if (self = [super init]) {
    }
    return self;
}


- (void)parseTTString{
    
    NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
    
    NSString *ttKey = [NSString stringWithFormat:@"TTOf%@", [preferences objectForKey:@"registrationNumber"]];
    NSString *timeTableString = [preferences objectForKey:ttKey];
    NSError *e = nil;
    NSData *ttDataFromString = [timeTableString dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *jsonArray = [NSJSONSerialization JSONObjectWithData: ttDataFromString options: NSJSONReadingMutableContainers error: &e];
    
    if (!jsonArray) {
        NSLog(@"Error parsing JSON: %@", e);
        }
    else {
        NSArray *subjects = [jsonArray valueForKey:@"subjects"];
        for(NSDictionary *item in subjects) {

            [Subject insertSubjectWithTitle:[item valueForKey:@"title"]
                                   WithCode:[item valueForKey:@"code"]
                            WithClassNumber:[item valueForKey:@"cnum"]
                                WithFaculty:[item valueForKey:@"faculty"]
                                   WithSlot:[item valueForKey:@"slot"] 
                                  WithVenue:[item valueForKey:@"venue"]
                    WithNotificationEnabled:YES
                              WithAttendace:nil
                                  WithMarks:nil
                                WithContext:self.context];
            
        } //end of for
    }
}

- (void) parseAttendanceString
{
    NSError *e = nil;
    NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
    NSString *newString = [[preferences stringForKey:[preferences stringForKey:@"registrationNumber"]] stringByReplacingOccurrencesOfString:@"valid%" withString:@""];
    NSData *attendanceDataFromString = [newString dataUsingEncoding:NSUTF8StringEncoding];
    NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData: attendanceDataFromString options: NSJSONReadingMutableContainers error: &e];
    if (!jsonArray) {
        NSLog(@"Error parsing JSON: %@", e);
        if([newString isEqualToString:@"networkerror"]){
            UIAlertView *errorMessage = [[UIAlertView alloc] initWithTitle:@"Network Error" message:@"There was a problem connecting to the internet. Please check your Data/Wi-Fi connection and try again." delegate:self cancelButtonTitle:@"Okay." otherButtonTitles: nil];
            [errorMessage show];
            
        }
        else if([newString isEqualToString:@"timedout"] || [newString isEqualToString:@"captchaerror"]){
            UIAlertView *errorMessage = [[UIAlertView alloc] initWithTitle:@"Sorry" message:@"Something went wrong. Please try again. If this keeps on happening, please let us know via the \"Help\" section." delegate:self cancelButtonTitle:@"Okay." otherButtonTitles: nil];
            [errorMessage show];
        }
    }
    
    else {
        for(NSDictionary *item in jsonArray)
        {
            NSData *subjectDetails = [NSKeyedArchiver archivedDataWithRootObject:[item valueForKey:@"details"]];
            
            [Attendance insertAttendanceForSubjectWithClassNumber:[item valueForKey:@"classnbr"] WithDetails:subjectDetails WithConducted:[[item valueForKey:@"conducted"] integerValue] WithAttended:[[item valueForKey:@"attended"] integerValue] WithType:[item valueForKey:@"type"] WithContext:self.context];
            
            /*
            unarchiver code:
            NSData *newdata = [NSData dataWithData:self.myEntity.nameOfMyData];
            NSMutableArray *photoArray = [NSMutableArray arrayWithArray: [NSKeyedUnarchiver unarchiveObjectWithData:newdata]];
             */
        }
    }
    
}

-(void)parseMarksString{
    NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
    
    NSString *marksKey = [NSString stringWithFormat:@"MarksOf%@", [preferences objectForKey:@"registrationNumber"]];
    NSString *marksCacheString = [preferences objectForKey:marksKey];
    
    NSError *e = nil;
    NSData *attendanceDataFromString = [marksCacheString dataUsingEncoding:NSUTF8StringEncoding];
    NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData: attendanceDataFromString options: NSJSONReadingMutableContainers error: &e];
    
    NSArray *marksArray = jsonArray[0];
    for(NSArray *item in marksArray){
        if([item count] > 16){
           [Marks insertMarksForSubjectWithClassNumber:item[1] withCAT1:[item[6] floatValue] withCAT2:[item[8] floatValue] withQuiz1:[item[10] floatValue] withQuiz2:[item[12] floatValue] withQuiz3:[item[14] floatValue] withAssignment:[item[16] floatValue] withContext:self.context];
        }
    }
    
    
}

-(NSArray *)getAllSubjects{
    //NSMutableArray *returnArray;
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Subject"];
    request.predicate = nil;
    request.sortDescriptors = nil;
    
    NSArray *allSubjects = [self.context executeFetchRequest:request error:nil];
    /*for(Subject *subject in allSubjects)
    {
        [returnArray addObject:subject];
    }*/
    if([allSubjects count] > 0){
      return allSubjects;
    }
    else{
        return nil;
    }
    
}

-(int)initializeDataSources{
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Subject"];
    request.predicate = nil;
    request.sortDescriptors = nil;
    NSArray *allSubjects = [self.context executeFetchRequest:request error:nil];
    
    if([allSubjects count] < 1){
        [self parseTTString];
        [self parseAttendanceString];
        [self parseMarksString];
        return 1;
    }
    else{
        return 0;
    }
    
}




@end
