//
//  ContactsListCell.h
//  MandapTak
//
//  Created by Anuj Jain on 9/7/15.
//  Copyright (c) 2015 Walkover. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContactsListCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *lblNumber;
@property (strong, nonatomic) IBOutlet UILabel *lblInfo;
@property (strong, nonatomic) IBOutlet UILabel *lblRelation;
@property (strong, nonatomic) IBOutlet UIButton *btnDelete;

@end
