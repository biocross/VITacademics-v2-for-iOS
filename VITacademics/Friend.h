//
//  Friend.h
//  VITacademics
//
//  Created by Siddharth on 20/04/14.
//  Copyright (c) 2014 Siddharth Gupta. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Friend : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * timetable;
@property (nonatomic, retain) NSData * picture;
@property (nonatomic, retain) NSString * facebookID;
@property (nonatomic, retain) NSString * registrationNumber;
@property (nonatomic, retain) NSString * dateOfBirth;

@end
