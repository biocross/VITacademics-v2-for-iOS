//
//  Subject.h
//  VITacademics
//
//  Created by Siddharth on 02/04/14.
//  Copyright (c) 2014 Siddharth Gupta. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Attendance.h"
#import "Marks.h"

@interface Subject : NSManagedObject

@property (nonatomic, retain) NSString * classNumber;
@property (nonatomic, retain) NSString * code;
@property (nonatomic, retain) NSString * faculty;
@property (nonatomic) NSNumber *notification;
@property (nonatomic, retain) NSString * slot;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * venue;
@property (nonatomic, retain) Attendance *attendance;
@property (nonatomic, retain) Marks *marks;

@end
