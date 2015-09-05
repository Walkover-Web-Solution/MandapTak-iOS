//
//  CastePopoverViewController.m
//  MandapTak
//
//  Created by Hussain Chhatriwala on 13/08/15.
//  Copyright (c) 2015 Walkover. All rights reserved.
//

#import "CastePopoverViewController.h"
#import "MBProgressHUD.h"
#import "UITableView+DragLoad.h"
@interface CastePopoverViewController ()<UITableViewDragLoadDelegate>{
    BOOL isSearching;

}
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation CastePopoverViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"%@",self.arrTableData);
    [_tableView setDragDelegate:self refreshDatePermanentKey:@"FriendList"];
    self.arrTableData =[NSMutableArray array];
    [self loadMore];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark SearchBarDelagate
-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    if(searchBar.text.length>0){
        isSearching = YES;
    }
    else{
        isSearching = NO;
    }
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    
    MBProgressHUD * hud;
    hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    PFQuery *query = [PFQuery queryWithClassName:@"Caste"];
    [query whereKey:@"religionId" equalTo:self.religionObj];
    [query whereKey:@"name" matchesRegex:[NSString stringWithFormat:@"(?i)^%@",searchBar.text]];
    [query findObjectsInBackgroundWithBlock:^(NSArray *comments, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        self.arrTableData = comments.mutableCopy;
        [self.tableView reloadData];
        
    }];
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
    //Location *location = self.arrTableData[indexPath.row];
    PFObject *obj = self.arrTableData[indexPath.row];
    cell.textLabel.text = [obj valueForKey:@"name"];
    //set font family
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.delegate selectedCaste:self.arrTableData[indexPath.row]];
    
    
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

-(void)loadMore{
    
    
    MBProgressHUD * hud;
    hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    PFQuery *query = [PFQuery queryWithClassName:@"Caste"];
    query.skip = self.arrTableData.count;
    query.limit = 20;
    if(isSearching)
        [query whereKey:@"name" matchesRegex:[NSString stringWithFormat:@"(?i)^%@",self.searchBar.text]];
    
    [query whereKey:@"religionId" equalTo:self.religionObj];
    [query whereKey:@"name" matchesRegex:[NSString stringWithFormat:@"(?i)^%@",self.searchBar.text]];
    [query findObjectsInBackgroundWithBlock:^(NSArray *comments, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        self.arrTableData = [NSMutableArray arrayWithArray:[self.arrTableData arrayByAddingObjectsFromArray:comments]];
        if(comments.count<20)
            [_tableView setDragDelegate:nil refreshDatePermanentKey:@"FriendList"];

        [self.tableView reloadData];
        
    }];
    [self.tableView finishLoadMore];
}

@end
