//
//  LocationPreferencePopoverVC.h
//  MandapTak
//
//  Created by Anuj Jain on 8/14/15.
//  Copyright (c) 2015 Walkover. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Location.h"
#import <Parse/Parse.h>
#import "UITableView+DragLoad.h"

@protocol LocationPreferencePopoverVCDelegate
-(void)selectedLocation:(Location*)location andUpdateFlag:(BOOL)flag;
@end
@interface LocationPreferencePopoverVC : UIViewController<UISearchBarDelegate,UITableViewDragLoadDelegate,UITableViewDelegate>
{
    NSMutableArray *arrLocData;
    BOOL isSearching;
}
@property (weak, nonatomic) id <LocationPreferencePopoverVCDelegate> delegate;
@property (strong, nonatomic) NSArray *arrSelectedData;
@end
