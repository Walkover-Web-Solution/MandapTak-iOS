//
//  AgentViewController.m
//  MandapTak
//
//  Created by Hussain Chhatriwala on 07/09/15.
//  Copyright (c) 2015 Walkover. All rights reserved.
//

#import "AgentViewController.h"
#import <Parse/Parse.h>
#import "MBProgressHUD.h"
#import "AgentCustomTableViewCell.h"
#import "AgentCellOptionPopoverViewController.h"
#import "WYPopoverController.h"
#import "AppData.h"
#import "WYStoryboardPopoverSegue.h"
#import "UITableView+DragLoad.h"
#import "CreateNewUserPopoverViewController.h"
@interface AgentViewController ()<WYPopoverControllerDelegate,AgentCellOptionPopoverViewControllerDelegate,CreateNewUserPopoverViewControllerDelegate>{
    NSMutableArray *arrProfiles;
    WYPopoverController *settingsPopoverController;
    __weak IBOutlet UILabel *lblUserCredits;
    CGRect btnRect;
    NSMutableArray *arrBtnFrame;
    NSInteger credit;
    WYPopoverController* popoverController;
}
- (IBAction)uploadMoreProfileAction:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *lblUserInfo;
- (IBAction)backButtonAction:(id)sender;

@end

@implementation AgentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.lblUserInfo.hidden = YES;
    arrProfiles = [NSMutableArray array];
    arrBtnFrame = [NSMutableArray array];
    [self getUserCredits];
    [self getAllAddedProfiles];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

-(void)getUserCredits{
    PFQuery *query = [PFQuery queryWithClassName:@"UserCredits"];
    [query whereKey:@"userId" equalTo:[PFUser currentUser]];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        
        if (!error) {
            PFObject *obj = objects[0];
            credit =[[obj valueForKey:@"credits"] integerValue];
            lblUserCredits.text = [NSString stringWithFormat:@"%@ Credits",[obj valueForKey:@"credits"]];
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
-(void)getAllAddedProfiles{
    PFQuery *query = [PFQuery queryWithClassName:@"UserProfile"];
    [query whereKey:@"userId" equalTo:[PFUser currentUser]];
    [query whereKey:@"relation" equalTo:@"Agent"];
    [query includeKey:@"profileId"];
    [query includeKey:@"userId"];
    [query includeKey:@"profileId.userId"];

    
    MBProgressHUD * hud;
    hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        if (!error) {
            if(objects.count == 0){
                self.lblUserInfo.hidden = NO;
            }
            else
                self.lblUserInfo.hidden = YES;
                arrBtnFrame = [NSMutableArray arrayWithCapacity:objects.count];
            //  [self getUserProfileForUser:objects[0]];
            arrProfiles = objects.mutableCopy;
            [self.tableView reloadData];
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];

}

#pragma mark UITableViewDelegate

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
        return arrProfiles.count;
}



- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier1 = @"AgentCustomTableViewCell";
    AgentCustomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier1];
//    if (cell == nil)
//        cell = [[AgentCustomTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier1];
    PFObject *userProfile = arrProfiles[indexPath.row];
    PFObject *profile = [userProfile valueForKey:@"profileId"];
    PFUser *user = [profile valueForKey:@"userId"];
    cell.imgProfile.image = [UIImage imageNamed:@"userDefImg.png"];

    if([profile objectForKey:@"profilePic"]!=nil){
        [[profile objectForKey:@"profilePic"] getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
            cell.imgProfile.image = [UIImage imageWithData:data];;
        }];
    }
    NSString *name =[profile valueForKey:@"name"];
    cell.lblNumber.text = user.username;
    if(name!=nil||name.length!=0)
        cell.lblName.text = [profile valueForKey:@"name"];
    else
        cell.lblName.text = @"No Name";

    cell.btnOptions.tag = indexPath.row;
    if([[profile valueForKey:@"isActive"] boolValue]){
        cell.lblStatus.text = @"Active";
        cell.lblStatus.textColor = [UIColor greenColor];
        if(![[profile valueForKey:@"isComplete"] boolValue]){
            cell.lblStatus.text = @"Incomplete";
            cell.lblStatus.textColor = [UIColor orangeColor];
        }
    }
    else{
        cell.lblStatus.text = @"Deactivated";
        cell.lblStatus.textColor = [UIColor redColor];
    }
    NSDate *updatedDate = [user valueForKey:@"createdAt"];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    dateFormatter.dateFormat = @"dd/MM/yyyy";
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
    
    NSString *dateString = [dateFormatter stringFromDate: updatedDate];
    cell.lblUploadedOn.text =[NSString stringWithFormat:@"Created At: %@",dateString] ;
    CGPoint originalPoint = cell.btnOptions.frame.origin;
    CALayer *layer = cell.contentView.layer;
    CGPoint point = originalPoint;
    point = [layer convertPoint:point toLayer:layer.superlayer];
    layer = layer.superlayer;
    CGRect  rect=layer.frame;
    CGFloat yPos = [UIScreen mainScreen].bounds.size.width-30;
    rect.origin.x=yPos;
    rect.origin.y =indexPath.row* 73;
  //  [arrBtnFrame replaceObjectAtIndex:indexPath.row withObject:NSStringFromCGRect(rect)];
    arrBtnFrame[indexPath.row] =NSStringFromCGRect(rect);
    NSLog(@"%@",arrBtnFrame);
    [cell.btnOptions addTarget:self action:@selector(optionButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
        
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    MBProgressHUD *HUD;
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    PFObject *userProfile = arrProfiles[indexPath.row];
    PFObject *profile = [userProfile valueForKey:@"profileId"];
    
    [profile setObject:@NO forKey:@"isActive"];
    [profile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        if (!error) {
            [self getAllAddedProfiles];
            
        } else {
            //Something bad has ocurred
            NSString *errorString = [[error userInfo] objectForKey:@"error"];
            UIAlertView *errorAlertView = [[UIAlertView alloc] initWithTitle:@"Error" message:errorString delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [errorAlertView show];
        }
    }];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"NewUserIdentifier"])
    {
        CreateNewUserPopoverViewController *controller = segue.destinationViewController;
        controller.preferredContentSize = CGSizeMake(300, 180);
        WYStoryboardPopoverSegue* popoverSegue = (WYStoryboardPopoverSegue*)segue;
        popoverController = [popoverSegue popoverControllerWithSender:sender
                                             permittedArrowDirections:WYPopoverArrowDirectionAny
                                                             animated:YES];

        popoverController.popoverLayoutMargins = UIEdgeInsetsMake(4, 4, 4, 4);
        popoverController.delegate = self;
        controller.delegate = self;
        
    }

}

-(void)optionButtonAction:(id)sender{
    AgentCellOptionPopoverViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"AgentCellOptionPopoverViewController"];
    viewController.preferredContentSize = CGSizeMake(160, 60);
    viewController.delegate = self;
    //viewController.title = @"Select Specialization";
    viewController.btnTag = [sender tag];
    viewController.modalInPopover = NO;
    viewController.userProfile = arrProfiles[[sender tag] ];
    settingsPopoverController = [[WYPopoverController alloc]initWithContentViewController:viewController];
    settingsPopoverController.delegate = self;
    // settingsPopoverController.passthroughViews = @[btn];
    //settingsPopoverController.popoverLayoutMargins = UIEdgeInsetsMake(10, 10, 10, 10);
    settingsPopoverController.wantsDefaultContentAppearance = NO;
    CGRect frame =CGRectFromString(arrBtnFrame[[sender tag]]) ;
    [settingsPopoverController presentPopoverFromRect:frame
                                               inView:self.tableView
                             permittedArrowDirections:WYPopoverArrowDirectionAny
                                             animated:YES
                                              options:WYPopoverAnimationOptionFadeWithScale];

}
- (IBAction)backButtonAction:(id)sender {
    
}
- (IBAction)uploadMoreProfileAction:(id)sender {
    
}
-(void)userMobileNumber:(NSString *)mobNo{
    [self getAllAddedProfiles];
    [popoverController dismissPopoverAnimated:YES];

}
-(void)selectedOption:(NSString *)option withTag:(NSInteger)tag{
  
    MBProgressHUD *HUD;
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    PFObject *userProfile = arrProfiles[tag];
    PFObject *profile = [userProfile valueForKey:@"profileId"];
    if([[profile valueForKey:@"isActive"] boolValue])
        [profile setObject:@NO forKey:@"isActive"];
    else
        [profile setObject:@YES forKey:@"isActive"];

    [profile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        if (!error) {
            [self getAllAddedProfiles];
            
        } else {
            //Something bad has ocurred
            NSString *errorString = [[error userInfo] objectForKey:@"error"];
            UIAlertView *errorAlertView = [[UIAlertView alloc] initWithTitle:@"Error" message:errorString delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [errorAlertView show];
        }
    }];

    [settingsPopoverController dismissPopoverAnimated:YES];
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender{
    
    if([identifier isEqualToString:@"NewUserIdentifier"]){
        if(credit>20)
            return true;
        else{
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Opps!" message:@"You do not have sufficient credit to add a new user.Please contact your Admin." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
            return false;
        }
         }
    
    
      return YES;
}


@end
