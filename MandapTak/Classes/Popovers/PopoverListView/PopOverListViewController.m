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
#import "UITableView+DragLoad.h"

@interface PopOverListViewController ()<UITableViewDragLoadDelegate,UISearchBarDelegate>{
    BOOL isSearching;
    NSTimer *timer;
    NSInteger currentTime;

}
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *arrTableData;
- (IBAction)closeButtonAction:(id)sender;

@end

@implementation PopOverListViewController
@synthesize arrSelectedData;
- (void)viewDidLoad {
    [super viewDidLoad];
    isSearching = NO;
    self.arrTableData = [NSMutableArray array];
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

- (BOOL)textField:(UITextField *)textField
shouldChangeCharactersInRange:(NSRange)range
replacementString:(NSString *)string {
    return true;
}
-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    MBProgressHUD * hud;
    hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    PFQuery *query = [PFQuery queryWithClassName:@"City" ];
    query.limit = 20;
    [query whereKey:@"name" matchesRegex:[NSString stringWithFormat:@"(?i)%@",searchBar.text]];
    [query includeKey:@"Parent.Parent"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *comments, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        self.arrTableData = [NSMutableArray array];
        NSMutableArray *arrLocData = [NSMutableArray array];
        for(PFObject *obj in comments){
            Location *location = [[Location alloc]init];
            PFObject *parent = [obj valueForKey:@"Parent"];
            location.city = [obj valueForKey:@"name"];
            location.cityPointer = obj;
            location.placeId = [obj valueForKey:@"objectId"];
            location.state = [parent valueForKey:@"name"];
            PFObject *subParent = [parent valueForKey:@"Parent"];
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

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
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
    [self.delegate selectedLocation:self.arrTableData[indexPath.row]];
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

//- (void)dragTableRefreshCanceled:(UITableView *)tableView
//{
//    //cancel refresh request(generally network request) here
//    
//    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(finishRefresh) object:nil];
//}
-(void)loadMore{
    MBProgressHUD * hud;
    hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    PFQuery *query = [PFQuery queryWithClassName:@"City" ];
    query.skip = self.arrTableData.count;
    query.limit = 20;
    NSLog(@"text----%@",self.searchBar.text);

    if(isSearching){
        NSLog(@"text----%@",self.searchBar.text);

        NSString *searchText = [NSString stringWithFormat:@"%@",self.searchBar.text];
        [query whereKey:@"name" matchesRegex:[NSString stringWithFormat:@"(?i)%@",searchText]];


    }
    [query includeKey:@"Parent.Parent"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *comments, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if(comments.count<20)
            [_tableView setDragDelegate:nil refreshDatePermanentKey:@"FriendList"];
        for(PFObject *obj in comments){
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
        
    }];
    [self.tableView finishLoadMore];

}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)closeButtonAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
