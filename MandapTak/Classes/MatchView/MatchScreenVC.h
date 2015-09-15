//
//  MatchScreenVC.h
//  MandapTak
//
//  Created by Anuj Jain on 9/15/15.
//  Copyright (c) 2015 Walkover. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol MatchScreenDelegate
@end

@interface MatchScreenVC : UIViewController
@property (weak, nonatomic) id <MatchScreenDelegate> delegate;
@end
