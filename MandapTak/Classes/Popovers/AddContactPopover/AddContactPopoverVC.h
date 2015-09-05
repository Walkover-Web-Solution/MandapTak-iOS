//
//  AddContactPopoverVC.h
//  MandapTak
//
//  Created by Anuj Jain on 9/5/15.
//  Copyright (c) 2015 Walkover. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol AddContactVCDelegate
- (void)showSelectedContacts: (NSArray *)arrSelNumbers;
@end

@interface AddContactPopoverVC : UIViewController
@property (weak, nonatomic) id <AddContactVCDelegate> delegate;
@end
