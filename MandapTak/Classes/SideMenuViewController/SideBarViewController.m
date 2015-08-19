//
//  SideBarViewController.m
//  MandapTak
//
//  Created by Hussain Chhatriwala on 28/07/15.
//  Copyright (c) 2015 Walkover. All rights reserved.
//

#import "SideBarViewController.h"
#import "EditProfileViewController.h"
#import "SWRevealViewController.h"
#import "PreferenceVC.h"

@interface SideBarViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imgView;

@end

@implementation SideBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.imgView.layer.cornerRadius = 70;
    self.imgView.clipsToBounds = YES;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark UITableView Data Source

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 3;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"PinLogsCell";
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (!cell) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        [cell setBackgroundColor:[UIColor clearColor]];
        cell.textLabel.textColor = [UIColor darkGrayColor];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    switch (indexPath.row) {
        case 0:
            cell.textLabel.text = @"Profile";
            cell.imageView.image = [UIImage imageNamed:@"profile"];
            break;
        case 1:
            cell.textLabel.text = @"Settings";
            cell.imageView.image = [UIImage imageNamed:@"setting"];
            break;
        case 2:
            cell.textLabel.text = @"Preferences";
            cell.imageView.image = [UIImage imageNamed:@"preferences"];
            break;

        default:
            break;
    }
    //set font family
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 0)
    {
        UIStoryboard *sb2 = [UIStoryboard storyboardWithName:@"Profile" bundle:nil];
        EditProfileViewController *vc2 = [sb2 instantiateViewControllerWithIdentifier:@"EditProfileViewController"];
        [[NSUserDefaults standardUserDefaults]setValue:@"summary" forKey:@"firstPageType"];
        
        //vc.globalCompanyId = [self.companies.companyId intValue];
      
        UINavigationController *navController = [[UINavigationController alloc]initWithRootViewController:vc2];
        navController.navigationBarHidden =YES;
        [self presentViewController:navController animated:YES completion:nil];
        [self.revealViewController setFrontViewPosition: FrontViewPositionLeft animated: YES];
    }
    else if(indexPath.row == 2)
    {
        
        UIStoryboard *sbPref = [UIStoryboard storyboardWithName:@"Preference" bundle:nil];
        PreferenceVC *prefVC = [sbPref instantiateViewControllerWithIdentifier:@"PreferenceVC"];
        
        //vc.globalCompanyId = [self.companies.companyId intValue];
        
        UINavigationController *navController = [[UINavigationController alloc]initWithRootViewController:prefVC];
        self.navigationController.navigationBarHidden = NO;
        //navController.navigationBarHidden =YES;
        [self presentViewController:navController animated:YES completion:nil];
        [self.revealViewController setFrontViewPosition: FrontViewPositionLeft animated: YES];
    }
}



#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ( [segue isKindOfClass: [SWRevealViewControllerSegue class]] ) {
        SWRevealViewControllerSegue *swSegue = (SWRevealViewControllerSegue*) segue;
        
        swSegue.performBlock = ^(SWRevealViewControllerSegue* rvc_segue, UIViewController* svc, UIViewController* dvc) {
            
            UINavigationController* navController = (UINavigationController*)self.revealViewController.frontViewController;
            [navController setViewControllers: @[dvc] animated: NO ];
            [self.revealViewController setFrontViewPosition: FrontViewPositionLeft animated: YES];
        };
        
    }
    
    
}


@end
