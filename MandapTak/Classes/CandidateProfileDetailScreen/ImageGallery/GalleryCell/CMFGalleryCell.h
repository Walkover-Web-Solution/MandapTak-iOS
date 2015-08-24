//
//  CMFGalleryCell.h
//  MandapTak
//
//  Created by Anuj Jain on 8/21/15.
//  Copyright (c) 2015 Walkover. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CMFGalleryCell : UICollectionViewCell
@property (nonatomic, strong) NSString *imageName;
@property (nonatomic, strong) UIImage *userImage;

-(void)updateCell;
@end
