//
//  Marks+Operations.h
//  VITacademics
//
//  Created by Siddharth on 23/03/14.
//  Copyright (c) 2014 Siddharth Gupta. All rights reserved.
//

#import "Marks.h"

@interface Marks (Operations)

+ (Marks *) insertMarksForSubjectWithClassNumber:(NSString *)classNumber
                                        withCAT1:(NSInteger) cat1
                                        withCAT2:(NSInteger) cat2
                                       withQuiz1:(NSInteger) q1
                                       withQuiz2:(NSInteger) q2
                                       withQuiz3:(NSInteger) q3
                                  withAssignment:(NSInteger) assignment
                                     withContext:(NSManagedObjectContext *) context;

@end
