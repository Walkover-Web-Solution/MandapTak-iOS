//
//  SideBarViewController.m
//  MandapTak
//
//  Created by Hussain Chhatriwala on 28/07/15.
//  Copyright (c) 2015 Walkover. All rights reserved.
//

#import "SideBarViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>

#import "EditProfileViewController.h"
#import "SWRevealViewController.h"
#import "PreferenceVC.h"
#import "SettingsVC.h"
#import "TourOptionsVC.h"
#import "OptionsListVC.h"
#import "DemoScreenVC.h"

@interface SideBarViewController ()
{
    //activity indicator
    IBOutlet UIActivityIndicatorView *activityIndicator;
    MPMoviePlayerViewController *moviePlayer;
}

@property (weak, nonatomic) IBOutlet UIImageView *imgView;

@end

@implementation SideBarViewController
@synthesize lblUserName;
- (void)viewDidLoad
{
    [super viewDidLoad];
    lblUserName.text = [[NSUserDefaults standardUserDefaults]valueForKey:@"currentProfileName"];
    //[[NSUserDefaults standardUserDefaults] setValue:@"yes" forKey:@"isFirstLoad"];

    self.imgView.layer.cornerRadius = 70;
    self.imgView.clipsToBounds = YES;
    // Do any additional setup after loading the view.
}


-(void)viewWillAppear:(BOOL)animated
{
    [self getUserProfilePic];
}
-(void)updateCurrentProfile{
    [self getUserProfilePic];
}
#pragma mark User Profile Pic
-(void) getUserProfilePic
{
    //get user profile pic
    PFQuery *query = [PFQuery queryWithClassName:@"Profile"];
    [query whereKey:@"objectId" equalTo:[[NSUserDefaults standardUserDefaults]valueForKey:@"currentProfileId"]];
    query.cachePolicy = kPFCachePolicyCacheThenNetwork;
    //MBProgressHUD * hud;
    //hud=[MBProgressHUD showHUDAddedTo:self.imgView animated:YES];
    [self showLoader];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
     {
         //[MBProgressHUD hideHUDForView:self.imgView animated:YES];
         [self hideLoader];
         if (!error)
         {
             // The find succeeded.
             PFObject *obj= objects[0];
             lblUserName.text = [obj valueForKey:@"name"];
             
             PFFile *userImageFile = obj[@"profilePic"];
             if (userImageFile)
             {
                 [userImageFile getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error)
                  {
                      //[MBProgressHUD hideAllHUDsForView:self.imgView animated:YES];
                      [self hideLoader];
                      if (!error)
                      {
                          
                          UIImage *image = [UIImage imageWithData:imageData];
                          //[arrImages addObject:image];
                          self.imgView.image = image;
                      }
                      else
                      {
                          NSLog(@"Error = > %@",error);
                      }
                      //add our blurred image to the scrollview
                      //profileImageView.image = arrImages[0];
                  }];
             }
             else
             {
                 //[MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                 [self hideLoader];
                 self.imgView.layer.backgroundColor = [[UIColor lightGrayColor] CGColor];
                 self.imgView.image = [UIImage imageNamed:@"userProfile"];
             }
             //currentProfile =obj;
             //[self switchToMatches];
             
         }
         
         else if (error.code ==100){
             //[MBProgressHUD hideHUDForView:self.view animated:YES];
             [self hideLoader];
             UIAlertView *errorAlertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Connection Failed" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
             [errorAlertView show];
         }
         else if (error.code ==120)
         {
             //handle cache miss condition
             //[MBProgressHUD showHUDAddedTo:self.imgView animated:YES];
             [self hideLoader];
         }
         else if (error.code ==209){
             //[MBProgressHUD hideHUDForView:self.view animated:YES];
             [self hideLoader];
             [PFUser logOut];
             PFUser *user = nil;
             PFInstallation *currentInstallation = [PFInstallation currentInstallation];
             [currentInstallation setObject:user forKey:@"user"];
             [currentInstallation saveInBackground];

             UIAlertView *errorAlertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Loged from another device, Please login again!!" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
             [errorAlertView show];
             UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
             StartMainViewController *vc = [sb instantiateViewControllerWithIdentifier:@"StartMainViewController"];
             [self presentViewController:vc animated:YES completion:nil];
         }
     }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UITableView Data Source

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 5;
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
        case 3:
            cell.textLabel.text = @"Video Tour";
            //cell.imageView.image = [UIImage imageNamed:@"preferences"];
            break;
        case 4:
            cell.textLabel.text = @"Tutorial View";
            //cell.imageView.image = [UIImage imageNamed:@"preferences"];
            break;
        default:
            break;
    }
    cell.textLabel.font = [UIFont fontWithName: @"MYRIADPRO-REGULAR" size:16];
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
        [self.revealViewController setFrontViewPosition:FrontViewPositionLeft animated: YES];
    }
    else if(indexPath.row == 1)
    {
        
        UIStoryboard *sbPref = [UIStoryboard storyboardWithName:@"Settings" bundle:nil];
        SettingsVC *settingsVC = [sbPref instantiateViewControllerWithIdentifier:@"SettingsVC"];
        
        //vc.globalCompanyId = [self.companies.companyId intValue];
        
        UINavigationController *navController = [[UINavigationController alloc]initWithRootViewController:settingsVC];
        navController.navigationBarHidden = YES;
        self.navigationController.navigationBarHidden = YES;
        //navController.navigationBarHidden =YES;
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
    else if(indexPath.row == 3)
    {
        
        NSString *path = [[NSBundle mainBundle] pathForResource:@"MTLowRes" ofType:@"mp4"];
        MPMoviePlayerViewController *moviePlayer = [[MPMoviePlayerViewController alloc]initWithContentURL:[NSURL fileURLWithPath:path]];
        [self presentModalViewController:moviePlayer animated:NO];
        [self.revealViewController setFrontViewPosition:FrontViewPositionLeft];
        
        //[self performSegueWithIdentifier:@"tourOptionsIdentifier" sender:nil];
        //[self.revealViewController setFrontViewPosition:FrontViewPositionLeft animated:YES];
//        NSString *path = [[NSBundle mainBundle] pathForResource:@"MTLowRes" ofType:@"mp4"];//MTLowRes
//        moviePlayer = [[MPMoviePlayerViewController alloc]initWithContentURL:[NSURL fileURLWithPath:path]];
//        [self presentModalViewController:moviePlayer animated:NO];
        //[[NSUserDefaults standardUserDefaults ] setValue:@"yes" forKey:@"shouldRotateToLandscape"];
        //[self presentViewController:moviePlayer animated:NO completion:nil];
        
        /*
        //code 02
        [self.revealViewController setFrontViewPosition:FrontViewPositionRight animated: YES];
        UIStoryboard *sbPref = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        OptionsListVC *optionsVC = [sbPref instantiateViewControllerWithIdentifier:@"OptionsListVC"];
        UINavigationController *navController = [[UINavigationController alloc]initWithRootViewController:optionsVC];
        navController.navigationBarHidden = YES;
        self.navigationController.navigationBarHidden = YES;
        //navController.navigationBarHidden =YES;
        [self presentViewController:navController animated:YES completion:nil];
        */
        
        /*
        //code 03
        UIAlertView *optionAlertView = [[UIAlertView alloc] initWithTitle:nil message:@"Select an Option?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Video",@"Tutorial", nil];
        [optionAlertView show];
         */
    }
    else if (indexPath.row == 4)
    {
        //[[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"WSCoachMarksShown"];
        //[[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isFromTour"];
        /*
        SWRevealViewController *vc2 = [self.storyboard instantiateViewControllerWithIdentifier:@"SWRevealViewController"];
        [self presentViewController:vc2 animated:YES completion:nil];
         */
        //[self performSegueWithIdentifier:@"tourOptionsIdentifier" sender:nil];
        
        DemoScreenVC *demoVC = [self.storyboard instantiateViewControllerWithIdentifier:@"DemoScreenVC"];
        self.navigationController.navigationBarHidden = NO;
        [self presentViewController:demoVC animated:YES completion:nil];
        [self.revealViewController setFrontViewPosition:FrontViewPositionLeft];
        
        /*
        TourOptionsVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"TourOptionsVC"];
        [self presentViewController:vc animated:YES completion:nil];
        [self.revealViewController setFrontViewPosition:FrontViewPositionLeft];
         */
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
            [self.revealViewController setFrontViewPosition: FrontViewPositionLeft animated:YES];
        };
        
    }
    else if([segue.identifier isEqualToString:@"tourOptionsIdentifier"])
    {
        TourOptionsVC *vc = [segue destinationViewController];
        //[self.navigationController pushViewController:vc animated:YES];
        [self.navigationController presentViewController:vc animated:YES completion:nil];
        [self.revealViewController setFrontViewPosition:FrontViewPositionLeft];
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

#pragma mark Alert View Delegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"MTLowRes" ofType:@"mp4"];
        moviePlayer = [[MPMoviePlayerViewController alloc]initWithContentURL:[NSURL fileURLWithPath:path]];
        [self presentModalViewController:moviePlayer animated:NO];
    }
    else if(buttonIndex == 2)
    {
        //[[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"WSCoachMarksShown"];
        //[[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isFromTour"];
        SWRevealViewController *vc2 = [self.storyboard instantiateViewControllerWithIdentifier:@"SWRevealViewController"];
        [self presentViewController:vc2 animated:YES completion:nil];
        //[self.revealViewController setFrontViewPosition:FrontViewPositionLeft];
    }
}
@end
