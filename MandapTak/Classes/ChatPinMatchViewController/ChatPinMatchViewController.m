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
#import <Parse/Parse.h>
@interface ChatPinMatchViewController (){
    NSInteger currentTab;
    NSArray *arrMatches;
    NSArray *arrPins;
    NSArray *arrChats;
    PFObject *currentProfile;
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
    arrMatches = [NSArray array];
    arrPins = [NSArray array];
    arrChats = [NSArray array];
    PFQuery *query = [PFQuery queryWithClassName:@"Profile"];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [query whereKey:@"objectId" equalTo:[[NSUserDefaults standardUserDefaults]valueForKey:@"currentProfileId"]];
    MBProgressHUD * hud;
    hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        if (!error) {
            
            // The find succeeded.
            PFObject *obj= objects[0];
            currentProfile =obj;
            [self switchToMatches];
            
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
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
        matchAndPinCell.lblDesignation.text = [profile valueForKey:@"designation"];
        [[profile objectForKey:@"profilePic"] getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
            matchAndPinCell.imgProfile.image = [UIImage imageWithData:data];;
        }];
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
        return matchAndPinCell;

    }
    else if(currentTab ==1){
        PFObject *pinnedProfile = arrPins[indexPath.row];
        PFObject *profile = [pinnedProfile valueForKey:@"pinnedProfileId"];
        matchAndPinCell.lblDesignation.text = [profile valueForKey:@"designation"];
        [[profile objectForKey:@"profilePic"] getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
            matchAndPinCell.imgProfile.image = [UIImage imageWithData:data];;
        }];
        [matchAndPinCell.btnPinOrMatch setImage:[UIImage imageNamed:@"unpin"] forState:UIControlStateNormal];
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

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (currentTab) {
        case 0:
          
            break;
        case 1:
           
            break;
        case 2:
            
            break;

            
        default:
            break;
    }
}

#pragma TabBarAction

-(void)resetTab{
    [self.btnMatch setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [self.btnPin setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [self.btnChat setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];

}
-(void)switchToMatches{
    [self.btnMatch setTitleColor:[UIColor colorWithRed:240/255.0f green:113/255.0f blue:116/255.0f alpha:1] forState:UIControlStateNormal];
    self.lblPageTitle.text = @"MATCHES";
    MBProgressHUD * hud;
    hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [PFCloud callFunctionInBackground:@"getMatchedProfile"
                       withParameters:@{@"profileId":[currentProfile objectId]}
                                block:^(NSArray *results, NSError *error)
     {
         [MBProgressHUD hideHUDForView:self.view animated:YES];
         if (!error)
         {
             arrMatches = results;
             [self.tableView reloadData];

         }
         else{
             UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Opps" message:[[error userInfo] objectForKey:@"error"] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
             [alert show];
         }
     }];

}


-(void)switchToPin{
    [self.btnPin setTitleColor:[UIColor colorWithRed:240/255.0f green:113/255.0f blue:116/255.0f alpha:1] forState:UIControlStateNormal];
    self.lblPageTitle.text = @"PINS";
    

    PFQuery *query = [PFQuery queryWithClassName:@"PinnedProfile"];
    [query whereKey:@"profileId" equalTo:currentProfile];
    [query includeKey:@"pinnedProfileId.casteId.religionId"];
    [query includeKey:@"pinnedProfileId.religionId"];
    [query includeKey:@"pinnedProfileId.gotraId.casteId.religionId"];

    [query includeKey:@"pinnedProfileId"];

    MBProgressHUD * hud;
    hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        if (!error) {
            //  [self getUserProfileForUser:objects[0]];
            arrPins = objects;
            [self.tableView reloadData];
            } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];

    

}
-(void)switchToChat{
    [self.btnChat setTitleColor:[UIColor colorWithRed:240/255.0f green:113/255.0f blue:116/255.0f alpha:1] forState:UIControlStateNormal];
    self.lblPageTitle.text = @"CHATS";
    [self.tableView reloadData];
}
@end
