//
//  ViewFullProfileVC.m
//  MandapTak
//
//  Created by Anuj Jain on 8/24/15.
//  Copyright (c) 2015 Walkover. All rights reserved.
//

#import "ViewFullProfileVC.h"

@interface ViewFullProfileVC ()

@end

@implementation ViewFullProfileVC
@synthesize arrImages,profileObject,arrEducation;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self loadImages];
    [self setupCollectionView];
    
    lblName.text = [profileObject.profilePointer valueForKey:@"name"];
    lblGender.text = [profileObject.profilePointer valueForKey:@"gender"];
    lblDOB.text = profileObject.dob;
    lblHeight.text = [NSString stringWithFormat:@"%@",profileObject.height];
    lblWeight.text = [NSString stringWithFormat:@"%@ Kg",profileObject.weight];
    lblTOB.text = profileObject.tob;
    lblPlaceOfBirth.text = profileObject.placeOfBirth;
    lblReligion.text = [NSString stringWithFormat:@"%@,%@",profileObject.religion,profileObject.caste];
    lblMinBudget.text = [NSString stringWithFormat:@"Min:%@",profileObject.minBudget];
    lblMaxBudget.text = [NSString stringWithFormat:@"Max:%@",profileObject.maxBudget];
    tableViewEducation.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self showBasicDetails:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark Image Collection View methods
-(void)loadImages
{
    dataArray = arrImages;
    //pageControl.numberOfPages = [dataArray count];
}

-(void)setupCollectionView {
    [ImagesCollectionView registerClass:[CMFGalleryCell class] forCellWithReuseIdentifier:@"cellIdentifier"];
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    [flowLayout setMinimumInteritemSpacing:0.0f];
    [flowLayout setMinimumLineSpacing:0.0f];
    [ImagesCollectionView setPagingEnabled:YES];
    [ImagesCollectionView setCollectionViewLayout:flowLayout];
    
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [dataArray count];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CMFGalleryCell *cell = (CMFGalleryCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"cellIdentifier" forIndexPath:indexPath];
    NSString *imageName = [dataArray objectAtIndex:indexPath.row];
    [cell setUserImage:[dataArray objectAtIndex:indexPath.row]];
    [cell setImageName:imageName];
    [cell updateImageCell];
    return cell;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return ImagesCollectionView.frame.size;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)back:(id)sender
{
    //[self.navigationController popViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)showBasicDetails:(id)sender
{
    //show view 1
    view1.hidden = false;
    view2.hidden = true;
    view3.hidden = true;
    view4.hidden = true;
}

- (IBAction)showHeightWeight:(id)sender
{
    //show view 2
    view1.hidden = true;
    view2.hidden = false;
    view3.hidden = true;
    view4.hidden = true;

}

- (IBAction)showWorkDetails:(id)sender
{
    view3.hidden = false;
    view1.hidden = true;
    view2.hidden = true;
    view4.hidden = true;
}

- (IBAction)showBiodata:(id)sender
{
    view4.hidden = false;
    view1.hidden = true;
    view2.hidden = true;
    view3.hidden = true;
}

- (IBAction)downloadBiodata:(id)sender
{
    PFQuery *query = [PFQuery queryWithClassName:@"Profile"];
    //NSLog(@"candidater profile ID -> %@",profileObject.profilePointer.objectId);
    [query whereKey:@"objectId" equalTo:profileObject.profilePointer.objectId];//rvkzhpnLKr //EYKXEM27cu
    
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        
    if (!error)
    {
        PFFile *userImageFile = [object objectForKey:@"bioData"]; //profileCropedPhoto
        
        NSString *fileName = [userImageFile url];
        NSURL *URL = [NSURL URLWithString:fileName];
        if (URL == nil)
        {
            UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"Error" message:@"File not found" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [av show];
        }
        else
        {
            SVModalWebViewController *webViewController = [[SVModalWebViewController alloc] initWithURL:URL];
            webViewController.modalPresentationStyle = UIModalPresentationPageSheet;
            [self presentViewController:webViewController animated:YES completion:NULL];
        }
    }
    }];
    
}

#pragma mark UITableView Data Source
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
/*
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UILabel *myLabel = [[UILabel alloc] init];
    myLabel.frame = CGRectMake(20, 8, 320, 20);
    myLabel.font = [UIFont fontWithName:@"MYRIADPRO-REGULAR.OTF" size:17];
    myLabel.text = [self tableView:tableView titleForHeaderInSection:section];
    
    UIView *headerView = [[UIView alloc] init];
    [headerView addSubview:myLabel];
    
    return headerView;
}
*/
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *sectionName;
    switch (section)
    {
        case 0:
            sectionName = NSLocalizedString(@"WORK", @"mySectionName");
            break;
        case 1:
            sectionName = NSLocalizedString(@"EDUCATION", @"myOtherSectionName");
            break;
        default:
            sectionName = @"";
            break;
    }
    return sectionName;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger numberOfRows;
    switch (section)
    {
        case 0:
            numberOfRows = 1;
            break;
        case 1:
            numberOfRows = arrEducation.count;
            break;
        default:
            numberOfRows = 1;
            break;
    }
    return numberOfRows;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height;
    switch (indexPath.section)
    {
        case 0:
            height = 70.0;
            break;
        case 1:
            height = 50.0;
            break;
        default:
            height = 70.0;
            break;
    }
    return height;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"PinLogsCell";
    WorkEducationCell *cell = [tableViewEducation dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (!cell) {
        cell=[[WorkEducationCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    if (indexPath.section == 0)
    {
        cell.lblTitle.text = profileObject.designation;
        cell.lblDetail.text = profileObject.company;
        cell.lblDescription.text = [NSString stringWithFormat:@"%@ /annum",profileObject.income];
    }
    else
    {
        Education *obj = [[Education alloc]init];
        obj = arrEducation[indexPath.row];
        PFObject *specialization = obj.specialisation;
        PFObject *degreeName = [specialization valueForKey:@"degreeId"];
        NSString *specializationName = [specialization valueForKey:@"name"];
        cell.lblTitle.text = [NSString stringWithFormat:@"%@",[degreeName valueForKey:@"name"]];
        cell.lblDetail.text = specializationName;
        cell.lblDescription.hidden = YES;
    }

    return cell;
}
@end
