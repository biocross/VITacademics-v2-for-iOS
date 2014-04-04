//
//  Marks.h
//  VITacademics
//
//  Created by Siddharth on 02/04/14.
//  Copyright (c) 2014 Siddharth Gupta. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Subject;

@interface Marks : NSManagedObject

@property (nonatomic, retain) NSNumber * assignment;
@property (nonatomic, retain) NSNumber * cat1;
@property (nonatomic, retain) NSNumber * cat2;
@property (nonatomic, retain) NSNumber * quiz1;
@property (nonatomic, retain) NSNumber * quiz2;
@property (nonatomic, retain) NSNumber * quiz3;
@property (nonatomic, retain) Subject *subject;

@end
