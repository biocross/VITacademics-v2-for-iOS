//
//  Friend+Operations.m
//  VITacademics
//
//  Created by Siddharth on 19/04/14.
//  Copyright (c) 2014 Siddharth Gupta. All rights reserved.
//

#import "Friend+Operations.h"

@implementation Friend (Operations)

+(void)insertFriendWithName:(NSString *)name withTimetable:(NSString *)timeTable withPicture:(NSData *)picture withFacebookID:(NSString *)facebookID withRegistrationNumber:(NSString *)registrationNumber withDateOfBirth:(NSString *)dateOfBirth WithContext:(NSManagedObjectContext *)context
{
    Friend *friend = [NSEntityDescription insertNewObjectForEntityForName:@"Friend" inManagedObjectContext:context];
    friend.name = name;
    friend.timetable = timeTable;
    friend.facebookID = facebookID;
    friend.registrationNumber = registrationNumber;
    friend.dateOfBirth = dateOfBirth;
    
    if(picture){
        friend.picture = picture;
    }
    
    NSError *error = nil;
    if (![context save:&error]) {
        NSLog(@"Can't Save Friend! %@ %@", error, [error localizedDescription]);
    }
    else{
        NSLog(@"Saved in Friend Operations: %@", friend.name);
    }
}
@end
