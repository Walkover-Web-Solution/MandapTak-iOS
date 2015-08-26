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
    
    //NSLog(@"profile name = %@",[profileObject.profilePointer valueForKey:@"name"]);
    lblName.text = [profileObject.profilePointer valueForKey:@"name"];
    lblGender.text = [profileObject.profilePointer valueForKey:@"gender"];
    lblDOB.text = profileObject.dob;
    lblHeight.text = [NSString stringWithFormat:@"%@",profileObject.height];
    lblWeight.text = [NSString stringWithFormat:@"%@",profileObject.weight];
    lblTOB.text = profileObject.tob;
    lblPlaceOfBirth.text = profileObject.placeOfBirth;
    lblReligion.text = profileObject.religion;
    lblBudget.text = profileObject.budget;
    tableViewEducation.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self showBasicDetails:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark Image Collection View methods
-(void)loadImages {
    
    //NSString *sourcePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"Asstes"];
    //dataArray = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:sourcePath error:NULL];
    //NSLog(@"arr = %@",dataArray);
    //dataArray = [NSArray arrayWithObjects:@"sampleImage01.jpg",@"sampleImage02.jpg",@"sampleImage03.jpg",@"sampleImage04.jpg",@"sampleImage05.jpg",@"sampleImage06.jpg",@"Profile_1.png",@"Profile_2.png ",@"Profile-3.png", nil];
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
}


#pragma mark UITableView Data Source
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

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
        //cell.lblDescription.text = @"Education Description";
    }

    return cell;
}
@end
