//
//  MultiSelectController.m
//  MultiSelectControl
//
//  Created by Darshan Patel on 7/3/15.
//  Copyright (c) 2015 Darshan Patel. All rights reserved.
//
//  The MIT License (MIT)
//
//  Copyright (c) 2015 Darshan Patel
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

#import "MultiSelectController.h"
#import "MultiSelectCell.h"
#import "MultiSelectFlowLayout.h"
#import <Parse/Parse.h>
#import "Location.h"

@interface MultiSelectController ()<UICollectionViewDataSource,UICollectionViewDelegate,UITableViewDataSource,UITableViewDelegate,MultiSelectDelegate>
{
    NSMutableArray *arrLocData;
}
@property (nonatomic,strong) NSMutableArray *arrSelected;
@end

@implementation MultiSelectController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];

    self.automaticallyAdjustsScrollViewInsets = NO;
    self.arrSelected = [[NSMutableArray alloc] init];
    self.arrTableData = [NSMutableArray array];
    
    if (!self.multiSelectCellBackgroundColor) {

        self.multiSelectCellBackgroundColor = [UIColor colorWithRed:52.0/255.0 green:152.0/255.0 blue:219.0/255.0 alpha:1.0];
    }

    if (!self.tableTextColor) {

        self.tableTextColor = [UIColor blackColor];

    }

    if (!self.multiSelectTextColor) {

        self.multiSelectTextColor = [UIColor whiteColor];
    }
    
    //get parse city list
    //[self getCityList];
    [self getLocations];

    [self navigationBarSetup];
    [self collectionViewInitializations];
    // Do any additional setup after loading the view from its nib.
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

    [self.arrSelected removeAllObjects];
    [self.multiSelectCollectionView reloadData];

    self.delegate = nil;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)navigationBarSetup
{

    if (!self.leftButtonTextColor) {

        self.leftButtonTextColor = [UIColor blackColor];
    }


    if (!self.rightButtonTextColor) {

        self.rightButtonTextColor = [UIColor blackColor];
    }


    if (!self.rightButtonText) {

        self.rightButtonText = @"Apply";
    }


    if (!self.leftButtonText) {


        self.leftButtonText = @"Cancel";
    }

    NSDictionary * navBarTitleTextAttributes =
    @{ NSForegroundColorAttributeName : [UIColor blackColor],
       NSFontAttributeName            : [UIFont systemFontOfSize:16.0] };

    self.navigationController.navigationBar.titleTextAttributes = navBarTitleTextAttributes;

    self.navigationItem.title = @"Select";
    [self.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];


    UIBarButtonItem *spacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    spacer.width = -10; // for example shift right bar button to the right


    UIButton *btnCancel =[UIButton buttonWithType:UIButtonTypeCustom];
    btnCancel.frame= CGRectMake(0, 0, 70, 32);
    [btnCancel setTitle:self.leftButtonText forState:UIControlStateNormal];
    [btnCancel setTitleColor:self.leftButtonTextColor forState:UIControlStateNormal];
    [btnCancel addTarget:self action:@selector(btnCancelTapped:) forControlEvents:UIControlEventTouchUpInside];


    UIBarButtonItem *barCancel =[[UIBarButtonItem alloc] initWithCustomView:btnCancel];
    self.navigationItem.leftBarButtonItems = @[spacer,barCancel];


    UIBarButtonItem *spacera = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    spacera.width = -15; // for example shift right bar button to the right

    UIButton *btnApply =[UIButton buttonWithType:UIButtonTypeCustom];
    btnApply.frame= CGRectMake(0, 0, 70, 32);
    [btnApply setTitle:self.rightButtonText forState:UIControlStateNormal];
    [btnApply setTitleColor:self.rightButtonTextColor forState:UIControlStateNormal];
    [btnApply addTarget:self action:@selector(btnApplyTapped:) forControlEvents:UIControlEventTouchUpInside];



    UIBarButtonItem *barApply =[[UIBarButtonItem alloc] initWithCustomView:btnApply];
    self.navigationItem.rightBarButtonItems = @[spacera,barApply];





}
-(void)collectionViewInitializations
{
    MultiSelectFlowLayout *flowLayout = [[MultiSelectFlowLayout alloc] init];
    [flowLayout setItemSize:CGSizeMake(100, 30)];
    [flowLayout setSectionInset:UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0)];
    [flowLayout setMinimumLineSpacing:0.0];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    [self.multiSelectCollectionView setCollectionViewLayout:flowLayout];

   // [self.multiSelectCollectionView registerClass:[MultiSelectCell class] forCellWithReuseIdentifier:@"MultiSelectCell"];

}
-(void)updateViewConstraints
{
    [super updateViewConstraints];

    if ([self.arrSelected count]!=0) {

        self.topLayoutConstraint.constant = 68;

    }else
    {
        self.topLayoutConstraint.constant = 0;
    }

}
-(void) getLocations
{
    PFQuery *query = [PFQuery queryWithClassName:@"City" ];
    //query.skip = self.arrTableData.count;
    query.limit = 10000;
    query.cachePolicy = kPFCachePolicyCacheThenNetwork;
    [query includeKey:@"Parent.Parent"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *comments, NSError *error) {
        if(!error){
            NSMutableArray *arrFetchedItems =comments.mutableCopy;
            for(PFObject *tempObj in arrFetchedItems){
                for(Location *obj in self.arrTableData){
                    if([obj.placeId isEqual:[tempObj valueForKey:@"objectId"]]){
                        [arrFetchedItems removeObject:tempObj];
                        break;
                    }
                }
            }
            for(PFObject *obj in arrFetchedItems)
            {
                Location *location = [[Location alloc]init];
                PFObject *parent = [obj valueForKey:@"Parent"];
                location.city = [obj valueForKey:@"name"];
                location.cityPointer = obj;
                location.placeId = [obj valueForKey:@"objectId"];
                location.state = [parent valueForKey:@"name"];
                PFObject *subParent = [parent valueForKey:@"Parent"];
                location.country = [subParent valueForKey:@"name"];
                location.descriptions = [NSString stringWithFormat:@"%@, %@, %@",[obj valueForKey:@"name"],[parent valueForKey:@"name"],[subParent valueForKey:@"name"]];
                [self.arrTableData addObject:location];
            }
            
            //sort array alphabetically
            //1
            /*
            NSSortDescriptor * frequencyDescriptor = [[NSSortDescriptor alloc] initWithKey:@"descriptions" ascending:YES];
            
            id obj;
            NSEnumerator * enumerator = [self.arrTableData objectEnumerator];
            while ((obj = [enumerator nextObject])) NSLog(@"%@", obj);
            
            NSArray * descriptors = [NSArray arrayWithObjects:frequencyDescriptor, nil];
            NSArray * sortedArray = [self.arrTableData sortedArrayUsingDescriptors:descriptors];
            
            NSLog(@"\nSorted ...");
            
            enumerator = [sortedArray objectEnumerator];
            while ((obj = [enumerator nextObject])) NSLog(@"%@", obj);
            */
            
            //2
            NSSortDescriptor *lastDescriptor = [[NSSortDescriptor alloc] initWithKey:@"descriptions" ascending:YES selector:@selector(localizedCaseInsensitiveCompare:)];
            
            NSArray * descriptors = [NSArray arrayWithObjects:lastDescriptor, nil];
            NSArray * sortedArray = [self.arrTableData sortedArrayUsingDescriptors:descriptors];
            
            self.arrTableData = [sortedArray mutableCopy] ;
            for (Location *obj in self.arrTableData) {
                NSLog(@"%@",obj.descriptions);
            }
            [self.tblOptions reloadData];
        }
    }];
}

#pragma mark City List Query
- (void) getCityList
{
    PFQuery *query = [PFQuery queryWithClassName:@"City" ];
    //[query whereKey:@"name" matchesRegex:[NSString stringWithFormat:@"(?i)%@",searchText]];
    //[query whereKey:@"name" hasPrefix:searchBar.text];
    [query includeKey:@"Parent.Parent"];
    [query orderByAscending:@"name"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *comments, NSError *error)
     {
         //[MBProgressHUD hideHUDForView:self.view animated:YES];
         
         //NSMutableArray *arrLocData = [NSMutableArray array];
         for(PFObject *obj in comments)
         {
             Location *location = [[Location alloc]init];
             NSLog(@"cityName %@",[obj valueForKey:@"name"]);
             PFObject *parent = [obj valueForKey:@"Parent"];
             location.city = [obj valueForKey:@"name"];
             location.cityPointer = obj;
             NSString *strClass =  obj.parseClassName;
             NSLog(@"class name = %@",strClass);
             location.placeId = [obj valueForKey:@"objectId"];
             NSLog(@"placeId ---- %@",[parent valueForKey:@"objectId"]);
             NSLog(@"StateName %@",[parent valueForKey:@"name"]);
             location.state = [parent valueForKey:@"name"];
             
             PFObject *subParent = [parent valueForKey:@"Parent"];
             NSLog(@"CountryName %@",[subParent valueForKey:@"name"]);
             location.country = [subParent valueForKey:@"name"];
             location.descriptions = [NSString stringWithFormat:@"%@, %@, %@",[obj valueForKey:@"name"],[parent valueForKey:@"name"],[subParent valueForKey:@"name"]];
             [arrLocData addObject:location];
             
         }
         [self getStateList];
         self.arrTableData = arrLocData;
         //[self.tblOptions reloadData];
         
     }];
}


#pragma mark State List Query
- (void) getStateList
{
    PFQuery *query = [PFQuery queryWithClassName:@"State" ];
    //[query whereKey:@"name" matchesRegex:[NSString stringWithFormat:@"(?i)^%@",searchText]];
    //[query whereKey:@"name" hasPrefix:searchBar.text];
    [query includeKey:@"Parent.Parent"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *stateObjects, NSError *error)
     {
         //[MBProgressHUD hideHUDForView:self.view animated:YES];
         
         //NSMutableArray *arrLocData = [NSMutableArray array];
         for(PFObject *obj in stateObjects){
             Location *location = [[Location alloc]init];
             NSLog(@"2 state name %@",[obj valueForKey:@"name"]);
             PFObject *parentCountry = [obj valueForKey:@"Parent"];
             location.state = [obj valueForKey:@"name"];
             location.cityPointer = obj;
             NSString *strClass =  obj.parseClassName;
             NSLog(@"class name = %@",strClass);
             location.placeId = [obj valueForKey:@"objectId"];
             NSLog(@"placeId ---- %@",[parentCountry valueForKey:@"objectId"]);
             NSLog(@"Country Name %@",[parentCountry valueForKey:@"name"]);
             location.country = [parentCountry valueForKey:@"name"];
             
             //PFObject *subParent = [parent valueForKey:@"Parent"];
             //NSLog(@"CountryName %@",[subParent valueForKey:@"name"]);
             //location.country = [subParent valueForKey:@"name"];
             location.descriptions = [NSString stringWithFormat:@"%@, %@",[obj valueForKey:@"name"],[parentCountry valueForKey:@"name"]];
             [arrLocData addObject:location];
         }
         self.arrTableData = arrLocData;
         [self.tblOptions reloadData];
     }];
}


#pragma mark UITableView Data Source
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"data list = > %lu",self.arrTableData.count);
    return self.arrTableData.count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
/*
- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return [self.arrOptions count];
}
*/
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] ;
    }
    Location *location = self.arrTableData[indexPath.row];
    cell.textLabel.text = location.descriptions;
    cell.textLabel.textColor = self.tableTextColor;
    cell.backgroundColor = [UIColor clearColor];
    cell.tintColor = self.multiSelectCellBackgroundColor;
    
    if ([self.arrSelected containsObject:location.descriptions]) {

        cell.accessoryType = UITableViewCellAccessoryCheckmark;

    }else
    {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    return cell;
    
    /*
     static NSString *cellIdentifier = @"PinLogsCell";
     UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:cellIdentifier];
     
     if (!cell) {
     cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
     [cell setBackgroundColor:[UIColor clearColor]];
     cell.textLabel.textColor = [UIColor darkGrayColor];
     }
     Location *location = self.arrTableData[indexPath.row];
     cell.textLabel.text = location.descriptions;
     
     //disable already selected location
     if ([arrSelectedData containsObject:location.placeId])
     {
     cell.userInteractionEnabled = NO;
     cell.accessoryType = UITableViewCellAccessoryCheckmark;
     }
     else
     {
     cell.userInteractionEnabled = YES;
     cell.accessoryType = UITableViewCellAccessoryNone;
     }
     cell.textLabel.font = [UIFont fontWithName:@"MYRIADPRO-REGULAR" size:16];
     return cell;
     */
    
    /*
     //new code
     UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
     if (cell == nil) {
     cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] ;
     }
     
     Location *location = self.arrTableData[indexPath.row];
     cell.textLabel.text = location.descriptions;
     cell.textLabel.textColor = self.tableTextColor;
     cell.backgroundColor = [UIColor clearColor];
     cell.tintColor = self.multiSelectCellBackgroundColor;
     cell.textLabel.font = [UIFont fontWithName:@"MYRIADPRO-REGULAR" size:16];
     
     if ([self.arrSelected containsObject:self.arrTableData[indexPath.row]]) {
     
     cell.accessoryType = UITableViewCellAccessoryCheckmark;
     
     }else
     {
     cell.accessoryType = UITableViewCellAccessoryNone;
     }
     return cell;
     */
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell=[tableView cellForRowAtIndexPath:indexPath];
    Location *location = self.arrTableData[indexPath.row];
    cell.textLabel.text = location.descriptions;
    if (cell.accessoryType == UITableViewCellAccessoryCheckmark) {

        cell.accessoryType = UITableViewCellAccessoryNone;

        [self.arrSelected removeObject:location.descriptions];
        [self.multiSelectCollectionView reloadData];
        [self.view setNeedsUpdateConstraints];


    }else
    {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;

        [self.arrSelected addObject:location.descriptions];
        [self.multiSelectCollectionView reloadData];

        [self.view setNeedsUpdateConstraints];

    }

}
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{

    return [self.arrSelected count];
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{

    MultiSelectCell *cell = (MultiSelectCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"MultiSelectCell" forIndexPath:indexPath];
    cell.delegate =self;
    cell.lblText.text = [self.arrSelected objectAtIndex:indexPath.row];
    cell.lblText.textColor = self.multiSelectTextColor;
    cell.layer.cornerRadius = 3.0;
    cell.backgroundColor = self.multiSelectCellBackgroundColor;
    return cell;

}
- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    ((MultiSelectCell*)cell).delegate = nil;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{

    CGRect textRect = [[self.arrSelected objectAtIndex:indexPath.row]
                       boundingRectWithSize:CGSizeMake(320, 30)
                       options:NSStringDrawingUsesLineFragmentOrigin
                       attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.0]}

                       context:nil];

    return CGSizeMake(textRect.size.width+32, 30);

}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 4;
}


-(void)didCancelClicked:(NSString *)text
{
    [self.arrSelected removeObject:text];
    [self.multiSelectCollectionView reloadData];
    [self.tblOptions reloadData];
    [self.view setNeedsUpdateConstraints];

}

-(IBAction)btnCancelTapped:(id)sender
{
    [self.navigationController dismissViewControllerAnimated:YES completion:^{

        if ([self.delegate respondsToSelector:@selector(multiSelectControllerDidCancel:)]) {

            [self.delegate multiSelectControllerDidCancel:self];
        }
    }];
}
-(IBAction)btnApplyTapped:(id)sender
{
    [self.navigationController dismissViewControllerAnimated:YES completion:^{

        if ([self.delegate respondsToSelector:@selector(multiSelectController:didFinishPickingSelections:)]) {

            [self.delegate multiSelectController:self didFinishPickingSelections:self.arrSelected];

        }
    }];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
