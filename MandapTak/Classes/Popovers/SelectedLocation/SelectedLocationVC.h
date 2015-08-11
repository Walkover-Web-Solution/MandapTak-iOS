//
//  SelectedLocationVC.h
//  MandapTak
//
//  Created by Anuj Jain on 8/7/15.
//  Copyright (c) 2015 Walkover. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol SelectedLocationVCDelegate
- (void)showSelLocations: (NSArray *)arrLocation;
@end
@interface SelectedLocationVC : UIViewController <UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) id <SelectedLocationVCDelegate> delegate;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) NSMutableArray *arrTableData;
- (IBAction)saveAction:(id)sender;
@end
