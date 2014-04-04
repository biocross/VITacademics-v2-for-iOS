//
//  Attendance.h
//  VITacademics
//
//  Created by Siddharth on 02/04/14.
//  Copyright (c) 2014 Siddharth Gupta. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Subject;

@interface Attendance : NSManagedObject

@property (nonatomic, retain) NSData * attendanceDetails;
@property (nonatomic, retain) NSNumber * attended;
@property (nonatomic, retain) NSNumber * conducted;
@property (nonatomic, retain) NSString * percentage;
@property (nonatomic, retain) NSString * type;
@property (nonatomic, retain) Subject *subject;

@end
