//
//  MatchScreenVC.h
//  MandapTak
//
//  Created by Anuj Jain on 9/15/15.
//  Copyright (c) 2015 Walkover. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Profile.h"
#import <LayerKit/LayerKit.h>
@protocol MatchScreenDelegate
@end

@interface MatchScreenVC : UIViewController
@property (weak, nonatomic) id <MatchScreenDelegate> delegate;
@property (strong,nonatomic) Profile *profileObj;
@property (strong,nonatomic) NSString *txtTraits;
@property (nonatomic) LYRClient *layerClient;
@property (strong, nonatomic) PFObject *currentProfile;

@end
