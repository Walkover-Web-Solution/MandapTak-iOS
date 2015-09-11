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
@interface ChatPinMatchViewController (){
    NSInteger currentTab;
    NSArray *arrMatches;
    NSArray *arrPins;
    NSArray *arrChats;
    NSMutableArray *arrCachedMatches;
    __weak IBOutlet UILabel *lblUserInfo;
  //  PFObject *currentProfile;
}
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
    currentTab = 0;
    lblUserInfo.hidden = YES;
    arrCachedMatches = [NSMutableArray array];

    arrMatches = [NSArray array];
    arrPins = [NSArray array];
    arrChats = [NSArray array];
    PFQuery *query = [PFQuery queryWithClassName:@"Profile"];
    query.cachePolicy = kPFCachePolicyCacheThenNetwork;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [query whereKey:@"objectId" equalTo:[[NSUserDefaults standardUserDefaults]valueForKey:@"currentProfileId"]];
    if(self.currentProfile){
        [self switchToMatches];
    }
    else{
        if([[AppData sharedData]isInternetAvailable]){
            MBProgressHUD * hud;
            hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
            [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                
                if (!error) {
                    
                    // The find succeeded.
                    PFObject *obj= objects[0];
                    self.currentProfile =obj;
                    [self switchToMatches];
                    
                } else {
                    // Log details of the failure
                    NSLog(@"Error: %@ %@", error, [error userInfo]);
                }
            }];

        }
        else{
            UIAlertView *alert =  [[UIAlertView alloc]initWithTitle:@"Opps!!" message:@"Please Check your internet connection" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
        }

    }
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


-(void)matchButtonAction:(id)sender {
    
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
            return arrChats.count;
            break;
       
    }
    return 0;
}



- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier2 = @"MatchAndPinTableViewCell";
    MatchAndPinTableViewCell *matchAndPinCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier2];
    
    static NSString *cellIdentifier3 = @"DegreeTableViewCell";
    ChatTableViewCell *chatCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier3];
    if(currentTab ==0){
        
        PFObject *profile = arrMatches[indexPath.row];
        Profile *profileModel = arrCachedMatches[indexPath.row];
        matchAndPinCell.lblDesignation.text = profileModel.designation;

        /*
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
        if(![[profile valueForKey:@"casteId"] isKindOfClass:[NSNull class]]){
            strReligion = [strReligion stringByAppendingString:[NSString stringWithFormat:@", %@",[[profile valueForKey:@"casteId"] valueForKey:@"name"]]];
        }
        if(![[profile valueForKey:@"gotraId"] isKindOfClass:[NSNull class]]){
            strReligion =[strReligion stringByAppendingString:[NSString stringWithFormat:@", %@",[[profile valueForKey:@"gotraId"] valueForKey:@"name"]]];
        }
        matchAndPinCell.lblReligion.text =strReligion;
        [matchAndPinCell.btnPinOrMatch setImage:[UIImage imageNamed:@"matchCellOption"] forState:UIControlStateNormal];
        matchAndPinCell.lblName.text = [profile valueForKey:@"name"];
        matchAndPinCell.lblDesignation.text = [profile valueForKey:@"designation"];
        [matchAndPinCell.btnPinOrMatch addTarget:self action:@selector(matchButtonAction:) forControlEvents:UIControlEventTouchUpInside];
         
         */
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

        return matchAndPinCell;

          }
    else if(currentTab ==2){
        return chatCell;
    }

       return matchAndPinCell;
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
        
    }
}
-(void)showFullProfileForProfile:(PFObject*)profileObj{
    Profile *profileModel = [[Profile alloc]init];
    profileModel.profilePointer = profileObj;
    profileModel.name = profileObj[@"name"];
    profileModel.age = [NSString stringWithFormat:@"%@",profileObj[@"age"]];
    //profileModel.height = [NSString stringWithFormat:@"%@",profileObj[@"height"]];
    profileModel.weight = [NSString stringWithFormat:@"%@",profileObj[@"weight"]];
    //caste label
    PFObject *caste = [profileObj valueForKey:@"casteId"];
    PFObject *religion = [profileObj valueForKey:@"religionId"];
    //NSLog(@"religion = %@ and caste = %@",[religion valueForKey:@"name"],[caste valueForKey:@"name"]);
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
    
    vc.profileObject = profileModel;
    
    [self.navigationController presentViewController:vc animated:YES completion:nil];
}
#pragma TabBarAction

-(void)resetTab{
    [self.btnMatch setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [self.btnPin setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [self.btnChat setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];

}
-(void)switchToMatches{
    if([[AppData sharedData]isInternetAvailable]){
        [self.btnMatch setTitleColor:[UIColor colorWithRed:240/255.0f green:113/255.0f blue:116/255.0f alpha:1] forState:UIControlStateNormal];
        self.lblPageTitle.text = @"MATCHES";
        MBProgressHUD * hud;
        hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
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
    [self.btnChat setTitleColor:[UIColor colorWithRed:240/255.0f green:113/255.0f blue:116/255.0f alpha:1] forState:UIControlStateNormal];
    self.lblPageTitle.text = @"CHATS";
    [self.tableView reloadData];
}
@end
