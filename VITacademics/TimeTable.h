//
//  TimeTable.h
//  VITacademics
//
//  Created by Sids on 11/15/13.
//  Copyright (c) 2013 Siddharth Gupta. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Subject.h"

@interface TimeTable : NSObject

@property NSArray *subjects;

- (void)printArrays;
- (id)initWithTTString:(NSString *)TimeTableString;
- (void)parseSubjectAndAddToTT:(Subject *)subject;
- (NSString *)extractSlotNumber:(NSString *)originalString;
- (int)getEndRange:(NSString *)originalString;
- (void)addLabSlotsToTT:(int)slot subject:(Subject *)subject;
-(NSMutableArray *)getTimeSlotArray;

-(id)getCurrentClass;
-(NSMutableArray *)getTodaysTimeTable;
- (BOOL)todayIsAWeekend;

@property (retain) NSMutableArray *monday;
@property (retain) NSMutableArray *tuesday;
@property (retain) NSMutableArray *wednesday;
@property (retain) NSMutableArray *thursday;
@property (retain) NSMutableArray *friday;
@property (retain) NSMutableArray *todaysTimeTable;



@end
