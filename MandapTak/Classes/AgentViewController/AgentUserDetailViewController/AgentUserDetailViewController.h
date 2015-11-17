//
//  AgentUserDetailViewController.h
//  MandapTak
//
//  Created by Hussain Chhatriwala on 09/11/15.
//  Copyright © 2015 Walkover. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
@interface AgentUserDetailViewController : UIViewController
@property (strong, nonatomic) PFObject *userProfile;
@end
