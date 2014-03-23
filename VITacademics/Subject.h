//
//  Subject.h
//  VITacademics
//
//  Created by Siddharth on 23/03/14.
//  Copyright (c) 2014 Siddharth Gupta. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Attendance, Marks;

@interface Subject : NSManagedObject

@property (nonatomic, retain) NSString * classNumber;
@property (nonatomic, retain) NSString * slot;
@property (nonatomic, retain) NSString * code;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * type;
@property (nonatomic, retain) NSString * venue;
@property (nonatomic, retain) NSString * faculty;
@property BOOL *notification;
@property (nonatomic, retain) Marks *marks;
@property (nonatomic, retain) Attendance *attendance;

@end
