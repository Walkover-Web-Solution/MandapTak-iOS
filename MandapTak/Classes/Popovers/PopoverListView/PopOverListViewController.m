//
//  PopOverListViewController.m
//  MandapTak
//
//  Created by Hussain Chhatriwala on 04/08/15.
//  Copyright (c) 2015 Walkover. All rights reserved.
//

#import "PopOverListViewController.h"
#import "ServiceManager.h"
#import "MBProgressHUD.h"
#import "Location.h"
@interface PopOverListViewController ()
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *arrTableData;
@end

@implementation PopOverListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.arrTableData = [NSArray array];
    // Do any additional setup after loading the view.
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
    MBProgressHUD * hud;
    hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    PFQuery *query = [PFQuery queryWithClassName:@"City" ];
    
    [query whereKey:@"name" matchesRegex:[NSString stringWithFormat:@"(?i)^%@",searchBar.text]];
  //  [query whereKey:@"name" hasPrefix:searchBar.text];
    [query includeKey:@"Parent.Parent"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *comments, NSError *error) {
        NSMutableArray *arrLocData = [NSMutableArray array];
        for(PFObject *obj in comments){
            [MBProgressHUD hideHUDForView:self.view animated:YES];

            Location *location = [[Location alloc]init];
            NSLog(@"cityName %@",[obj valueForKey:@"name"]);
            PFObject *parent = [obj valueForKey:@"Parent"];
            location.city = [obj valueForKey:@"name"];
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
        self.arrTableData = arrLocData;
        [self.tableView reloadData];
        
    }];
    
    [searchBar resignFirstResponder];
    // Do the search...
}

#pragma mark UITableView Data Source

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
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

    //set font family
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.delegate selectedLocation:self.arrTableData[indexPath.row]];
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
