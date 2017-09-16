//
//  ViewController.m
//  ARPlayDemo
//
//  Created by alexyang on 2017/7/7.
//  Copyright © 2017年 alexyang. All rights reserved.
//

#import "ViewController.h"
#import "SCNViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
}
- (IBAction)btnClicked:(id)sender {
    
    SCNViewController *scnVC = [[SCNViewController alloc]init];
    [self.navigationController pushViewController:scnVC animated:YES];
}
- (IBAction)btnVRModeClicked:(id)sender {
    
    SCNViewController *scnVC = [[SCNViewController alloc]init];
    scnVC.isCardBoard = YES;
    [self.navigationController pushViewController:scnVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}


@end
