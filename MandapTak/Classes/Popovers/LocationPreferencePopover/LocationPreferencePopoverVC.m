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
@property (strong, nonatomic) NSMutableArray *arrTableData;
@end

@implementation LocationPreferencePopoverVC
@synthesize arrSelectedData;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.arrTableData = [NSMutableArray array];
    arrLocData = [[NSMutableArray alloc] init];
    self.searchBar.delegate = self;
    [self loadMore];
    
    [_tableView setDragDelegate:self refreshDatePermanentKey:@"FriendList"];
    
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
    [query whereKey:@"name" matchesRegex:[NSString stringWithFormat:@"(?i)%@",searchText]];
    //[query whereKey:@"name" hasPrefix:searchBar.text];
    [query includeKey:@"Parent.Parent"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *comments, NSError *error)
     {
         [MBProgressHUD hideHUDForView:self.view animated:YES];
         
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
    cell.textLabel.font = [UIFont fontWithName:@"MYRIADPRO-REGULAR" size:16];
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

#pragma mark Load More Method
-(void)loadMore{
    MBProgressHUD * hud;
    hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    PFQuery *query = [PFQuery queryWithClassName:@"City" ];
    query.skip = self.arrTableData.count;
    query.limit = 20;
    query.cachePolicy = kPFCachePolicyCacheThenNetwork;
    if(isSearching){
        
        NSString *searchText = [NSString stringWithFormat:@"%@",self.searchBar.text];
        [query whereKey:@"name" matchesRegex:[NSString stringWithFormat:@"(?i)%@",searchText]];
    }
    [query includeKey:@"Parent.Parent"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *comments, NSError *error) {
        if(!error){
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            if(comments.count<20)
                [_tableView setDragDelegate:nil refreshDatePermanentKey:@"FriendList"];
            else
                [_tableView setDragDelegate:self refreshDatePermanentKey:@"FriendList"];
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
            [self.tableView reloadData];
        }
    }];
    [self.tableView finishLoadMore];
    
}

#pragma mark - Drag delegate methods
- (void)dragTableLoadMoreCanceled:(UITableView *)tableView
{
    //cancel load more request(generally network request) here
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(loadMore) object:nil];
}
- (void)dragTableDidTriggerLoadMore:(UITableView *)tableView
{
    //send load more request(generally network request) here
    
    [self performSelector:@selector(loadMore) withObject:nil afterDelay:0];
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
