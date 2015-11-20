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
#import "StartMainViewController.h"
#import <MediaPlayer/MediaPlayer.h>
#import <AVKit/AVKit.h>
#import "AgentUserDetailViewController.h"
#import "AgentEditDetailsViewController.h"
@interface AgentViewController ()<WYPopoverControllerDelegate,AgentCellOptionPopoverViewControllerDelegate,CreateNewUserPopoverViewControllerDelegate,UITableViewDragLoadDelegate>{
    NSMutableArray *arrProfiles;
    WYPopoverController *settingsPopoverController;
    __weak IBOutlet UILabel *lblUserCredits;
    CGRect btnRect;
    __weak IBOutlet UIView *viewCredits;
    NSMutableArray *arrBtnFrame;
    BOOL isSearching;
    NSTimer *timer;
    NSInteger currentTime;
    NSInteger credit;
    WYPopoverController* popoverController;
    __weak IBOutlet UIBarButtonItem *btnAdd;
    NSInteger agentBal;
    PFObject *currentProfile;
}
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UIButton *btnCreateNewProfile;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *lblUserInfo;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@end

@implementation AgentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.lblUserInfo.hidden = YES;
    arrProfiles = [NSMutableArray array];
    arrBtnFrame = [NSMutableArray array];
    if([AppData sharedData].profileId)
        [self loadMore];
    else{
        [self showLoader];
       [[AppData sharedData] setProfileForCurrentUserwithCompletionBlock:^(PFObject *profile, NSError *error) {
           [self hideLoader];
           [self loadMore];
       }] ;
    }
    viewCredits.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    viewCredits.layer.shadowOffset = CGSizeMake(1, 1);
    viewCredits.layer.shadowOpacity = .5f;
    viewCredits.layer.shadowRadius = .5f;
    viewCredits.hidden = YES;
    [self getUserCredits];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [_tableView setDragDelegate:self refreshDatePermanentKey:@"FriendList"];
    
}

-(void)getUserCredits{
    PFQuery *query = [PFQuery queryWithClassName:@"UserCredits"];
    [query whereKey:@"userId" equalTo:[PFUser currentUser]];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        
        if (!error) {
            PFObject *obj = objects[0];
            credit =[[obj valueForKey:@"credits"] integerValue];
            agentBal = credit;
            lblUserCredits.text = [NSString stringWithFormat:@"%@ Credits",[obj valueForKey:@"credits"]];
        }
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self getUserCredits];
    self.tableView.contentOffset = CGPointMake(0, self.searchBar.frame.size.height);
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
            if(objects.count == 0)
                self.lblUserInfo.hidden = NO;
            else
                self.lblUserInfo.hidden = YES;
            
            arrBtnFrame = [NSMutableArray arrayWithCapacity:objects.count];
            arrProfiles = objects.mutableCopy;
            [self.tableView reloadData];
        }
    }];
}
-(void)timerStart{
    currentTime=currentTime+1;
    if(currentTime==2){
        [timer invalidate];
        timer = nil;
        arrBtnFrame = [NSMutableArray  array];
        arrProfiles = [NSMutableArray array];
        [self loadMore];
    }
}

#pragma mark SearchBarDelagate
-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    if(searchBar.text.length>0){
        isSearching = YES;
        currentTime =0;
        [timer invalidate];
        timer = nil;
        timer = [NSTimer timerWithTimeInterval:.5 target:self selector:@selector(timerStart) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
        currentTime =0;
    }
    else if(searchText.length==0){
        isSearching = NO;
        [self.searchBar resignFirstResponder];
        [self loadMore];
    }
    else{
        [self.searchBar resignFirstResponder];

        isSearching = NO;
    }
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [self loadMore];
}
#pragma mark UITableViewDelegate

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return arrProfiles.count;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier1 = @"AgentCustomTableViewCell";
    AgentCustomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier1];
    if (cell == nil)
           cell = [[AgentCustomTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier1];
    
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
    CGFloat xPos = [UIScreen mainScreen].bounds.size.width-30;
    rect.origin.x=xPos;
    rect.origin.y =indexPath.row * 74+44;
    //  [arrBtnFrame replaceObjectAtIndex:indexPath.row withObject:NSStringFromCGRect(rect)];
    arrBtnFrame[indexPath.row] =NSStringFromCGRect(rect);
    [cell.btnOptions addTarget:self action:@selector(optionButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    PFObject *userProfile = arrProfiles[indexPath.row];
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Agent" bundle:nil];
    AgentUserDetailViewController *vc = [sb instantiateViewControllerWithIdentifier:@"AgentUserDetailViewController"];
    vc.userProfile = userProfile;
    [self presentViewController:vc animated:YES completion:nil];
}

//- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
//{
  
//    MBProgressHUD *HUD;
//    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    PFObject *userProfile = arrProfiles[indexPath.row];
//    PFObject *profile = [userProfile valueForKey:@"profileId"];
//    
//    [profile setObject:@NO forKey:@"isActive"];
//    [profile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
//        
//        [MBProgressHUD hideHUDForView:self.view animated:YES];
//        
//        if (!error) {
//            [self getAllAddedProfiles];
//            
//        } else {
//            NSString *errorString = [[error userInfo] objectForKey:@"error"];
//            UIAlertView *errorAlertView = [[UIAlertView alloc] initWithTitle:@"Error" message:errorString delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
//            [errorAlertView show];
//        }
//    }];
//}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"NewUserIdentifier"])
    {
        CreateNewUserPopoverViewController *controller = segue.destinationViewController;
        controller.preferredContentSize = CGSizeMake(300, 200);
        controller.agentBal = agentBal;
        WYStoryboardPopoverSegue* popoverSegue = (WYStoryboardPopoverSegue*)segue;
        popoverController = [popoverSegue popoverControllerWithSender:sender permittedArrowDirections:WYPopoverArrowDirectionAny animated:YES];
        popoverController.popoverLayoutMargins = UIEdgeInsetsMake(4, 4, 4, 4);
        popoverController.delegate = self;
        controller.delegate = self;
    }
}

-(void)optionButtonAction:(id)sender{
    AgentCellOptionPopoverViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"AgentCellOptionPopoverViewController"];
    viewController.preferredContentSize = CGSizeMake(160, 80);
    viewController.delegate = self;
    //viewController.title = @"Select Specialization";
    viewController.btnTag = [sender tag];
    viewController.modalInPopover = NO;
    viewController.userProfile = arrProfiles[[sender tag] ];
    settingsPopoverController = [[WYPopoverController alloc]initWithContentViewController:viewController];
    settingsPopoverController.delegate = self;
    settingsPopoverController.wantsDefaultContentAppearance = NO;
    CGRect frame =CGRectFromString(arrBtnFrame[[sender tag]]) ;
    [settingsPopoverController presentPopoverFromRect:frame inView:self.tableView permittedArrowDirections:WYPopoverArrowDirectionAny animated:YES options:WYPopoverAnimationOptionFadeWithScale];
    
}
-(void)userMobileNumber:(NSString *)mobNo{
    [self getAllAddedProfiles];
    [self getUserCredits];
    [popoverController dismissPopoverAnimated:YES];
}

-(void)selectedOption:(NSString *)option withTag:(NSInteger)tag{
    if(![option isEqual:@"GivePermission"]){
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
                arrProfiles = [NSMutableArray array];
                [self loadMore];
            } else {
                //Something bad has ocurred
                NSString *errorString = [[error userInfo] objectForKey:@"error"];
                UIAlertView *errorAlertView = [[UIAlertView alloc] initWithTitle:@"Error" message:errorString delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                [errorAlertView show];
            }
        }];
    }
    else{
        // givePermissionOption
        PFObject *userProfile = arrProfiles[tag];
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Agent" bundle:nil];
        AgentEditDetailsViewController *vc = [sb instantiateViewControllerWithIdentifier:@"AgentEditDetailsViewController"];
        vc.userProfile = userProfile;
        vc.optionType = @"GivePermission";
        [self presentViewController:vc animated:YES completion:nil];
    }
    
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

-(void)loadMore{
    PFQuery *query = [PFQuery queryWithClassName:@"UserProfile"];
    [query whereKey:@"userId" equalTo:[PFUser currentUser]];
    if([AppData sharedData].profileId)
        [query whereKey:@"profileId" notEqualTo:[AppData sharedData].profileId];
    [query orderByDescending:@"createdAt"];
    [query whereKey:@"relation" equalTo:@"Agent"];
    [query includeKey:@"userId"];
    [query includeKey:@"profileId.userId"];
    query.skip = arrProfiles.count;
    query.limit = 15;
    
    //query.cachePolicy = kPFCachePolicyCacheThenNetwork;
    if(isSearching){
        NSString *searchText = [NSString stringWithFormat:@"%@",self.searchBar.text];
        NSCharacterSet* notDigits = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
        if ([searchText rangeOfCharacterFromSet:notDigits].location == NSNotFound)
        {
            PFQuery *innerQueryProfile = [PFQuery queryWithClassName:@"Profile"];
            PFQuery *innerQueryUser =[PFUser query];
            [innerQueryUser whereKey:@"username" matchesRegex:[NSString stringWithFormat:@"(?i)%@",searchText]];
            [innerQueryProfile whereKey:@"userId" matchesQuery:innerQueryUser];
            [query whereKey:@"profileId" matchesQuery:innerQueryProfile];
        }
        else{
            PFQuery *innerQueryProfile = [PFQuery queryWithClassName:@"Profile"];
            [innerQueryProfile whereKey:@"name" matchesRegex:[NSString stringWithFormat:@"(?i)%@",searchText]];
            [query whereKey:@"profileId" matchesQuery:innerQueryProfile];
        }
    }
    [self showLoader];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        [self hideLoader];
        if (!error) {
            viewCredits.hidden = NO;

            if(objects.count<15)
                [_tableView setDragDelegate:nil refreshDatePermanentKey:@"FriendList"];
            else
                [_tableView setDragDelegate:self refreshDatePermanentKey:@"FriendList"];
            
            NSMutableArray *arrFetchedItems =objects.mutableCopy;
            
//            for(PFObject *tempObj in arrFetchedItems){
//                for(PFObject *obj in arrProfiles){
//                    PFUser *tempUser  = [tempObj valueForKey:@"userId"];
//                    PFUser *user  = [obj valueForKey:@"userId"];
//                    if([tempUser.username isEqual:user.username]){
//                        [arrFetchedItems removeObject:tempObj];
//                        break;
//                    }
//                }
//            }
            [arrProfiles addObjectsFromArray:arrFetchedItems];
            NSInteger count  =arrBtnFrame.count+arrFetchedItems.count;
            for(int i = 0; i<count; i++) [arrBtnFrame addObject: [NSNull null]];

            if(arrProfiles.count == 0)
                self.lblUserInfo.hidden = NO;
            else
                self.lblUserInfo.hidden = YES;
            [self.tableView reloadData];
        }
        else  if (error.code ==209){
            [PFUser logOut];
            PFUser *user = nil;
            PFInstallation *currentInstallation = [PFInstallation currentInstallation];
            [currentInstallation setObject:user forKey:@"user"];
            [currentInstallation saveInBackground];
            UIAlertView *errorAlertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Logged in from another device, Please login again!!" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [errorAlertView show];
            UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            StartMainViewController *vc = [sb instantiateViewControllerWithIdentifier:@"StartMainViewController"];
            [self presentViewController:vc animated:YES completion:nil];
        }
    }];
    [self.tableView finishLoadMore];
    
}
#pragma mark - Drag delegate methods
- (void)dragTableLoadMoreCanceled:(UITableView *)tableView
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(loadMore) object:nil];
}
- (void)dragTableDidTriggerLoadMore:(UITableView *)tableView
{
    [self performSelector:@selector(loadMore) withObject:nil afterDelay:0];
}

#pragma mark ShowActivityIndicator
-(void)showLoader{
    [self.activityIndicator startAnimating];
    self.btnCreateNewProfile.enabled = NO;
   // self.tableView.allowsSelection = NO;
    btnAdd.enabled = NO;
    self.tableView.userInteractionEnabled = NO;
}

-(void)hideLoader{
    [self.activityIndicator stopAnimating];
    self.btnCreateNewProfile.enabled = YES;
    self.tableView.allowsSelection = YES;
    self.tableView.userInteractionEnabled = YES;
    btnAdd.enabled = YES;
}

@end
