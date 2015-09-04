//
//  ImageViewController.m
//  MandapTak
//
//  Created by Hussain Chhatriwala on 20/08/15.
//  Copyright (c) 2015 Walkover. All rights reserved.
//

#import "ImageViewController.h"
#import "Photos.h"
#import "PhotoTweaksViewController.h"
#import "MBProgressHUD.h"
#import "AppData.h"
@interface ImageViewController ()<PhotoTweaksViewControllerDelegate>{
    NSInteger currentIndex;
    Photos *primaryPhoto;
    NSMutableArray *arrDeletedPhotos;
    UIImage *primaryCropPhoto;
  }
@property (weak, nonatomic) IBOutlet UIButton *deleteButtonAction;
- (IBAction)deleteButtonAction:(id)sender;

@end




@implementation ImageViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    arrDeletedPhotos = [NSMutableArray array];
    Photos *photo = self.arrImages[self.currentIndex];
    imageView.image = photo.image;
    NSLog(@"%@",photo.name);
    UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    // Setting the swipe direction.
    [self.navigationController setNavigationBarHidden:YES animated:NO];

    
    [swipeLeft setDirection:UISwipeGestureRecognizerDirectionLeft];
    [self.view addGestureRecognizer:swipeLeft];
    [self.view addGestureRecognizer:swipeRight];
    

    // Do any additional setup after loading the view.
}

- (IBAction)doneButtonAction:(id)sender {
    [self.delegate selectedPrimaryPhoto:primaryPhoto andCropedPhoto:primaryCropPhoto andIndex:currentIndex withDeletedPhotos:arrDeletedPhotos];
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)cancelButtonAction:(id)sender {
    [self.delegate selectedPrimaryPhoto:primaryPhoto andCropedPhoto:primaryCropPhoto andIndex:currentIndex withDeletedPhotos:arrDeletedPhotos];
    [self dismissViewControllerAnimated:YES completion:nil];

}

- (IBAction)cropButtonAction:(id)sender {
//    ImageCropViewController *controller = [[ImageCropViewController alloc] initWithImage:self.arrImages[currentIndex]];
//    controller.delegate = self;
//    controller.blurredBackground = YES;
//    [[self navigationController] pushViewController:controller animated:YES];
}
- (IBAction)makePrimary:(id)sender {
    Photos *photo = self.arrImages[self.currentIndex];
    primaryPhoto = photo;
//    if(photo.imgObject!=nil){
//        [photo.imgObject setObject:[NSNumber numberWithBool:YES] forKey:@"isPrimary"];
//        [photo.imgObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
//            if (!error) {
//                // succesful
//                
//            } else {
//                //Something bad has ocurred
//                NSString *errorString = [[error userInfo] objectForKey:@"error"];
//                UIAlertView *errorAlertView = [[UIAlertView alloc] initWithTitle:@"Error" message:errorString delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
//                [errorAlertView show];
//            }
//        }];
//
//    }
    PhotoTweaksViewController *photoTweaksViewController = [[PhotoTweaksViewController alloc] initWithImage:photo.image];
    photoTweaksViewController.delegate = self;
    photoTweaksViewController.autoSaveToLibray = NO;

    [self presentViewController:photoTweaksViewController animated:YES completion:nil];
}

- (void)photoTweaksController:(PhotoTweaksViewController *)controller didFinishWithCroppedImage:(UIImage *)croppedImage
{
    primaryCropPhoto = croppedImage;
    [self.delegate selectedPrimaryPhoto:primaryPhoto andCropedPhoto:primaryCropPhoto andIndex:currentIndex withDeletedPhotos:arrDeletedPhotos];
    [self dismissViewControllerAnimated:YES completion:^{
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
}


- (void)photoTweaksControllerDidCancel:(PhotoTweaksViewController *)controller
{
    [controller.navigationController popViewControllerAnimated:YES];
}


- (void)handleSwipe:(UISwipeGestureRecognizer *)swipe {
    CATransition *transition = [CATransition animation];

    if (swipe.direction == UISwipeGestureRecognizerDirectionLeft) {
        if(self.currentIndex!=self.arrImages.count-1){
            self.currentIndex++;
            transition.duration = .3f;
            [transition setType:kCATransitionPush];
            [transition setSubtype:kCATransitionFromRight];
        }
        else{
            [transition setType:kCATransition];
            transition.duration = 0.0f;
        }
    }
    if (swipe.direction == UISwipeGestureRecognizerDirectionRight) {
        NSLog(@"Right Swipe");
        if(self.currentIndex!=0){
            self.currentIndex--;
            transition.duration = .3f;
            [transition setType:kCATransitionPush];
            [transition setSubtype:kCATransitionFromLeft];
        }
        else{
            [transition setType:kCATransition];
            transition.duration = 0.0f;
        }
    }
 
   
        [imageView.layer addAnimation:transition forKey:nil];

    Photos *photo = self.arrImages[self.currentIndex];
    [imageView setImage:photo.image];
    
  }


- (IBAction)deleteButtonAction:(id)sender {
    if([[AppData sharedData]isInternetAvailable]){
        Photos *photo = self.arrImages[self.currentIndex];
        if(photo.imgObject){
            MBProgressHUD * hud;
            hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
            
            [photo.imgObject deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                if (succeeded){
                    [arrDeletedPhotos addObject:self.arrImages[currentIndex]];
                    [self.arrImages removeObject:self.arrImages[currentIndex]];
                    if(self.arrImages.count==0){
                        [self.delegate selectedPrimaryPhoto:primaryPhoto andCropedPhoto:primaryCropPhoto andIndex:currentIndex withDeletedPhotos:arrDeletedPhotos];
                        [self dismissViewControllerAnimated:YES completion:nil];
                        
                    }
                    NSLog(@"deleted"); // this is my function to refresh the data
                    Photos *photoToShow = self.arrImages[self.currentIndex];
                    imageView.image = photoToShow.image;
                } else {
                    NSLog(@"Try Later");
                }
            }];
        }
        else{
            [arrDeletedPhotos addObject:self.arrImages[currentIndex]];
            [self.arrImages removeObject:self.arrImages[currentIndex]];
            Photos *photoToShow = self.arrImages[self.currentIndex];
            imageView.image = photoToShow.image;
        }

    }
    else{
               UIAlertView *alert =  [[UIAlertView alloc]initWithTitle:@"Opps!!" message:@"Please Check your internet connection" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                [alert show];
    }

    

}
@end
