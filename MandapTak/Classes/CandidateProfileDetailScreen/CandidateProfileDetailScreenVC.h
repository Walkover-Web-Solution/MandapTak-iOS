//
//  CandidateProfileDetailScreenVC.h
//  MandapTak
//
//  Created by Anuj Jain on 8/20/15.
//  Copyright (c) 2015 Walkover. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FullyHorizontalFlowLayout.h"

@interface CandidateProfileDetailScreenVC : UIViewController<UICollectionViewDataSource,UICollectionViewDelegate>
{
    
    IBOutlet UIImageView *profileImageView;
    IBOutlet UILabel *lblName;
    IBOutlet UILabel *lblAgeHeight;
    IBOutlet UILabel *lblCaste;
    IBOutlet UILabel *lblOccupation;
    IBOutlet UILabel *lblTraitMatch;
    IBOutlet UICollectionView *ImagesCollectionView;
    
    NSArray *collectionImages;
}
- (IBAction)back:(id)sender;
@end
