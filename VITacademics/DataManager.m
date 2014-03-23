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


- (void)parseAttendanceString{
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
    }//end of if
    else {
        
        for(NSDictionary *item in jsonArray) {

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



@end
