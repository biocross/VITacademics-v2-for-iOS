//
//  TimeTable.m
//  VITacademics
//
//  Created by Sids on 11/15/13.
//  Copyright (c) 2013 Siddharth Gupta. All rights reserved.
//

#import "TimeTable.h"

@interface TimeTable () {
}

@end

@implementation TimeTable

-(id)initWithTTString: (NSString *)TimeTableString{
    
    [self initArrays];
    
    
    NSError *e = nil;
    //NSString *newString = [TimeTableString stringByReplacingOccurrencesOfString:@"valid%" withString:@""];
    NSData *ttDataFromString = [TimeTableString dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *jsonArray = [NSJSONSerialization JSONObjectWithData: ttDataFromString options: NSJSONReadingMutableContainers error: &e];
    
    //NSLog(@"%@", [jsonArray description]);
    
    NSArray *subjects = [jsonArray valueForKey:@"subjects"];
    
    if (!jsonArray) {
        NSLog(@"Error parsing JSON: %@", e);
    }
    else{
        NSLog(@"TimeTable Parsed!");
        for(NSDictionary *item in subjects){
            [self parseSubjectAndAddToTT: item];
        }
    }
    
    return self;
}


- (void) initArrays{
    _monday = [[NSMutableArray alloc] init];
    _tuesday = [[NSMutableArray alloc] init];
    _wednesday = [[NSMutableArray alloc] init];
    _thursday = [[NSMutableArray alloc] init];
    _friday = [[NSMutableArray alloc] init];
    
    for (int i=0; i<12; i++){
        NSString *temp = [NSString stringWithFormat:@"%d", i];
        [_monday addObject:temp];
        [_tuesday addObject:temp];
        [_wednesday addObject:temp];
        [_thursday addObject:temp];
        [_friday addObject:temp];
    }
    
}

- (void) printArrays{
    [_monday replaceObjectAtIndex:0 withObject:@"yay"];
    NSLog(@"Here's monday \n %@", [_monday description]);
}

-(id)getCurrentClass{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit fromDate:[NSDate date]];
    NSInteger currentHour = [components hour];
    NSInteger currentMinute = [components minute];
    
    
    id currentClass;
    
    if(currentHour >= 8 && currentMinute <50){
        currentClass = self.todaysTimeTable[0];
    }
    if(currentHour >= 9 && currentMinute <50){
        currentClass = self.todaysTimeTable[1];
    }
    if(currentHour >= 10 && currentMinute <50){
        currentClass = self.todaysTimeTable[2];
    }
    if(currentHour >= 11 && currentMinute <50){
        currentClass = self.todaysTimeTable[3];
    }
    if(currentHour >= 12 && currentMinute <50){
        currentClass = self.todaysTimeTable[4];
    }
    
    
    if(currentHour >= 14 && currentMinute <50){
        currentClass = self.todaysTimeTable[5];
    }
    if(currentHour >= 15 && currentMinute <50){
        currentClass = self.todaysTimeTable[6];
    }
    if(currentHour >= 16 && currentMinute <50){
        currentClass = self.todaysTimeTable[7];
    }
    if(currentHour >= 17 && currentMinute <50){
        currentClass = self.todaysTimeTable[8];
    }
    if(currentHour >= 18 && currentMinute <50){
        currentClass = self.todaysTimeTable[9];
    }
    
    
    return currentClass;
}

-(NSMutableArray *)getTodaysTimeTable{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"EEEE"];
    NSString *todaysDay = [dateFormatter stringFromDate:[NSDate date]];
    
    
    self.todaysTimeTable = [[NSMutableArray alloc] init];
    
    if([todaysDay isEqualToString:@"Monday"]){
        self.todaysTimeTable = _monday;
    }
    else if([todaysDay isEqualToString:@"Tuesday"]){
        self.todaysTimeTable = _tuesday;
    }
    else if([todaysDay isEqualToString:@"Wednesday"]){
        self.todaysTimeTable = _wednesday;
    }
    else if([todaysDay isEqualToString:@"Thursday"]){
        self.todaysTimeTable = _thursday;
    }
    else if([todaysDay isEqualToString:@"Friday"]){
        self.todaysTimeTable = _friday;
    }
    else{
        self.todaysTimeTable = _monday;
    }
    
    
    /*
    NSMutableArray *legibleTimetable = [[NSMutableArray alloc] init];
    
    
    NSInteger length = [self.todaysTimeTable count];
    for(int i = 0 ; i<length ; i++){
        if([self.todaysTimeTable[i] isKindOfClass:[NSDictionary class]]){
            [legibleTimetable addObject:self.todaysTimeTable[i]];
        }
    }
    */
    
    return self.todaysTimeTable;
}



-(void)parseSubjectAndAddToTT:(NSDictionary *)subject{
    NSString *slot = [subject objectForKey:@"slot"];
    BOOL hasTutorial = NO;
    BOOL isLab = NO;
    
    if([slot rangeOfString:@"L"].location != NSNotFound){
        isLab = YES;
    }
    
    if(!isLab){
        //Subject is not a lab, proceeding with theory parsing:
        
        if([slot length] > 2){
            hasTutorial = YES;
        }
        
        int skippyBoy = 0;
        
        if([slot rangeOfString:@"A"].location != NSNotFound){
            if([slot rangeOfString:@"1"].location != NSNotFound){
                skippyBoy = 0;
            }
            if([slot rangeOfString:@"2"].location != NSNotFound){
                skippyBoy = 6;
            }
            
            [_monday replaceObjectAtIndex:skippyBoy+0 withObject:subject];
            [_thursday replaceObjectAtIndex:skippyBoy+1 withObject:subject];
            
            
            if(hasTutorial){
                [_tuesday replaceObjectAtIndex:skippyBoy+3 withObject:subject];
            }
        }
        
        if([slot rangeOfString:@"B"].location != NSNotFound){
            if([slot rangeOfString:@"1"].location != NSNotFound){
                skippyBoy = 0;
            }
            if([slot rangeOfString:@"2"].location != NSNotFound){
                skippyBoy = 6;
            }
            
            [_tuesday replaceObjectAtIndex:skippyBoy+0 withObject:subject];
            [_friday replaceObjectAtIndex:skippyBoy+1 withObject:subject];
            
            
            if(hasTutorial){
                [_wednesday replaceObjectAtIndex:skippyBoy+3 withObject:subject];
            }
        }
        
        if([slot rangeOfString:@"C"].location != NSNotFound){
            if([slot rangeOfString:@"1"].location != NSNotFound){
                skippyBoy = 0;
            }
            if([slot rangeOfString:@"2"].location != NSNotFound){
                skippyBoy = 6;
            }
            
            [_monday replaceObjectAtIndex:skippyBoy+2 withObject:subject];
            [_wednesday replaceObjectAtIndex:skippyBoy+0 withObject:subject];
            [_thursday replaceObjectAtIndex:skippyBoy+3 withObject:subject];
            
            
            if(hasTutorial){
                [_friday replaceObjectAtIndex:skippyBoy+4 withObject:subject];
            }
        }
        
        if([slot rangeOfString:@"D"].location != NSNotFound){
            if([slot rangeOfString:@"1"].location != NSNotFound){
                skippyBoy = 0;
            }
            if([slot rangeOfString:@"2"].location != NSNotFound){
                skippyBoy = 6;
            }
            
            [_tuesday replaceObjectAtIndex:skippyBoy+2 withObject:subject];
            [_thursday replaceObjectAtIndex:skippyBoy+0 withObject:subject];
            [_friday replaceObjectAtIndex:skippyBoy+3 withObject:subject];
            
            
            if(hasTutorial){
                [_monday replaceObjectAtIndex:skippyBoy+4 withObject:subject];
            }
        }
        
        if([slot rangeOfString:@"E"].location != NSNotFound){
            if([slot rangeOfString:@"1"].location != NSNotFound){
                skippyBoy = 0;
            }
            if([slot rangeOfString:@"2"].location != NSNotFound){
                skippyBoy = 6;
            }
            
            [_monday replaceObjectAtIndex:skippyBoy+3 withObject:subject];
            [_wednesday replaceObjectAtIndex:skippyBoy+2 withObject:subject];
            [_friday replaceObjectAtIndex:skippyBoy+0 withObject:subject];
            
            
            if(hasTutorial){
                [_thursday replaceObjectAtIndex:skippyBoy+4 withObject:subject];
            }
        }
        
        if([slot rangeOfString:@"F"].location != NSNotFound){
            if([slot rangeOfString:@"1"].location != NSNotFound){
                skippyBoy = 0;
            }
            if([slot rangeOfString:@"2"].location != NSNotFound){
                skippyBoy = 6;
            }
            
            [_monday replaceObjectAtIndex:skippyBoy+1 withObject:subject];
            [_wednesday replaceObjectAtIndex:skippyBoy+1 withObject:subject];
            [_thursday replaceObjectAtIndex:skippyBoy+2 withObject:subject];
            
            
            if(hasTutorial){
                [_tuesday replaceObjectAtIndex:skippyBoy+4 withObject:subject];
            }
        }
        
        if([slot rangeOfString:@"G"].location != NSNotFound){
            
            if([slot rangeOfString:@"1"].location != NSNotFound){
                skippyBoy = 0;
            }
            if([slot rangeOfString:@"2"].location != NSNotFound){
                skippyBoy = 6;
            }
            
            [_tuesday replaceObjectAtIndex:skippyBoy+1 withObject:subject];
            [_friday replaceObjectAtIndex:skippyBoy+2 withObject:subject];
            
            
            if(hasTutorial){
                [_wednesday replaceObjectAtIndex:skippyBoy+4 withObject:subject];
            }
        }
        
    }
    
    else{
        NSMutableArray *finalSlots = [[NSMutableArray alloc] init];
        NSString *temp = [[NSString alloc] init];
        
        slot = [NSString stringWithFormat:@"%@+", slot];
        
        while([slot length] != 0){
            temp = [self extractSlotNumber:slot];
            [finalSlots addObject:temp];
            slot = [slot substringFromIndex:[self getEndRange:slot] + 1];
            }
        
        int length = [finalSlots count];
        for(int i=0 ; i<length ; i++){
            [self addLabSlotsToTT:[finalSlots[i] integerValue] subject:subject];
        }
    }
  
}

-(void)addLabSlotsToTT:(int)slot subject:(NSDictionary *)subject{
    
    int skippyBoy = 0;
    if(slot > 30){
        skippyBoy = 6;
        slot = slot - 30;
    }
    
    if(slot < 7){
        [_monday replaceObjectAtIndex:slot-1+skippyBoy withObject:subject];
    }
    else if(slot > 6 && slot < 13){
        [_tuesday replaceObjectAtIndex:slot-7+skippyBoy withObject:subject];
    }
    else if(slot > 12 && slot < 19){
        [_wednesday replaceObjectAtIndex:slot-13+skippyBoy withObject:subject];
    }
    else if(slot > 18 && slot < 25){
        [_thursday replaceObjectAtIndex:slot-19+skippyBoy withObject:subject];
    }
    else if(slot > 24 && slot < 31){
        [_friday replaceObjectAtIndex:slot-25+skippyBoy withObject:subject];
    }
    
}



- (NSString *)extractSlotNumber:(NSString *)original{
    NSRange startRange = [original rangeOfString:@"L"];
    NSRange endRange = [original rangeOfString:@"+"];
    NSRange searchRange = NSMakeRange(startRange.location+1, endRange.location-1);
    NSString *temp = [original substringWithRange:searchRange];
    
    return temp;
}

-(int)getEndRange:(NSString *)originalString{
    NSRange endRange = [originalString rangeOfString:@"+"];
    return endRange.location;
}

-(NSMutableArray *)getTimeSlotArray{
    NSMutableArray *timeSlots = [[NSMutableArray alloc] init];
    
    for(int i=0; i<5; i++){
        NSDateComponents *components = [[NSCalendar currentCalendar] components:NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit fromDate:[NSDate date]];
        [components setHour:8+i];
        [components setMinute:0];
        [components setSecond:0];
        [timeSlots addObject:components];
    }
    
    NSDateComponents *components1 = [[NSCalendar currentCalendar] components:NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit fromDate:[NSDate date]];
    [components1 setHour:12];
    [components1 setMinute:0];
    [components1 setSecond:0];
    [timeSlots addObject:components1];
   
    for(int i=0; i<5; i++){
        NSDateComponents *components = [[NSCalendar currentCalendar] components:NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit fromDate:[NSDate date]];
        [components setHour:14+i];
        [components setMinute:0];
        [components setSecond:0];
        [timeSlots addObject:components];
    }
    
    NSDateComponents *components2 = [[NSCalendar currentCalendar] components:NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit fromDate:[NSDate date]];
    [components2 setHour:18];
    [components2 setMinute:0];
    [components2 setSecond:0];
    [timeSlots addObject:components2];
    
    return timeSlots;
}





@end
