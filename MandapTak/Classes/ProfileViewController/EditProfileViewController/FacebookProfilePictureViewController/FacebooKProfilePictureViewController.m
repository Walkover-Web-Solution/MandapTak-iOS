//
//  FacebooKProfilePictureViewController.m
//  MandapTak
//
//  Created by Hussain Chhatriwala on 26/08/15.
//  Copyright (c) 2015 Walkover. All rights reserved.
//

#import "FacebooKProfilePictureViewController.h"
#import "PhotoSelectionCell.h"
#import "Photos.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import "ServiceManager.h"
@interface FacebooKProfilePictureViewController (){
    NSMutableArray *arrImageList;
    NSMutableArray *arrSelectedImages;
    NSString *profileAlbumId;
    NSUInteger allPicCount;
    NSUInteger currentCount;
    __weak IBOutlet UIActivityIndicatorView *activityIndicator;
}
- (IBAction)cancelButtonAction:(id)sender;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
- (IBAction)doneButtonAction:(id)sender;

@end

@implementation FacebooKProfilePictureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    arrImageList = [NSMutableArray array];
    arrSelectedImages = [NSMutableArray array];
    allPicCount = 0;
    currentCount = 0;
    [self getAllAlbums];
    [activityIndicator startAnimating];
    activityIndicator.hidden = NO;
}

-(void)getAllAlbums{

    FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc]
                                  initWithGraphPath:[NSString stringWithFormat:@"/%@/albums",[[NSUserDefaults standardUserDefaults]valueForKey:@"FacebookUserId"]]
                                  parameters:nil
                                  HTTPMethod:@"GET"];
    [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection,
                                          id result,
                                          NSError *error) {
        if(!error){
            NSArray *arrData = [result valueForKey:@"data"];
            for(NSDictionary *dict in arrData){
                if([[dict valueForKey:@"name"] isEqual:@"Profile Pictures"]){
                    profileAlbumId = [dict valueForKey:@"id"];
                    [self getAllPhotos];
                    break;
                }
            }
        }
        // Handle the result
    }];
}
-(void)getAllPhotos{
    
    FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc]
                                  initWithGraphPath:[NSString stringWithFormat:@"/%@/photos",profileAlbumId]
                                  parameters:nil
                                  HTTPMethod:@"GET"];
    [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection,
                                          id result,
                                          NSError *error) {
        if(!error){
            NSArray *arrData = [result valueForKey:@"data"];
            allPicCount = arrData.count;
            
            for(NSDictionary *dict in arrData){
                [self getPictureForId:[dict valueForKey:@"id"]];
                 }
        }
    }];

}
-(void)getPictureForId:(NSString*)picId{
    NSDictionary *params = @{ @"redirect" : @false};
    FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc]
                                  initWithGraphPath:[NSString stringWithFormat:@"/%@/picture",picId] //As many fields as you need
                                  parameters:params
                                  HTTPMethod:@"GET"];
    [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection,
                                          id result,
                                          NSError *error) {
        currentCount ++;
        if (!error){
             NSDictionary* data = [result valueForKey:@"data"];
            NSString *url = [data objectForKey:@"url"];
            NSData *dataImage = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
            UIImage *img = [UIImage imageWithData:dataImage];
            [arrImageList addObject:img];
            [self.collectionView reloadData];
            if(currentCount ==allPicCount){
                [activityIndicator stopAnimating];
                activityIndicator.hidden = YES;

            }
        }
    }];
}

#pragma mark UICollectionViewDataSource

-(NSInteger)numberOfSectionsInCollectionView:
(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView
    numberOfItemsInSection:(NSInteger)section
{
    return arrImageList.count;
    
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                 cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PhotoSelectionCell *cell  = [collectionView dequeueReusableCellWithReuseIdentifier:@"PhotoSelectionCell"
                                                                     forIndexPath:indexPath];
    
    if(cell!=nil){
        cell  = [collectionView dequeueReusableCellWithReuseIdentifier:@"PhotoSelectionCell" forIndexPath:indexPath];
        
    }
    Photos *photo = arrImageList[indexPath.row];
    
    cell.imgProfile.image =arrImageList[indexPath.row] ;
    if([arrSelectedImages containsObject:photo]){
        cell.imgSelection.image =[UIImage imageNamed:@"SelectionOverlay~iOS7"];
    }
    else {
        cell.imgSelection.image =[UIImage imageNamed:@""];
        
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [self.collectionView reloadData];
    if([arrSelectedImages containsObject:arrImageList[indexPath.row]]){
        [arrSelectedImages removeObject:arrImageList[indexPath.row]];
    }
    else
         [arrSelectedImages addObject:arrImageList[indexPath.row]];
    
    [self.collectionView reloadData];
}

- (IBAction)cancelButtonAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)doneButtonAction:(id)sender {
    NSMutableArray *arrData = [NSMutableArray array];
    for(UIImage *img in arrSelectedImages){
        Photos *photo = [[Photos alloc]init];
        photo.image =img;
        photo.imgObject = nil;
        [arrData addObject:photo];
    }
    [self.delegate selectedProfilePhotoArray:arrData];
    [self dismissViewControllerAnimated:YES completion:nil];

}
@end
