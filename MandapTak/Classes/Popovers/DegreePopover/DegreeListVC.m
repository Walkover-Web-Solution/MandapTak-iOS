//
//  DegreeListVC.m
//  MandapTak
//
//  Created by Anuj Jain on 8/8/15.
//  Copyright (c) 2015 Walkover. All rights reserved.
//

#import "DegreeListVC.h"

@interface DegreeListVC ()

@end

@implementation DegreeListVC
@synthesize arrSelDegree;
@synthesize filteredTableData;
@synthesize searchBar;
@synthesize isFiltered;

- (void)viewDidLoad {
    [super viewDidLoad];
    searchBar.delegate = (id)self;
    arrTableData = [[NSMutableArray alloc]init];
    arrSelDegreeId = [[NSMutableArray alloc] init];
    arrNewSelection = [[NSMutableArray alloc] init];
    arrDegreeName = [[NSArray alloc] initWithObjects:@"BE",@"B Tech",@"BBA",@"BCA",@"ME",@"M Tech",@"MBA",@"MCA", nil];
    arrDegreeId = [[NSArray alloc] initWithObjects:@"001",@"002",@"003",@"004",@"005",@"006",@"007",@"008", nil];
    //arrSelDegree = [[NSMutableArray alloc] init];
    // Do any additional setup after loading the view.
    
    //insert degree array data into object
    
    for (int i=0; i<arrDegreeId.count; i++)
    {
        globalDegreeObj = [[Degree alloc] init];
        globalDegreeObj.degreeId = arrDegreeId[i];
        globalDegreeObj.degreeName = arrDegreeName[i];
        [arrTableData addObject:globalDegreeObj];
    }
    
    for (globalDegreeObj in arrSelDegree)
    {
        [arrSelDegreeId addObject:globalDegreeObj.degreeId];
        NSLog(@"Sel arr id = %@ and name = %@ and degree = %@",globalDegreeObj.degreeId,globalDegreeObj.degreeName,globalDegreeObj);
    }
    
    for (globalDegreeObj in arrTableData)
    {
        if ([arrSelDegreeId containsObject:globalDegreeObj.degreeId])
        {
            [arrNewSelection addObject:globalDegreeObj];
        }
    }
    
    for (Degree *d in arrTableData)
    {
        NSLog(@"All arr id = %@ and name = %@ and degree = %@",d.degreeId,d.degreeName,d);
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UITableView Data Source

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int rowCount;
    if(self.isFiltered)
        rowCount = filteredTableData.count;
    else
        rowCount = arrTableData.count;
    
    return rowCount;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cell";
    UITableViewCell *cell = [tableViewDegree dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (!cell)
    {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
        [cell setBackgroundColor:[UIColor clearColor]];
        cell.textLabel.textColor = [UIColor darkGrayColor];
        
    }
    
    globalDegreeObj = [[Degree alloc] init];

    NSString *strLabelText;
    if(isFiltered)
        globalDegreeObj = [filteredTableData objectAtIndex:indexPath.row];
    else
        globalDegreeObj = [arrTableData objectAtIndex:indexPath.row];
    cell.textLabel.text =globalDegreeObj.degreeName;
    cell.detailTextLabel.text = globalDegreeObj.degreeId;
    
    if ([arrSelDegreeId containsObject:globalDegreeObj.degreeId])
    {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else
    {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    //NSLog(@"d obj = %@",dObj.degreeId);
    
    //apply checkmark condition
    /*
    for (Degree *obj in arrTableData)
    {
        NSLog(@"id = %@",degreeObj.degreeId);
        if ([degreeObj.degreeId isEqual:obj.degreeId])
        {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
        else
        {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    }
     */
    /*
    if ([arrSelDegree containsObject:arrTableData[indexPath.row]])
    {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else
    {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
     */
    return cell;
}

-(void)searchBar:(UISearchBar*)searchBar textDidChange:(NSString*)text
{
    if(text.length == 0)
    {
        isFiltered = FALSE;
    }
    else
    {
        isFiltered = true;
        filteredTableData = [[NSMutableArray alloc] init];
        
        /*
        for (NSString *strDegree in arrDegreeName)
        {
            NSRange nameRange = [strDegree rangeOfString:text options:NSCaseInsensitiveSearch];
            if(nameRange.location != NSNotFound)
            {
                [filteredTableData addObject:strDegree];
            }
        }
        */
        for (globalDegreeObj in arrTableData)
        {
            NSRange nameRange = [globalDegreeObj.degreeName rangeOfString:text options:NSCaseInsensitiveSearch];
            //NSRange descriptionRange = [food.description rangeOfString:text options:NSCaseInsensitiveSearch];
            if(nameRange.location != NSNotFound)
            {
                [filteredTableData addObject:globalDegreeObj];
            }
        }
    }
    
    [tableViewDegree reloadData];
}

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    
    [tableViewDegree reloadData];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    //globalDegreeObj = [[Degree alloc]init];
    
    //apply filter condition
    if (isFiltered)
    {
        globalDegreeObj = filteredTableData[indexPath.row];
    }
    else
    {
        globalDegreeObj = arrTableData[indexPath.row];
    }
    
    if(cell.accessoryType == UITableViewCellAccessoryNone)
    {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        [arrNewSelection addObject:globalDegreeObj];
        [arrSelDegreeId addObject:globalDegreeObj.degreeId];
        
    }
    else
    {
        cell.accessoryType = UITableViewCellAccessoryNone;
        [arrNewSelection removeObject:globalDegreeObj];
        [arrSelDegreeId removeObject:globalDegreeObj.degreeId];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //[tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)saveAction:(id)sender
{
    [self.delegate showSelDegree:arrNewSelection];
}
@end
