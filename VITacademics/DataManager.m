//
//  DataManager.m
//  VITacademics
//
//  Created by Siddharth on 02/02/14.
//  Copyright (c) 2014 Siddharth Gupta. All rights reserved.
//

#import "DataManager.h"
#import "Subjects.h"
#import "Subject.h"

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


- (NSMutableArray *)parseWithAttendanceString{
    NSError *e = nil;
    NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
    NSString *newString = [[preferences stringForKey:[preferences stringForKey:@"registrationNumber"]] stringByReplacingOccurrencesOfString:@"valid%" withString:@""];
    NSData *attendanceDataFromString = [newString dataUsingEncoding:NSUTF8StringEncoding];
    NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData: attendanceDataFromString options: NSJSONReadingMutableContainers error: &e];
    NSMutableArray *refreshedArray = [[NSMutableArray alloc] init];
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
            
            Subject *x = [[Subject alloc] initWithSubject:[item valueForKey:@"code"] title:[item valueForKey:@"title"] slot:[item valueForKey:@"slot"] attended:[[item valueForKey:@"attended"] integerValue] conducted:[[item valueForKey:@"conducted"] integerValue] number:[[item valueForKey:@"sl_no"] integerValue] type:[item valueForKey:@"type"] details:[item valueForKey:@"details"] classNumber:[item valueForKey:@"classnbr"]];
            
            [refreshedArray addObject:x];
            
        } //end of for
    }

    return refreshedArray;
}



@end
