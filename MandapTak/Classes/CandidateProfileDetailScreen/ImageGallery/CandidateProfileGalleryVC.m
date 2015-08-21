//
//  CandidateProfileGalleryVC.m
//  MandapTak
//
//  Created by Anuj Jain on 8/21/15.
//  Copyright (c) 2015 Walkover. All rights reserved.
//

#import "CandidateProfileGalleryVC.h"

@interface CandidateProfileGalleryVC ()

@end

@implementation CandidateProfileGalleryVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self loadImages];
    [self setupCollectionView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark UICollectionView methods

-(void)setupCollectionView {
    [GalleryCollectionView registerClass:[CMFGalleryCell class] forCellWithReuseIdentifier:@"cellIdentifier"];
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    [flowLayout setMinimumInteritemSpacing:0.0f];
    [flowLayout setMinimumLineSpacing:0.0f];
    [GalleryCollectionView setPagingEnabled:YES];
    [GalleryCollectionView setCollectionViewLayout:flowLayout];
}


-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [dataArray count];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CMFGalleryCell *cell = (CMFGalleryCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"cellIdentifier" forIndexPath:indexPath];
    
    NSString *imageName = [dataArray objectAtIndex:indexPath.row];
    [cell setImageName:imageName];
    [cell updateCell];
    
    return cell;
    
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return GalleryCollectionView.frame.size;
}


#pragma mark -
#pragma mark Data methods
-(void)loadImages {
    
    NSString *sourcePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"Assets"];
    //dataArray = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:sourcePath error:NULL];
    NSLog(@"arr = %@",dataArray);
    dataArray = [NSArray arrayWithObjects:@"Profile_2.png",@"Profile_2.png",@"Profile_2.png",@"Profile_2.png",@"Profile_2.png",@"Profile_2.png",@"Profile_2.png",@"Profile_1.png",@"Profile_1.png",@"Profile_1.png",@"Profile_1.png", nil];
    pageControl.numberOfPages = [dataArray count];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)backAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)back:(id)sender
{
//    [self.navigationController popViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
