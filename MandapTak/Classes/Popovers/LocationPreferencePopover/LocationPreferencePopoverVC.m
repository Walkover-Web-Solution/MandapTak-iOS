//
//  LocationPreferencePopoverVC.m
//  MandapTak
//
//  Created by Anuj Jain on 8/14/15.
//  Copyright (c) 2015 Walkover. All rights reserved.
//

#import "LocationPreferencePopoverVC.h"
#import "ServiceManager.h"
#import "MBProgressHUD.h"
#import "Location.h"

@interface LocationPreferencePopoverVC ()
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *arrTableData;
@end

@implementation LocationPreferencePopoverVC
@synthesize arrSelectedData;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.arrTableData = [NSArray array];
    arrLocData = [[NSMutableArray alloc] init];
    self.searchBar.delegate = self;
    // Do any additional setup after loading the view.
}
-(void)viewDidAppear:(BOOL)animated{
    [self.searchBar becomeFirstResponder];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark SearchBarDelagate
-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [arrLocData removeAllObjects];
    [self.tableView reloadData];
    
    MBProgressHUD * hud;
    hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [self getCityList:searchBar.text];
    
    [searchBar resignFirstResponder];
    // Do the search...
}

#pragma mark City List Query
- (void) getCityList:(NSString *)searchText
{
    PFQuery *query = [PFQuery queryWithClassName:@"City" ];
    [query whereKey:@"name" matchesRegex:[NSString stringWithFormat:@"(?i)^%@",searchText]];
    //[query whereKey:@"name" hasPrefix:searchBar.text];
    [query includeKey:@"Parent.Parent"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *comments, NSError *error)
     {
         [MBProgressHUD hideHUDForView:self.view animated:YES];
         
         //NSMutableArray *arrLocData = [NSMutableArray array];
         for(PFObject *obj in comments){
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
         [self getStateList:searchText];
         self.arrTableData = arrLocData;
         //[self.tableView reloadData];
         
     }];
}


#pragma mark State List Query
- (void) getStateList:(NSString *)searchText
{
    PFQuery *query = [PFQuery queryWithClassName:@"State" ];
    [query whereKey:@"name" matchesRegex:[NSString stringWithFormat:@"(?i)^%@",searchText]];
    //[query whereKey:@"name" hasPrefix:searchBar.text];
    [query includeKey:@"Parent.Parent"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *stateObjects, NSError *error)
     {
         [MBProgressHUD hideHUDForView:self.view animated:YES];
         
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
         [self.tableView reloadData];
     }];
}


#pragma mark UITableView Data Source
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"data list = > %@",self.arrTableData);
    return self.arrTableData.count;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
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
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.delegate selectedLocation:self.arrTableData[indexPath.row] andUpdateFlag:YES];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
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
