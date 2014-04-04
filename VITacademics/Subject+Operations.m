//
//  Subject+Operations.m
//  VITacademics
//
//  Created by Siddharth on 23/03/14.
//  Copyright (c) 2014 Siddharth Gupta. All rights reserved.
//

#import "Subject+Operations.h"
#import "Attendance.h"
#import "Marks.h"

@implementation Subject (Operations)

+ (void) insertSubjectWithTitle:(NSString *) title
                       WithCode:(NSString *) code
                WithClassNumber:(NSString *) classNumber
                    WithFaculty:(NSString *) faculty
                       WithSlot:(NSString *) slot
                      WithVenue:(NSString *) venue
        WithNotificationEnabled:(BOOL) notificationToggle
                  WithAttendace:(Attendance *) attendance
                      WithMarks:(Marks *) marks
                    WithContext:(NSManagedObjectContext *) context
{
    Subject *subject = [NSEntityDescription insertNewObjectForEntityForName:@"Subject" inManagedObjectContext:context];
    subject.title = title;
    subject.code = code;
    subject.classNumber = classNumber;
    subject.faculty = faculty;
    subject.slot = slot;
    subject.venue = venue;
    //subject.notification = notificationToggle;
    subject.marks = marks;
    subject.attendance = attendance;
    NSLog(@"Saved in Subject Operations: %@", subject.title);
}

@end
