//
//  ViewController.m
//  Umbrella
//
//  Created by Sai Teja on 9/24/17.
//  Copyright © 2017 Sai Teja. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UILabel *cityLBL;
@property (weak, nonatomic) IBOutlet UILabel *tempLBL;
@property (weak, nonatomic) IBOutlet UILabel *conditionLBL;
@property (weak, nonatomic) IBOutlet UIScrollView *todayScrollView;
@property (weak, nonatomic) IBOutlet UIScrollView *tomorrowScrollView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
