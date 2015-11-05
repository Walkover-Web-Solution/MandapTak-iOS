//
//  CandidateProfileDetailScreenVC.m
//  MandapTak
//
//  Created by Anuj Jain on 8/20/15.
//  Copyright (c) 2015 Walkover. All rights reserved.
//

#import "CandidateProfileDetailScreenVC.h"
#import "ConversationViewController.h"
#import <MediaPlayer/MediaPlayer.h>
@interface CandidateProfileDetailScreenVC (){
    LYRConversation *userConversation;
    BOOL isFetchingConversation;
    BOOL isConversationAvailable;
    __weak IBOutlet UIButton *btnChat;
    BOOL isChatAvailable;
    __weak IBOutlet UIView *headerView;

}
- (IBAction)chatButtonAction:(id)sender;

@end

@implementation CandidateProfileDetailScreenVC
@synthesize profileObject,textTraits;
- (void)viewDidLoad
{
    [super viewDidLoad];
    selectedIndex = 0;
    
    //hide acitvity indicator initially
    [self showLoader];
    
    //set user default for pop case
    NSUserDefaults *userDefaults = [[NSUserDefaults alloc]init];
    [userDefaults setValue:@"no" forKey:@"reloadCandidateList"];
    
    loadimagesarray = [[NSMutableArray alloc]init];
    arrImages = [[NSMutableArray alloc]init];
    arrEducation = [[NSMutableArray alloc]init];
    //profileObject = [[Profile alloc] init];
    
    arrHeight = [NSArray arrayWithObjects:@"4ft 5in - 134cm",@"4ft 6in - 137cm",@"4ft 7in - 139cm",@"4ft 8in - 142cm",@"4ft 9in - 144cm",@"4ft 10in - 147cm",@"4ft 11in - 149cm",@"5ft - 152cm",@"5ft 1in - 154cm",@"5ft 2in - 157cm",@"5ft 3in - 160cm",@"5ft 4in - 162cm",@"5ft 5in - 165cm",@"5ft 6in - 167cm",@"5ft 7in - 170cm",@"5ft 8in - 172cm",@"5ft 9in - 175cm",@"5ft 10in - 177cm",@"5ft 11in - 180cm",@"6ft - 182cm",@"6ft 1in - 185cm",@"6ft 2in - 187cm",@"6ft 3in - 190cm",@"6ft 4in - 193cm",@"6ft 5in - 195cm",@"6ft 6in - 198cm",@"6ft 7in - 200cm",@"6ft 8in - 203cm",@"6ft 9in - 205cm",@"6ft 10in - 208cm",@"6ft 11in - 210cm",@"7ft - 213cm", nil];
    
    collectionImages = [NSArray arrayWithObjects:@"sampleImage01.jpg",@"sampleImage02.jpg",@"sampleImage03.jpg",@"sampleImage04.jpg",@"sampleImage05.jpg",@"sampleImage06.jpg",@"Profile_2.png",@"Profile_1.png", nil];
 
    //lblTraitMatch.hidden = YES;
    
    [self showUserProfile];
    
    //collection view
    FullyHorizontalFlowLayout *collectionViewLayout = [FullyHorizontalFlowLayout new];
    collectionViewLayout.itemSize = CGSizeMake(320, 85);
    [ImagesCollectionView setCollectionViewLayout:collectionViewLayout];
    ImagesCollectionView.pagingEnabled = YES;
    
    //get user profile
    //[self getUserProfileForId:@"nASUvS6R7Z"];
    //display user profile
    [self getUserImages];
    //[self showBlurredImage];
    //current changes
    //btnLike.hidden = YES;
    //btnMatchPin.hidden = YES;
    
    //apply like/dislike buttons visiblity conditions
    if (self.isFromMatches)
    {
        btnLike.hidden = YES;
        btnDislike.hidden = YES;
    }
    else
    {
        btnLike.hidden = NO;
        btnDislike.hidden = NO;
    }
    headerView.layer.masksToBounds = NO;
    headerView.layer.shadowOffset = CGSizeMake(.5, .5);
    headerView.layer.shadowRadius = 2;
    headerView.layer.shadowOpacity = 0.5;
    btnChat.hidden = YES;
    //btnChat.layer.cornerRadius = 25.0f;
    if(self.isFromMatches){
        [self loginLayer];
    }

}

-(void)viewWillAppear:(BOOL)animated
{
    
}

-(void) showBlurredImage
{
    //adding blur effect to image
    self.navigationController.navigationBarHidden = YES;
    UIImage *theImage = [UIImage imageNamed:@"sampleImage01.jpg"];
    
    //create our blurred image
    CIContext *context = [CIContext contextWithOptions:nil];
    CIImage *inputImage = [CIImage imageWithCGImage:theImage.CGImage];
    
    //setting up Gaussian Blur (we could use one of many filters offered by Core Image)
    CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur"];
    [filter setValue:inputImage forKey:kCIInputImageKey];
    [filter setValue:[NSNumber numberWithFloat:10.0f] forKey:@"inputRadius"];
    CIImage *result = [filter valueForKey:kCIOutputImageKey];
    //CIGaussianBlur has a tendency to shrink the image a little, this ensures it matches up exactly to the bounds of our original image
    CGImageRef cgImage = [context createCGImage:result fromRect:[inputImage extent]];
    
    //add our blurred image to the scrollview
    profileImageView.image = [UIImage imageWithCGImage:cgImage];
    
    //CGImageSourceCreateThumbnailAtIndex
    /*
    UIImage *originalImage = ...;
    CGSize destinationSize = ...;
    UIGraphicsBeginImageContext(destinationSize);
    [originalImage drawInRect:CGRectMake(0,0,destinationSize.width,destinationSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
     */
}


-(void) showPrimaryImageFromObject:(UIImage *)img
{
    //create our blurred image
    CIContext *context = [CIContext contextWithOptions:nil];
    CIImage *inputImage = [CIImage imageWithCGImage:img.CGImage];
    
    //setting up Gaussian Blur (we could use one of many filters offered by Core Image)
    CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur"];
    [filter setValue:inputImage forKey:kCIInputImageKey];
    [filter setValue:[NSNumber numberWithFloat:10.0f] forKey:@"inputRadius"];
    CIImage *result = [filter valueForKey:kCIOutputImageKey];
    //CIGaussianBlur has a tendency to shrink the image a little, this ensures it matches up exactly to the bounds of our original image
    CGImageRef cgImage = [context createCGImage:result fromRect:[inputImage extent]];
    
    //add our blurred image to the scrollview
    profileImageView.image = [UIImage imageWithCGImage:cgImage];
}

/*
-(void) getUserProfileForId : (NSString *)profileId
{
    MBProgressHUD * hud;
    hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    //NSString *profileId = @"nASUvS6R7Z"; //@"gDlvVzftXF";
    PFQuery *query = [PFQuery queryWithClassName:@"Profile"];
    
    [query whereKey:@"objectId" equalTo:profileId];
    [query includeKey:@"currentLocation.Parent.Parent"];
    [query includeKey:@"placeOfBirth.Parent.Parent"];
    [query includeKey:@"casteId"];
    [query includeKey:@"religionId"];
    [query includeKey:@"education1.degreeId"];
    [query includeKey:@"education2.degreeId"];
    [query includeKey:@"education3.degreeId"];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
    {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (!error) {
            PFObject *obj = objects[0];
            profileObject.profilePointer = obj;
            lblName.text = [NSString stringWithFormat:@"%@",[obj valueForKey:@"name"]];
            
            
            //Age
            NSDate *birthday = [obj valueForKey:@"dob"];
            NSDate* now = [NSDate date];
            NSDateComponents* ageComponents = [[NSCalendar currentCalendar]
                                               components:NSCalendarUnitYear
                                               fromDate:birthday
                                               toDate:now
                                               options:0];
            NSInteger age = [ageComponents year];
            
            //Height
            NSString *strHeight = [self getFormattedHeightFromValue:[NSString stringWithFormat:@"%@cm",[obj valueForKey:@"height"]]];
            
            lblAgeHeight.text = [NSString stringWithFormat:@"%ld,%@",(long)age,strHeight];
            lblDesignation.text = [NSString stringWithFormat:@"%@",[obj valueForKey:@"designation"]];
            lblOccupation.text = [NSString stringWithFormat:@"%@",[obj valueForKey:@"designation"]];
            //lblIncome.text = [NSString stringWithFormat:@"%@",[obj valueForKey:@"package"]];
            lblIndustry.text = [NSString stringWithFormat:@"%@ , %@/annum",[obj valueForKey:@"placeOfWork"],[obj valueForKey:@"package"]];
            lblWeight.text = [NSString stringWithFormat:@"Weight : %@ Kg",[obj valueForKey:@"weight"]];
            //caste label
            PFObject *caste = [obj valueForKey:@"casteId"];
            PFObject *religion = [obj valueForKey:@"religionId"];
            lblCaste.text = [NSString stringWithFormat:@"%@,%@",[religion valueForKey:@"name"],[caste valueForKey:@"name"]];
            //current location label
            PFObject *currentLoc = [obj valueForKey:@"currentLocation"];
            PFObject *currentState = [currentLoc valueForKey:@"Parent"];
            lblCurrentLocation.text = [NSString stringWithFormat:@"Current Location : %@,%@",[currentLoc valueForKey:@"name"],[currentState valueForKey:@"name"]];
            
            //birth location label
            PFObject *birthLoc = [obj valueForKey:@"placeOfBirth"];
            PFObject *birthState = [birthLoc valueForKey:@"Parent"];
            
            //save data in model object
            profileObject.height = strHeight;
            profileObject.weight = [obj valueForKey:@"weight"];
            profileObject.income = [obj valueForKey:@"package"];
            profileObject.religion = [NSString stringWithFormat:@"%@,%@",[religion valueForKey:@"name"],[caste valueForKey:@"name"]];
            profileObject.placeOfBirth = [NSString stringWithFormat:@"%@,%@",[birthLoc valueForKey:@"name"],[birthState valueForKey:@"name"]];
            profileObject.minBudget = [NSString stringWithFormat:@"%@",[obj valueForKey:@"minMarriageBudget"]];
            profileObject.maxBudget = [NSString stringWithFormat:@"%@",[obj valueForKey:@"maxMarriageBudget"]];
            profileObject.designation = [NSString stringWithFormat:@"%@",[obj valueForKey:@"designation"]];
            profileObject.company = [NSString stringWithFormat:@"%@",[obj valueForKey:@"placeOfWork"]];
            
            //DOB
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"yyyy-MM-dd"];
            NSString *strDate = [formatter stringFromDate:birthday];
            profileObject.dob = strDate;
            
            //TOB
            NSDate *dateTOB = [obj valueForKey:@"tob"];
            NSDateFormatter *formatterTime = [[NSDateFormatter alloc] init];
            [formatterTime setDateFormat:@"hh:mm:ss"];
            [formatterTime setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
            NSString *strTOB = [formatterTime stringFromDate:dateTOB];
            profileObject.tob = strTOB;
            //education label
            
            NSMutableArray *arrDegrees = [[NSMutableArray alloc]init];
            //NSMutableArray *arrSpecialization = [[NSMutableArray alloc]init];
 
            for (int i=1; i<4; i++)
            {
                Education *educationObject = [[Education alloc]init];
                NSString *eduLevel = [NSString stringWithFormat:@"education%d",i];
                PFObject *specialization = [obj valueForKey:eduLevel];
                PFObject *degreeName = [specialization valueForKey:@"degreeId"];
                //NSString *specializationName = [specialization valueForKey:@"name"];
                NSString *strDegrees = [degreeName valueForKey:@"name"];
                if (strDegrees.length > 0)
                {
                    [arrDegrees addObject:strDegrees];
                    //save data for full profile screen
                    educationObject.degree = degreeName;
                    educationObject.specialisation = specialization;
                    [arrEducation addObject:educationObject];
                }
            }
            NSString *strAllDegree = [arrDegrees componentsJoinedByString:@","];
            lblEducation.text = [NSString stringWithFormat:@"%@",strAllDegree];
        }
    }];
}
*/

-(void) showUserProfile
{
    PFObject *obj = profileObject.profilePointer;
    
    //new code
    lblName.text = profileObject.name;
    lblAgeHeight.text = [NSString stringWithFormat:@"%@,%@",profileObject.age,profileObject.height];
    lblDesignation.text = profileObject.designation;
    lblOccupation.text = profileObject.designation;
    
    //lblIncome.text = [NSString stringWithFormat:@"%@",[obj valueForKey:@"package"]];
    lblIndustry.text = [NSString stringWithFormat:@"%@ , %@/annum",[obj valueForKey:@"placeOfWork"],[obj valueForKey:@"package"]];
    lblWeight.text = [NSString stringWithFormat:@"Weight : %@ Kg",[obj valueForKey:@"weight"]];
    
    //caste label
    lblCaste.text = [NSString stringWithFormat:@"%@,%@",profileObject.religion,profileObject.caste];
    
    //current location label
    lblCurrentLocation.text = [NSString stringWithFormat:@"Current Location : %@,",profileObject.currentLocation];
    
    //traits label
    //get traits count
    NSString *objID = obj.objectId;
    
    //condition for gender
    NSString *boyProfileId,*girlProfileId;
    if ([[profileObject.profilePointer valueForKey:@"gender"] isEqualToString:@"Male"])
    {
        boyProfileId = objID;
        girlProfileId = [[NSUserDefaults standardUserDefaults]valueForKey:@"currentProfileId"];
    }
    else
    {
        boyProfileId = [[NSUserDefaults standardUserDefaults]valueForKey:@"currentProfileId"];
        girlProfileId = objID;
    }
    //textTraits = @"";
    if (textTraits.length == 0)
    {
        //hit API to get traits matching count
        [PFCloud callFunctionInBackground:@"matchKundli"
                           withParameters:@{@"boyProfileId":boyProfileId,
                                            @"girlProfileId":girlProfileId}
                                    block:^(NSString *traitResult, NSError *error)
         {
             if (!error)
             {
                 lblTraitMatch.text = [NSString stringWithFormat:@"%@ Traits Match",traitResult];
                 textTraits = lblTraitMatch.text;
                 NSLog(@"Traits matching on detail screen  = %@",traitResult);
             }
             else
             {
                 NSLog(@"Error info -> %@",error.description);
             }
             
         }];
    }
    else
    {
        lblTraitMatch.text = textTraits;
    }
    
    
    
    NSMutableArray *arrDegrees = [[NSMutableArray alloc]init];
    //NSMutableArray *arrSpecialization = [[NSMutableArray alloc]init];
    
    for (int i=1; i<4; i++)
    {
        Education *educationObject = [[Education alloc]init];
        NSString *eduLevel = [NSString stringWithFormat:@"education%d",i];
        PFObject *specialization = [obj valueForKey:eduLevel];
        PFObject *degreeName = [specialization valueForKey:@"degreeId"];
        //NSString *specializationName = [specialization valueForKey:@"name"];
        NSString *strDegrees = [degreeName valueForKey:@"name"];
        if (!(strDegrees == nil || strDegrees == (id)[NSNull null]))
        {
            [arrDegrees addObject:strDegrees];
            //save data for full profile screen
            educationObject.degree = degreeName;
            educationObject.specialisation = specialization;
            [arrEducation addObject:educationObject];
        }
    }
    NSString *strAllDegree = [arrDegrees componentsJoinedByString:@","];
    lblEducation.text = [NSString stringWithFormat:@"%@",strAllDegree];
}


- (NSString *)getFormattedHeightFromValue:(NSString *)value
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF CONTAINS[cd] %@", value];
    NSString *strFiltered = [[arrHeight filteredArrayUsingPredicate:predicate] firstObject];
    return strFiltered;
}


#pragma mark get User Images
-(void) getUserImages
{
    PFQuery *query = [PFQuery queryWithClassName:@"Photo"];
    __block int totalNumberOfEntries = 0;
    [query whereKey:@"profileId" equalTo:[PFObject objectWithoutDataWithClassName:@"Profile" objectId:profileObject.profilePointer.objectId]];   //@"EYKXEM27cu"
    [query orderByDescending:@"createdAt"];
    //query.cachePolicy = kPFCachePolicyCacheElseNetwork;
    [query countObjectsInBackgroundWithBlock:^(int number1, NSError *error) {
    if (!error)
    {
        totalNumberOfEntries = number1;
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
        {
            if (!error)
            {
                // The find succeeded.
                [loadimagesarray addObjectsFromArray:objects];
            }
            else
            {
                // Log details of the failure
                NSLog(@"Error: %@ %@", error, [error userInfo]);
            }
            //[self retrieveImagesFromArray:loadimagesarray];
            [self performSelector:@selector(retrieveImagesFromArray) withObject:nil afterDelay:0.5];
        }];
    }
    }];
    
}

-(void) retrieveImagesFromArray
{
    for (PFObject *obj in loadimagesarray)
    {
        //[MBProgressHUD showHUDAddedTo:ImagesCollectionView animated:YES];
        [self showLoader];
        PFFile *userImageFile = obj[@"file"];
        
        int highScore = [obj[@"isPrimary"] intValue];
        if (highScore == 1)
        {
            primaryFlag = true;
            PFFile *userImageFile = obj[@"file"];
            [userImageFile getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error)
             {
                 if (!error)
                 {
                     UIImage *image = [UIImage imageWithData:imageData];
                     if (primaryFlag)
                     {
                         //[self showPrimaryImageFromObject:image];
                     }
                 }
             }];
        }
        
        
        [userImageFile getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error)
         {
             if (!error)
             {
                 //[MBProgressHUD hideAllHUDsForView:ImagesCollectionView animated:YES];
                 [self hideLoader];
                 UIImage *image = [UIImage imageWithData:imageData];
                 [arrImages addObject:image];
             }
             else
             {
                 NSLog(@"Error = > %@",error);
             }
             [ImagesCollectionView reloadData];
             //add our blurred image to the scrollview
             //profileImageView.image = arrImages[0];
         }];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark Collection View Methods
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    //return collectionImages.count;
    return arrImages.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *identifier = @"Cell";
    UICollectionViewCell *cell = [ImagesCollectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    cell.layer.cornerRadius = 30.0;
    UIImageView *collectionImageView = (UIImageView *)[cell viewWithTag:100];
    [collectionImageView setContentMode:UIViewContentModeScaleAspectFill];
     //collectionImageView.image = [UIImage imageNamed:[arrImages objectAtIndex:indexPath.row]];
    //collectionImageView.image = [arrImages objectAtIndex:indexPath.row];
    
    UIImage *myIcon = [self imageWithImage:[arrImages objectAtIndex:indexPath.row] scaledToSize:CGSizeMake(60, 60)];
    collectionImageView.image = myIcon;
     return cell;
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //NSLog(@"SETTING SIZE FOR ITEM AT INDEX %d", indexPath.row);
    return CGSizeMake(60, 60);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 20.0;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    selectedIndex = indexPath.row;
    [self performSegueWithIdentifier:@"galleryIdentifier" sender:self];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([segue.identifier isEqualToString:@"galleryIdentifier"])
    {
        CandidateProfileGalleryVC *vc = [segue destinationViewController];
        vc.arrImages = arrImages;
        vc.selectedIndex = selectedIndex;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
    else if ([segue.identifier isEqualToString:@"fullProfileIdentifier"])
    {
        ViewFullProfileVC *vc = [segue destinationViewController];
        vc.arrImages = arrImages;
        vc.layerClient = self.layerClient;
        vc.isFromMatches = self.isFromMatches;
        vc.currentProfile = self.currentProfile;
        vc.profileObject = profileObject;
        vc.arrEducation = arrEducation;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}


- (IBAction)back:(id)sender
{
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"MTLowRes" ofType:@"mp4"];
    MPMoviePlayerViewController *moviePlayer = [[MPMoviePlayerViewController alloc]initWithContentURL:[NSURL fileURLWithPath:path]];
    [self presentModalViewController:moviePlayer animated:NO];
     
    
    //set traits to nil
    textTraits = nil;
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)viewFullProfile:(id)sender
{
}

- (IBAction)likeAction:(id)sender
{
    
    PFUser *user = [PFUser currentUser];
    NSLog(@"user name -> %@",user.username);
    NSLog(@"profile user name -> %@",[[NSUserDefaults standardUserDefaults]valueForKey:@"currentProfileName"]);
    
    //[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self showLoader];
    
    Profile *userProfileObj = profileObject;
        NSString *strObjId = userProfileObj.profilePointer.objectId;
       
        [PFCloud callFunctionInBackground:@"likeAndFind"
                           withParameters:@{@"userProfileId":[[NSUserDefaults standardUserDefaults]valueForKey:@"currentProfileId"],
                                            @"likeProfileId":strObjId,
                                            @"userName":[[NSUserDefaults standardUserDefaults]valueForKey:@"currentProfileName"]}
                                    block:^(id results, NSError *error)
         {
             //[MBProgressHUD hideHUDForView:self.view animated:YES];
             [self hideLoader];
             
             if (!error)
             {
                 //insert data in History Model
                 [[NSUserDefaults standardUserDefaults] setValue:@"yes" forKey:@"reloadCandidateList"];
                 // this is where you handle the results and change the UI.
                 if ([results isKindOfClass:[NSString class]])
                 {
                     //go back to home screen and reload home screen
                     //fire notification to handle on chatpin match screen
                     [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdatePinNotification" object:nil];
                     [self back:nil];
                     
                 }
                 else
                 {
                     Profile *likedProfileObj = [[Profile alloc] init];
                     likedProfileObj = profileObject;

                     // Does not break
                     NSDictionary* userInfo = @{@"traitsCount": lblTraitMatch.text};
                     if (self.isFromPins)
                     {
                         [self dismissViewControllerAnimated:YES completion:^{
                             [[NSNotificationCenter defaultCenter] postNotificationName:@"MatchPinnedNotification" object:likedProfileObj userInfo:userInfo];
                         }];
                     }
                     else
                     {
                         [self dismissViewControllerAnimated:YES completion:^{
                             [[NSNotificationCenter defaultCenter] postNotificationName:@"MatchedNotification" object:likedProfileObj userInfo:userInfo];
                         }];
                     }
                 }
             }
         }];
}

- (IBAction)dislikeAction:(id)sender
{
    [self showLoader];
    Profile *userProfileObj = profileObject;
    NSString *strObjId = userProfileObj.profilePointer.objectId;
    
    //make entry in dislike table
    PFObject *dislikeObj = [PFObject objectWithClassName:@"DislikeProfile"];
    dislikeObj[@"profileId"] = [PFObject objectWithoutDataWithClassName:@"Profile" objectId:[[NSUserDefaults standardUserDefaults]valueForKey:@"currentProfileId"]];
    dislikeObj[@"dislikeProfileId"] = [PFObject objectWithoutDataWithClassName:@"Profile" objectId:strObjId];
    
    [dislikeObj saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
     {
         [self hideLoader];
         if (succeeded)
         {
             //set reload condition = true
             [[NSUserDefaults standardUserDefaults] setValue:@"yes" forKey:@"reloadCandidateList"];
             [self back:nil];
             //go back to previous screen
             //delete entry from pin table(if exists)
             NSLog(@"profile id --> %@",[[NSUserDefaults standardUserDefaults]valueForKey:@"currentProfileId"]);
             NSLog(@"pinned profile Id --> %@",strObjId);
             
             PFQuery *query = [PFQuery queryWithClassName:@"PinnedProfile"];
             [query whereKey:@"profileId" equalTo:[PFObject objectWithoutDataWithClassName:@"Profile" objectId:[[NSUserDefaults standardUserDefaults]valueForKey:@"currentProfileId"]]];
             
             [query whereKey:@"pinnedProfileId" equalTo:[PFObject objectWithoutDataWithClassName:@"Profile" objectId:strObjId]];
             
             [query findObjectsInBackgroundWithBlock:^(NSArray *profileArray, NSError *error)
             {
                 if (!error)
                 {
                     PFObject *profileObj = profileArray[0];
                     
                     [profileObj deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
                     {
                         if (succeeded)
                         {
                             [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdatePinNotification" object:nil];
                             //[self back:nil];
                         }
                         else
                         {
                             NSLog(@"DELETE ERROR");
                         }
                     }];
                 }
                 else
                 {
                     NSLog(@"%@",error);
                 }
             }];
             
         }
         else
         {
             // There was a problem, check error.description
         }
     }];
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
#pragma mark Chat
-(LYRConversation*)getChatConversationIfPossibleWithUsers:(NSMutableArray*)arrUser{
    NSArray *participants = arrUser;
    LYRQuery *query = [LYRQuery queryWithQueryableClass:[LYRConversation class]];
    query.predicate = [LYRPredicate predicateWithProperty:@"participants" predicateOperator:LYRPredicateOperatorIsEqualTo value:participants];
    
    NSError *error = nil;
    NSOrderedSet *conversations = [self.layerClient executeQuery:query error:&error];
    if (!error) {
        NSLog(@"%tu conversations with participants %@", conversations.count, participants);
        if(conversations.count==0){
            NSError *error = nil;
            LYRConversation *conversation = [self.layerClient newConversationWithParticipants:[NSSet setWithArray:arrUser] options:nil error:&error];
            userConversation = conversation;
        }
        else{
            userConversation = conversations[0];
        }
        UIButton *chat=[UIButton buttonWithType:UIButtonTypeCustom];
        [chat setTitle:@"Chat" forState:UIControlStateNormal];
        btnChat.hidden = NO;
        isChatAvailable = YES;
        
    } else {
        NSLog(@"Query failed with error %@", error);
    }
    return nil;
}
-(void)getAllUserForAConversation{
    //get all user corresponding to currentProfile
    PFQuery *query = [PFQuery queryWithClassName:@"UserProfile"];
    //query.cachePolicy = kPFCachePolicyCacheThenNetwork;
    
    //[query whereKey:@"userId" equalTo:userId];
    NSLog(@"%@",[[NSUserDefaults standardUserDefaults]valueForKey:@"currentProfileId"]);
    [query whereKey:@"profileId" equalTo:self.currentProfile];
    [query whereKey:@"profileId" equalTo:profileObject.profilePointer];
    [query whereKey:@"relation" notEqualTo:@"Agent"];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        
        if (!error) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            NSMutableArray *arrUserIds = [NSMutableArray array];
            for(PFObject *obj in objects){
                PFUser *user = [obj valueForKey:@"userId"];
                [arrUserIds addObject:user.objectId];
            }
            NSLog(@"arrUserIds --  %@",arrUserIds);
            [self getChatConversationIfPossibleWithUsers:arrUserIds];
            
            // The find succeeded.
        }
    }];
    
}

#pragma mark - Layer Authentication Methods

- (void)loginLayer
{
    // Connect to Layer
    // See "Quick Start - Connect" for more details
    [self.layerClient connectWithCompletion:^(BOOL success, NSError *error) {
        if (!success) {
            if(error.code ==6000)
                [self getAllUserForAConversation];
        } else {
            PFUser *user = [PFUser currentUser];
            NSString *userID = user.objectId;
            [self authenticateLayerWithUserID:userID completion:^(BOOL success, NSError *error) {
                if (!error){
                    [self getAllUserForAConversation];
                    
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

- (IBAction)chatButtonAction:(id)sender {
    ConversationViewController *controller = [ConversationViewController conversationViewControllerWithLayerClient:self.layerClient];
    controller.conversation = userConversation;
    controller.displaysAddressBar = NO;
    UINavigationController *navController  = [[UINavigationController alloc]initWithRootViewController:controller];
    controller.title = self.profileObject.name;
    [self presentViewController:navController animated:YES completion:nil];
    //[self.navigationController pushViewController:controller animated:YES];
}

#pragma mark Show Scaled Images
- (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    //UIGraphicsBeginImageContext(newSize);
    // In next line, pass 0.0 to use the current device's pixel scaling factor (and thus account for Retina resolution).
    // Pass 1.0 to force exact pixel size.
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

@end
