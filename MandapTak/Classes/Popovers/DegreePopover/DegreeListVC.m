//
//  DegreeListVC.m
//  MandapTak
//
//  Created by Anuj Jain on 8/8/15.
//  Copyright (c) 2015 Walkover. All rights reserved.
//

#import "DegreeListVC.h"
#import "UITableView+DragLoad.h"

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
    arrDegreeId = [[NSMutableArray alloc] init];
    arrDegreeName = [[NSMutableArray alloc] init];
    arrDegreeTypeId = [[NSMutableArray alloc] init];
    arrDegreeTypeName = [[NSMutableArray alloc] init];
    
    //fetch all degrees
    [self fetchAllDegree];
    
    
    //fetch all degree types
    
    //arrDegreeName = [[NSMutableArray alloc] initWithObjects:@"BE",@"B Tech",@"BBA",@"BCA",@"ME",@"M Tech",@"MBA",@"MCA", nil];
    //arrDegreeId = [[NSMutableArray alloc] initWithObjects:@"001",@"002",@"003",@"004",@"005",@"006",@"007",@"008", nil];
    //arrSelDegree = [[NSMutableArray alloc] init];
    // Do any additional setup after loading the view.
    
    //insert degree array data into object

}

-(void) fetchAllDegree
{
    /*
    PFQuery *query = [PFQuery queryWithClassName:@"Degree"];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
     {
         [query includeKey:@"DegreeType"];
         if (!error)
         {
             // The find succeeded.
             for (NSDictionary *dict in objects)
             {
                 Degree *objDegree = [[Degree alloc]init];
                 objDegree.objectName = [dict valueForKey:@"name"];
                 objDegree.objectId = [dict valueForKey:@"objectId"];
                 [arrDegreeName addObject:[dict valueForKey:@"name"]];
                 [arrDegreeId addObject:[dict valueForKey:@"objectId"]];
                 NSLog(@"Degree Type = %@",[dict valueForKey:@"DegreeTypeId"]);
                 NSString *strDegreeType = dict[@"DegreeTypeId"];
                 PFObject *post = dict[@"DegreeTypeId"];
                 [post fetchIfNeededInBackgroundWithBlock:^(PFObject *object, NSError *error) {
                     NSString *title = post[@"typeOfDegree"];
                     NSLog(@"title = %@",title);
                 }];
             }
             //PFObject *obj = objects[0];
             //self.currentProfile = obj;
             [self fetchAllDegreeType];
             //[self updateData];
         }
         
     }];
     */
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    PFQuery *query = [PFQuery queryWithClassName:@"Degree" ];
    //[query whereKey:@"name" matchesRegex:[NSString stringWithFormat:@"(?i)^%@",searchText]];
    //[query whereKey:@"name" hasPrefix:searchBar.text];
    [query includeKey:@"degreeTypeId"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
     {
         [MBProgressHUD hideHUDForView:self.view animated:YES];
         
         //NSMutableArray *arrLocData = [NSMutableArray array];
         for(PFObject *obj in objects)
         {
             Degree *degObject = [[Degree alloc]init];
             NSLog(@"degree name %@",[obj valueForKey:@"name"]);
             PFObject *degType = [obj valueForKey:@"degreeTypeId"];
             degObject.objectName = [obj valueForKey:@"name"];
             degObject.objectPointer = obj;
             NSString *strClass =  obj.parseClassName;
             NSLog(@"class name = %@",strClass);
             degObject.objectId = [obj valueForKey:@"objectId"];
             NSLog(@"Degree Type Id ---- %@",[degType valueForKey:@"objectId"]);
             NSLog(@"Type name %@",[degType valueForKey:@"typeOfDegree"]);
             degObject.objectType = [degType valueForKey:@"typeOfDegree"];
             
             //PFObject *subParent = [parent valueForKey:@"Parent"];
             //NSLog(@"CountryName %@",[subParent valueForKey:@"name"]);
             //location.country = [subParent valueForKey:@"name"];
             //location.descriptions = [NSString stringWithFormat:@"%@, %@, %@",[obj valueForKey:@"name"],[parent valueForKey:@"name"],[subParent valueForKey:@"name"]];
             [arrDegreeName addObject:degObject];
             
         }
         [self fetchAllDegreeType];
         //self.arrTableData = arrLocData;
         //[self.tableView reloadData];
         
     }];
}


-(void) fetchAllDegreeType
{
    /*
    PFQuery *query = [PFQuery queryWithClassName:@"DegreeType"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
     {
         if (!error)
         {
             // The find succeeded.
             for (NSDictionary *dict in objects)
             {
                 [arrDegreeTypeName addObject:[dict valueForKey:@"typeOfDegree"]];
                 [arrDegreeTypeId addObject:[dict valueForKey:@"objectId"]];
                
             }
             [self updateData];
         }
     }];
     */
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    PFQuery *query = [PFQuery queryWithClassName:@"DegreeType" ];
    //[query whereKey:@"name" matchesRegex:[NSString stringWithFormat:@"(?i)^%@",searchText]];
    //[query whereKey:@"name" hasPrefix:searchBar.text];
    //[query includeKey:@"Parent.Parent"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *typeObjects, NSError *error)
     {
         [MBProgressHUD hideHUDForView:self.view animated:YES];
         
         //NSMutableArray *arrLocData = [NSMutableArray array];
         for(PFObject *obj in typeObjects)
         {
             Degree *degreeType = [[Degree alloc]init];
             NSLog(@"2 Degree type name %@",[obj valueForKey:@"typeOfDegree"]);
             //PFObject *parentCountry = [obj valueForKey:@"Parent"];
             degreeType.objectType = [obj valueForKey:@"typeOfDegree"];
             degreeType.objectPointer = obj;
             NSString *strClass =  obj.parseClassName;
             NSLog(@"class name = %@",strClass);
             degreeType.objectId = [obj valueForKey:@"objectId"];
             
             
             //PFObject *subParent = [parent valueForKey:@"Parent"];
             //NSLog(@"CountryName %@",[subParent valueForKey:@"name"]);
             //location.country = [subParent valueForKey:@"name"];
             //location.descriptions = [NSString stringWithFormat:@"%@, %@",[obj valueForKey:@"name"],[parentCountry valueForKey:@"name"]];
             [arrDegreeName addObject:degreeType];
         }
         //self.arrTableData = arrLocData;
         //[self.tableView reloadData];
         [self updateData];
     }];
}


-(void) updateData
{
    /*
    for (int i=0; i<arrDegreeId.count; i++)
    {
        globalDegreeObj = [[Degree alloc] init];
        globalDegreeObj.objectId = arrDegreeId[i];
        globalDegreeObj.objectName = arrDegreeName[i];
        [arrTableData addObject:globalDegreeObj];
    }
    
    for (int i=0; i<arrDegreeTypeId.count; i++)
    {
        globalDegreeObj = [[Degree alloc] init];
        globalDegreeObj.objectId = arrDegreeTypeId[i];
        globalDegreeObj.objectName = arrDegreeTypeName[i];
        [arrTableData addObject:globalDegreeObj];
    }
     */
    
    for (int i=0; i<arrDegreeName.count; i++)
    {
        globalDegreeObj = [[Degree alloc] init];
        globalDegreeObj = arrDegreeName[i];
        //globalDegreeObj.objectId = arrDegreeName[i];
        //globalDegreeObj.objectName = arrDegreeName[i];
        [arrTableData addObject:globalDegreeObj];
    }
    
    
    for (globalDegreeObj in arrSelDegree)
    {
        [arrSelDegreeId addObject:globalDegreeObj.objectId];
        //NSLog(@"Sel arr id = %@ and name = %@ and degree = %@",globalDegreeObj.objectId,globalDegreeObj.objectName,globalDegreeObj);
    }
    
    for (globalDegreeObj in arrTableData)
    {
        if ([arrSelDegreeId containsObject:globalDegreeObj.objectId])
        {
            [arrNewSelection addObject:globalDegreeObj];
        }
    }
    /*
    for (Degree *d in arrTableData)
    {
        NSLog(@"All arr id = %@ and name = %@ and degree = %@",d.objectId,d.objectName,d);
    }
    */
    [tableViewDegree reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UITableView Data Source
/*
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        return @"Degree Type";
    }
    else
    {
        return @"Degree Name";
    }
}
*/
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    /*
    if (section == 0) {
        return 2;
    }
    else {
     */
        int rowCount;
        if(self.isFiltered)
            rowCount = filteredTableData.count;
        else
            rowCount = arrTableData.count;
        
        return rowCount;
    //}
    
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
    
    PFObject *object = globalDegreeObj.objectPointer;
    if ([object.parseClassName isEqualToString:@"Degree"])
    {
        cell.textLabel.text =globalDegreeObj.objectName;
    }
    else if ([object.parseClassName isEqualToString:@"DegreeType"])
    {
        cell.textLabel.text =globalDegreeObj.objectType;
    }
    
    
    if ([arrSelDegreeId containsObject:globalDegreeObj.objectId])
    {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else
    {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    
    //cell.detailTextLabel.text = globalDegreeObj.degreeId;
    
    
    
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
        
        for (globalDegreeObj in arrTableData)
        {
            PFObject *degreeObject = globalDegreeObj.objectPointer;
            NSRange nameRange;
            if ([degreeObject.parseClassName isEqualToString:@"Degree"])
            {
                nameRange = [globalDegreeObj.objectName rangeOfString:text options:NSCaseInsensitiveSearch];
            }
            else if ([degreeObject.parseClassName isEqualToString:@"DegreeType"])
            {
                nameRange = [globalDegreeObj.objectType rangeOfString:text options:NSCaseInsensitiveSearch];
            }
            if((nameRange.location != NSNotFound))
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
        [arrSelDegreeId addObject:globalDegreeObj.objectId];
        
    }
    else
    {
        cell.accessoryType = UITableViewCellAccessoryNone;
        [arrNewSelection removeObject:globalDegreeObj];
        [arrSelDegreeId removeObject:globalDegreeObj.objectId];
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
