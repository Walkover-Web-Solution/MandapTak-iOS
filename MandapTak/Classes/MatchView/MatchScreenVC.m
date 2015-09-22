//
//  MatchScreenVC.m
//  MandapTak
//
//  Created by Anuj Jain on 9/15/15.
//  Copyright (c) 2015 Walkover. All rights reserved.
//

#import "MatchScreenVC.h"
#import "SWRevealViewController.h"
#import "MBProgressHUD.h"

@interface MatchScreenVC ()
{
    
    IBOutlet UIImageView *userImageView;
    IBOutlet UILabel *lblName;
    IBOutlet UILabel *lblAgeHeight;
    IBOutlet UILabel *lblReligion;
    IBOutlet UILabel *lblDesignation;
    IBOutlet UILabel *lblTraits;
    
    NSArray *arrHeight;
}
- (IBAction)back:(id)sender;

@end

@implementation MatchScreenVC
@synthesize profileObj,txtTraits;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //set image view frame = circular
    userImageView.layer.cornerRadius = 80.0f;
    userImageView.clipsToBounds = YES;
    
    //store height data in array
    arrHeight = [NSArray arrayWithObjects:@"4ft 5in - 134cm",@"4ft 6in - 137cm",@"4ft 7in - 139cm",@"4ft 8in - 142cm",@"4ft 9in - 144cm",@"4ft 10in - 147cm",@"4ft 11in - 149cm",@"5ft - 152cm",@"5ft 1in - 154cm",@"5ft 2in - 157cm",@"5ft 3in - 160cm",@"5ft 4in - 162cm",@"5ft 5in - 165cm",@"5ft 6in - 167cm",@"5ft 7in - 170cm",@"5ft 8in - 172cm",@"5ft 9in - 175cm",@"5ft 10in - 177cm",@"5ft 11in - 180cm",@"6ft - 182cm",@"6ft 1in - 185cm",@"6ft 2in - 187cm",@"6ft 3in - 190cm",@"6ft 4in - 193cm",@"6ft 5in - 195cm",@"6ft 6in - 198cm",@"6ft 7in - 200cm",@"6ft 8in - 203cm",@"6ft 9in - 205cm",@"6ft 10in - 208cm",@"6ft 11in - 210cm",@"7ft - 213cm", nil];
    
    //[[NSUserDefaults standardUserDefaults] setValue:@"no" forKey:@"isNotification"];
    // Do any additional setup after loading the view.
    
    //check if data is present in object
    if (profileObj)
    {
        lblName.text = profileObj.name;
        lblAgeHeight.text = [NSString stringWithFormat:@"%@, %@",profileObj.age,profileObj.height];
        lblDesignation.text = profileObj.designation;
        lblReligion.text = [NSString stringWithFormat:@"%@,%@",profileObj.religion,profileObj.caste];
        lblTraits.text = txtTraits;
        userImageView.image = profileObj.profilePic;
    }
    else
    {
        //get data from object id
        [self getUserProfile];
    }
}


#pragma mark User Profile Pic
-(void) getUserProfile
{
    //get user profile pic
    PFQuery *query = [PFQuery queryWithClassName:@"Profile"];
    NSLog(@"user profile id - > %@",[[NSUserDefaults standardUserDefaults]valueForKey:@"notificationProfileId"]);
    [query whereKey:@"objectId" equalTo:[[NSUserDefaults standardUserDefaults]valueForKey:@"notificationProfileId"]];
    [query includeKey:@"casteId"];
    [query includeKey:@"religionId"];
    query.cachePolicy = kPFCachePolicyCacheThenNetwork;
    MBProgressHUD * hud;
    hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
     {
         [MBProgressHUD hideHUDForView:self.view animated:YES];
         if (!error)
         {
             // The find succeeded.
             PFObject *obj = objects[0];
             
             //get basic details
             lblName.text = obj[@"name"];
             lblAgeHeight.text = [NSString stringWithFormat:@"%@, %@",obj[@"age"],[self getFormattedHeightFromValue:[NSString stringWithFormat:@"%@cm",obj[@"height"]]]];
             lblDesignation.text = obj[@"designation"];
             
             //caste label
             PFObject *caste = [obj valueForKey:@"casteId"];
             PFObject *religion = [obj valueForKey:@"religionId"];
             lblReligion.text = [NSString stringWithFormat:@"%@,%@",[religion valueForKey:@"name"],[caste valueForKey:@"name"]];
             //lblTraits.text = txtTraits;
             
             //get user image
             PFFile *userImageFile = obj[@"profilePic"];
             if (userImageFile)
             {
                 [userImageFile getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error)
                  {
                      //[MBProgressHUD hideAllHUDsForView:self.imgView animated:YES];
                      if (!error)
                      {
                          
                          UIImage *image = [UIImage imageWithData:imageData];
                          //[arrImages addObject:image];
                          userImageView.image = image;
                          userImageView.layer.borderWidth = 2.0f;
                          userImageView.layer.borderColor = [[UIColor colorWithRed:244.0/255.0 green:111.0/255.0 blue:111.0/255.0 alpha:1] CGColor];
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
                 [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                 userImageView.layer.backgroundColor = [[UIColor lightGrayColor] CGColor];
                 userImageView.image = [UIImage imageNamed:@"userProfile"];
             }
             
             //get traits count
             //condition for gender
             NSString *boyProfileId,*girlProfileId;
             if ([obj[@"gender"] isEqualToString:@"Male"])
             {
                 boyProfileId = obj.objectId;
                 girlProfileId = [[NSUserDefaults standardUserDefaults]valueForKey:@"currentProfileId"];
             }
             else
             {
                 boyProfileId = [[NSUserDefaults standardUserDefaults]valueForKey:@"currentProfileId"];
                 girlProfileId = obj.objectId;
             }
             
             [PFCloud callFunctionInBackground:@"matchKundli"
                                withParameters:@{@"boyProfileId":boyProfileId,
                                                 @"girlProfileId":girlProfileId}
                                         block:^(NSString *traitResult, NSError *error)
              {
                  if (!error)
                  {
                      lblTraits.text = [NSString stringWithFormat:@"%@ Traits Match",traitResult];
                      NSLog(@"Traits matching  = %@",traitResult);
                  }
                  else
                  {
                      NSLog(@"Error info -> %@",error.description);
                  }
                  
              }];
             //currentProfile =obj;
             //[self switchToMatches];
             
         }
         /*
         else if (error.code ==100){
             //[MBProgressHUD hideHUDForView:self.view animated:YES];
             
             UIAlertView *errorAlertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Connection Failed" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
             [errorAlertView show];
         }
         else if (error.code ==120)
         {
             //handle cache miss condition
             //[MBProgressHUD showHUDAddedTo:self.imgView animated:YES];
         }
         else if (error.code ==209){
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
          */
     }];
}


- (NSString *)getFormattedHeightFromValue:(NSString *)value
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF CONTAINS[cd] %@", value];
    NSString *strFiltered = [[arrHeight filteredArrayUsingPredicate:predicate] firstObject];
    return strFiltered;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)back:(id)sender
{
    /*
    if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"isNotification"] isEqualToString:@"yes"])
    {
        [[NSUserDefaults standardUserDefaults] setValue:@"no" forKey:@"isNotification"];
        //UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        SWRevealViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"SWRevealViewController"];
        [self.navigationController presentViewController:vc animated:YES completion:nil];
        //[self dismissViewControllerAnimated:NO completion:nil];
        //[self.navigationController popToRootViewControllerAnimated:YES];
    }
    else
    {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
     */
    [[NSUserDefaults standardUserDefaults] setValue:@"no" forKey:@"isNotification"];
    
    //if user likes a profile and receives a popup,then we need to reload the homescreen
    //[[NSUserDefaults standardUserDefaults] setValue:@"yes" forKey:@"reloadCandidateList"];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
