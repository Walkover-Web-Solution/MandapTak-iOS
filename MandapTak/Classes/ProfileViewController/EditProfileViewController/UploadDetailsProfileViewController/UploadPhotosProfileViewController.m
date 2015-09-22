//
//  UploadPhotosProfileViewController.m
//  MandapTak
//
//  Created by Hussain Chhatriwala on 20/08/15.
//  Copyright (c) 2015 Walkover. All rights reserved.
//

#import "UploadPhotosProfileViewController.h"
#import "ZCImagePickerController.h"
#import "ImageViewCell.h"
#import "ImageViewController.h"
#import "PhotosOptionPopoverViewController.h"
#import "WYPopoverController.h"
#import "Photos.h"
//#import <ParseFacebookUtils/PFFacebookUtils.h>
#import "WYStoryboardPopoverSegue.h"

@interface UploadPhotosProfileViewController ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate,ZCImagePickerControllerDelegate,WYPopoverControllerDelegate,PhotosOptionPopoverViewControllerDelegate,ImageViewControllerDelegate>{
    NSMutableArray *arrNewImages;
    NSMutableArray *arrOldImages;
    NSMutableArray *arrImageList;
    NSString * selectedImage;
    WYPopoverController* popoverController;
    BOOL isSelectingBiodata;
    BOOL isTakingPhoto;
    NSString *selectedFrom;
    NSString *selectedTo;
    UIImage *selectedBiodata;
    UIImage *primaryCropedPhoto;
    Photos *primaryPhoto;
    BOOL isImagePicker;
}

@end

@implementation UploadPhotosProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    isImagePicker = YES;
    arrNewImages = [NSMutableArray array];
    arrOldImages = [NSMutableArray array];

    arrImageList = [NSMutableArray array];
    
    [self updateuserInfo];
  //  [self getAllPhotos];
    // Do any additional setup after loading the view.
    
}
-(void)getAllPhotos{
    PFQuery *query = [PFQuery queryWithClassName:@"Photo"];
    
    [query whereKey:@"profileId" equalTo:@"EYKXEM27cu"];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded.
            for(PFObject *object in objects){
                Photos *photo = [[Photos alloc]init];
                PFFile *image = (PFFile *)[object objectForKey:@"file"];
                photo.image = [UIImage imageWithData:image.getData];
                photo.imgObject = object;
                [arrOldImages addObject:photo];
            }
            arrImageList = [NSMutableArray arrayWithArray:[arrOldImages arrayByAddingObjectsFromArray:arrNewImages]];

            [self.collectionView reloadData];
            
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}
-(void)updateuserInfo{
    
    if(![[self.currentProfile valueForKey:@"minMarriageBudget"] isKindOfClass: [NSNull class]]){
        selectedFrom = [NSString stringWithFormat:@"%@",[self.currentProfile valueForKey:@"minMarriageBudget"] ] ;
    }
    
    if(![[self.currentProfile valueForKey:@"maxMarriageBudget"] isKindOfClass: [NSNull class]]){
        selectedTo = [NSString stringWithFormat:@"%@",[self.currentProfile valueForKey:@"maxMarriageBudget"] ] ;
    }
    if(![[self.currentProfile valueForKey:@"bioData"] isKindOfClass: [NSNull class]]){
        PFFile *image = (PFFile *)[self.currentProfile valueForKey:@"bioData"];
        selectedBiodata = [UIImage imageWithData:image.getData];
        if(selectedBiodata!=nil){
            self.biodataImgView.image =selectedBiodata;
            [self.btnUploadBiodata setTitle:[NSString stringWithFormat:@"Uploaded biodata"] forState:UIControlStateNormal];

        }
    }

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:nil];
    //_imageView.image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    if(isSelectingBiodata){
        self.biodataImgView.image =[info objectForKey:@"UIImagePickerControllerOriginalImage"];
        [self.btnUploadBiodata setTitle:[NSString stringWithFormat:@"Uploaded biodata"] forState:UIControlStateNormal];
    }
    else{
        Photos *photo = [[Photos alloc]init];
        photo.image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        photo.imgObject = nil;
        [arrNewImages addObject:photo];
        [self.collectionView reloadData];
    }
    
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
    ImageViewCell *cell  = [collectionView dequeueReusableCellWithReuseIdentifier:@"ImageViewCell"
                                                                     forIndexPath:indexPath];
    if(cell!=nil){
        cell  = [collectionView dequeueReusableCellWithReuseIdentifier:@"ImageViewCell" forIndexPath:indexPath];
        
    }
    Photos *photo = arrImageList[indexPath.row];
    cell.imgView.image =photo.image ;
    if([selectedImage isEqual:arrImageList[indexPath.row]]){
        cell.starImgView.image =[UIImage imageNamed:@"star.png"];
    }
    else {
        cell.starImgView.image =[UIImage imageNamed:@""];
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    selectedImage = arrImageList[indexPath.row];
    [self.collectionView reloadData];
    UIStoryboard *sb2 = [UIStoryboard storyboardWithName:@"Profile" bundle:nil];
    ImageViewController *vc2 = [sb2 instantiateViewControllerWithIdentifier:@"ImageViewController"];
    vc2.selectedImage = arrImageList[indexPath.row];
    vc2.arrImages = arrImageList;
    vc2.currentIndex = indexPath.row;
    //vc.globalCompanyId = [self.companies.companyId intValue];
    
    UINavigationController *navController = [[UINavigationController alloc]initWithRootViewController:vc2];
    navController.navigationBarHidden =YES;
    [self presentViewController:navController animated:YES completion:nil];
}


#pragma mark - ZCImagePickerControllerDelegate

- (void)zcImagePickerController:(ZCImagePickerController *)imagePickerController didFinishPickingMediaWithInfo:(NSArray *)info {
    [self dismissPickerView];
    
    for (NSDictionary *imageDic in info) {
        Photos *photo = [[Photos alloc]init];
        photo.image =[imageDic objectForKey:UIImagePickerControllerOriginalImage];
        photo.imgObject = nil;
        [arrNewImages addObject:photo];
    }
    arrImageList = [NSMutableArray arrayWithArray:[arrOldImages arrayByAddingObjectsFromArray:arrNewImages]];
    [self.collectionView reloadData];
}

- (void)zcImagePickerControllerDidCancel:(ZCImagePickerController *)imagePickerController {
    [self dismissPickerView];
}
-(void)launchSingleImagePicker{
    UIImagePickerController * picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    [self presentViewController:picker animated:YES completion:nil];

}
#pragma mark - Private Methods

- (void)launchImagePickerViewController {
    ZCImagePickerController *imagePickerController = [[ZCImagePickerController alloc] init];
    imagePickerController.imagePickerDelegate = self;
    imagePickerController.maximumAllowsSelectionCount = 5;
    imagePickerController.mediaType = ZCMediaAllAssets;
    
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
        
        // You should present the image picker in a popover on iPad.
        
       // _popoverController = [[UIPopoverController alloc] initWithContentViewController:imagePickerController];
      //  [_popoverController presentPopoverFromRect:_launchButton.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    }
    else {
        // Full screen on iPhone and iPod Touch.
        
        [self presentViewController:imagePickerController animated:YES completion:NULL];
    }
}

- (void)dismissPickerView {
        [self dismissViewControllerAnimated:YES completion:NULL];
}
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    if ([segue.identifier isEqualToString:@"PhotosIdentifier"])
    {
        PhotosOptionPopoverViewController *controller = segue.destinationViewController;
        controller.preferredContentSize = CGSizeMake(300, 200);
        WYStoryboardPopoverSegue* popoverSegue = (WYStoryboardPopoverSegue*)segue;
        popoverController = [popoverSegue popoverControllerWithSender:sender
                                             permittedArrowDirections:WYPopoverArrowDirectionAny
                                                             animated:YES];
        isSelectingBiodata = NO;
        popoverController.popoverLayoutMargins = UIEdgeInsetsMake(4, 4, 4, 4);
        popoverController.delegate = self;
        controller.delegate = self;
    }
    if ([segue.identifier isEqualToString:@"BiodataIdentifier"])
    {
        PhotosOptionPopoverViewController *controller = segue.destinationViewController;
        controller.preferredContentSize = CGSizeMake(300, 140);
        WYStoryboardPopoverSegue* popoverSegue = (WYStoryboardPopoverSegue*)segue;
        popoverController = [popoverSegue popoverControllerWithSender:sender permittedArrowDirections:WYPopoverArrowDirectionAny animated:YES];
        isSelectingBiodata =YES;
        popoverController.popoverLayoutMargins = UIEdgeInsetsMake(4, 4, 4, 4);
        popoverController.delegate = self;
        controller.delegate = self;
    }
}

#pragma mark ImageViewControllerDelegate
-(void)selectedPrimaryPhoto:(UIImage *)primaryPhoto andCropedPhoto:(UIImage *)cropedPhoto andIndex:(NSInteger)index{
    for(UIImage *image in arrImageList){
        
    }
}
-(void)selectedPrimaryPhoto:(Photos *)primaryImg andCropedPhoto:(UIImage *)cropedImg andIndex:(NSInteger)index withDeletedPhotos:(NSArray *)arrDeletedPhotos{
    for(Photos *photo in arrDeletedPhotos){
        if([arrImageList containsObject:photo]){
            [arrImageList delete:photo];
        }
        if([arrOldImages containsObject:photo]){
            [arrOldImages delete:photo];
        }
        if([arrNewImages containsObject:photo]){
            [arrNewImages delete:photo];
        }
    }
    primaryPhoto = primaryImg;
    primaryCropedPhoto = cropedImg;
}
#pragma mark PopoverDelegate
-(void)selectedTag:(NSInteger)tag{
    UIImagePickerController * picker = [[UIImagePickerController alloc] init];

    switch (tag) {
        case 0:
            //take Photos
            picker.delegate = self;
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            //[self presentModalViewController:picker animated:YES];
            [self presentViewController:picker animated:YES completion:nil];
            isTakingPhoto = YES;
            break;
        case 1:
            //Photo gallery

            if(isSelectingBiodata)
                [self launchSingleImagePicker];
            else
                [self launchImagePickerViewController];
            break;
        case 2:
           // [self loginViaFacebook];
            //From Facebook

                      break;
        default:
            break;
    }
    [popoverController dismissPopoverAnimated:YES];
}

-(void)viewWillDisappear:(BOOL)animated{
    if(selectedFrom)
        self.currentProfile[@"minMarriageBudget"] = @([selectedFrom integerValue]);

    if(selectedTo)
        self.currentProfile[@"maxMarriageBudget"] = @([selectedTo integerValue]);
    if(selectedBiodata){
        NSData *pictureData = UIImagePNGRepresentation(selectedBiodata);
        PFFile *file = [PFFile fileWithName:@"biodata" data:pictureData];
        [self.currentProfile setObject:file forKey:@"bioData"];
    }
//
//    NSMutableArray *arrAllPhotoToBeSaved = [NSMutableArray array];
//    for(Photos *photo in arrNewImages){
//        NSData *pictureData = UIImagePNGRepresentation(photo.image);
//        PFFile *file = [PFFile fileWithName:@"img" data:pictureData];
//        PFObject *photo = [PFObject objectWithClassName:@"Photo"];
//        [photo setObject:self.currentProfile forKey:@"profileId"];
//        [photo setObject:file forKey:@"file"];
//        [arrAllPhotoToBeSaved addObject:photo];
//    }
//    [PFObject saveAllInBackground:arrAllPhotoToBeSaved block:^(BOOL succeeded, NSError *error) {
//                if (succeeded) {
//                    NSLog(@"Woohoo!");
//                }
//    }];
    [self.delegate updatedPfObjectForFourthTab:self.currentProfile withNewImg:arrNewImages withProfilePic:primaryPhoto andCropedProfilePic:primaryCropedPhoto];
}
@end
