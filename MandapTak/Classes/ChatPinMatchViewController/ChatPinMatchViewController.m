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
#import "ConversationListViewController.h"
@interface ChatPinMatchViewController ()<ATLConversationListViewControllerDelegate, ATLConversationListViewControllerDataSource,LYRQueryControllerDelegate>{
    NSInteger currentTab;
    NSArray *arrMatches;
    NSArray *arrPins;
    __weak IBOutlet UIButton *btnBack;
    NSArray *arrChats;
    NSMutableArray *arrCachedMatches;
    __weak IBOutlet UILabel *lblUserInfo;
    NSOrderedSet *conversations;
    __weak IBOutlet UIView *chatView;
  //  PFObject *currentProfile;
}
@property (nonatomic) LYRQueryController *queryController;

@property (weak, nonatomic) IBOutlet UIButton *btnChat;
@property (weak, nonatomic) IBOutlet UIButton *btnPin;
@property (weak, nonatomic) IBOutlet UIButton *btnMatch;
@property (weak, nonatomic) IBOutlet UILabel *lblPageTitle;
- (IBAction)backToHome:(id)sender;
- (IBAction)tabButtonAction:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

static NSString *const LayerAppIDString = @"layer:///apps/staging/3ffe495e-45e8-11e5-9685-919001005125";
@implementation ChatPinMatchViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    //self.layerClient = [LYRClient clientWithAppID:appID];
    //self.layerClient.autodownloadMIMETypes = [NSSet setWithObjects:ATLMIMETypeImagePNG, ATLMIMETypeImageJPEG, ATLMIMETypeImageJPEGPreview, ATLMIMETypeImageGIF, ATLMIMETypeImageGIFPreview, ATLMIMETypeLocation, nil];
    
    chatView.hidden = YES;
    
    [self loginLayer];
    currentTab = 0;
    lblUserInfo.hidden = YES;
    arrCachedMatches = [NSMutableArray array];
    arrMatches = [NSArray array];
    arrPins = [NSArray array];
    arrChats = [NSArray array];
      self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    if(self.currentProfile){
        [self switchToMatches];
    }
    else{
        if([[AppData sharedData]isInternetAvailable]){
            MBProgressHUD * hud;
            hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
            btnBack.enabled =YES;
            PFQuery *query = [PFQuery queryWithClassName:@"Profile"];
            query.cachePolicy = kPFCachePolicyCacheOnly;
            [query whereKey:@"objectId" equalTo:[[NSUserDefaults standardUserDefaults]valueForKey:@"currentProfileId"]];
            [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                
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
    NSOrderedSet *conversations = [self.layerClient executeQuery:query2 error:&error2];
    if (conversations) {
        NSLog(@"%tu conversations", conversations.count);
    } else {
        NSLog(@"Query failed with error %@", error);
    }
       
    
}

-(void)getAllChat{
    LYRQuery *query2 = [LYRQuery queryWithQueryableClass:[LYRConversation class]];
    
    NSError *error2 = nil;
    conversations = [self.layerClient executeQuery:query2 error:&error2];
    if (conversations) {
        NSLog(@"%tu conversations", conversations.count);
    } else {
        NSLog(@"Query failed with error %@", error2);
    }
    [self.tableView reloadData];
}

- (IBAction)backToHome:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)tabButtonAction:(id)sender {
    [self resetTab];
    if(currentTab != [sender tag]){
        currentTab = [sender tag];
    switch ([sender tag]) {
        case 0:
            [self switchToMatches];
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
    MatchAndPinTableViewCell *matchAndPinCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier2];
    matchAndPinCell.selectionStyle = UITableViewCellSelectionStyleNone;
    static NSString *cellIdentifier3 = @"ChatTableViewCell";
    ChatTableViewCell *chatCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier3];
    if(currentTab ==0){
        
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
        matchAndPinCell.lblReligion.text =strReligion;
        [matchAndPinCell.btnPinOrMatch setImage:[UIImage imageNamed:@"matchCellOption"] forState:UIControlStateNormal];
        matchAndPinCell.lblName.text = [profile valueForKey:@"name"];
        matchAndPinCell.lblDesignation.text = [profile valueForKey:@"designation"];
       // [matchAndPinCell.btnPinOrMatch addTarget:self action:@selector(matchButtonAction:) forControlEvents:UIControlEventTouchUpInside];
         
        matchAndPinCell.btnPinOrMatch.hidden = YES;
        return matchAndPinCell;

    }
    else if(currentTab ==1){
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

- (NSString *)getFormattedHeightFromValue:(NSString *)value
{
    NSArray * arrHeight = [NSArray arrayWithObjects:@"4ft 5in - 134cm",@"4ft 6in - 137cm",@"4ft 7in - 139cm",@"4ft 8in - 142cm",@"4ft 9in - 144cm",@"4ft 10in - 147cm",@"4ft 11in - 149cm",@"5ft - 152cm",@"5ft 1in - 154cm",@"5ft 2in - 157cm",@"5ft 3in - 160cm",@"5ft 4in - 162cm",@"5ft 5in - 165cm",@"5ft 6in - 167cm",@"5ft 7in - 170cm",@"5ft 8in - 172cm",@"5ft 9in - 175cm",@"5ft 10in - 177cm",@"5ft 11in - 180cm",@"6ft - 182cm",@"6ft 1in - 185cm",@"6ft 2in - 187cm",@"6ft 3in - 190cm",@"6ft 4in - 193cm",@"6ft 5in - 195cm",@"6ft 6in - 198cm",@"6ft 7in - 200cm",@"6ft 8in - 203cm",@"6ft 9in - 205cm",@"6ft 10in - 208cm",@"6ft 11in - 210cm",@"7ft - 213cm", nil];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF CONTAINS[cd] %@", value];
    NSString *strFiltered = [[arrHeight filteredArrayUsingPredicate:predicate] firstObject];
    return strFiltered;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(currentTab ==0){
        PFObject *profile = arrMatches[indexPath.row];
        [self showFullProfileForProfile:profile];
    }
    else if(currentTab == 1){
        PFObject *pinnedProfile = arrPins[indexPath.row];
        PFObject *profile = [pinnedProfile valueForKey:@"pinnedProfileId"];
        [self showFullProfileForProfile:profile];

    }
    else{
       // if ([self.delegate respondsToSelector:@selector(conversationListViewController:didSelectConversation:)]){
            LYRConversation *conversation = [self.queryController objectAtIndexPath:indexPath];
         //   [self.delegate conversationListViewController:self didSelectConversation:conversation];
       // }

    }
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
    UIStoryboard *sb2 = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    CandidateProfileDetailScreenVC *vc = [sb2 instantiateViewControllerWithIdentifier:@"CandidateProfileDetailScreenVC"];
    vc.currentProfile = self.currentProfile;
    vc.profileObject = profileModel;
    vc.isFromMatches = true;
    vc.layerClient = self.layerClient;
    [self.navigationController presentViewController:vc animated:YES completion:nil];
}
#pragma TabBarAction

-(void)resetTab{
    [self.btnMatch setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [self.btnPin setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [self.btnChat setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];

}
-(void)switchToMatches{
    chatView.hidden = YES;
    if([[AppData sharedData]isInternetAvailable]){
        [self.btnMatch setTitleColor:[UIColor colorWithRed:240/255.0f green:113/255.0f blue:116/255.0f alpha:1] forState:UIControlStateNormal];
        self.lblPageTitle.text = @"MATCHES";
        MBProgressHUD * hud;
        hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
        btnBack.enabled =YES;
        [PFCloud callFunctionInBackground:@"getMatchedProfile"
                           withParameters:@{@"profileId":[self.currentProfile objectId]}
                                    block:^(NSArray *results, NSError *error)
         {
             [MBProgressHUD hideHUDForView:self.view animated:YES];
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
                 [self.tableView reloadData];
                 
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

-(void)switchToPin{
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
        MBProgressHUD * hud;
        hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
        btnBack.enabled =YES;
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            if (!error) {
                if(objects.count == 0){
                    lblUserInfo.text = @"No Profiles Pinned.";
                    lblUserInfo.hidden = NO;
                }
                else
                    lblUserInfo.hidden = YES;
                
                //  [self getUserProfileForUser:objects[0]];
                arrPins = objects;
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
-(void)switchToChat{
    chatView.hidden = NO;
    [self.btnChat setTitleColor:[UIColor colorWithRed:240/255.0f green:113/255.0f blue:116/255.0f alpha:1] forState:UIControlStateNormal];
    self.lblPageTitle.text = @"CHATS";
    [self.tableView reloadData];
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
                    [self getAllChat];
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
    NSOrderedSet *conversations = [self.layerClient executeQuery:query2 error:&error2];
    if (conversations) {
        NSLog(@"%tu conversations", conversations.count);
    } else {
        NSLog(@"Query failed with error %@", error);
    }
    ConversationListViewController *controller = [ConversationListViewController  conversationListViewControllerWithLayerClient:self.layerClient];
    [chatView addSubview:controller.view];
    [self addChildViewController:controller];
    //[self.navigationController pushViewController:controller animated:YES];

}



@end
