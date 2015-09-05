//
//  SettingsVC.m
//  MandapTak
//
//  Created by Anuj Jain on 9/5/15.
//  Copyright (c) 2015 Walkover. All rights reserved.
//

#import "SettingsVC.h"
#import "AddContactPopoverVC.h"
#import "WYStoryboardPopoverSegue.h"
#import "WYPopoverController.h"

@interface SettingsVC ()<WYPopoverControllerDelegate,UITableViewDataSource,UITableViewDelegate>
{
    WYPopoverController* popoverController;
}
@end

@implementation SettingsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    //Degree View
    if ([segue.identifier isEqualToString:@"AddContactIdentifier"])
    {
        //isSelectingCurrentLocation = YES;
        AddContactPopoverVC *controller = segue.destinationViewController;
        controller.contentSizeForViewInPopover = CGSizeMake(310, 250);
        WYStoryboardPopoverSegue* popoverSegue = (WYStoryboardPopoverSegue*)segue;
        popoverController = [popoverSegue popoverControllerWithSender:sender
                                             permittedArrowDirections:WYPopoverArrowDirectionAny
                                                             animated:YES];
        popoverController.popoverLayoutMargins = UIEdgeInsetsMake(4, 4, 4, 4);
        popoverController.delegate = self;
        controller.delegate = self;
        
    }
}

- (IBAction)backAction:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   return 4;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"PinLogsCell";
    UITableViewCell *cell = [tableViewContacts dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (!cell) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    cell.textLabel.text = @"contact";
    
    return cell;
}

#pragma mark Popover Methods
- (void)showSelectedContacts: (NSArray *)arrSelNumbers
{
    [popoverController dismissPopoverAnimated:YES];

}
@end
