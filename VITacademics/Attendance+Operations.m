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
                                       WithContext:(NSManagedObjectContext *) context
{
    Attendance *oldAttendance,*attendance = [NSEntityDescription insertNewObjectForEntityForName:@"Attendance" inManagedObjectContext:context];
    attendance.attendanceDetails = details;
    attendance.conducted = [NSNumber numberWithInt:conducted];
    attendance.attended = [NSNumber numberWithInt:attended];
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Subject"];
    request.predicate = nil;
    request.sortDescriptors = nil;
    NSArray *allSubjects = [context executeFetchRequest:request error:nil];
    for(Subject *subject in allSubjects)
    {
        if(subject.classNumber == classNumber)
        {
            oldAttendance = subject.attendance;
            subject.attendance = attendance;
        }
    }
    return oldAttendance;
}

@end
