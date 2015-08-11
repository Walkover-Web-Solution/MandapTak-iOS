//
//  HeightPopoverViewController.m
//  MandapTak
//
//  Created by Hussain Chhatriwala on 06/08/15.
//  Copyright (c) 2015 Walkover. All rights reserved.
//

#import "HeightPopoverViewController.h"

@interface HeightPopoverViewController (){
    NSArray *arrFeet;
    NSArray *arrInches;
    NSString *selectedFeet;
    NSString *selectedInches;
    NSArray *arrHeight;
    NSString *selectedHeight;
}
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;
- (IBAction)doneButtonAction:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation HeightPopoverViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    selectedInches= 0;
    selectedFeet = 0;
    arrFeet = [NSArray arrayWithObjects:@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8", nil];
    arrHeight = [NSArray arrayWithObjects:@"4ft 5in - 134cm",@"4ft 6in - 137cm",@"4ft 7in - 139cm",@"4ft 8in - 142cm",@"4ft 9in - 144cm",@"4ft 10in - 147cm",@"4ft 11in - 149cm",@"5ft - 152cm",@"5ft 1in - 154cm",@"5ft 2in - 157cm",@"5ft 3in - 160cm",@"5ft 4in - 162cm",@"5ft 5in - 165cm",@"5ft 6in - 167cm",@"5ft 7in - 170cm",@"5ft 8in - 172cm",@"5ft 9in - 175cm",@"5ft 10in - 177cm",@"5ft 11in - 180cm",@"6ft - 182cm",@"6ft 1in - 185cm",@"6ft 2in - 187cm",@"6ft 3in - 190cm",@"6ft 4in - 193cm",@"6ft 5in - 195cm",@"6ft 6in - 198cm",@"6ft 7in - 200cm",@"6ft 8in - 203cm",@"6ft 9in - 205cm",@"6ft 10in - 208cm",@"6ft 11in - 210cm",@"7ft - 213cm", nil];
    [self.pickerView reloadAllComponents];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark UITableView Data Source

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return arrHeight.count;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"PinLogsCell";
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (!cell) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        [cell setBackgroundColor:[UIColor clearColor]];
        cell.textLabel.textColor = [UIColor darkGrayColor];
        cell.textLabel.textAlignment = NSTextAlignmentCenter;

    }
   
    cell.textLabel.text = arrHeight[indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
        [self.delegate selectedHeight:arrHeight[indexPath.row]];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

#pragma mark UIPickerViewDelegate

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 4;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    switch (component) {
        case 0:
            return 1;
            break;
        case 1:
            return arrFeet.count;
            break;
        case 2:
            return 1;
            break;
        case 3:
            return arrInches.count;
            break;
        default:
            break;
    }
    return 0;

}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    switch (component) {
        case 0:
            return @"Feet";
            break;
        case 1:
            return arrFeet[row];
            break;
        case 2:
            return @"Inches";
            break;
        case 3:
            return arrInches[row];
            break;
        default:
            break;
    }
    return 0;
    //return @"status";
}
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel* tView = (UILabel*)view;
    if (!tView){
        tView = [[UILabel alloc] init];
        tView.font = [UIFont systemFontOfSize:14];
        
    }
    switch (component) {
        case 0:
            tView.text = @"Feet";
            break;
        case 1:
            tView.text = arrFeet[row];
            break;
        case 2:
            tView.text = @"Inch";
            break;
        case 3:
            tView.text = arrInches[row];
            break;
        default:
            break;
    }

    return tView;
}
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    switch (component) {
        case 1:
            selectedFeet=arrFeet[row];
            break;
        case 3:
            selectedInches=arrInches[row];
            break;
        default:
            break;
    }

}

 - (IBAction)doneButtonAction:(id)sender {
 [self.delegate selectedHeight:selectedHeight];
 }


 */

@end
