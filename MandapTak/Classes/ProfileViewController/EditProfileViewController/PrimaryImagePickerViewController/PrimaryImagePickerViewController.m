//
//  PrimaryImagePickerViewController.m
//  MandapTak
//
//  Created by Hussain Chhatriwala on 20/10/15.
//  Copyright © 2015 Walkover. All rights reserved.
//

#import "PrimaryImagePickerViewController.h"
#import "PhotoSelectionCell.h"
@interface PrimaryImagePickerViewController ()<PhotoTweaksViewControllerDelegate>{
    UIImage *selectedCropedImage;
    Photos *selectedPrimaryPhoto;
}
- (IBAction)cancelButtonAction:(id)sender;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
- (IBAction)doneButtonAction:(id)sender;

@end

@implementation PrimaryImagePickerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark UICollectionViewDataSource


-(NSInteger)collectionView:(UICollectionView *)collectionView
    numberOfItemsInSection:(NSInteger)section
{
    return self.arrImageList.count;
    
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                 cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PhotoSelectionCell *cell  = [collectionView dequeueReusableCellWithReuseIdentifier:@"PhotoSelectionCell"
                                                                          forIndexPath:indexPath];
    
    if(cell!=nil){
        cell  = [collectionView dequeueReusableCellWithReuseIdentifier:@"PhotoSelectionCell" forIndexPath:indexPath];
        
    }
    Photos *photo = self.arrImageList[indexPath.row];
    
    cell.imgProfile.image =photo.image ;
//    if([arrSelectedImages containsObject:photo]){
//        cell.imgSelection.image =[UIImage imageNamed:@"SelectionOverlay~iOS7"];
//    }
//    else {
//        cell.imgSelection.image =[UIImage imageNamed:@""];
//        
//    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    selectedPrimaryPhoto = self.arrImageList[indexPath.row];
    Photos *photo = self.arrImageList[indexPath.row];
    PhotoTweaksViewController *photoTweaksViewController = [[PhotoTweaksViewController alloc] initWithImage:photo.image];
    photoTweaksViewController.delegate = self;
    photoTweaksViewController.autoSaveToLibray = NO;
    
    [self presentViewController:photoTweaksViewController animated:YES completion:nil];
}


- (IBAction)cancelButtonAction:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)doneButtonAction:(id)sender{
    [self.delegate selectedPrimaryPhoto:selectedPrimaryPhoto andCropedPhoto:selectedCropedImage];
    [self dismissViewControllerAnimated:YES completion:nil];

}

#pragma mark PhotoTweaksControllerDelegate
- (void)photoTweaksController:(PhotoTweaksViewController *)controller didFinishWithCroppedImage:(UIImage *)croppedImage
{
    selectedCropedImage = croppedImage;
    [self.delegate selectedPrimaryPhoto:selectedPrimaryPhoto andCropedPhoto:selectedCropedImage];
    [self dismissViewControllerAnimated:YES completion:^{
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
}


- (void)photoTweaksControllerDidCancel:(PhotoTweaksViewController *)controller
{
    [controller.navigationController popViewControllerAnimated:YES];
}

@end
