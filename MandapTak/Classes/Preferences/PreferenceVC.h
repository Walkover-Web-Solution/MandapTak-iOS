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
#import "PopOverListViewController.h"
#import "WYStoryboardPopoverSegue.h"
#import "WYPopoverController.h"
#import "SelectedLocationVC.h"
#import "DegreeListVC.h"
#import "Degree.h"
#import "HeightPopoverViewController.h"

@interface PreferenceVC : UIViewController<UITextFieldDelegate,WYPopoverControllerDelegate,SelectedLocationVCDelegate,PopOverListViewControllerDelegate,DegreeListVCDelegate,HeightPopoverViewControllerDelegate>
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
    NSMutableArray *arrSelLocations,*arrSelDegree;
    IBOutlet UIScrollView *scrollView;
    IBOutlet UISlider *sliderWork;
    IBOutlet UILabel *lblWorkStatus;
    
    WYPopoverController* popoverController,*popOver2;
    IBOutlet UIButton *btnLocation;
    IBOutlet UILabel *lblLocation;
    IBOutlet UILabel *lblDegree;
    
    //height
    BOOL heightFlag;
}
- (IBAction)back:(id)sender;
- (IBAction)setPreferences:(id)sender;
- (IBAction)goAction:(id)sender;
- (IBAction)sliderChanged:(id)sender;
- (IBAction)sliderValueChanged:(id)sender;

@end
