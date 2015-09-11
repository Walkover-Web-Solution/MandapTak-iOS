//
//  IndustryPopoverViewController.m
//  MandapTak
//
//  Created by Hussain Chhatriwala on 17/08/15.
//  Copyright (c) 2015 Walkover. All rights reserved.
//

#import "IndustryPopoverViewController.h"
#import <Parse/Parse.h>
#import "MBProgressHUD.h"
#import "UITableView+DragLoad.h"
@interface IndustryPopoverViewController ()<UITableViewDragLoadDelegate>{
    BOOL isSearching;
    NSTimer *timer;
    NSInteger currentTime;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) NSArray *arrTableData;

@end

@implementation IndustryPopoverViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.arrTableData =[NSMutableArray array];
    [_tableView setDragDelegate:self refreshDatePermanentKey:@"FriendList"];
    [self loadMore];
   
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)timerStart{
    currentTime=currentTime+1;
    if(currentTime==2){
        [timer invalidate];
        timer = nil;
        self.arrTableData = [NSMutableArray array];
        [self loadMore];
    }
}
#pragma mark SearchBarDelagate
-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    if(searchBar.text.length>0){
        isSearching = YES;
        currentTime =0;
        [timer invalidate];
        timer = nil;
        timer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(timerStart) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
        currentTime =0;
    }
    else{
        isSearching = NO;
    }
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    MBProgressHUD * hud;
    hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    PFQuery *query = [PFQuery queryWithClassName:@"Industries"];
    query.cachePolicy = kPFCachePolicyCacheElseNetwork;
    //  [query whereKey:@"casteId" equalTo:self.casteObj];
    [query whereKey:@"name" matchesRegex:[NSString stringWithFormat:@"(?i)^%@",searchBar.text]];
    [query findObjectsInBackgroundWithBlock:^(NSArray *comments, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        self.arrTableData = comments;
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
    //Location *location = self.arrTableData[indexPath.row];
    PFObject *obj = self.arrTableData[indexPath.row];
    cell.textLabel.text = [obj valueForKey:@"name"];
    //cell.textLabel.text =self.arrTableData [indexPath.row];
    
    //set font family
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.delegate selectedIndustry:self.arrTableData[indexPath.row]];
    
    
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    NSLog(@"Will begin dragging");
    [self.searchBar resignFirstResponder];
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // check if indexPath.row is last row
    // Perform operation to load new Cell's.
    if(indexPath.row ==self.arrTableData.count-1){
        [self loadMore];
    }
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
    PFQuery *query = [PFQuery queryWithClassName:@"Industries"];
    query.skip = self.arrTableData.count;
    query.cachePolicy = kPFCachePolicyCacheElseNetwork;
    query.limit = 20;
    if(isSearching)
        [query whereKey:@"name" matchesRegex:[NSString stringWithFormat:@"(?i)^%@",self.searchBar.text]];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *comments, NSError *error) {
        if(!error){
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            NSMutableArray *arrFetchedItems =comments.mutableCopy;
            for(PFObject *tempObj in comments){
                for(PFObject *obj in self.arrTableData){
                    if([[tempObj valueForKey:@"name" ] isEqual:[obj valueForKey:@"name" ]]){
                        [arrFetchedItems removeObject:tempObj];
                        break;
                    }
                }
            }
            if(comments.count<20)
                [_tableView setDragDelegate:nil refreshDatePermanentKey:@"FriendList"];
            else
                [_tableView setDragDelegate:self refreshDatePermanentKey:@"FriendList"];

            self.arrTableData = [NSMutableArray arrayWithArray:[self.arrTableData arrayByAddingObjectsFromArray:comments]];
            [self.tableView reloadData];
        }
    }];
    [self.tableView finishLoadMore];
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
