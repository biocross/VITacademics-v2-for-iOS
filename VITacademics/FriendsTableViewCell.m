//
//  FriendsTableViewCell.m
//  VITacademics
//
//  Created by Siddharth on 21/04/14.
//  Copyright (c) 2014 Siddharth Gupta. All rights reserved.
//

#import "FriendsTableViewCell.h"
#import "OLDTimeTable.h"

@implementation FriendsTableViewCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)initCellData{
    DataManager *sharedManager = [DataManager sharedManager];
    self.context = sharedManager.context;
    
    [self.friendname setFont:[UIFont fontWithName:@"MuseoSans-300" size:16]];
    [self.friendClassStatus setFont:[UIFont fontWithName:@"MuseoSans-300" size:14]];
    [self.friendClassStatus setTextColor:[UIColor colorWithRed:0.1803 green:0.8 blue:0.4431 alpha:1]];
    
    if(self.friend.picture){
        self.profilePicture.image = [UIImage imageWithData:self.friend.picture];
    }
    
    self.profilePicture.layer.cornerRadius = self.profilePicture.frame.size.height /2;
    self.profilePicture.layer.masksToBounds = YES;
    self.profilePicture.layer.borderWidth = 0;
    
    
    self.friendname.text = self.friend.name;
    NSDictionary *currentClass;
    
    OLDTimeTable *ofFriend = [[OLDTimeTable alloc] initWithTTString:self.friend.timetable];
    [ofFriend getTodaysTimeTable];
    
    @try {
        currentClass = [[ofFriend getCurrentClass] isKindOfClass:[NSDictionary class]] ? [ofFriend getCurrentClass] : 0;
    }
    @catch (NSException *exception) {
        NSLog(@"%@", [exception description]);
    }
    
    
    if(currentClass){
        self.friendClassStatus.text = [NSString stringWithFormat:@"has a class at %@.", [currentClass objectForKey:@"venue"]];
        [self.friendClassStatus setTextColor:[UIColor orangeColor]];
    }
    else{
        self.friendClassStatus.text = @"is free right now.";
    }
    
    if([self.friend.name isEqualToString:self.friend.registrationNumber]){
        NSLog(@"Loading data for %@", self.friend.registrationNumber);
        
        PFQuery *query = [PFUser query];
        [query whereKey:@"username" equalTo:self.friend.registrationNumber];
        [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
            if (!object) {
                NSLog(@"No Parse Object for friend: %@", self.friend.registrationNumber);
            }
            else{
                [self extractDetailsForFacebookID: [object valueForKey:@"facebookID"]];
            }
        }];
            
        /*
        PFQuery *query = [PFQuery queryWithClassName:@"User"];
        [query whereKey:@"registrationNumber" equalTo:self.friend.registrationNumber];
        [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
            if (!object) {
                NSLog(@"The getFirstObject request failed.");
            } else {
                NSString *facebookID = [object valueForKey:@"facebookID"];
                [self extractDetailsForFacebookID: facebookID];
            }
        }];
         */
    }
    

}

-(void)extractDetailsForFacebookID:(NSString *)facebookID{
    
    dispatch_queue_t downloadQueue = dispatch_queue_create("attendanceLoader", nil);
    dispatch_async(downloadQueue, ^{

        NSString *buildingUrl = [NSString stringWithFormat:@"http://graph.facebook.com/%@", facebookID];
        NSURL *url = [NSURL URLWithString:buildingUrl];
        NSError *error = nil;
        NSString *text = [NSString stringWithContentsOfURL:url encoding:NSASCIIStringEncoding error:&error];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if(!text){
                NSLog(@"Error in fetching Friend Data: %@", error);
            }
            else{
                NSError *e = nil;
                NSData *friendDataFromString = [text dataUsingEncoding:NSUTF8StringEncoding];
                NSDictionary *jsonArray = [NSJSONSerialization JSONObjectWithData: friendDataFromString options: NSJSONReadingMutableContainers error: &e];
                
                if (!jsonArray) {
                    NSLog(@"Error parsing friend's JSON returned from GraphAPI: %@", e);
                }
                else{
                    self.friend.name = [jsonArray valueForKey:@"name"];
                    self.friendname.text = self.friend.name;
                    NSError *error = nil;
                    if (![self.context save:&error]) {
                        NSLog(@"Can't Save Friend Name! %@ %@", error, [error localizedDescription]);
                    }
                    else{
                        NSLog(@"Updated Friend Name");
                        [self loadProfilePictureForFacebookID:facebookID];
                    }
                }
            }
            
            
        });
        
    });//end of GCD
    
}

-(void)loadProfilePictureForFacebookID: (NSString *)facebookID{
    self.imageData = [[NSMutableData alloc] init];
    
    NSURL *pictureURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://graph.facebook.com/%@/picture?type=square", facebookID]];
    
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:pictureURL
                                                              cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                          timeoutInterval:2.0f];
    NSURLConnection *urlConnection = [[NSURLConnection alloc] initWithRequest:urlRequest delegate:self];
    [urlConnection start];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [self.imageData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    self.profilePicture.image = [UIImage imageWithData:self.imageData];
    
    self.friend.picture = self.imageData;
    
    NSError *error = nil;
    if (![self.context save:&error]) {
        NSLog(@"Can't Save Friend Picture! %@ %@", error, [error localizedDescription]);
    }
    else{
        NSLog(@"Updated Friend Picture");
    }
}

@end
