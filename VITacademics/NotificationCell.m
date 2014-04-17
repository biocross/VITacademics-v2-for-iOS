//
//  NotificationCell.m
//  VITacademics
//
//  Created by Siddharth on 09/04/14.
//  Copyright (c) 2014 Siddharth Gupta. All rights reserved.
//

#import "NotificationCell.h"
#import "TimeTable.h"


@implementation NotificationCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
    }
    return self;
}

-(void)switchValueDidChange{
    
    NSManagedObjectContext *context = [[DataManager sharedManager] context];
    if(self.switchValue.isOn){
        [self.subject setValue:[NSNumber numberWithInt:1] forKey:@"notification"];
    }
    else{
        [self.subject setValue:[NSNumber numberWithInt:0] forKey:@"notification"];
    }
    
    NSError *error = nil;
    // Save the object to persistent store
    if (![context save:&error]) {
        NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
    }
    else{
        NSLog(@"self.switchchanged to %@", self.subject.notification);
    }
    
    
    
    TimeTable *ttObject = [[TimeTable alloc] initWithTTString:@""];
    NSArray *timeSlotArray = [[NSArray alloc] init];
    timeSlotArray = [ttObject getTimeSlotArray];
    
    int indexOfMatchedSubject = -1;
    int i = 0;
    for(id item in ttObject.monday){
        if([item isKindOfClass:[Subject class]]){
            indexOfMatchedSubject = i;
            break;
        }
        i += 1;
    }
    
    if(indexOfMatchedSubject > 0){
        
    }

    
    
}

-(void)initData{
    self.title.text = self.subject.title;
    self.type.text = self.subject.attendance.type;
    //self.switchValue.enabled = self.subject.notification;
    
    [self.switchValue setOn:[self.subject.notification intValue] animated:YES];
    
    
    [self.switchValue addTarget:self
                         action:@selector(switchValueDidChange)
               forControlEvents:UIControlEventValueChanged];

}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
