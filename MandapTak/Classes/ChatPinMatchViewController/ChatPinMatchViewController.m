//
//  ChatPinMatchViewController.m
//  MandapTak
//
//  Created by Hussain Chhatriwala on 31/08/15.
//  Copyright (c) 2015 Walkover. All rights reserved.
//

#import "ChatPinMatchViewController.h"
#import "MatchAndPinTableViewCell.h"
#import "ChatTableViewCell.h"
#import "MBProgressHUD.h"
#import "AppData.h"
#import "Profile.h"
#import "ViewFullProfileVC.h"
#import "CandidateProfileDetailScreenVC.h"
#import <Atlas/Atlas.h>
#import "UserManager.h"
#import "SVProgressHUD.h"
#import "ConversationListViewController.h"
#import "ConversationViewController.h"
#import "DRCellSlideGestureRecognizer.h"
//#import "LNBRippleEffect.h"
@interface ChatPinMatchViewController ()<LYRQueryControllerDelegate,UIGestureRecognizerDelegate>{
    NSInteger currentTab;
    NSArray *arrMatches;
    NSMutableArray *arrPins;
    __weak IBOutlet UIButton *btnBack;
    NSArray *arrChats;
    __weak IBOutlet UITableView *matchTableView;
    NSMutableArray *arrCachedMatches;
    __weak IBOutlet UILabel *lblUserInfo;
    NSOrderedSet *conversations;
    __weak IBOutlet UIView *chatView;
    __weak IBOutlet UIActivityIndicatorView *activityIndicator;
    // add ripple effect
    __weak IBOutlet UIView *undoBarView;
    __weak IBOutlet UILabel *lblUndoTitle;
    __weak IBOutlet UIButton *btnUndo;
    NSString *statusOfUndo;
    PFObject *profileLiked;
    PFObject *profileDisliked;
    //LNBRippleEffect *rippleEffect;
}
- (IBAction)undoButtonAction:(id)sender;
@property (nonatomic) LYRQueryController *queryController;

@property (weak, nonatomic) IBOutlet UIButton *btnChat;
@property (weak, nonatomic) IBOutlet UIButton *btnPin;
@property (weak, nonatomic) IBOutlet UIButton *btnMatch;
@property (weak, nonatomic) IBOutlet UILabel *lblPageTitle;
- (IBAction)backToHome:(id)sender;
- (IBAction)tabButtonAction:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ChatPinMatchViewController
- (void)viewDidLoad {
    
    [super viewDidLoad];
    undoBarView.hidden = YES;
    chatView.hidden = YES;
    [self loginLayer];
    currentTab = 0;
    lblUserInfo.hidden = YES;
    arrCachedMatches = [NSMutableArray array];
    arrMatches = [NSArray array];
    arrPins = [NSMutableArray array];
    arrChats = [NSArray array];
    btnUndo.layer.cornerRadius = 1.0f;
    btnUndo.layer.borderColor = [UIColor whiteColor].CGColor;
    btnUndo.layer.borderWidth = 1.0f;
    //notification for matched profile
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(openMatchScreen:) name:@"MatchPinnedNotification" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(switchToPin) name:@"UpdatePinNotification" object:nil ];
    self.tableView.tableFooterView =  matchTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];

    if(self.currentProfile)
        [self switchToMatches];
    
    else{
        if([[AppData sharedData]isInternetAvailable]){
            [self showLoader];
            btnBack.enabled =YES;
            PFQuery *query = [PFQuery queryWithClassName:@"Profile"];
            query.cachePolicy = kPFCachePolicyCacheOnly;
            [query whereKey:@"objectId" equalTo:[[NSUserDefaults standardUserDefaults]valueForKey:@"currentProfileId"]];
            [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                [self hideLoader];
                if (!error) {
                    // The find succeeded.
                    PFObject *obj= objects[0];
                    self.currentProfile =obj;
                    [self switchToMatches];
                }
            }];
        }
        else{
            UIAlertView *alert =  [[UIAlertView alloc]initWithTitle:@"Opps!!" message:@"Please Check your internet connection" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
        }

    }
    // add ripple effect
    
//    rippleEffect = [[LNBRippleEffect alloc]initWithImage:[UIImage imageNamed:@""] Frame:CGRectMake(110, 200, 100, 100) Color:[UIColor colorWithRed:240/255.0f green:113/255.0f blue:116/255.0f alpha:.9] Target:nil ID:self];
//    [rippleEffect setRippleColor:[UIColor colorWithRed:240/255.0f green:113/255.0f blue:116/255.0f alpha:.9]];
//    [rippleEffect setRippleTrailColor:[UIColor colorWithRed:240/255.0f green:113/255.0f blue:116/255.0f alpha:.9]];
//    [self.view addSubview:rippleEffect];
    
}

- (IBAction)backToHome:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)unPinButtonAction:(id)sender {
    MBProgressHUD * hud;
    hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];

    PFObject *pinnedProfile = arrPins[[sender tag]];
    [pinnedProfile deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (succeeded) {
            [self switchToPin];
            NSLog(@"Woohoo, Success!");
        }
    }];
}


#pragma mark UITableViewDelegate

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (currentTab) {
        case 0:
            return arrMatches.count;
            break;
        case 1:
            return arrPins.count;
            break;
        case 2:
            return conversations.count;
            break;
       
    }
    return 0;
}



- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier2 = @"MatchAndPinTableViewCell";
 //   MatchAndPinTableViewCell *matchAndPinCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier2];
    MatchAndPinTableViewCell *matchAndPinCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier2];
    if (matchAndPinCell == nil)
        matchAndPinCell = [[MatchAndPinTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier2];

    matchAndPinCell.selectionStyle = UITableViewCellSelectionStyleNone;
    static NSString *cellIdentifier3 = @"ChatTableViewCell";
    ChatTableViewCell *chatCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier3];
    if([tableView isEqual:matchTableView]){
        matchAndPinCell.btnChat.hidden = NO;
        matchAndPinCell.btnPinOrMatch.hidden = YES;
    }
    else{
        matchAndPinCell.btnChat.hidden = YES ;
        matchAndPinCell.btnPinOrMatch.hidden = NO;

    }
    if(currentTab ==0){
        matchAndPinCell.btnChat.tag = indexPath.row;

        PFObject *profile = arrMatches[indexPath.row];

        
        matchAndPinCell.lblDesignation.text = [profile valueForKey:@"designation"];
        if([profile objectForKey:@"profilePic"]!=nil){
            [[profile objectForKey:@"profilePic"] getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
                matchAndPinCell.imgProfile.image = [UIImage imageWithData:data];;
            }];

        }
               matchAndPinCell.btnPinOrMatch.tag = indexPath.row;
        NSString *strReligion =@"";;
        if(![[profile valueForKey:@"religionId"] isKindOfClass:[NSNull class]]){
            strReligion = [strReligion stringByAppendingString:[[profile valueForKey:@"religionId"] valueForKey:@"name"]];
        }
        if(![[profile valueForKey:@"casteId"] isKindOfClass:[NSNull class]]&&[profile valueForKey:@"casteId"] !=nil){
            strReligion = [strReligion stringByAppendingString:[NSString stringWithFormat:@", %@",[[profile valueForKey:@"casteId"] valueForKey:@"name"]]];
        }
        if(![[profile valueForKey:@"gotraId"] isKindOfClass:[NSNull class]] &&[profile valueForKey:@"gotraId"] !=nil){
            strReligion =[strReligion stringByAppendingString:[NSString stringWithFormat:@", %@",[[profile valueForKey:@"gotraId"] valueForKey:@"name"]]];
        }
        if([strReligion containsString:@", <null>"]){
            strReligion = [strReligion stringByReplacingOccurrencesOfString:@", <null>" withString:@""];
        }

        matchAndPinCell.lblReligion.text =strReligion;
        [matchAndPinCell.btnPinOrMatch setImage:[UIImage imageNamed:@"matchCellOption"] forState:UIControlStateNormal];
        matchAndPinCell.lblName.text = [profile valueForKey:@"name"];
        matchAndPinCell.lblDesignation.text = [profile valueForKey:@"designation"];
       // [matchAndPinCell.btnPinOrMatch addTarget:self action:@selector(matchButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [matchAndPinCell.btnChat addTarget:self action:@selector(chatButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        matchAndPinCell.btnPinOrMatch.hidden = YES;
        return matchAndPinCell;

    }
    else if(currentTab ==1){
        
        DRCellSlideGestureRecognizer *slideGestureRecognizer = [DRCellSlideGestureRecognizer new];
        
        UIColor *greenColor = [UIColor colorWithRed:91/255.0 green:220/255.0 blue:88/255.0 alpha:1];
        UIColor *redColor = [UIColor colorWithRed:222/255.0 green:61/255.0 blue:14/255.0 alpha:1];
        
        DRCellSlideAction *likeAction = [DRCellSlideAction actionForFraction:.25];
        likeAction.icon = [UIImage imageNamed:@"dislike2"];
        
        likeAction.activeBackgroundColor = redColor;
        
        
        
        DRCellSlideAction *dislikeAction = [DRCellSlideAction actionForFraction:-.25];
        dislikeAction.icon = [UIImage imageNamed:@"like"];
        dislikeAction.activeBackgroundColor = greenColor;
        

        likeAction.behavior = DRCellSlideActionPushBehavior;
        likeAction.didTriggerBlock = [self pushTriggerBlock];
        likeAction.elasticity = 100;

        [slideGestureRecognizer addActions:@[ likeAction]];
        
        [matchAndPinCell addGestureRecognizer:slideGestureRecognizer];
        dislikeAction.behavior = DRCellSlideActionPushBehavior;
        dislikeAction.didTriggerBlock = [self pullTriggerBlock];
        dislikeAction.elasticity = 100;

        [slideGestureRecognizer addActions:@[ dislikeAction]];


        PFObject *pinnedProfile = arrPins[indexPath.row];
        PFObject *profile = [pinnedProfile valueForKey:@"pinnedProfileId"];
        matchAndPinCell.lblDesignation.text = [profile valueForKey:@"designation"];
        if([profile objectForKey:@"profilePic"]!=nil){
            [[profile objectForKey:@"profilePic"] getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
                matchAndPinCell.imgProfile.image = [UIImage imageWithData:data];;
            }];

        }
       
        [matchAndPinCell.btnPinOrMatch setImage:[UIImage imageNamed:@"unpin"] forState:UIControlStateNormal];
        matchAndPinCell.btnPinOrMatch.tag = indexPath.row;

        NSString *strReligion =@"";;
        if([profile valueForKey:@"religionId"] !=nil){
            strReligion = [strReligion stringByAppendingString:[[profile valueForKey:@"religionId"] valueForKey:@"name"]];
        }
        if([profile valueForKey:@"casteId"]!=nil){
            strReligion = [strReligion stringByAppendingString:[NSString stringWithFormat:@", %@",[[profile valueForKey:@"casteId"] valueForKey:@"name"]]];
        }
        if([profile valueForKey:@"gotraId"] !=nil){
            strReligion =[strReligion stringByAppendingString:[NSString stringWithFormat:@", %@",[[profile valueForKey:@"gotraId"] valueForKey:@"name"]]];
        }
        if([strReligion containsString:@", <null>"]){
            strReligion = [strReligion stringByReplacingOccurrencesOfString:@", <null>" withString:@""];
        }

        matchAndPinCell.lblReligion.text =strReligion;

        matchAndPinCell.lblName.text = [profile valueForKey:@"name"];
        matchAndPinCell.lblDesignation.text = [profile valueForKey:@"designation"];
        [matchAndPinCell.btnPinOrMatch addTarget:self action:@selector(unPinButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        matchAndPinCell.btnPinOrMatch.hidden = NO;

        return matchAndPinCell;

          }
    else if(currentTab ==2){
        LYRConversation *conv = conversations[indexPath.row];
        if ([conv.metadata valueForKey:@"title"]){
            chatCell.lblName = [conv.metadata valueForKey:@"title"];
            return chatCell;
        } else {
            NSArray *unresolvedParticipants = [[UserManager sharedManager] unCachedUserIDsFromParticipants:[conv.participants allObjects]];
            NSArray *resolvedNames = [[UserManager sharedManager] resolvedNamesFromParticipants:[conv.participants allObjects]];
            
            if ([unresolvedParticipants count]) {
                [[UserManager sharedManager] queryAndCacheUsersWithIDs:unresolvedParticipants completion:^(NSArray *participants, NSError *error) {
                    if (!error) {
                        if (participants.count) {
                            [self reloadCellForConversation:conv];
                        }
                    } else {
                        NSLog(@"Error querying for Users: %@", error);
                    }
                }];
            }
            
            if ([resolvedNames count] && [unresolvedParticipants count]) {
                chatCell.lblName.text = [NSString stringWithFormat:@"%@ and %lu others", [resolvedNames componentsJoinedByString:@", "], (unsigned long)[unresolvedParticipants count]];
                
                return chatCell;

            } else if ([resolvedNames count] && [unresolvedParticipants count] == 0) {
                chatCell.lblName.text =  [NSString stringWithFormat:@"%@", [resolvedNames componentsJoinedByString:@", "]];
                return chatCell;

            } else {
                chatCell.lblName.text =  [NSString stringWithFormat:@"Conversation with %lu users...", (unsigned long)conv.participants.count];
                return chatCell;
            }
        }
        return chatCell;

    }

       return chatCell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self hideUndoBar];

    if(currentTab ==0){
        PFObject *profile = arrMatches[indexPath.row];
        [self showFullProfileForProfile:profile];
    }
    else if(currentTab == 1){
        PFObject *pinnedProfile = arrPins[indexPath.row];
        PFObject *profile = [pinnedProfile valueForKey:@"pinnedProfileId"];
        [self showFullProfileForProfile:profile];
        
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self hideUndoBar];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([tableView isEqual:self.tableView])
        return 73;
    
    return 106;
}
#pragma mark LikeOnSwipeAction
- (DRCellSlideActionBlock) pullTriggerBlock {
    return ^(UITableView *tableView, NSIndexPath *indexPath) {
        [self showLoader];
       
        PFObject *pinnedProfile = arrPins[indexPath.row];
        [arrPins removeObjectAtIndex:indexPath.row];
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationLeft];
        PFObject *profile = [pinnedProfile valueForKey:@"pinnedProfileId"];
        profileLiked = profile;
        [PFCloud callFunctionInBackground:@"likeAndFind"
                           withParameters:@{@"userProfileId":[[NSUserDefaults standardUserDefaults]valueForKey:@"currentProfileId"],
                                            @"likeProfileId":profile.objectId,
                                            @"userName":[[NSUserDefaults standardUserDefaults]valueForKey:@"currentProfileName"]}
                                    block:^(id results, NSError *error)
         {
             //[MBProgressHUD hideHUDForView:self.view animated:YES];
             [self hideLoader];
             
             if (!error)
             {
                 [self refreshPinPage];
                 statusOfUndo = @"liked";
                 profileLiked = profile;
                 lblUndoTitle.text = [NSString stringWithFormat:@"You Liked %@",[profileLiked valueForKey:@"name"]];
                 [self showUndoBar];
                 

             }
             
         }];
        
    };
}

#pragma mark DisikeOnSwipeAction

- (DRCellSlideActionBlock)pushTriggerBlock {
    return ^(UITableView *tableView, NSIndexPath *indexPath) {
        PFObject *pinnedProfile = arrPins[indexPath.row];
        [arrPins removeObjectAtIndex:indexPath.row];
        
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationRight];
        [self showLoader];
        
        [pinnedProfile deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [self hideLoader];

            if (succeeded) {
                [self showLoader];
                PFObject *profile = [pinnedProfile valueForKey:@"pinnedProfileId"];
                NSString *strObjId = profile.objectId;
                profileDisliked = profile;
                statusOfUndo = @"disliked";

                //make entry in dislike table
                PFObject *dislikeObj = [PFObject objectWithClassName:@"DislikeProfile"];
                dislikeObj[@"profileId"] = [PFObject objectWithoutDataWithClassName:@"Profile" objectId:[[NSUserDefaults standardUserDefaults]valueForKey:@"currentProfileId"]];
                dislikeObj[@"dislikeProfileId"] = [PFObject objectWithoutDataWithClassName:@"Profile" objectId:strObjId];
                
                [dislikeObj saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
                 {
                     //[MBProgressHUD hideHUDForView:self.view animated:YES];
                     [self hideLoader];
                     [self refreshPinPage];
                     statusOfUndo = @"disliked";
                     profileDisliked = profile;
                     lblUndoTitle.text = [NSString stringWithFormat:@"You Disliked %@",[profileDisliked valueForKey:@"name"]];

                     [self showUndoBar];
                 }];

                NSLog(@"Woohoo, Success!");
            }
        }];

            };
}
#pragma mark ShowAndHideActivityIndicator

-(void)showUndoBar{
    CATransition *animation = [CATransition animation];
    animation.type = kCATransitionFromBottom;
    animation.duration = 0.4;
    [undoBarView.layer addAnimation:animation forKey:nil];
    undoBarView.hidden = NO;
   // [self performSelector:@selector(hideUndoBar) withObject:nil afterDelay:2.f];
    [self refreshPinPage];
    UIEdgeInsets contentInsets;

    contentInsets = UIEdgeInsetsMake(0.0, 0.0, 50, 0.0);
    self.tableView.contentInset = contentInsets;
    self.tableView.scrollIndicatorInsets = contentInsets;
}

-(void)hideUndoBar{
    CATransition *animation = [CATransition animation];
    animation.type = kCATransitionFromTop;
    animation.duration = 0.4;
    [undoBarView.layer addAnimation:animation forKey:nil];
    undoBarView.hidden = YES;
    UIEdgeInsets contentInsets;
    
    contentInsets = UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0);

    self.tableView.contentInset = contentInsets;
    self.tableView.scrollIndicatorInsets = contentInsets;
}

#pragma mark RefreshPinProfile
-(void)refreshPinPage{
    if([[AppData sharedData]isInternetAvailable]){
        [self.btnPin setTitleColor:[UIColor colorWithRed:240/255.0f green:113/255.0f blue:116/255.0f alpha:1] forState:UIControlStateNormal];
        self.lblPageTitle.text = @"PINS";
        PFQuery *query = [PFQuery queryWithClassName:@"PinnedProfile"];
        [query whereKey:@"profileId" equalTo:self.currentProfile];
        [query includeKey:@"pinnedProfileId.casteId.religionId"];
        [query includeKey:@"pinnedProfileId.religionId"];
        [query includeKey:@"pinnedProfileId.gotraId.casteId.religionId"];
        [query includeKey:@"pinnedProfileId"];
        query.cachePolicy = kPFCachePolicyNetworkOnly;

        [query includeKey:@"pinnedProfileId.Parent.Parent"];
        [query includeKey:@"pinnedProfileId.currentLocation.Parent.Parent"];
        [query includeKey:@"pinnedProfileId.placeOfBirth.Parent.Parent"];
        [query includeKey:@"pinnedProfileId.casteId.Parent.Parent"];
        [query includeKey:@"pinnedProfileId.religionId.Parent.Parent"];
        [query includeKey:@"pinnedProfileId.gotraId.Parent.Parent"];
        [query includeKey:@"pinnedProfileId.education1.degreeId"];
        [query includeKey:@"pinnedProfileId.education2.degreeId"];
        [query includeKey:@"pinnedProfileId.education3.degreeId"];
        [query includeKey:@"pinnedProfileId.industryId"];
        [self showLoader];
        btnBack.enabled =YES;
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            [self hideLoader];
            
            if (!error) {
                if(objects.count == 0){
                    lblUserInfo.text = @"No Profiles Pinned.";
                    lblUserInfo.hidden = NO;
                }
                else
                    lblUserInfo.hidden = YES;
                
                //  [self getUserProfileForUser:objects[0]];
                arrPins = objects.mutableCopy;
                [self.tableView reloadData];
            } else {
                // Log details of the failure
                NSLog(@"Error: %@ %@", error, [error userInfo]);
                if(error.code ==100 ){
                    
                }
            }
        }];
        
    }
    else{
        UIAlertView *alert =  [[UIAlertView alloc]initWithTitle:@"Opps!!" message:@"Please Check your internet connection" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
    }

}
- (void)reloadCellForConversation:(LYRConversation *)conversation
{
    if (!conversation) {
        @throw [NSException exceptionWithName:NSInvalidArgumentException reason:@"`conversation` cannot be nil." userInfo:nil];
    }
    NSIndexPath *indexPath = [self.queryController indexPathForObject:conversation];
    if (indexPath) {
        [self.tableView reloadRowsAtIndexPaths:@[ indexPath ] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}
#pragma mark ShowFullProfile
- (NSString *)getFormattedHeightFromValue:(NSString *)value
{
    NSArray * arrHeight = [NSArray arrayWithObjects:@"4ft 5in - 134cm",@"4ft 6in - 137cm",@"4ft 7in - 139cm",@"4ft 8in - 142cm",@"4ft 9in - 144cm",@"4ft 10in - 147cm",@"4ft 11in - 149cm",@"5ft - 152cm",@"5ft 1in - 154cm",@"5ft 2in - 157cm",@"5ft 3in - 160cm",@"5ft 4in - 162cm",@"5ft 5in - 165cm",@"5ft 6in - 167cm",@"5ft 7in - 170cm",@"5ft 8in - 172cm",@"5ft 9in - 175cm",@"5ft 10in - 177cm",@"5ft 11in - 180cm",@"6ft - 182cm",@"6ft 1in - 185cm",@"6ft 2in - 187cm",@"6ft 3in - 190cm",@"6ft 4in - 193cm",@"6ft 5in - 195cm",@"6ft 6in - 198cm",@"6ft 7in - 200cm",@"6ft 8in - 203cm",@"6ft 9in - 205cm",@"6ft 10in - 208cm",@"6ft 11in - 210cm",@"7ft - 213cm", nil];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF CONTAINS[cd] %@", value];
    NSString *strFiltered = [[arrHeight filteredArrayUsingPredicate:predicate] firstObject];
    return strFiltered;
}

-(void)showFullProfileForProfile:(PFObject*)profileObj{
    Profile *profileModel = [[Profile alloc]init];
    profileModel.profilePointer = profileObj;
    profileModel.name = profileObj[@"name"];
    profileModel.age = [NSString stringWithFormat:@"%@",profileObj[@"age"]];
    profileModel.weight = [NSString stringWithFormat:@"%@",profileObj[@"weight"]];
    //caste label
    PFObject *caste = [profileObj valueForKey:@"casteId"];
    PFObject *religion = [profileObj valueForKey:@"religionId"];
    profileModel.religion = [religion valueForKey:@"name"];
    profileModel.caste = [caste valueForKey:@"name"];
    profileModel.designation = profileObj[@"designation"];
    
    //Height
    profileModel.height = [self getFormattedHeightFromValue:[NSString stringWithFormat:@"%@cm",[profileObj valueForKey:@"height"]]];
    
    //ADD data in model for complete profile view screen
    PFObject *currentLoc = [profileObj valueForKey:@"currentLocation"];
    PFObject *currentState = [currentLoc valueForKey:@"Parent"];
    profileModel.currentLocation = [NSString stringWithFormat:@"%@,%@",[currentLoc valueForKey:@"name"],[currentState valueForKey:@"name"]];
    profileModel.income = [profileObj valueForKey:@"package"];
    
    //birth location label
    PFObject *birthLoc = [profileObj valueForKey:@"placeOfBirth"];
    PFObject *birthState = [birthLoc valueForKey:@"Parent"];
    
    profileModel.placeOfBirth = [NSString stringWithFormat:@"%@,%@",[birthLoc valueForKey:@"name"],[birthState valueForKey:@"name"]];
    profileModel.minBudget = [NSString stringWithFormat:@"%@",[profileObj valueForKey:@"minMarriageBudget"]];
    profileModel.maxBudget = [NSString stringWithFormat:@"%@",[profileObj valueForKey:@"maxMarriageBudget"]];
    profileModel.company = [NSString stringWithFormat:@"%@",[profileObj valueForKey:@"placeOfWork"]];
    
    //DOB
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *strDate = [formatter stringFromDate:[profileObj valueForKey:@"dob"]];
    profileModel.dob = strDate;
    
    //TOB
    NSDate *dateTOB = [profileObj valueForKey:@"tob"];
    NSDateFormatter *formatterTime = [[NSDateFormatter alloc] init];
    [formatterTime setDateFormat:@"hh:mm:ss"];
    [formatterTime setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
    NSString *strTOB = [formatterTime stringFromDate:dateTOB];
    profileModel.tob = strTOB;
    
    //profilepic
    //load images in background
    PFFile *userImageFile = profileObj[@"profilePic"];
    [userImageFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error)
     {
         if (!error)
         {
             //got profile pic data for circular image view
             profileModel.profilePic = [UIImage imageWithData:data];
         }
     }];
    
    UIStoryboard *sb2 = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    CandidateProfileDetailScreenVC *vc = [sb2 instantiateViewControllerWithIdentifier:@"CandidateProfileDetailScreenVC"];
    vc.currentProfile = self.currentProfile;
    vc.profileObject = profileModel;
    
    //change screen navigation to full profile screen
    /*
     ViewFullProfileVC *vc = [segue destinationViewController];
     vc.arrImages = arrImages;
     vc.arrEducation = arrEducation;
     [self.navigationController pushViewController:vc animated:YES];
     */
    // Show chat button if it is match profile
    if(currentTab==0)
    {
        vc.isFromMatches = true;
        vc.isFromPins = false;
    }
    else
    {
        vc.isFromMatches = false;
        vc.isFromPins = true;
    }
    
    vc.layerClient = self.layerClient;
    [self.navigationController presentViewController:vc animated:YES completion:nil];
}
#pragma mark TabBarAction

- (IBAction)tabButtonAction:(id)sender {
    [self hideUndoBar];

    [self resetTab];
    if(currentTab != [sender tag]){
        currentTab = [sender tag];
        switch ([sender tag]) {
            case 0:
                [self switchToMatches];
                if(arrMatches.count>0)
                    lblUserInfo.hidden = YES;

                break;
            case 1:
                [self switchToPin];
                break;
            case 2:
                [self switchToChat];
                break;
            default:
                break;
        }
    }
    
}

-(void)resetTab{
    [self.btnMatch setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [self.btnPin setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [self.btnChat setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];

}
-(void)switchToMatches{
    chatView.hidden = YES;
    self.tableView.hidden = YES;
    matchTableView.hidden = NO;
    
    [self.btnMatch setTitleColor:[UIColor colorWithRed:240/255.0f green:113/255.0f blue:116/255.0f alpha:1] forState:UIControlStateNormal];

    //// chaged logic
    
    arrMatches = [[AppData sharedData]fetchAllMatches];
    if(arrMatches.count>0)
        lblUserInfo.hidden = YES;
    
    [matchTableView reloadData];
    if(arrMatches.count==0){
        if([[AppData sharedData]isInternetAvailable]){
            [self.btnMatch setTitleColor:[UIColor colorWithRed:240/255.0f green:113/255.0f blue:116/255.0f alpha:1] forState:UIControlStateNormal];
            self.lblPageTitle.text = @"MATCHES";
            [self showLoader];
            btnBack.enabled =YES;
            [PFCloud callFunctionInBackground:@"getMatchedProfile"
                               withParameters:@{@"profileId":[self.currentProfile objectId]}
                                        block:^(NSArray *results, NSError *error)
             {
                 [self hideLoader];
                 
                 if (!error)
                 {
                     if(results.count == 0){
                         lblUserInfo.text = @"No Matches found!!";
                         lblUserInfo.hidden = NO;
                     }
                     else
                         lblUserInfo.hidden = YES;
                     
                     arrMatches = results;
                     [PFObject pinAllInBackground:arrMatches];
                     [matchTableView reloadData];
                     
                 }
                 else{
                     UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Opps" message:[[error userInfo] objectForKey:@"error"] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                     [alert show];
                 }
             }];
        }
        else{
            UIAlertView *alert =  [[UIAlertView alloc]initWithTitle:@"Opps!!" message:@"Please Check your internet connection" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
        }

    }
}

-(void)switchToPin{
    matchTableView.hidden = YES;
    self.tableView.hidden = NO;
    chatView.hidden = YES;
    if([[AppData sharedData]isInternetAvailable]){
        [self.btnPin setTitleColor:[UIColor colorWithRed:240/255.0f green:113/255.0f blue:116/255.0f alpha:1] forState:UIControlStateNormal];
        self.lblPageTitle.text = @"PINS";
        PFQuery *query = [PFQuery queryWithClassName:@"PinnedProfile"];
        [query whereKey:@"profileId" equalTo:self.currentProfile];
        [query includeKey:@"pinnedProfileId.casteId.religionId"];
        [query includeKey:@"pinnedProfileId.religionId"];
        [query includeKey:@"pinnedProfileId.gotraId.casteId.religionId"];
        [query includeKey:@"pinnedProfileId"];
        query.cachePolicy = kPFCachePolicyCacheThenNetwork;
        [query includeKey:@"pinnedProfileId.Parent.Parent"];
        [query includeKey:@"pinnedProfileId.currentLocation.Parent.Parent"];
        [query includeKey:@"pinnedProfileId.placeOfBirth.Parent.Parent"];
        [query includeKey:@"pinnedProfileId.casteId.Parent.Parent"];
        [query includeKey:@"pinnedProfileId.religionId.Parent.Parent"];
        [query includeKey:@"pinnedProfileId.gotraId.Parent.Parent"];
        [query includeKey:@"pinnedProfileId.education1.degreeId"];
        [query includeKey:@"pinnedProfileId.education2.degreeId"];
        [query includeKey:@"pinnedProfileId.education3.degreeId"];
        [query includeKey:@"pinnedProfileId.industryId"];
        [self showLoader];
        btnBack.enabled =YES;
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            [self hideLoader];

            if (!error) {
                if(objects.count == 0){
                    lblUserInfo.text = @"No Profiles Pinned.";
                    lblUserInfo.hidden = NO;
                }
                else
                    lblUserInfo.hidden = YES;
                
                if(currentTab!=1)
                    if(arrMatches.count>0)
                       lblUserInfo.hidden = YES;
 
                arrPins = objects.mutableCopy;
                [self.tableView reloadData];
            }
        }];
    }
    else{
        UIAlertView *alert =  [[UIAlertView alloc]initWithTitle:@"Opps!!" message:@"Please Check your internet connection" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
    }
}

-(void)switchToChat{
    chatView.hidden = NO;
    matchTableView.hidden = YES;
    self.tableView.hidden = YES;
    [self.btnChat setTitleColor:[UIColor colorWithRed:240/255.0f green:113/255.0f blue:116/255.0f alpha:1] forState:UIControlStateNormal];
    self.lblPageTitle.text = @"CHATS";
    [self.tableView reloadData];
    lblUserInfo.hidden = YES;
}

#pragma mark - ATLConversationListViewControllerDataSource Methods

- (NSString *)conversationListViewController:(ATLConversationListViewController *)conversationListViewController titleForConversation:(LYRConversation *)conversation
{
    if ([conversation.metadata valueForKey:@"title"]){
        return [conversation.metadata valueForKey:@"title"];
    }
    else {
        NSArray *unresolvedParticipants = [[UserManager sharedManager] unCachedUserIDsFromParticipants:[conversation.participants allObjects]];
        NSArray *resolvedNames = [[UserManager sharedManager] resolvedNamesFromParticipants:[conversation.participants allObjects]];
        
        if ([unresolvedParticipants count]) {
            [[UserManager sharedManager] queryAndCacheUsersWithIDs:unresolvedParticipants completion:^(NSArray *participants, NSError *error) {
                if (!error) {
                    if (participants.count) {
                      //  [self reloadCellForConversation:conversation];
                    }
                } else {
                    NSLog(@"Error querying for Users: %@", error);
                }
            }];
        }
        if ([resolvedNames count] && [unresolvedParticipants count]) {
            return [NSString stringWithFormat:@"%@ and %lu others", [resolvedNames componentsJoinedByString:@", "], (unsigned long)[unresolvedParticipants count]];
        } else if ([resolvedNames count] && [unresolvedParticipants count] == 0) {
            return [NSString stringWithFormat:@"%@", [resolvedNames componentsJoinedByString:@", "]];
        } else {
            return [NSString stringWithFormat:@"Conversation with %lu users...", (unsigned long)conversation.participants.count];
        }
    }
}

#pragma mark - Layer Authentication Methods

- (void)loginLayer
{
    // Connect to Layer
    // See "Quick Start - Connect" for more details
    // https://developer.layer.com/docs/quick-start/ios#connect
    [self.layerClient connectWithCompletion:^(BOOL success, NSError *error) {
        if (!success) {
            if(error.code ==6000)
                [self presentConversationListViewController];
        } else {
            PFUser *user = [PFUser currentUser];
            NSString *userID = user.objectId;
            [self authenticateLayerWithUserID:userID completion:^(BOOL success, NSError *error) {
                if (!error){
                    
                    [self presentConversationListViewController];
                    //[self getAllChat];
                } else {
                    NSLog(@"Failed Authenticating Layer Client with error:%@", error);
                }
            }];
        }
    }];
}

- (void)authenticateLayerWithUserID:(NSString *)userID completion:(void (^)(BOOL success, NSError * error))completion
{
    // Check to see if the layerClient is already authenticated.
    if (self.layerClient.authenticatedUserID) {
        // If the layerClient is authenticated with the requested userID, complete the authentication process.
        if ([self.layerClient.authenticatedUserID isEqualToString:userID]){
            NSLog(@"Layer Authenticated as User %@", self.layerClient.authenticatedUserID);
            if (completion) completion(YES, nil);
            return;
        } else {
            //If the authenticated userID is different, then deauthenticate the current client and re-authenticate with the new userID.
            [self.layerClient deauthenticateWithCompletion:^(BOOL success, NSError *error) {
                if (!error){
                    [self authenticationTokenWithUserId:userID completion:^(BOOL success, NSError *error) {
                        if (completion){
                            completion(success, error);
                        }
                    }];
                } else {
                    if (completion){
                        completion(NO, error);
                    }
                }
            }];
        }
    } else {
        // If the layerClient isn't already authenticated, then authenticate.
        [self authenticationTokenWithUserId:userID completion:^(BOOL success, NSError *error) {
            if (completion){
                completion(success, error);
            }
        }];
    }
}

- (void)authenticationTokenWithUserId:(NSString *)userID completion:(void (^)(BOOL success, NSError* error))completion
{
    /*
     * 1. Request an authentication Nonce from Layer
     */
    [self.layerClient requestAuthenticationNonceWithCompletion:^(NSString *nonce, NSError *error) {
        if (!nonce) {
            if (completion) {
                completion(NO, error);
            }
            return;
        }
        
        /*
         * 2. Acquire identity Token from Layer Identity Service
         */
        NSDictionary *parameters = @{@"nonce" : nonce, @"userID" : userID};
        
        [PFCloud callFunctionInBackground:@"generateToken" withParameters:parameters block:^(id object, NSError *error) {
            if (!error){
                
                NSString *identityToken = (NSString*)object;
                [self.layerClient authenticateWithIdentityToken:identityToken completion:^(NSString *authenticatedUserID, NSError *error) {
                    if (authenticatedUserID) {
                        if (completion) {
                            completion(YES, nil);
                        }
                        NSLog(@"Layer Authenticated as User: %@", authenticatedUserID);
                    } else {
                        completion(NO, error);
                    }
                }];
            } else {
                NSLog(@"Parse Cloud function failed to be called to generate token with error: %@", error);
            }
        }];
        
    }];
}
- (void)presentConversationListViewController
{
    LYRQuery *query = [LYRQuery queryWithQueryableClass:[LYRMessage class]];
    
    NSError *error;
    NSOrderedSet *messages = [self.layerClient executeQuery:query error:&error];
    if (messages) {
        NSLog(@"%tu messages", messages.count);
    } else {
        NSLog(@"Query failed with error %@", error);
    }
    
    LYRQuery *query2 = [LYRQuery queryWithQueryableClass:[LYRConversation class]];
    NSError *error2 = nil;
    NSOrderedSet *conversation = [self.layerClient executeQuery:query2 error:&error2];
    if (conversation) {
        NSLog(@"%tu conversations", conversation.count);
    } else {
        NSLog(@"Query failed with error %@", error);
    }
    ConversationListViewController *controller = [ConversationListViewController  conversationListViewControllerWithLayerClient:self.layerClient];
    [chatView addSubview:controller.view];
    [self addChildViewController:controller];
}
#pragma mark ShowActiviatyIndicator

-(void)showLoader{
    [activityIndicator startAnimating];
    self.btnChat.enabled = NO;
    self.btnPin.enabled = NO;
    self.btnMatch.enabled = NO;
    self.tableView.allowsSelection = NO;
    lblUserInfo.hidden = YES;
    self.tableView.userInteractionEnabled = NO;

}
-(void)hideLoader{
    [activityIndicator stopAnimating];
    self.btnChat.enabled = YES;
    self.btnPin.enabled = YES;
    self.btnMatch.enabled = YES;
    self.tableView.allowsSelection = YES;
    self.tableView.userInteractionEnabled = YES;

}


#pragma mark - Notification
-(void)openMatchScreen:(NSNotification *) notification
{
    [self switchToPin];
    Profile *pro = [notification object];
    //get traits count
    NSDictionary* userInfo = notification.userInfo;
    UIStoryboard *sb2 = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    MatchScreenVC *vc = [sb2 instantiateViewControllerWithIdentifier:@"MatchScreenVC"];
    vc.profileObj = pro;
    vc.txtTraits = userInfo[@"traitsCount"];;
    [self.navigationController presentViewController:vc animated:YES completion:nil];

}

#pragma mark ChatCode

-(void)chatButtonAction:(id)sender {
    [self getAllUserForAConversationForIndex:[sender tag]];
}
#pragma mark Chat
-(LYRConversation*)getChatConversationIfPossibleWithUsers:(NSMutableArray*)arrUser withProfileObject:(PFObject*)profileObj{
    NSArray *participants = arrUser;
    LYRQuery *query = [LYRQuery queryWithQueryableClass:[LYRConversation class]];
    query.predicate = [LYRPredicate predicateWithProperty:@"participants" predicateOperator:LYRPredicateOperatorIsEqualTo value:participants];
    [self showLoader];
    NSError *error = nil;
    NSOrderedSet *conversations1 = [self.layerClient executeQuery:query error:&error];
    [self hideLoader];
    if (!error) {
        LYRConversation *userConversation;

        if(conversations1.count==0){
            NSError *error = nil;
            LYRConversation *conversation1 = [self.layerClient newConversationWithParticipants:[NSSet setWithArray:arrUser] options:nil error:&error];
            userConversation = conversation1;
        }
        else{
            userConversation = conversations1[0];
        }
        ConversationViewController *controller = [ConversationViewController conversationViewControllerWithLayerClient:self.layerClient];
        controller.conversation = userConversation;
        controller.displaysAddressBar = NO;
        UINavigationController *navController  = [[UINavigationController alloc]initWithRootViewController:controller];
        controller.title = profileObj[@"name"];
        [self presentViewController:navController animated:YES completion:nil];

        UIButton *chat=[UIButton buttonWithType:UIButtonTypeCustom];
        [chat setTitle:@"Chat" forState:UIControlStateNormal];
        
    } else {
        NSLog(@"Query failed with error %@", error);
    }
    return nil;
}
-(void)getAllUserForAConversationForIndex:(NSInteger)index{
    PFObject *profileObject = arrMatches[index];
    [self showLoader];
    PFQuery *query1 = [PFQuery queryWithClassName:@"UserProfile"];
    [query1 whereKey:@"profileId" equalTo:self.currentProfile];
    [query1 whereKey:@"relation" equalTo:@"Bachelor"];
    PFQuery *query2 = [PFQuery queryWithClassName:@"UserProfile"];
    [query2 whereKey:@"profileId" equalTo:profileObject];
    [query2 whereKey:@"relation" equalTo:@"Bachelor"];
    PFQuery *mainQuery = [PFQuery orQueryWithSubqueries:@[query1,query2]];
    [mainQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        [self hideLoader];

        if (!error) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            NSMutableArray *arrUserIds = [NSMutableArray array];
            for(PFObject *obj in objects){
                PFUser *user = [obj valueForKey:@"userId"];
                [arrUserIds addObject:user.objectId];
            }
            NSLog(@"arrUserIds --  %@",arrUserIds);
            [self getChatConversationIfPossibleWithUsers:arrUserIds withProfileObject:profileObject];
            // The find succeeded.
        }
    }];
    
}

- (IBAction)undoButtonAction:(id)sender {
    //Insert profile in pin Class
    [self showLoader];
    PFObject *pinnedProfile = [PFObject objectWithClassName:@"PinnedProfile"];
    [pinnedProfile setObject:self.currentProfile forKey:@"profileId"];
    if([statusOfUndo isEqual:@"liked"])
        [pinnedProfile setObject:profileLiked forKey:@"pinnedProfileId"];
    else  if([statusOfUndo isEqual:@"disliked"])
        [pinnedProfile setObject:profileDisliked forKey:@"pinnedProfileId"];

    [pinnedProfile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        
        if (succeeded) {
            [self hideLoader];
            [self hideUndoBar];
            [self refreshPinPage];
            if([statusOfUndo isEqual:@"liked"]){
                PFQuery *query = [PFQuery queryWithClassName:@"LikedProfile"];
               [query whereKey:@"likeProfileId" equalTo:profileLiked];
                [query whereKey:@"profileId" equalTo:self.currentProfile];
                [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                    
                    if (!error) {
                        PFObject *likedProfile = objects[0];
                        [likedProfile deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                            if (succeeded)
                                NSLog(@"undo liked");
                        }];
                    }
                }];
            }
            else  if([statusOfUndo isEqual:@"disliked"]){
                PFQuery *query = [PFQuery queryWithClassName:@"DislikeProfile"];
                [query whereKey:@"dislikeProfileId" equalTo:profileDisliked];
                [query whereKey:@"profileId" equalTo:self.currentProfile];
                [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                    
                    if (!error) {
                        PFObject *likedProfile = objects[0];
                        [likedProfile deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                            if (succeeded)
                                NSLog(@"undo disliked");
                        }];
                    }
                }];
            }
        }
    }];
}

@end
