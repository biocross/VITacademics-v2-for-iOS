//
//  Attendance+Operations.m
//  VITacademics
//
//  Created by Siddharth on 23/03/14.
//  Copyright (c) 2014 Siddharth Gupta. All rights reserved.
//

#import "Attendance+Operations.h"
#import "Subject.h"

@implementation Attendance (Operations)

+ (Attendance *) insertAttendanceForSubjectWithClassNumber:(NSString *)classNumber
                                       WithDetails:(NSData *)details
                                     WithConducted:(NSInteger) conducted
                                      WithAttended:(NSInteger) attended
                                                  WithType:(NSString *) type
                                       WithContext:(NSManagedObjectContext *) context
{
    Attendance *oldAttendance, *attendance = [NSEntityDescription insertNewObjectForEntityForName:@"Attendance" inManagedObjectContext:context];
    attendance.attendanceDetails = details;
    attendance.conducted = [NSNumber numberWithInt:conducted];
    attendance.attended = [NSNumber numberWithInt:attended];
    attendance.type = type;
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Subject"];
    request.predicate = nil;
    request.sortDescriptors = nil;
    NSArray *allSubjects = [context executeFetchRequest:request error:nil];
    for(Subject *subject in allSubjects)
    {
        NSLog(@"Checking for subject %@ %@ %@", subject.title, subject.classNumber, classNumber);
        if([subject.classNumber isEqualToString:classNumber])
        {
            NSLog(@"Matched subject %@ %@ %@", subject.title, subject.classNumber, classNumber);
            oldAttendance = subject.attendance;
            subject.attendance = attendance;
        }
    }
    return oldAttendance;
}

@end
