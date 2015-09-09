//
//  DegreePopoverForProfileViewController.m
//  MandapTak
//
//  Created by Hussain Chhatriwala on 17/08/15.
//  Copyright (c) 2015 Walkover. All rights reserved.
//

#import "DegreePopoverForProfileViewController.h"
#import <Parse/Parse.h>
#import "MBProgressHUD.h"
#import "UITableView+DragLoad.h"
#import "Education.h"
@interface DegreePopoverForProfileViewController ()<UITableViewDragLoadDelegate>{
    BOOL isDegreeSelected;
    BOOL isSearching;
    NSTimer *timer;
    NSInteger currentTime;

}
@property (strong, nonatomic) NSMutableArray *arrTableData;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@end

@implementation DegreePopoverForProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.arrTableData = [NSMutableArray array];
    [self loadMore];
    [_tableView setDragDelegate:self refreshDatePermanentKey:@"FriendList"];
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
    PFQuery *query = [PFQuery queryWithClassName:@"Degree"];
  //  [query whereKey:@"casteId" equalTo:self.casteObj];
    [query whereKey:@"name" matchesRegex:[NSString stringWithFormat:@"(?i)%@",searchBar.text]];
    [query findObjectsInBackgroundWithBlock:^(NSArray *comments, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        self.arrTableData = comments.mutableCopy;
        for(Education *education in self.arrEducation){
            for(PFObject *deg in self.arrTableData){
                if([[deg valueForKey:@"objectId"] isEqual:[education.degree valueForKey:@"objectId"]]){
                    [self.arrTableData removeObject:deg];
                    break;
                }
            }
        }
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
    [self.delegate selectedDegree:self.arrTableData[indexPath.row] forTag:self.btnTag];
    
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    NSLog(@"Will begin dragging");
    [self.searchBar resignFirstResponder];
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
    PFQuery *query = [PFQuery queryWithClassName:@"Degree"];
    //  [query whereKey:@"casteId" equalTo:self.casteObj];
    if(isSearching)
        [query whereKey:@"name" matchesRegex:[NSString stringWithFormat:@"(?i)%@",self.searchBar.text]];
    query.skip = self.arrTableData.count;
    query.limit = 20;
    query.cachePolicy = kPFCachePolicyCacheElseNetwork;

    [query findObjectsInBackgroundWithBlock:^(NSArray *comments, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if(comments.count<20)
            [_tableView setDragDelegate:nil refreshDatePermanentKey:@"FriendList"];
        
        self.arrTableData = [NSMutableArray arrayWithArray:[self.arrTableData arrayByAddingObjectsFromArray:comments]];
        [self.tableView reloadData];
        for(Education *education in self.arrEducation){
            for(PFObject *deg in self.arrTableData){
                if([[deg valueForKey:@"objectId"] isEqual:[education.degree valueForKey:@"objectId"]]){
                    [self.arrTableData removeObject:deg];
                    break;
                }
            }
        }
        [self.tableView reloadData];
        
    }];
    
    [self.tableView finishLoadMore];
}
@end
