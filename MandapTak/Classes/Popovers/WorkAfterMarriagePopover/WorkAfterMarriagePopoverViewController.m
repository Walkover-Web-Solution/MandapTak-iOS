//
//  WorkAfterMarriagePopoverViewController.m
//  MandapTak
//
//  Created by Hussain Chhatriwala on 17/08/15.
//  Copyright (c) 2015 Walkover. All rights reserved.
//

#import "WorkAfterMarriagePopoverViewController.h"

@interface WorkAfterMarriagePopoverViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *arrTableData;
@end

@implementation WorkAfterMarriagePopoverViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.arrTableData = [NSArray arrayWithObjects:@"Yes",@"No",@"May be", nil];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    //PFObject *obj = self.arrTableData[indexPath.row];
    //cell.textLabel.text = [obj valueForKey:@"name"];
    cell.textLabel.text =self.arrTableData [indexPath.row];
    
    //set font family
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.delegate selectedMarraigeType:self.arrTableData[indexPath.row]];
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
