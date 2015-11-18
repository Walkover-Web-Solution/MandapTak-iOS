//
//  ReportAbuseVC.h
//  MandapTak
//
//  Created by Anuj Jain on 11/17/15.
//  Copyright © 2015 Walkover. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol ReportAbuseVCDelegate
-(void)closePopover;
@end
@interface ReportAbuseVC : UIViewController
@property (weak, nonatomic) id <ReportAbuseVCDelegate> delegate;
@property (weak, nonatomic) NSString *reportedProfile;
@end
