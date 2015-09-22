//
//  ViewFullProfileVC.h
//  MandapTak
//
//  Created by Anuj Jain on 8/24/15.
//  Copyright (c) 2015 Walkover. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CMFGalleryCell.h"
#import "Profile.h"
#import "WorkEducationCell.h"
#import "Education.h"
#import "SVWebViewController.h"
#import "SVModalWebViewController.h"
#import <LayerKit/LayerKit.h>

@interface ViewFullProfileVC : UIViewController<UICollectionViewDataSource,UICollectionViewDelegate,UITableViewDataSource,UITableViewDelegate>
{
    
    IBOutlet UIView *view1;
    IBOutlet UIView *view2;
    IBOutlet UIView *view3;
    IBOutlet UIView *view4;
    IBOutlet UIView *tabButtonsView;
    IBOutlet UICollectionView *ImagesCollectionView;
    NSArray *dataArray;
    IBOutlet UILabel *lblName;
    IBOutlet UILabel *lblGender;
    IBOutlet UILabel *lblPlaceOfBirth;
    IBOutlet UILabel *lblDOB;
    IBOutlet UILabel *lblWeight;
    IBOutlet UILabel *lblHeight;
    IBOutlet UILabel *lblTOB;
    IBOutlet UILabel *lblReligion;
    IBOutlet UILabel *lblBudget;
    IBOutlet UITableView *tableViewEducation;

    IBOutlet UILabel *lblMinBudget;
    IBOutlet UILabel *lblMaxBudget;
    IBOutlet UIButton *button1;
    IBOutlet UIButton *button2;
    IBOutlet UIButton *button3;
    IBOutlet UIButton *button4;
}
- (IBAction)back:(id)sender;
- (IBAction)showBasicDetails:(id)sender;
- (IBAction)showHeightWeight:(id)sender;
- (IBAction)showWorkDetails:(id)sender;
- (IBAction)showBiodata:(id)sender;
- (IBAction)downloadBiodata:(id)sender;
@property (nonatomic) LYRClient *layerClient;
@property (nonatomic) BOOL isFromMatches;
@property (strong, nonatomic) PFObject *currentProfile;
@property (strong,nonatomic) NSMutableArray *arrImages;
@property (strong,nonatomic) NSMutableArray *arrEducation;
@property (strong,nonatomic) Profile *profileObject;
@end
