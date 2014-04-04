//
//  Marks+Operations.m
//  VITacademics
//
//  Created by Siddharth on 23/03/14.
//  Copyright (c) 2014 Siddharth Gupta. All rights reserved.
//

#import "Marks+Operations.h"
#import "Subject.h"

@implementation Marks (Operations)

+ (Marks *) insertMarksForSubjectWithClassNumber:(NSString *)classNumber
                                        withCAT1:(NSInteger) cat1
                                        withCAT2:(NSInteger) cat2
                                       withQuiz1:(NSInteger) q1
                                       withQuiz2:(NSInteger) q2
                                       withQuiz3:(NSInteger) q3
                                  withAssignment:(NSInteger) assignment
                                     withContext:(NSManagedObjectContext *) context
{
    Marks *oldMarks, *marks = [NSEntityDescription insertNewObjectForEntityForName:@"Marks" inManagedObjectContext:context];
    marks.cat1 = [NSNumber numberWithInt:cat1];
    marks.cat2 = [NSNumber numberWithInt:cat2];
    marks.quiz1 = [NSNumber numberWithInt:q1];
    marks.quiz2 = [NSNumber numberWithInt:q2];
    marks.quiz3 = [NSNumber numberWithInt:q3];
    marks.assignment = [NSNumber numberWithInt:assignment];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Subject"];
    request.predicate = nil;
    request.sortDescriptors = nil;
    NSArray *allSubjects = [context executeFetchRequest:request error:nil];
    for(Subject *subject in allSubjects)
    {
        if([subject.classNumber isEqualToString:classNumber])
        {
            oldMarks = subject.marks;
            subject.marks = marks;
        }
    }
    return oldMarks;
    
    
}

@end
