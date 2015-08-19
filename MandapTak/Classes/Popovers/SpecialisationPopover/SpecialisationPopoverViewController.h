//
//  SpecialisationPopoverViewController.h
//  MandapTak
//
//  Created by Hussain Chhatriwala on 18/08/15.
//  Copyright (c) 2015 Walkover. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
@protocol SpecialisationPopoverViewControllerDelegate
-(void)selectedSpecialization:(PFObject*)industry forTag:(NSInteger)tag;
@end
@interface SpecialisationPopoverViewController : UIViewController
@property (weak, nonatomic) id <SpecialisationPopoverViewControllerDelegate> delegate;
@property (strong, nonatomic) PFObject *selectedDegree;
@property (assign, nonatomic) NSInteger btnTag;
@end
