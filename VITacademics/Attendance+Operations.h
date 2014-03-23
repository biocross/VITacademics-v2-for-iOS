//
//  Attendance+Operations.h
//  VITacademics
//
//  Created by Siddharth on 23/03/14.
//  Copyright (c) 2014 Siddharth Gupta. All rights reserved.
//

#import "Attendance.h"

@interface Attendance (Operations)

+ (Attendance *) insertAttendanceForSubjectWithClassNumber:(NSString *)classNumber
                                               WithDetails:(NSData *)details
                                             WithConducted:(NSInteger) conducted
                                              WithAttended:(NSInteger) attended
                                               WithContext:(NSManagedObjectContext *) context;

@end
