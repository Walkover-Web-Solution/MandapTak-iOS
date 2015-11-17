//
//  AgentUserDetailViewController.m
//  MandapTak
//
//  Created by Hussain Chhatriwala on 09/11/15.
//  Copyright © 2015 Walkover. All rights reserved.
//

#import "AgentUserDetailViewController.h"
#import "UserDetailTableViewCell.h"
#import "WYPopoverController.h"
#import "WYStoryboardPopoverSegue.h"
#import "CreateNewUserPopoverViewController.h"

@interface AgentUserDetailViewController (){
    NSMutableArray *arrProfiles;
    WYPopoverController* popoverController;

    __weak IBOutlet UILabel *lblUserInfo;
    __weak IBOutlet UILabel *lblBal;
    PFObject *selectedUserProfile;
}
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *backButtonAction;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
- (IBAction)backButtonAction:(id)sender;

@end

@implementation AgentUserDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    lblUserInfo.hidden  =YES;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    arrProfiles = [NSMutableArray array];
    PFObject *profile = [self.userProfile valueForKey:@"profileId"];
    [self showLoader];
    PFQuery *query = [PFQuery queryWithClassName:@"UserProfile"];
    [self getUserCredits];
    [query includeKey:@"profileId"];
    [query includeKey:@"userId"];
    [query includeKey:@"profileId.userId"];
    [query whereKey:@"profileId" equalTo:profile];
    //[query whereKey:@"relation" notEqualTo:@"Bachelor"];
    //[query whereKey:@"relation" notEqualTo:@"Agent"];
    [query whereKey:@"relation" notContainedIn:@[@"Bachelor", @"Agent"]];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        [self hideLoader];
        
        if (!error) {
            lblUserInfo.hidden = NO;
            if(objects.count==0){
                lblUserInfo.text = @"No Permissons given till now.";
            }
                     arrProfiles = objects.mutableCopy;
            [self.tableView reloadData];
            //            NSMutableArray *arrUserIds = [NSMutableArray array];
            //            for(PFObject *obj in objects){
            //                PFUser *user = [obj valueForKey:@"userId"];
            //                [arrUserIds addObject:user.objectId];
            //            }
            //            NSLog(@"arrUserIds --  %@",arrUserIds);
            // The find succeeded.
        }
    }];

    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)getUserCredits{
    PFObject *profile = [self.userProfile valueForKey:@"profileId"];
    PFUser *user = [profile valueForKey:@"userId"];

    PFQuery *query = [PFQuery queryWithClassName:@"UserCredits"];
    [query whereKey:@"userId" equalTo:user];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        
        if (!error) {
            PFObject *obj = objects[0];
            //credit =[[obj valueForKey:@"credits"] integerValue];
            lblBal.text = [NSString stringWithFormat:@"%@ Credits",[obj valueForKey:@"credits"]];
        }
    }];
}

#pragma mark UITableViewDelegate

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return arrProfiles.count;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier1 = @"UserDetailTableViewCell";
    UserDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier1];
    if (cell == nil)
        cell = [[UserDetailTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier1];
    
    PFObject *userProfile = arrProfiles[indexPath.row];
  //  PFObject *profile = [userProfile valueForKey:@"profileId"];
    PFUser *user = [userProfile valueForKey:@"userId"];
    
      // NSString *name =[profile valueForKey:@"name"];
    
    cell.lblUserNumber.text = user.username;
    cell.lblRelation.text = [userProfile valueForKey:@"relation"];

//    if(name!=nil||name.length!=0)
//        cell.lblUserNumber.text = [profile valueForKey:@"name"];
    
    cell.btnEdit.tag = indexPath.row;
    [cell.btnEdit addTarget:self action:@selector(performEditAction:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
    
}

-(void)performEditAction:(id)sender{
    selectedUserProfile = arrProfiles[[sender tag]];
    [self performSegueWithIdentifier:@"EditUserIdentifier" sender:self];

}
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"EditUserIdentifier"])
    {
        AgentUserDetailViewController *vc = [segue destinationViewController];
        vc.userProfile = selectedUserProfile;
            }
    // Pass the selected object to the new view controller.
}

#pragma mark ShowActivityIndicator
-(void)showLoader{
    [self.activityIndicator startAnimating];
    self.tableView.allowsSelection = NO;
    self.tableView.userInteractionEnabled = NO;
}

-(void)hideLoader{
    [self.activityIndicator stopAnimating];
    self.tableView.allowsSelection = YES;

    self.tableView.userInteractionEnabled = YES;
}

- (IBAction)backButtonAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
