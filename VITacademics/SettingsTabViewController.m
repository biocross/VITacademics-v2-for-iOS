//
//  SettingsTabViewController.m
//  VITacademics
//
//  Created by Siddharth on 04/01/14.
//  Copyright (c) 2014 Siddharth Gupta. All rights reserved.
//

#import "SettingsTabViewController.h"
#import "SettingsViewController.h"
#import "AppDelegate.h"
#import "CampusMapViewController.h"
#import "AHKActionSheet.h"

@interface SettingsTabViewController ()

@end

@implementation SettingsTabViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(indexPath.section == 0){
        
        CampusMapViewController *mapController = [self.storyboard instantiateViewControllerWithIdentifier:@"campusMapViewController"];
        [self.navigationController pushViewController:mapController animated:YES];
        
        
    }
    
    if(indexPath.section == 1){
        
        AHKActionSheet *actionSheet = [[AHKActionSheet alloc] initWithTitle:nil];
        
        actionSheet.blurTintColor = [UIColor colorWithWhite:0.0f alpha:0.75f];
        actionSheet.blurRadius = 8.0f;
        actionSheet.buttonHeight = 50.0f;
        actionSheet.cancelButtonHeight = 50.0f;
        actionSheet.cancelButtonShadowColor = [UIColor colorWithWhite:0.0f alpha:0.1f];
        actionSheet.separatorColor = [UIColor colorWithWhite:1.0f alpha:0.3f];
        actionSheet.selectedBackgroundColor = [UIColor colorWithWhite:0.0f alpha:0.5f];\
        UIFont *defaultFont = [UIFont fontWithName:@"Avenir" size:17.0f];
        actionSheet.destructiveButtonTextAttributes = @{ NSFontAttributeName : defaultFont,
                                                         NSForegroundColorAttributeName : [UIColor redColor] };
        
        
        [actionSheet addButtonWithTitle:@"Reset VITacademics" type:AHKActionSheetButtonTypeDestructive handler:^(AHKActionSheet *as) {
            [self resetApp];
        }];
        
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(10, 0, 300, 150)];
        UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 300, 150)];
        label1.text = @"This will reset VITacademics to the way it was when you installed it.\n\nFor now, this is the only way to change credentials in the app.";
        label1.minimumScaleFactor = 0.2;
        label1.textColor = [UIColor whiteColor];
        label1.numberOfLines = 5;
        label1.font = [UIFont fontWithName:@"Avenir" size:17.0f];
        label1.backgroundColor = [UIColor clearColor];
        [headerView addSubview:label1];
        
        actionSheet.headerView = headerView;
        
        [actionSheet show];
        
        
    }
    
    if(indexPath.section == 2){
        
        if(indexPath.row == 0){
            if([MFMailComposeViewController canSendMail]) {
                MFMailComposeViewController *mailCont = [[MFMailComposeViewController alloc] init];
                mailCont.mailComposeDelegate = self;
                [mailCont setToRecipients:[NSArray arrayWithObject:@"sids.1992@gmail.com"]];
                [mailCont setSubject:@"VITacademics iOS Bug Report"];
                [self presentViewController:mailCont animated:YES completion:nil];
            }
        }
    
        if(indexPath.row == 1){
            NSString *message = @"https://itunes.apple.com/in/app/vitacademics/id727796987?mt=8";
            //UIImage *imageToShare = [UIImage imageNamed:@"test.jpg"];
            NSArray *postItems = @[message]; //add image here if you want
            UIActivityViewController *activityVC = [[UIActivityViewController alloc]
                                                    initWithActivityItems:postItems
                                                    applicationActivities:nil];
            [self presentViewController:activityVC animated:YES completion:nil];
        }
    }
    if(indexPath.section == 3){
        
        
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        
        if([prefs objectForKey:@"facebookID"]){
            AHKActionSheet *actionSheet = [[AHKActionSheet alloc] initWithTitle:nil];
            
            actionSheet.blurTintColor = [UIColor colorWithWhite:0.0f alpha:0.75f];
            actionSheet.blurRadius = 8.0f;
            actionSheet.buttonHeight = 50.0f;
            actionSheet.cancelButtonHeight = 50.0f;
            actionSheet.cancelButtonShadowColor = [UIColor colorWithWhite:0.0f alpha:0.1f];
            actionSheet.separatorColor = [UIColor colorWithWhite:1.0f alpha:0.3f];
            actionSheet.selectedBackgroundColor = [UIColor colorWithWhite:0.0f alpha:0.5f];\
            UIFont *defaultFont = [UIFont fontWithName:@"Avenir" size:17.0f];
            actionSheet.destructiveButtonTextAttributes = @{ NSFontAttributeName : defaultFont,
                                                             NSForegroundColorAttributeName : [UIColor redColor] };
            
            
            [actionSheet addButtonWithTitle:@"Disconnect Facebook" type:AHKActionSheetButtonTypeDestructive handler:^(AHKActionSheet *as) {
                
                [PFFacebookUtils unlinkUserInBackground:[PFUser currentUser] block:^(BOOL succeeded, NSError *error) {
                    if (succeeded) {
                        NSLog(@"The user is no longer associated with their Facebook account.");
                    }
                }];
                
                NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
                [preferences removeObjectForKey:@"facebookID"];
                [preferences removeObjectForKey:@"facebookName"];
                
            }];
            
            UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(10, 0, 300, 150)];
            UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 300, 150)];
            label1.text = @"Disconnecting facebook disables the Friends Feature.";
            label1.minimumScaleFactor = 0.2;
            label1.textColor = [UIColor whiteColor];
            label1.numberOfLines = 5;
            label1.font = [UIFont fontWithName:@"Avenir" size:17.0f];
            label1.backgroundColor = [UIColor clearColor];
            [headerView addSubview:label1];
            
            actionSheet.headerView = headerView;
            
            [actionSheet show];
        }
        else
        {
            UIAlertView *nope = [[UIAlertView alloc] initWithTitle:@"Facebook" message:@"Looks like you haven't activated the friends feature yet. There's nothing to disconnect!" delegate:self cancelButtonTitle:@"Oh, alright." otherButtonTitles:nil, nil];
            [nope show];
        }
        
    }
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
    [controller dismissViewControllerAnimated:YES completion:nil];
}


- (void) resetApp{
    NSLog(@"Resetting App.");
    NSUserDefaults *new = [NSUserDefaults standardUserDefaults];
    [new removeObjectForKey:[new stringForKey:@"registrationNumber"]];
    [new removeObjectForKey:@"registrationNumber"];
    NSString *ttKey = [NSString stringWithFormat:@"TTOf%@", [new objectForKey:@"registrationNumber"]];
    [new removeObjectForKey:ttKey];
    [new removeObjectForKey:@"dateOfBirth"];
    [new removeObjectForKey:@"facebookID"];
    [new removeObjectForKey:@"facebookName"];
    
    Mixpanel *mixpanel = [Mixpanel sharedInstance];
    [mixpanel track:@"App Reset" properties:@{
                                                 }];
    
    
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate] ;
    [app clearCoreData];
    
    [self.tabBarController viewDidLoad];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

@end
