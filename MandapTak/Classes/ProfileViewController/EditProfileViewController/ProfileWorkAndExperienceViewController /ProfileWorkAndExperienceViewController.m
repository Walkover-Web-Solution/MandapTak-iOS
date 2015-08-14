//
//  ProfileWorkAndExperienceViewController.m
//  MandapTak
//
//  Created by Hussain Chhatriwala on 14/08/15.
//  Copyright (c) 2015 Walkover. All rights reserved.
//

#import "ProfileWorkAndExperienceViewController.h"
#import "WYPopoverController.h"
#import "TextFieldTableViewCell.h"
#import "CollageToAndFromTableViewCell.h"
#import "DateOfBirthPopoverViewController.h"
@interface ProfileWorkAndExperienceViewController ()<WYPopoverControllerDelegate>{
    WYPopoverController *settingsPopoverController;
    NSInteger numberOfRowsInEducationSection;

}
@property (weak, nonatomic) IBOutlet UIButton *btn;
- (IBAction)testButtonAction:(id)sender;
@end

@implementation ProfileWorkAndExperienceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    numberOfRowsInEducationSection = 4;
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

- (IBAction)testButtonAction:(id)sender {
    
    DateOfBirthPopoverViewController *settingsViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"DateOfBirthPopoverViewController"];
    settingsViewController.preferredContentSize = CGSizeMake(320, 280);
    
    settingsViewController.title = @"Settings";
    
   // [settingsViewController.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:@"change" style:UIBarButtonItemStylePlain target:self action:@selector(change:)]];
    
    //[settingsViewController.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(close:)]];
    
    settingsViewController.modalInPopover = NO;
    
    UINavigationController *contentViewController = [[UINavigationController alloc] initWithRootViewController:settingsViewController];
    
    settingsPopoverController = [[WYPopoverController alloc] initWithContentViewController:contentViewController];
    settingsPopoverController.delegate = self;
    //settingsPopoverController.passthroughViews = @[btn];
    //settingsPopoverController.popoverLayoutMargins = UIEdgeInsetsMake(10, 10, 10, 10);
    settingsPopoverController.wantsDefaultContentAppearance = NO;
    
   // if (sender == dialogButton)
    //{
    [settingsPopoverController presentPopoverFromRect:self.btn.bounds
                                               inView:self.btn
                             permittedArrowDirections:WYPopoverArrowDirectionAny
                                             animated:YES
                                              options:WYPopoverAnimationOptionFadeWithScale];

//    }
//    else
//    {
//        [settingsPopoverController presentPopoverFromRect:btn.bounds
//                                                   inView:btn
//                                 permittedArrowDirections:WYPopoverArrowDirectionAny
//                                                 animated:YES
//                                                  options:WYPopoverAnimationOptionFadeWithScale];
//    }

}

#pragma mark UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return 4;
            break;
        case 1:
            return numberOfRowsInEducationSection;
            break;
        case 3:
            return 1;
            break;
        default:
            break;
    }
    return 0;
}



- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = @"NormalCell";
    UITableViewCell *normalCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    static NSString *cellIdentifier2 = @"TextFieldTableViewCell";
    TextFieldTableViewCell *txtFldCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier2];
    
    static NSString *cellIdentifier3 = @"CollageToAndFromTableViewCell";
    CollageToAndFromTableViewCell *clgCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier3];
    
    
    
    switch (indexPath.section) {
        case 0:
            switch (indexPath.row) {
                case 0:
                    //Normal Cell for Industry Selction
                    break;
                case 1:
                    //Text Field cell for designation
                    break;
                    
                case 2:
                    //Text Field cell for company
                    break;
                    
                case 3:
                    //Text Field cell for current incomw
                    break;
                default:
                    break;
            }
            break;
        case 1:
            switch (indexPath.row) {
                case 0:
                    // normal cell Deg sel
                    break;
                case 1:
                    //Text Field cell for collage
                    break;
                case 2:
                    //collage cell
                    break;
                case 3:
                    
                    //cell with more button
                    
                    break;
                default:
                    
                    // cell with more education field
                    break;
            }
            break;
        case 2:
            switch (indexPath.row) {
                case 0:
                    // normal cell Deg sel
                    break;
                               default:
                    break;
            }
            break;

            
            
        default:
            break;
            
    }
        return normalCell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

@end
