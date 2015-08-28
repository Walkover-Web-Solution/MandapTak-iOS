//
//  PhotosOptionPopoverViewController.m
//  MandapTak
//
//  Created by Hussain Chhatriwala on 21/08/15.
//  Copyright (c) 2015 Walkover. All rights reserved.
//

#import "PhotosOptionPopoverViewController.h"
@interface PhotosOptionPopoverViewController (){
    
}
- (IBAction)photosOptionAction:(id)sender;


@end


@implementation PhotosOptionPopoverViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
}

- (IBAction)photosOptionAction:(id)sender {
    [self.delegate selectedTag:[sender tag]];
}
@end
