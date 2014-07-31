//
//  Friend+Operations.h
//  VITacademics
//
//  Created by Siddharth on 19/04/14.
//  Copyright (c) 2014 Siddharth Gupta. All rights reserved.
//

#import "Friend.h"

@interface Friend (Operations)
+ (void) insertFriendWithName:(NSString *) name
                withTimetable: (NSString *)timeTable
                  withPicture:(NSData *)picture
               withFacebookID:(NSString *)facebookID
       withRegistrationNumber:(NSString *)registrationNumber
              withDateOfBirth:(NSString *)dateOfBirth
                  WithContext:(NSManagedObjectContext *) context;

+ (BOOL) checkForFriendWithRegistrationNumber:(NSString *)regNo withContext:(NSManagedObjectContext *)context;
@end
