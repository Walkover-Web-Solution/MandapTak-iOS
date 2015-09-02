//
//  MatchAndPinTableViewCell.h
//  MandapTak
//
//  Created by Hussain Chhatriwala on 01/09/15.
//  Copyright (c) 2015 Walkover. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MatchAndPinTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgProfile;
@property (weak, nonatomic) IBOutlet UILabel *lblDesignation;
@property (weak, nonatomic) IBOutlet UILabel *lblReligion;
@property (weak, nonatomic) IBOutlet UIButton *btnPinOrMatch;
@property (weak, nonatomic) IBOutlet UILabel *lblName;

@end
