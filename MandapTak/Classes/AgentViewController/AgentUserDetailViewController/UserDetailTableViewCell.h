//
//  UserDetailTableViewCell.h
//  MandapTak
//
//  Created by Hussain Chhatriwala on 09/11/15.
//  Copyright © 2015 Walkover. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserDetailTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lblUserNumber;
@property (weak, nonatomic) IBOutlet UILabel *lblRelation;
@property (weak, nonatomic) IBOutlet UIButton *btnEdit;
@property (weak, nonatomic) IBOutlet UILabel *lblCreatedAt;

@end
