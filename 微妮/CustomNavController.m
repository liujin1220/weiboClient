//
//  CustomNavController.m
//  Tiwtter
//
//  Created by 刘锦 on 14-3-4.
//  Copyright (c) 2014年 刘锦. All rights reserved.
//

#import "CustomNavController.h"
#import "CONSTS.h"

@interface CustomNavController ()

@end

@implementation CustomNavController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        //导航栏背景
//         [self.navigationBar setBarTintColor:[UIColor colorWithRed:242/255.0 green:45/255.0 blue:91/255.0 alpha:1.0]];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

#pragma setNavBgCategory
@implementation UINavigationBar (SetBackground)
//rect为navigationBar的大小
//ios5.0之前
-(void)drawRect:(CGRect)rect{
}

@end

