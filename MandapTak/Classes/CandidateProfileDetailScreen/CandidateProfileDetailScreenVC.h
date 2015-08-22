//
//  CandidateProfileDetailScreenVC.h
//  MandapTak
//
//  Created by Anuj Jain on 8/20/15.
//  Copyright (c) 2015 Walkover. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FullyHorizontalFlowLayout.h"
#import <Parse/Parse.h>
#import "MBProgressHUD.h"
#import "CandidateProfileGalleryVC.h"


@interface CandidateProfileDetailScreenVC : UIViewController<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
{
    
    IBOutlet UIImageView *profileImageView;
    IBOutlet UILabel *lblName;
    IBOutlet UILabel *lblAgeHeight;
    IBOutlet UILabel *lblCaste;
    IBOutlet UILabel *lblOccupation;
    IBOutlet UILabel *lblTraitMatch;
    IBOutlet UICollectionView *ImagesCollectionView;
    
    IBOutlet UILabel *lblCurrentLocation;
    IBOutlet UILabel *lblWeight;
    IBOutlet UILabel *lblDesignation;
    IBOutlet UILabel *lblIndustry;
    IBOutlet UILabel *lblEducation;
    NSArray *collectionImages,*arrHeight;
    
    NSMutableArray *loadimagesarray,*arrImages;
}
- (IBAction)back:(id)sender;
- (IBAction)viewFullProfile:(id)sender;
@end
