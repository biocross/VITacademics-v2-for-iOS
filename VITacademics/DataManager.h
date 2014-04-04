//
//  DataManager.h
//  VITacademics
//
//  Created by Siddharth on 02/02/14.
//  Copyright (c) 2014 Siddharth Gupta. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataManager : NSObject


@property (nonatomic, retain) NSMutableArray *refreshedArray;

+ (id)sharedManager;
- (void)parseTTString;
- (void)parseMarksString;
- (void)parseAttendanceString;
- (NSArray *)getAllSubjects;
- (int)initializeDataSources;
@property NSManagedObjectContext *context;

@end
