//
//  FriendsViewController.m
//  VITacademics
//
//  Created by Siddharth on 15/12/13.
//  Copyright (c) 2013 Siddharth Gupta. All rights reserved.
//

#import "FriendsViewController.h"
#import "AppDelegate.h"

@interface FriendsViewController ()

@end

@implementation FriendsViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)friendWasAdded{
    [self initData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    [self.tableView registerNib:[UINib nibWithNibName:@"FriendsTableViewCell"
                                               bundle:[NSBundle mainBundle]]
         forCellReuseIdentifier:@"FriendCell"];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(friendWasAdded)
     name:@"reloadFriends"
     object:nil];
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refreshControlAction:) forControlEvents:UIControlEventValueChanged];
    [self setRefreshControl:refreshControl];
    
    [self initData];
    
}

-(void)viewDidAppear:(BOOL)animated{
    [self initData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)refreshControlAction:(id)sender{
    [self initData];
    [(UIRefreshControl *)sender endRefreshing];
}


-(void)initData{
    self.friends = [[NSMutableArray alloc] init];
    NSArray *friends = [[DataManager sharedManager] getFriends];
    [self.friends setArray:friends];
    [self.tableView reloadData];
    

}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    messageLabel.textColor = [UIColor blackColor];
    messageLabel.numberOfLines = 0;
    UIFont *newFont = [UIFont fontWithName:@"MuseoSans-300" size:15];
    [messageLabel setFont:newFont];
    messageLabel.textAlignment = NSTextAlignmentCenter;
    [messageLabel sizeToFit];
    // Return the number of sections.
    
    if ([self.friends count]) {
        
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        return 1;
        
        self.tableView.backgroundView = nil;
        messageLabel.text = @"";
        
    } else {
        
        
        
        
        if([prefs objectForKey:@"facebookID"]){
            messageLabel.text = @"Add some friends using the + above, or share your time table with your friends!";
        }
        else{
            messageLabel.text = @"The friends feature requires connection to Facebook. Tap any of the buttons above to activate the feature.";
        }
        
        
        self.tableView.backgroundView = messageLabel;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
     
        
    }
    
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 69;
}



-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if(![self.friends count]){
        NSLog(@"No Friends added yet!");
    }
    
    return [self.friends count];
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"Deleted Row");
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        
        NSManagedObjectContext *context = [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"Friend" inManagedObjectContext:context];
        [fetchRequest setEntity:entity];
        
        NSError *error;
        NSArray *items = [context executeFetchRequest:fetchRequest error:&error];
        
        for (NSManagedObject *managedObject in items) {
            Friend *friend = (Friend *)managedObject;
            Friend *selectedFriend = self.friends[indexPath.row];
            
            
            if([friend.registrationNumber isEqualToString:selectedFriend.registrationNumber]){
                NSLog(@"deleting friends: %@", friend.registrationNumber);
                [context deleteObject:managedObject];
            }
            NSLog(@"%@ friend object deleted", context);
        }
        if (![context save:&error]) {
            NSLog(@"Error deleting friend %@ - error:%@",context,error);
        }
        
        NSArray *friends = [[DataManager sharedManager] getFriends];
        [self.friends setArray:friends];
        
        
        
        [self.tableView beginUpdates];
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
        [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationRight];
        [self.tableView endUpdates];
    }
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    FriendsTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"FriendCell"];
    cell.friend = self.friends[indexPath.row];
    [cell initCellData];
    return cell;
}

- (IBAction)shareButtonPressed:(id)sender {
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    if([prefs objectForKey:@"facebookID"]){
            UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
            UIViewController *vc = [sb instantiateViewControllerWithIdentifier:@"ShareViewNav"];
            [self presentViewController:vc animated:YES completion:NULL];
    }
    else
    {
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
        UIViewController *vc = [sb instantiateViewControllerWithIdentifier:@"FacebookController"];
        [self presentViewController:vc animated:YES completion:NULL];
    }
    
    
}

- (IBAction)addFriendButtonPressed:(id)sender {
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    if([prefs objectForKey:@"facebookID"]){
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
        UIViewController *vc = [sb instantiateViewControllerWithIdentifier:@"AddFriendNav"];
        [self presentViewController:vc animated:YES completion:NULL];
    }
    else
    {
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
        UIViewController *vc = [sb instantiateViewControllerWithIdentifier:@"FacebookController"];
        [self presentViewController:vc animated:YES completion:NULL];
    }
}
@end
