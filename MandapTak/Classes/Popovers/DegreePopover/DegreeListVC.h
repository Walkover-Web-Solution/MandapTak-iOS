//
//  DegreeListVC.h
//  MandapTak
//
//  Created by Anuj Jain on 8/8/15.
//  Copyright (c) 2015 Walkover. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Degree.h"

@protocol DegreeListVCDelegate
- (void)showSelDegree: (NSArray *)arrSelDegree;
@end
@interface DegreeListVC : UIViewController<UISearchBarDelegate,UITextFieldDelegate>
{
    IBOutlet UITableView *tableViewDegree;
    NSArray *arrDegreeId,*arrDegreeName;
    NSMutableArray *arrTableData,*arrSelDegreeId,*arrNewSelection;
    Degree *globalDegreeObj;
}
@property (weak, nonatomic) id <DegreeListVCDelegate> delegate;
@property (weak, nonatomic) NSMutableArray *arrSelDegree;
- (IBAction)saveAction:(id)sender;
@property (strong, nonatomic) NSMutableArray* filteredTableData;

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (nonatomic, assign) bool isFiltered;
@end
