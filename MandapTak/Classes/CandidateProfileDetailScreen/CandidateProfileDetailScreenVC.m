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
    
    arrHeight = [NSArray arrayWithObjects:@"4ft 5in - 134cm",@"4ft 6in - 137cm",@"4ft 7in - 139cm",@"4ft 8in - 142cm",@"4ft 9in - 144cm",@"4ft 10in - 147cm",@"4ft 11in - 149cm",@"5ft - 152cm",@"5ft 1in - 154cm",@"5ft 2in - 157cm",@"5ft 3in - 160cm",@"5ft 4in - 162cm",@"5ft 5in - 165cm",@"5ft 6in - 167cm",@"5ft 7in - 170cm",@"5ft 8in - 172cm",@"5ft 9in - 175cm",@"5ft 10in - 177cm",@"5ft 11in - 180cm",@"6ft - 182cm",@"6ft 1in - 185cm",@"6ft 2in - 187cm",@"6ft 3in - 190cm",@"6ft 4in - 193cm",@"6ft 5in - 195cm",@"6ft 6in - 198cm",@"6ft 7in - 200cm",@"6ft 8in - 203cm",@"6ft 9in - 205cm",@"6ft 10in - 208cm",@"6ft 11in - 210cm",@"7ft - 213cm", nil];
    
    lblTraitMatch.hidden = YES;
    collectionImages = [NSArray arrayWithObjects:@"Profile_2.png",@"Profile_2.png",@"Profile_2.png",@"Profile_2.png",@"Profile_2.png",@"Profile_2.png",@"Profile_2.png",@"Profile_1.png",@"Profile_1.png",@"Profile_1.png",@"Profile_1.png", nil];
 
    //adding blur effect to image
    self.navigationController.navigationBarHidden = YES;
    UIImage *theImage = [UIImage imageNamed:@"Profile_2.png"];
    
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark Collection View Methods
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return collectionImages.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *identifier = @"Cell";
    UICollectionViewCell *cell = [ImagesCollectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    cell.layer.cornerRadius = 25.0;
    UIImageView *collectionImageView = (UIImageView *)[cell viewWithTag:100];
    
     collectionImageView.image = [UIImage imageNamed:[collectionImages objectAtIndex:indexPath.row]];
    
     return cell;
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout*)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    //NSLog(@"SETTING SIZE FOR ITEM AT INDEX %d", indexPath.row);
    return CGSizeMake(50, 50);
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
@end
