//
//  ChatPinMatchViewController.h
//  MandapTak
//
//  Created by Hussain Chhatriwala on 31/08/15.
//  Copyright (c) 2015 Walkover. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import <LayerKit/LayerKit.h>

@interface ChatPinMatchViewController : UIViewController
@property (nonatomic) LYRClient *layerClient;
@property (strong, nonatomic) PFObject *currentProfile;
@end
