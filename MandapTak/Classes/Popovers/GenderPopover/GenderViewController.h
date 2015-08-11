//
//  GenderViewController.h
//  MandapTak
//
//  Created by Hussain Chhatriwala on 04/08/15.
//  Copyright (c) 2015 Walkover. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol GenderViewControllerDelegate
-(void)selectedGender:(NSString*)gender;
@end
@interface GenderViewController : UIViewController
@property (weak, nonatomic) id <GenderViewControllerDelegate> delegate;
@end
