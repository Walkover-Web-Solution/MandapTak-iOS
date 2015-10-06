//
//  PreferenceVC.h
//  MandapTak
//
//  Created by Anuj Jain on 8/4/15.
//  Copyright (c) 2015 Walkover. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "UserProfileViewController.h"
//#import "PopOverListViewController.h"
#import "WYStoryboardPopoverSegue.h"
#import "WYPopoverController.h"
#import "SelectedLocationVC.h"
#import "DegreeListVC.h"
#import "Degree.h"
#import "HeightPopoverViewController.h"
#import <Parse/Parse.h>
#import <Parse/PFObject.h>
#import "MBProgressHUD.h"
#import "LocationPreferencePopoverVC.h"
#import "AppData.h"

@interface PreferenceVC : UIViewController<UITextFieldDelegate,WYPopoverControllerDelegate,SelectedLocationVCDelegate,LocationPreferencePopoverVCDelegate,DegreeListVCDelegate,HeightPopoverViewControllerDelegate,UIAlertViewDelegate>
{
    
    IBOutlet UITextField *txtMinAge;
    IBOutlet UITextField *txtMaxAge;
    IBOutlet UIButton *btnMinHeight;
    IBOutlet UIButton *btnMaxHeight;
    IBOutlet UITextField *txtIncome;
    IBOutlet UITextField *txtminBudget;
    IBOutlet UITextField *txtMaxBudget;
    
    //autocomplete
    /*
    UITableView *autocompleteTableView;
    NSMutableArray *arrAutoComplete;
     
     */
    NSMutableArray *arrSelLocations,*arrSelDegree,*arrSelectedDegreeId,*arrDegreePref,*arrSelectedLocationId,*arrLocationPref,*arrLocationObj,*arrDegreeObject;
    IBOutlet UIScrollView *scrollView;
    IBOutlet UISlider *sliderWork;
    IBOutlet UISlider *sliderManglik;
    IBOutlet UILabel *lblWorkStatus;
    IBOutlet UILabel *lblManglik;
    
    WYPopoverController* popoverController,*popOver2;
    IBOutlet UIButton *btnLocation;
    IBOutlet UILabel *lblLocation;
    IBOutlet UILabel *lblDegree;
    
    IBOutlet UILabel *lblBudget;
    //flag values
    BOOL heightFlag,insertFlag,addFlag;
    
    //work status
    int roundValue,roundValueManglik;
    int minHeight,maxHeight;
    NSArray *arrHeight;
    
    NSString *strObj;
    
    //constraints
    IBOutlet NSLayoutConstraint *equalHeightConstraint;
    
    //activity indicator
    IBOutlet UIActivityIndicatorView *activityIndicator;
}
- (IBAction)back:(id)sender;
- (IBAction)setPreferences:(id)sender;
- (IBAction)goAction:(id)sender;
- (IBAction)sliderChanged:(id)sender;
- (IBAction)sliderValueChanged:(id)sender;

@end
