//
//  WorkAfterMarriagePopoverViewController.h
//  MandapTak
//
//  Created by Hussain Chhatriwala on 17/08/15.
//  Copyright (c) 2015 Walkover. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol WorkAfterMarriagePopoverViewControllerDelegate
-(void)selectedMarraigeType:(NSString*)marraigeType ;
@end

@interface WorkAfterMarriagePopoverViewController : UIViewController
@property (weak, nonatomic) id <WorkAfterMarriagePopoverViewControllerDelegate> delegate;

@end
