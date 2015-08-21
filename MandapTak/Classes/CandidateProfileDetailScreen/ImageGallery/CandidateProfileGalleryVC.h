//
//  CandidateProfileGalleryVC.h
//  MandapTak
//
//  Created by Anuj Jain on 8/21/15.
//  Copyright (c) 2015 Walkover. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CMFGalleryCell.h"

@interface CandidateProfileGalleryVC : UIViewController <UICollectionViewDataSource,UICollectionViewDelegate>
{
    IBOutlet UICollectionView *GalleryCollectionView;
    NSArray *dataArray;
    IBOutlet UIPageControl *pageControl;
}
- (IBAction)backAction:(id)sender;
- (IBAction)back:(id)sender;
@end
