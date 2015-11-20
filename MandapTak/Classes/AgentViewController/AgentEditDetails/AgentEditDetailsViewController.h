//
//  AgentEditDetailsViewController.h
//  MandapTak
//
//  Created by Hussain Chhatriwala on 16/11/15.
//  Copyright © 2015 Walkover. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
@interface AgentEditDetailsViewController : UIViewController
@property (strong, nonatomic) PFObject *userProfile;
@property (strong, nonatomic) NSString *optionType;
@property (assign, nonatomic) NSInteger btnTag;
@property (assign, nonatomic) BOOL containBachelor;;

@end
