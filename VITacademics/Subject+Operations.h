//
//  Subject+Operations.h
//  VITacademics
//
//  Created by Siddharth on 23/03/14.
//  Copyright (c) 2014 Siddharth Gupta. All rights reserved.
//

#import "Subject.h"

@interface Subject (Operations)

+ (void) insertSubjectWithTitle:(NSString *) title
                       WithCode:(NSString *) code
                WithClassNumber:(NSString *) classNumber
                    WithFaculty:(NSString *) faculty
                       WithSlot:(NSString *) slot
                      WithVenue:(NSString *) venue
        WithNotificationEnabled:(BOOL) notificationToggle
                  WithAttendace:(Attendance *) attendance
                      WithMarks:(Marks *) Marks
                    WithContext:(NSManagedObjectContext *) context;
@end
