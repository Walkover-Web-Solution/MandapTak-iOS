//
//  SideBarViewController.h
//  MandapTak
//
//  Created by Hussain Chhatriwala on 28/07/15.
//  Copyright (c) 2015 Walkover. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SideBarViewController : UIViewController<UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *lblUserName;
@property (weak, nonatomic) IBOutlet UIImageView *imgUser;
@property (strong, nonatomic) UIWindow *window;
@end
