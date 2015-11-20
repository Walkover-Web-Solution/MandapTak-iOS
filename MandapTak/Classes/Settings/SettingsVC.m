//
//  SettingsVC.m
//  MandapTak
//
//  Created by Anuj Jain on 9/5/15.
//  Copyright (c) 2015 Walkover. All rights reserved.
//

#import "SettingsVC.h"
#import "AddContactPopoverVC.h"
#import "WYStoryboardPopoverSegue.h"
#import "WYPopoverController.h"
#import "ContactsListCell.h"
#import "AppData.h"
#import <Parse/Parse.h>

@interface SettingsVC ()<WYPopoverControllerDelegate,UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>
{
    WYPopoverController* popoverController;
    NSMutableArray *arrContactNumber,*arrUpdateInfo,*arrRelation,*arrUserProfileId,*arrPrimary,*arrUserId;
    IBOutlet UIButton *btnPermission;
    IBOutlet UIView *viewResetProfile;
    IBOutlet UILabel *lblUserCredits;
    
    int userCredits;
    //activity indicator
    IBOutlet UIActivityIndicatorView *activityIndicator;
}
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *givePermissionYOffset;
- (IBAction)resetAction:(id)sender;
@end

@implementation SettingsVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    arrContactNumber = [[NSMutableArray alloc]init];
    arrRelation = [[NSMutableArray alloc]init];
    arrUpdateInfo = [[NSMutableArray alloc]init];
    arrUserProfileId = [[NSMutableArray alloc]init];
    arrPrimary = [[NSMutableArray alloc]init];
    arrUserId = [[NSMutableArray alloc]init];
    // Do any additional setup after loading the view.
    [self getUserCredits];
    [self getContactsList];
    tableViewContacts.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

-(void)getUserCredits{
    PFQuery *query = [PFQuery queryWithClassName:@"UserCredits"];
    [query whereKey:@"userId" equalTo:[PFUser currentUser]];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        
        if (!error) {
            PFObject *obj = objects[0];
            lblUserCredits.text = [NSString stringWithFormat:@"%@ Credits",[obj valueForKey:@"credits"]];
            userCredits = [[obj valueForKey:@"credits"] intValue];
        }
        else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) getContactsList
{
    if([[AppData sharedData]isInternetAvailable])
    {
        //apply visiblity settings
        PFObject *obj =  [PFUser currentUser];
        
        //MBProgressHUD *hud;
        //hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [self showLoader];
        PFQuery *query = [PFQuery queryWithClassName:@"UserProfile"];
        [query whereKey:@"profileId" equalTo:[PFObject objectWithoutDataWithClassName:@"Profile" objectId:[[NSUserDefaults standardUserDefaults]valueForKey:@"currentProfileId"]]];
        [query includeKey:@"userId"];
        query.cachePolicy = kPFCachePolicyCacheThenNetwork;
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
         {
             //[MBProgressHUD hideHUDForView:self.view animated:YES];
             [self hideLoader];
             if (!error)
             {
                 if (objects.count > 0)
                 {
                     [arrContactNumber removeAllObjects];
                     [arrPrimary removeAllObjects];
                     [arrRelation removeAllObjects];
                     [arrUpdateInfo removeAllObjects];
                     [arrUserProfileId removeAllObjects];
                     for (PFObject *object in objects)
                     {
                         [arrUserProfileId addObject:object.objectId];
                         PFObject *userObj = object[@"userId"];
                         [arrUserId addObject:userObj.objectId];
                         if ([obj.objectId isEqualToString:userObj.objectId])
                         {
                             //NSNumber *primaryNumber = [NSNumber numberWithInt:[object objectForKey:@"isPrimary"]];
                             int intNum = 0;
                             intNum = [[NSNumber numberWithInt:[[object objectForKey:@"isPrimary"] intValue]] intValue];
                             if (intNum == 1)
                             {
                                 btnPermission.hidden = NO;
                                 viewResetProfile.hidden = NO;
                             }
                             else
                             {
                                 btnPermission.hidden = YES;
                                 viewResetProfile.hidden = YES;
                             }
                         }
                         
                         [arrContactNumber addObject:[userObj valueForKey:@"username"]];
                         
                         [arrRelation addObject:object[@"relation"]];
                         [arrPrimary addObject:[NSNumber numberWithInt:[[object objectForKey:@"isPrimary"] intValue]]];
                         
                         //add update date
                         NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                         [formatter setDateFormat:@"dd-MM-yyyy"];
                         NSString *strDate = [formatter stringFromDate:[object valueForKey:@"updatedAt"]];
                         [arrUpdateInfo addObject:strDate];
                     }
                 }
                 else
                 {
                     
                 }
                 _givePermissionYOffset.constant = 86;
                 
                 [tableViewContacts reloadData];
             }
             else
             {
                 NSLog(@"Error: %@ %@", error, [error userInfo]);
             }
         }];
    }
    else
    {
        UIAlertView *alert =  [[UIAlertView alloc]initWithTitle:@"Opps!!" message:@"Please Check your internet connection" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
    }
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    //Degree View
    if ([segue.identifier isEqualToString:@"AddContactIdentifier"])
    {
        if (userCredits < 10)
        {
            UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Insufficient Credits!!" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [av show];
            return;
        }
        else
        {
            //isSelectingCurrentLocation = YES;
            AddContactPopoverVC *controller = segue.destinationViewController;
            controller.contentSizeForViewInPopover = CGSizeMake(310, 250);
            WYStoryboardPopoverSegue* popoverSegue = (WYStoryboardPopoverSegue*)segue;
            popoverController = [popoverSegue popoverControllerWithSender:sender
                                                 permittedArrowDirections:WYPopoverArrowDirectionAny
                                                                 animated:YES];
            popoverController.popoverLayoutMargins = UIEdgeInsetsMake(4, 4, 4, 4);
            popoverController.delegate = self;
            controller.delegate = self;
        }
    }
}

- (IBAction)backAction:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(arrUserProfileId.count!=0){
        _givePermissionYOffset.constant = _givePermissionYOffset.constant+ (arrUserProfileId.count*59);
    }
    return arrUserProfileId.count;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"ContactsCell";
    ContactsListCell *cell = [tableViewContacts dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (!cell) {
        cell=[[ContactsListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    cell.lblNumber.text = arrContactNumber[indexPath.row];
    cell.lblInfo.text = [NSString stringWithFormat:@"Last updated at:%@",arrUpdateInfo[indexPath.row]];
    cell.lblRelation.text = arrRelation[indexPath.row];
    
    
    //NSLog(@"current user name -> %@ and id --> %@",obj[@"username"],obj.objectId);
    
    if (([arrPrimary[indexPath.row] intValue] == 1) || ([arrRelation[indexPath.row] isEqualToString:@"Agent"])/* || (obj.objectId == arrUserId[indexPath.row]) */)
    {
        cell.btnDelete.hidden = true;
    }
    else
    {
        cell.btnDelete.hidden = false;
    }
    
    //set target for delete button
    cell.btnDelete.tag = indexPath.row;
    [cell.btnDelete addTarget:self action:@selector(deleteContactWithNumber:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

#pragma mark Popover Methods
- (void)showSelectedContacts: (NSArray *)arrSelNumbers
{
    [popoverController dismissPopoverAnimated:YES];
    [self getContactsList];
    //[tableViewContacts reloadData];
}

-(void) deleteContactWithNumber:(id)sender
{
    int senderTag = [sender tag];
    NSString *strMobile = arrContactNumber[senderTag];
    
    if ([[AppData sharedData] isInternetAvailable])
    {
        //MBProgressHUD *HUD;
        //HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [self showLoader];
        [PFCloud callFunctionInBackground:@"deletePermission"
                           withParameters:@{@"profileId":[[NSUserDefaults standardUserDefaults]valueForKey:@"currentProfileId"],
                                            @"mobile" : [NSString stringWithFormat:@"%@",strMobile]}
                                    block:^(NSArray *results, NSError *error)
         {
             //[MBProgressHUD hideHUDForView:self.view animated:YES];
             [self hideLoader];
             if (!error)
             {
                 // this is where you handle the results and change the UI.
                 [self getContactsList];
             }
             else  if (error.code ==209){
                 UIAlertView *errorAlertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Logged in from another device, Please login again!!" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                 [errorAlertView show];
             }
             else
             {
                 UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"Error" message:error.description delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                 [av show];
                 return;
             }
         }];
        
        
    }
    else
    {
        UIAlertView *alert =  [[UIAlertView alloc]initWithTitle:@"Opps!!" message:@"Please Check your internet connection" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
    }

}

- (IBAction)resetAction:(id)sender
{
    UIAlertView *alert =  [[UIAlertView alloc]initWithTitle:@"Alert!!" message:@"Are you sure??" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok", nil];
    [alert show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        NSLog(@"delete confirmation");
        [self resetProfile];
    }
}

-(void) resetProfile
{
    if ([[AppData sharedData] isInternetAvailable])
    {
        //MBProgressHUD *HUD;
        //HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [self showLoader];
        [PFCloud callFunctionInBackground:@"resetProfiles"
                           withParameters:@{@"oid":[[NSUserDefaults standardUserDefaults]valueForKey:@"currentProfileId"]}
                                    block:^(NSArray *results, NSError *error)
         {
             //[MBProgressHUD hideHUDForView:self.view animated:YES];
             [self hideLoader];
             if (!error)
             {
                 // this is where you handle the results and change the UI.
                 //[self getContactsList];
                 UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"Success" message:@"Profile reset successfully" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                 [av show];
                 [self dismissViewControllerAnimated:YES completion:nil];
             }
             else  if (error.code ==209){
                 UIAlertView *errorAlertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Logged in from another device, Please login again!!" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                 [errorAlertView show];
             }
             else
             {
                 UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"Error" message:error.description delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                 [av show];
                 return;
             }
         }];
        
        
    }
    else
    {
        UIAlertView *alert =  [[UIAlertView alloc]initWithTitle:@"Opps!!" message:@"Please Check your internet connection" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
    }
}

#pragma mark ShowActivityIndicator

-(void)showLoader{
    activityIndicator.hidden = NO;
    [activityIndicator startAnimating];
}

-(void)hideLoader
{
    activityIndicator.hidden = YES;
    [activityIndicator stopAnimating];
}
@end
