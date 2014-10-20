//
//  CustomTabBarViewController.h
//  微妮
//
//  Created by 刘锦 on 14-9-11.
//  Copyright (c) 2014年 liujin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomNavController.h"
#import "HomeTableViewController.h"
#import "SquareViewController.h"
#import "PersonalTableViewController.h"
#import "MoreTableViewController.h"

@interface CustomTabBarViewController : UITabBarController
@property(nonatomic,strong)HomeTableViewController *homeVC;
@property(nonatomic,strong)SquareViewController *squareVC;
@property(nonatomic,strong)PersonalTableViewController *personalVC;
@property(nonatomic,strong)MoreTableViewController *moreVC;

@property(nonatomic,strong)CustomNavController *homeNav;
@property(nonatomic,strong)CustomNavController *squareNav;
@property(nonatomic,strong)CustomNavController *personalNav;
@property(nonatomic,strong)CustomNavController *moreNav;

@property(nonatomic,strong)UITabBarItem *homeItem;
@property(nonatomic,strong)UITabBarItem *squareItem;
@property(nonatomic,strong)UITabBarItem *personalItem;
@property(nonatomic,strong)UITabBarItem *moreItem;
@end
