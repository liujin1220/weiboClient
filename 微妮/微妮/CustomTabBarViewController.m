//
//  CustomTabBarViewController.m
//  微妮
//
//  Created by 刘锦 on 14-9-11.
//  Copyright (c) 2014年 liujin. All rights reserved.
//

#import "CustomTabBarViewController.h"

@interface CustomTabBarViewController ()

@end

@implementation CustomTabBarViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self loadViewControllers];
}
-(void)loadViewControllers{
    _homeVC = [[HomeViewController alloc] init];
    _homeNav=[[CustomNavController alloc]initWithRootViewController:_homeVC];
    _homeItem = [[UITabBarItem alloc]initWithTitle:@"首页" image:[UIImage imageNamed:@"home"] tag:1];
    _homeNav.tabBarItem = _homeItem;
    
    _squareVC = [[SquareViewController alloc] init];
    _squareNav=[[CustomNavController alloc]initWithRootViewController:_squareVC];
    _squareItem = [[UITabBarItem alloc]initWithTitle:@"广场" image:[UIImage imageNamed:@"square"] tag:2];
    _squareNav.tabBarItem = _squareItem;
    
    _personalVC = [[PersonalViewController alloc] init];
    _personalNav=[[CustomNavController alloc]initWithRootViewController:_personalVC];
    _personalItem = [[UITabBarItem alloc]initWithTitle:@"我" image:[UIImage imageNamed:@"personal"] tag:3];
    _personalNav.tabBarItem = _personalItem;
    
    
    _moreVC = [[MoreViewController alloc] init];
    _moreNav=[[CustomNavController alloc]initWithRootViewController:_moreVC];
    _moreItem= [[UITabBarItem alloc]initWithTitle:@"更多" image:[UIImage imageNamed:@"more"] tag:4];
    _moreNav.tabBarItem = _moreItem;

    NSArray *ViewContrls = @[_homeNav,_squareNav,_personalNav,_moreNav];
    [self setViewControllers:ViewContrls];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
