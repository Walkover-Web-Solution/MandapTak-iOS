//
//  CastePopoverViewController.h
//  MandapTak
//
//  Created by Hussain Chhatriwala on 13/08/15.
//  Copyright (c) 2015 Walkover. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
@protocol CastePopoverViewControllerDelegate
-(void)selectedCaste:(PFObject*)religion;
@end

@interface CastePopoverViewController : UIViewController
@property (weak, nonatomic) id <CastePopoverViewControllerDelegate> delegate;
@property (strong, nonatomic) NSMutableArray *arrTableData;
@property (strong, nonatomic) PFObject *religionObj;
@end
