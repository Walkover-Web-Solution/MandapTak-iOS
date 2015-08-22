//
//  CandidateProfileDetailScreenVC.m
//  MandapTak
//
//  Created by Anuj Jain on 8/20/15.
//  Copyright (c) 2015 Walkover. All rights reserved.
//

#import "CandidateProfileDetailScreenVC.h"

@interface CandidateProfileDetailScreenVC ()

@end

@implementation CandidateProfileDetailScreenVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    loadimagesarray = [[NSMutableArray alloc]init];
    arrImages = [[NSMutableArray alloc]init];
    
    arrHeight = [NSArray arrayWithObjects:@"4ft 5in - 134cm",@"4ft 6in - 137cm",@"4ft 7in - 139cm",@"4ft 8in - 142cm",@"4ft 9in - 144cm",@"4ft 10in - 147cm",@"4ft 11in - 149cm",@"5ft - 152cm",@"5ft 1in - 154cm",@"5ft 2in - 157cm",@"5ft 3in - 160cm",@"5ft 4in - 162cm",@"5ft 5in - 165cm",@"5ft 6in - 167cm",@"5ft 7in - 170cm",@"5ft 8in - 172cm",@"5ft 9in - 175cm",@"5ft 10in - 177cm",@"5ft 11in - 180cm",@"6ft - 182cm",@"6ft 1in - 185cm",@"6ft 2in - 187cm",@"6ft 3in - 190cm",@"6ft 4in - 193cm",@"6ft 5in - 195cm",@"6ft 6in - 198cm",@"6ft 7in - 200cm",@"6ft 8in - 203cm",@"6ft 9in - 205cm",@"6ft 10in - 208cm",@"6ft 11in - 210cm",@"7ft - 213cm", nil];
    
    lblTraitMatch.hidden = YES;
    [self getUserImages];
    
    collectionImages = [NSArray arrayWithObjects:@"sampleImage01.jpg",@"sampleImage02.jpg",@"sampleImage03.jpg",@"sampleImage04.jpg",@"sampleImage05.jpg",@"sampleImage06.jpg",@"Profile_2.png",@"Profile_1.png", nil];
 
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
    
    //collection view
    FullyHorizontalFlowLayout *collectionViewLayout = [FullyHorizontalFlowLayout new];
    collectionViewLayout.itemSize = CGSizeMake(320, 85);
    [ImagesCollectionView setCollectionViewLayout:collectionViewLayout];
    ImagesCollectionView.pagingEnabled = YES;
    
    //get user profile
    [self getUserProfileForId:@"nASUvS6R7Z"];
}

-(void) getUserProfileForId : (NSString *)profileId
{
    MBProgressHUD * hud;
    hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    //NSString *profileId = @"nASUvS6R7Z"; //@"gDlvVzftXF";
    PFQuery *query = [PFQuery queryWithClassName:@"Profile"];
    
    [query whereKey:@"objectId" equalTo:profileId];
    [query includeKey:@"currentLocation.Parent.Parent"];
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
            //education label
            
            NSMutableArray *arrDegrees = [[NSMutableArray alloc]init];
            for (int i=1; i<4; i++)
            {
                NSString *eduLevel = [NSString stringWithFormat:@"education%d",i];
                PFObject *specialization = [obj valueForKey:eduLevel];
                PFObject *degreeName = [specialization valueForKey:@"degreeId"];
                NSString *strDegrees = [degreeName valueForKey:@"name"];
                if (strDegrees.length > 0)
                {
                    [arrDegrees addObject:strDegrees];
                }
            }
            NSString *strAllDegree = [arrDegrees componentsJoinedByString:@","];
            lblEducation.text = [NSString stringWithFormat:@"%@",strAllDegree];
        }
    }];
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
    [query whereKey:@"profileId" equalTo:@"EYKXEM27cu"];
    [query orderByDescending:@"createdAt"];
    [query countObjectsInBackgroundWithBlock:^(int number1, NSError *error) {
        if (!error) {
            // The count request succeeded. Log the count
            
            totalNumberOfEntries = number1;
            
//            if (totalNumberOfEntries > [loadimagesarray count])
//            {
                NSLog(@"Retrieving data");
                //query.skip=[NSNumber numberWithInt:2300];
                [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
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
                    [self performSelector:@selector(retrieveImagesFromArray) withObject:nil afterDelay:1.0];
                }];
            }
            
//        }
//        else
//        {
//            // The request failed, we'll keep the chatData count?
//            number1 = [loadimagesarray count];
//        }
    }];
    
}

-(void) retrieveImagesFromArray
{
    for (PFObject *obj in loadimagesarray)
    {
        PFFile *userImageFile = obj[@"file"];
        [userImageFile getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error)
         {
             if (!error) {
                 UIImage *image = [UIImage imageWithData:imageData];
                 [arrImages addObject:image];
             }
             else
             {
                 NSLog(@"Error = > %@",error);
             }
             [ImagesCollectionView reloadData];
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
    
     collectionImageView.image = [UIImage imageNamed:[arrImages objectAtIndex:indexPath.row]];
    
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
        [self.navigationController pushViewController:vc animated:YES];
    }
     
}


- (IBAction)back:(id)sender
{
    //[self.navigationController popViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)viewFullProfile:(id)sender
{
    
    
}
@end
