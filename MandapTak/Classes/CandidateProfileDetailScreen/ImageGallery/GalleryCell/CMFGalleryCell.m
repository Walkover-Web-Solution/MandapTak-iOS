//
//  CMFGalleryCell.m
//  MandapTak
//
//  Created by Anuj Jain on 8/21/15.
//  Copyright (c) 2015 Walkover. All rights reserved.
//

#import "CMFGalleryCell.h"
@interface CMFGalleryCell()
@property (strong, nonatomic) IBOutlet UIImageView *imageView1;
@property (strong, nonatomic) IBOutlet UIImageView *imageView2;
@end

@implementation CMFGalleryCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        // Initialization code
        NSArray *arrayOfViews = [[NSBundle mainBundle] loadNibNamed:@"CMFGalleryCell" owner:self options:nil];
        
        if ([arrayOfViews count] < 1) {
            return nil;
        }
        
        if (![[arrayOfViews objectAtIndex:0] isKindOfClass:[UICollectionViewCell class]]) {
            return nil;
        }
        
        self = [arrayOfViews objectAtIndex:0];
    }
    
    return self;
}

-(void)updateCell {
    
    //NSString *sourcePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"Assets"];
    //NSString *filename = [NSString stringWithFormat:@"%@/%@", sourcePath, self.imageName];
    NSString *filename = [NSString stringWithFormat:@"%@", self.imageName];
    UIImage *image = [UIImage imageNamed:filename];//[UIImage imageNamed:@"Profile_2.png"]; //[UIImage imageWithContentsOfFile:filename];
    self.imageView2.hidden = YES;
    //[self.imageView1 setImage:image];
    [self.imageView1 setImage:self.userImage];
    [self.imageView1 setContentMode:UIViewContentModeScaleAspectFit];
    
}

-(void)updateImageCell
{
    
    //NSString *sourcePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"Assets"];
    //NSString *filename = [NSString stringWithFormat:@"%@/%@", sourcePath, self.imageName];
    NSString *filename = [NSString stringWithFormat:@"%@", self.imageName];
    UIImage *image = [UIImage imageNamed:filename];//[UIImage imageNamed:@"Profile_2.png"]; //[UIImage imageWithContentsOfFile:filename];
    self.imageView1.hidden = YES;
    //[self.imageView1 setImage:image];
    [self.imageView2 setImage:self.userImage];
    [self.imageView2 setContentMode:UIViewContentModeScaleAspectFit];
    
}

@end
