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

    self.subjects = [[NSArray alloc] init];
    self.subjects = [[DataManager sharedManager] getAllSubjects];
    
    for (Subject *subject in self.subjects){
        [self parseSubjectAndAddToTT: subject];
        //NSLog(@"Now working on %@ ", subject.title);
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

- (BOOL)todayIsAWeekend{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"EEEE"];
    NSString *todaysDay = [dateFormatter stringFromDate:[NSDate date]];
    
    BOOL weekend = NO;
    
    if([todaysDay isEqualToString:@"Monday"]){
    }
    else if([todaysDay isEqualToString:@"Tuesday"]){
    }
    else if([todaysDay isEqualToString:@"Wednesday"]){
    }
    else if([todaysDay isEqualToString:@"Thursday"]){
        
    }
    else if([todaysDay isEqualToString:@"Friday"]){
    }
    else{
        weekend = YES;
    }
    
    return weekend;

}


-(id)getCurrentClass{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit fromDate:[NSDate date]];
    NSInteger currentHour = [components hour];
    NSInteger currentMinute = [components minute];
    
    id currentClass;
    NSArray *timeSlots = [self getTimeSlotArray];
    
    for(int i=0; i<23 ; i++){
        
        NSInteger initialHour = [timeSlots[i] hour];
        NSInteger initialMinute = [timeSlots[i] minute];
        
        NSInteger finalHour = [timeSlots[i+1] hour];
        //NSInteger finalMinute = [timeSlots[i+1] minute];
        
        if(![self todayIsAWeekend]){
            
            if(!i%2){
                //even - it's a gap
                if(currentHour == initialHour && currentMinute > initialMinute && currentHour < finalHour ){
                    //NSLog(@"It's a gap right now between %@ and %@", [timeSlots[i] description], [timeSlots[i+1] description]);
                    break;
                }
                
            }
            else{
                //it's a class
                if(currentHour == initialHour && currentMinute > initialMinute ){
                    //NSLog(@"It's a class right now between %@ and %@", [timeSlots[i] description], [timeSlots[i+1] description]);
                    return self.todaysTimeTable[((i-1)/2)];
                    break;
                }
            }
        
        
        } //end of !weekend
        
        
    }
    
    
    
    /*
    if(![self todayIsAWeekend]){
        
        
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
        if(currentHour >= 13 && currentMinute <30){
            currentClass = self.todaysTimeTable[5];
        }
        if(currentHour >= 14 && currentMinute <50){
            currentClass = self.todaysTimeTable[6];
        }
        if(currentHour >= 15 && currentMinute <50){
            currentClass = self.todaysTimeTable[7];
        }
        if(currentHour >= 16 && currentMinute <50){
            currentClass = self.todaysTimeTable[8];
        }
        if(currentHour >= 17 && currentMinute <50){
            currentClass = self.todaysTimeTable[9];
        }
        if(currentHour >= 18 && currentMinute <50){
            currentClass = self.todaysTimeTable[10];
        }
        if(currentHour >= 19 && currentMinute <30){
            currentClass = self.todaysTimeTable[11];
        }
    }
    */
    
    
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



-(void)parseSubjectAndAddToTT:(Subject *)subject{
    NSString *slot = subject.slot;
    BOOL hasTutorial = NO;
    BOOL isLab = NO;
    
    if([slot rangeOfString:@"L"].location != NSNotFound){
        if([slot rangeOfString:@"+"].location != NSNotFound){
           isLab = YES;
        }
        else{
            NSLog(@"Subject with slot %@ not added to TT", slot);
        }
        
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

-(void)addLabSlotsToTT:(int)slot subject:(Subject *)subject{
    
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
    
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit fromDate:[NSDate date]];
    [components setHour:7];
    [components setMinute:30];
    [components setSecond:0];
    [timeSlots addObject:[components copy]];
    

    [components setHour:8];
    [components setMinute:00];
    [components setSecond:0];
    [timeSlots addObject:[components copy]];
    
    [components setHour:8];
    [components setMinute:50];
    [components setSecond:0];
    [timeSlots addObject:[components copy]];
    
    [components setHour:9];
    [components setMinute:00];
    [components setSecond:0];
    [timeSlots addObject:[components copy]];
    
    [components setHour:9];
    [components setMinute:50];
    [components setSecond:0];
    [timeSlots addObject:[components copy]];
    
    [components setHour:10];
    [components setMinute:00];
    [components setSecond:0];
    [timeSlots addObject:[components copy]];
    
    [components setHour:10];
    [components setMinute:50];
    [components setSecond:0];
    [timeSlots addObject:[components copy]];
    
    [components setHour:11];
    [components setMinute:00];
    [components setSecond:0];
    [timeSlots addObject:[components copy]];
    
    [components setHour:11];
    [components setMinute:50];
    [components setSecond:0];
    [timeSlots addObject:[components copy]];
    
    [components setHour:12];
    [components setMinute:00];
    [components setSecond:0];
    [timeSlots addObject:[components copy]];
    
    [components setHour:12];
    [components setMinute:50];
    [components setSecond:0];
    [timeSlots addObject:[components copy]];
    
    [components setHour:13];
    [components setMinute:30];
    [components setSecond:0];
    [timeSlots addObject:[components copy]];
    
    //Afternoon Begins
    [components setHour:13];
    [components setMinute:30];
    [components setSecond:0];
    [timeSlots addObject:[components copy]];
    
    [components setHour:14];
    [components setMinute:00];
    [components setSecond:0];
    [timeSlots addObject:[components copy]];
    
    [components setHour:14];
    [components setMinute:50];
    [components setSecond:0];
    [timeSlots addObject:[components copy]];
    
    [components setHour:15];
    [components setMinute:00];
    [components setSecond:0];
    [timeSlots addObject:[components copy]];
    
    [components setHour:15];
    [components setMinute:50];
    [components setSecond:0];
    [timeSlots addObject:[components copy]];
    
    [components setHour:16];
    [components setMinute:00];
    [components setSecond:0];
    [timeSlots addObject:[components copy]];
    
    [components setHour:16];
    [components setMinute:50];
    [components setSecond:0];
    [timeSlots addObject:[components copy]];
    
    [components setHour:17];
    [components setMinute:00];
    [components setSecond:0];
    [timeSlots addObject:[components copy]];
    
    [components setHour:17];
    [components setMinute:50];
    [components setSecond:0];
    [timeSlots addObject:[components copy]];
    
    [components setHour:18];
    [components setMinute:00];
    [components setSecond:0];
    [timeSlots addObject:[components copy]];
    
    [components setHour:18];
    [components setMinute:50];
    [components setSecond:0];
    [timeSlots addObject:[components copy]];
    
    [components setHour:19];
    [components setMinute:30];
    [components setSecond:0];
    [timeSlots addObject:[components copy]];

    return timeSlots;
}





@end
