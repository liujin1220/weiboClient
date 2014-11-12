//
//  RootViewController.m
//  微妮
//
//  Created by 刘锦 on 14-10-16.
//  Copyright (c) 2014年 liujin. All rights reserved.
//

#import "RootViewController.h"
#import "CustomTabBarViewController.h"
#import "LeftViewController.h"
#import "RightViewController.h"
#define kWeiboReLogin @"kWeiboReLogin"
static RootViewController *segtonInstance = nil;

@implementation RootViewController
-(id)init{
    self = [super init];
    if (self != nil) {
        //监听重新登录的通知
        [ [NSNotificationCenter defaultCenter]addObserver:self
                                                 selector:@selector(weiboLoginNotification:)
                                                     name:kWeiboReLogin
                                                   object:nil];
        //初始化
        LeftViewController *leftVC = [[LeftViewController alloc]init];
        RightViewController *rightVC = [[RightViewController alloc]init];
        _ddMenu= [[DDMenuController alloc]init];
        CustomTabBarViewController *tab = [[CustomTabBarViewController alloc]init];
        _ddMenu.rootViewController = tab;
        _ddMenu.leftViewController = leftVC;
        _ddMenu.rightViewController = rightVC;
    }
    return self;
}

+(RootViewController *)sharedRootViewController{
    @synchronized(self){
        if (segtonInstance == nil) {
            segtonInstance = [[[self class]alloc]init];
        }
        return segtonInstance;
    }
}
#pragma mark - 下面的方法为了确保只有一个实例对象
+ (id) allocWithZone:(NSZone *)zone{
    @synchronized(self){
        if (segtonInstance == nil) {
            segtonInstance = [super allocWithZone:zone];
        }
    }
    return segtonInstance;
}

- (id)copyWithZone:(NSZone *)zone{
    return segtonInstance;
}
#pragma mark - weiboLoginNotification
-(void)weiboLoginNotification:(NSNotification *)notification{
    NSLog(@"重新登录通知");
    [self.ddMenu dismissViewControllerAnimated:YES completion:nil];
}
@end
