//
//  DemoScreenVC.m
//  MandapTak
//
//  Created by Anuj Jain on 11/4/15.
//  Copyright © 2015 Walkover. All rights reserved.
//

#import "DemoScreenVC.h"

@interface DemoScreenVC ()
{
    IBOutlet UIImageView *imgViewProfilePic;
    IBOutlet UIView *blankView;
    IBOutlet UIView *profileView;
    IBOutlet UILabel *lblMessage;
    IBOutlet UIButton *btnUndo;
    IBOutlet UIButton *btnRefresh;
    IBOutlet UIButton *btnLike;
    IBOutlet UIButton *btnDislike;
    IBOutlet UIButton *btnPin;
    IBOutlet UIButton *btnDetail;
    IBOutlet NSLayoutConstraint *imageViewConstraint;
    IBOutlet UIView *loaderView;
    
    IBOutlet UIImageView *animationImageView;
    IBOutlet UIImageView *userImageView;
    IBOutlet UILabel *lblTraitMatch;
    IBOutlet UIActivityIndicatorView *activityIndicator;
    IBOutlet UILabel *lblTraits;
    IBOutlet UILabel *lblHeight;
    IBOutlet UILabel *lblProfession;
    IBOutlet UILabel *lblName;
    IBOutlet UILabel *lblReligion;
    NSUInteger currentIndex;
}
@property (weak, nonatomic) IBOutlet UIImageView *imgProfileView;
- (IBAction)back:(id)sender;
@end

@implementation DemoScreenVC

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

- (IBAction)back:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
