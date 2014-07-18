//
//  FacebookViewController.m
//  VITacademics
//
//  Created by Siddharth on 24/04/14.
//  Copyright (c) 2014 Siddharth Gupta. All rights reserved.
//

#import "FacebookViewController.h"

@interface FacebookViewController ()

@end

@implementation FacebookViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.subtitle setFont:[UIFont fontWithName:@"MuseoSans-300" size:13]];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(IBAction)loginWithFacebook:(id)sender{
    
    //[_activityIndicator startAnimating];
    [self.loadingLabel setAlpha:1];
    [self.activityIndicator setAlpha:1];
    [self.activityIndicator startAnimating];

    PFUser *user = [PFUser currentUser];
    NSLog(@"%@", [user description]);
    if (![PFFacebookUtils isLinkedWithUser:user]) {
        [PFFacebookUtils linkUser:user permissions:nil block:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
                NSLog(@"Woohoo, user logged in with Facebook!");
                [self extractUserInfo];
            }
        }];
    }
    
    
}

-(void)hideIndicators{
    [_activityIndicator stopAnimating];
    [_loadingLabel setAlpha:0];
}

-(void)extractUserInfo{
    FBRequest *request = [FBRequest requestForMe];
    
    [request startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        if (!error) {
            // result is a dictionary with the user's Facebook data
            NSDictionary *userData = (NSDictionary *)result;
            
            NSString *facebookID = userData[@"id"];
            NSString *name = userData[@"name"];
            
            PFUser *currentUser = [PFUser currentUser];
            if (currentUser) {
                if([PFFacebookUtils isLinkedWithUser:currentUser]){
                    currentUser[@"facebookName"] = name;
                    currentUser[@"facebookID"] = facebookID;
                    currentUser[@"isSignedIn"] = @"true";
                    
                    [currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                        if(succeeded){
                            NSLog(@"Saved credentials to currentUser");
                        }
                        else{
                            NSLog(@"There was a problem saving name to current user");
                        }
                    }];
                }
            }
            
            NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
            [preferences removeObjectForKey:@"facebookID"];
            [preferences removeObjectForKey:@"facebookName"];
            [preferences setObject:facebookID forKey:@"facebookID"];
            [preferences setObject:name forKey:@"facebookName"];
            
            self.imageData = [[NSMutableData alloc] init];
            
            NSURL *pictureURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://graph.facebook.com/%@/picture?type=square", facebookID]];
            
            NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:pictureURL
                                                                      cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                                  timeoutInterval:2.0f];
            NSURLConnection *urlConnection = [[NSURLConnection alloc] initWithRequest:urlRequest delegate:self];
            [urlConnection start];
            
            [self hideIndicators];
            [self dismissViewControllerAnimated:YES completion:nil];
            
            
        }
    }];

}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [self.imageData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    self.profilePhoto.image = [UIImage imageWithData:self.imageData];
}


- (IBAction)cancelButton:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
