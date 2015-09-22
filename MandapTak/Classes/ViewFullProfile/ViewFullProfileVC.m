//
//  ViewFullProfileVC.m
//  MandapTak
//
//  Created by Anuj Jain on 8/24/15.
//  Copyright (c) 2015 Walkover. All rights reserved.
//

#import "ViewFullProfileVC.h"
#import "ConversationViewController.h"
#import "MBProgressHUD.h"
@interface ViewFullProfileVC (){
    LYRConversation *userConversation;
    BOOL isFetchingConversation;
    BOOL isConversationAvailable;
    __weak IBOutlet UIButton *btnChat;
}
- (IBAction)chatButtonAction:(id)sender;

@end

@implementation ViewFullProfileVC
@synthesize arrImages,profileObject,arrEducation;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self loadImages];
    [self setupCollectionView];
    
    lblName.text = [profileObject.profilePointer valueForKey:@"name"];
    lblGender.text = [profileObject.profilePointer valueForKey:@"gender"];
    //lblDOB.text = profileObject.dob;
    
    //set date format
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *dateDOB = [formatter dateFromString:profileObject.dob];
    
    NSDateFormatter *dateToStrFormat = [[NSDateFormatter alloc]init];
    [dateToStrFormat setDateFormat:@"dd-MM-yyyy"];
    lblDOB.text = [dateToStrFormat stringFromDate:dateDOB];
    
    
    lblHeight.text = [NSString stringWithFormat:@"%@",profileObject.height];
    lblWeight.text = [NSString stringWithFormat:@"%@ Kg",profileObject.weight];
    lblTOB.text = profileObject.tob;
    lblPlaceOfBirth.text = profileObject.placeOfBirth;
    lblReligion.text = [NSString stringWithFormat:@"%@,%@",profileObject.religion,profileObject.caste];
    
    if (([profileObject.minBudget intValue] == 0) || ([profileObject.minBudget intValue] < 0))
    {
        lblMinBudget.text = @"Min:";
    }
    else
    {
        lblMinBudget.text = [NSString stringWithFormat:@"Min:%@",profileObject.minBudget];
    }
    
    if (([profileObject.minBudget intValue] == 0) || ([profileObject.minBudget intValue] < 0))
    {
        lblMaxBudget.text = @"Min:";
    }
    else
    {
        lblMaxBudget.text = [NSString stringWithFormat:@"Max:%@",profileObject.maxBudget];
    }
    
    btnChat.hidden = true;
    [self showBasicDetails:nil];
    if(self.isFromMatches){
        [self loginLayer];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark Image Collection View methods
-(void)loadImages
{
    dataArray = arrImages;
    //pageControl.numberOfPages = [dataArray count];
}

-(void)setupCollectionView {
    [ImagesCollectionView registerClass:[CMFGalleryCell class] forCellWithReuseIdentifier:@"cellIdentifier"];
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    [flowLayout setMinimumInteritemSpacing:0.0f];
    [flowLayout setMinimumLineSpacing:0.0f];
    [ImagesCollectionView setPagingEnabled:YES];
    [ImagesCollectionView setCollectionViewLayout:flowLayout];
    
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [dataArray count];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CMFGalleryCell *cell = (CMFGalleryCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"cellIdentifier" forIndexPath:indexPath];
    NSString *imageName = [dataArray objectAtIndex:indexPath.row];
    [cell setUserImage:[dataArray objectAtIndex:indexPath.row]];
    [cell setImageName:imageName];
    [cell updateImageCell];
    return cell;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return ImagesCollectionView.frame.size;
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
    //[self.navigationController popViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)showBasicDetails:(id)sender
{
    //show view 1
    view1.hidden = false;
    view2.hidden = true;
    view3.hidden = true;
    view4.hidden = true;
    
    button1.backgroundColor = [UIColor colorWithRed:247/255.0f green:157/255.0f blue:160/255.0f alpha:1];
    button2.backgroundColor = [UIColor colorWithRed:244.0/255.0 green:111.0/255.0 blue:111.0/255.0 alpha:1];
    button3.backgroundColor = [UIColor colorWithRed:244.0/255.0 green:111.0/255.0 blue:111.0/255.0 alpha:1];
    button4.backgroundColor = [UIColor colorWithRed:244.0/255.0 green:111.0/255.0 blue:111.0/255.0 alpha:1];

}

- (IBAction)showHeightWeight:(id)sender
{
    //show view 2
    view1.hidden = true;
    view2.hidden = false;
    view3.hidden = true;
    view4.hidden = true;
    
    button1.backgroundColor = [UIColor colorWithRed:244.0/255.0 green:111.0/255.0 blue:111.0/255.0 alpha:1];
    button2.backgroundColor = [UIColor colorWithRed:247/255.0f green:157/255.0f blue:160/255.0f alpha:1];
    button3.backgroundColor = [UIColor colorWithRed:244.0/255.0 green:111.0/255.0 blue:111.0/255.0 alpha:1];
    button4.backgroundColor = [UIColor colorWithRed:244.0/255.0 green:111.0/255.0 blue:111.0/255.0 alpha:1];
}

- (IBAction)showWorkDetails:(id)sender
{
    view3.hidden = false;
    view1.hidden = true;
    view2.hidden = true;
    view4.hidden = true;
    btnChat.hidden = true;
    button1.backgroundColor = [UIColor colorWithRed:244.0/255.0 green:111.0/255.0 blue:111.0/255.0 alpha:1];
    button2.backgroundColor = [UIColor colorWithRed:244.0/255.0 green:111.0/255.0 blue:111.0/255.0 alpha:1];
    button3.backgroundColor = [UIColor colorWithRed:247/255.0f green:157/255.0f blue:160/255.0f alpha:1];
    button4.backgroundColor = [UIColor colorWithRed:244.0/255.0 green:111.0/255.0 blue:111.0/255.0 alpha:1];
}

- (IBAction)showBiodata:(id)sender
{
    view4.hidden = false;
    view1.hidden = true;
    view2.hidden = true;
    view3.hidden = true;
    button1.backgroundColor = [UIColor colorWithRed:244.0/255.0 green:111.0/255.0 blue:111.0/255.0 alpha:1];
    button2.backgroundColor = [UIColor colorWithRed:244.0/255.0 green:111.0/255.0 blue:111.0/255.0 alpha:1];
    button3.backgroundColor = [UIColor colorWithRed:244.0/255.0 green:111.0/255.0 blue:111.0/255.0 alpha:1];
    button4.backgroundColor = [UIColor colorWithRed:247/255.0f green:157/255.0f blue:160/255.0f alpha:1];
}

- (IBAction)downloadBiodata:(id)sender
{
    PFQuery *query = [PFQuery queryWithClassName:@"Profile"];
    //NSLog(@"candidater profile ID -> %@",profileObject.profilePointer.objectId);
    [query whereKey:@"objectId" equalTo:profileObject.profilePointer.objectId];//rvkzhpnLKr //EYKXEM27cu
    query.cachePolicy = kPFCachePolicyCacheThenNetwork;
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        
    if (!error)
    {
        PFFile *userImageFile = [object objectForKey:@"bioData"]; //profileCropedPhoto
        
        NSString *fileName = [userImageFile url];
        NSURL *URL = [NSURL URLWithString:fileName];
        if (URL == nil)
        {
            UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"Error" message:@"File not found" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [av show];
        }
        else
        {
            SVModalWebViewController *webViewController = [[SVModalWebViewController alloc] initWithURL:URL];
            webViewController.modalPresentationStyle = UIModalPresentationPageSheet;
            [self presentViewController:webViewController animated:YES completion:NULL];
        }
    }
    }];
    
}

#pragma mark UITableView Data Source
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    /*
    UILabel *myLabel = [[UILabel alloc] init];
    myLabel.frame = CGRectMake(20, 8, 320, 20);
    myLabel.backgroundColor = [UIColor darkGrayColor];
    myLabel.font = [UIFont fontWithName:@"MYRIADPRO-REGULAR.OTF" size:17];
    myLabel.text = [self tableView:tableView titleForHeaderInSection:section];
    
    UIView *headerView = [[UIView alloc] init];
    [headerView addSubview:myLabel];
    
    return headerView;
     */
    
    // Create label with section title
    UILabel *label = [[UILabel alloc] init];
    label.frame = CGRectMake(20, 0, 284, 23);
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont fontWithName:@"MYRIADPRO-REGULAR.OTF" size:17];
    label.text = [self tableView:tableView titleForHeaderInSection:section];
    label.backgroundColor = [UIColor clearColor];
    
    // Create header view and add label as a subview
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 23)];
    view.backgroundColor = [UIColor colorWithRed:244.0/255.0 green:111.0/255.0 blue:111.0/255.0 alpha:1];
    [view addSubview:label];
    
    return view;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *sectionName;
    switch (section)
    {
        case 0:
            sectionName = NSLocalizedString(@"WORK", @"mySectionName");
            break;
        case 1:
            sectionName = NSLocalizedString(@"EDUCATION", @"myOtherSectionName");
            break;
        default:
            sectionName = @"";
            break;
    }
    return sectionName;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger numberOfRows;
    switch (section)
    {
        case 0:
            numberOfRows = 1;
            break;
        case 1:
            numberOfRows = arrEducation.count;
            break;
        default:
            numberOfRows = 1;
            break;
    }
    return numberOfRows;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height;
    switch (indexPath.section)
    {
        case 0:
            height = 70.0;
            break;
        case 1:
            height = 50.0;
            break;
        default:
            height = 70.0;
            break;
    }
    return height;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"PinLogsCell";
    WorkEducationCell *cell = [tableViewEducation dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (!cell) {
        cell=[[WorkEducationCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    if (indexPath.section == 0)
    {
        cell.lblTitle.text = profileObject.designation;
        cell.lblDetail.text = profileObject.company;
        cell.lblDescription.text = [NSString stringWithFormat:@"%@ /annum",profileObject.income];
    }
    else
    {
        Education *obj = [[Education alloc]init];
        obj = arrEducation[indexPath.row];
        PFObject *specialization = obj.specialisation;
        PFObject *degreeName = [specialization valueForKey:@"degreeId"];
        NSString *specializationName = [specialization valueForKey:@"name"];
        cell.lblTitle.text = [NSString stringWithFormat:@"%@",[degreeName valueForKey:@"name"]];
        cell.lblDetail.text = specializationName;
        cell.lblDescription.hidden = YES;
    }

    return cell;
}

#pragma mark Chat
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
            //[self getChatConversationIfPossibleWithUsers:arrUserIds];
            
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
           // if(error.code ==6000)
                //[self getAllUserForAConversation];
        } else {
            PFUser *user = [PFUser currentUser];
            NSString *userID = user.objectId;
            [self authenticateLayerWithUserID:userID completion:^(BOOL success, NSError *error) {
                if (!error){
                   // [self getAllUserForAConversation];

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
   }
@end
