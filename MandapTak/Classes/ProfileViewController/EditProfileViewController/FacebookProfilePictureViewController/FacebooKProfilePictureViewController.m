//
//  FacebooKProfilePictureViewController.m
//  MandapTak
//
//  Created by Hussain Chhatriwala on 26/08/15.
//  Copyright (c) 2015 Walkover. All rights reserved.
//

#import "FacebooKProfilePictureViewController.h"
#import <ParseFacebookUtils/PFFacebookUtils.h>
#import <FacebookSDK/FacebookSDK.h>
#import "PhotoSelectionCell.h"
#import "Photos.h"
@interface FacebooKProfilePictureViewController (){
    NSMutableArray *arrImageList;
    NSMutableArray *arrSelectedImages;
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
    [self getAllAlbums];
    //  [self getAllPhotos];
    // Do any additional setup after loading the view.
    
}
-(void)getAllAlbums{
    // https://graph.facebook.com/[ALBUM_ID]/photos?access_token=[AUTH_TOKEN]
    FBAccessTokenData *token = [[PFFacebookUtils session] accessTokenData];
    NSString *accessToken =token.accessToken;
    NSString *url =[NSString stringWithFormat:@"https://graph.facebook.com/%@/albums?access_token=%@",[[NSUserDefaults standardUserDefaults]valueForKey:@"facebookUserId"],accessToken];
    NSURL *pictureURL = [NSURL URLWithString:url];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:pictureURL];
    
    [NSURLConnection sendAsynchronousRequest:urlRequest
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                               if (connectionError == nil && data != nil) {
                                   NSError *error;
                                   NSDictionary *responce=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
                                   
                                   [self.collectionView reloadData];
                               } else {
                                   NSLog(@"Failed to load profile photo.");
                               }
                           }];
    

}

-(void)getAllPhotosForAlbumId:(NSString*)albumId{
    FBAccessTokenData *token = [[PFFacebookUtils session] accessTokenData];
    NSString *accessToken =token.accessToken;
    NSString *url =[NSString stringWithFormat:@"https://graph.facebook.com/%@/photos?access_token=%@",albumId,accessToken];
    NSURL *pictureURL = [NSURL URLWithString:url];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:pictureURL];
    
    [NSURLConnection sendAsynchronousRequest:urlRequest
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                               if (connectionError == nil && data != nil) {
                                   NSError *error;
                                   NSDictionary *responce=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
                                   
                                   [self.collectionView reloadData];
                               } else {
                                   NSLog(@"Failed to load profile photo.");
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
        cell  = [collectionView dequeueReusableCellWithReuseIdentifier:@"ImageViewCell" forIndexPath:indexPath];
        
    }
    Photos *photo = arrImageList[indexPath.row];
    
    cell.imgProfile.image =photo.image ;
    if([arrSelectedImages containsObject:photo]){
        cell.imgSelection.image =[UIImage imageNamed:@"star.png"];
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
    [self.delegate selectedProfilePhotoArray:arrSelectedImages];
}
@end
