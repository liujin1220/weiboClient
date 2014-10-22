//
//  CustomTabBarViewController.h
//  微妮
//
//  Created by 刘锦 on 14-9-11.
//  Copyright (c) 2014年 liujin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomNavController.h"
#import "HomeViewController.h"
#import "SquareViewController.h"
#import "PersonalViewController.h"
#import "MoreViewController.h"

@interface CustomTabBarViewController : UITabBarController
@property(nonatomic,strong) HomeViewController*homeVC;
@property(nonatomic,strong)SquareViewController *squareVC;
@property(nonatomic,strong)PersonalViewController *personalVC;
@property(nonatomic,strong)MoreViewController *moreVC;

@property(nonatomic,strong)CustomNavController *homeNav;
@property(nonatomic,strong)CustomNavController *squareNav;
@property(nonatomic,strong)CustomNavController *personalNav;
@property(nonatomic,strong)CustomNavController *moreNav;

@property(nonatomic,strong)UITabBarItem *homeItem;
@property(nonatomic,strong)UITabBarItem *squareItem;
@property(nonatomic,strong)UITabBarItem *personalItem;
@property(nonatomic,strong)UITabBarItem *moreItem;
@end
