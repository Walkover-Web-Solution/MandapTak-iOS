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
    
    collectionImages = [NSArray arrayWithObjects:@"Profile_2.png",@"Profile_2.png",@"Profile_2.png",@"Profile_2.png",@"Profile_2.png",@"Profile_2.png",@"Profile_2.png",@"Profile_1.png",@"Profile_1.png",@"Profile_1.png",@"Profile_1.png", nil];
    //[ImagesCollectionView registerClass:[ImagesViewCell class] forCellWithReuseIdentifier:@"Cell"];
    //adding blur effect to image
    /*
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    UIVisualEffectView *blurEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    blurEffectView.frame = profileImageView.frame;
    blurEffectView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [profileImageView addSubview:blurEffectView];
     */
    
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
    //collectionViewLayout.nbColumns = 5;
    //collectionViewLayout.nbLines = 3;
    
    [ImagesCollectionView setCollectionViewLayout:collectionViewLayout];
    ImagesCollectionView.pagingEnabled = YES;
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
