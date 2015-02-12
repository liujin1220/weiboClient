//
//  BaseViewController.m
//  微妮
//
//  Created by 刘锦 on 14/10/22.
//  Copyright (c) 2014年 liujin. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController
- (id)init{
    self = [super init];
    if (self) {
        //监听主题切换的通知
        [ [NSNotificationCenter defaultCenter]addObserver:self
                                                 selector:@selector(weiboNotification:)
                                                     name:kWeiboDidChangeNotification
                                                   object:nil];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

/**
 *  设置导航栏上的标题
 *
 *  @param title 标题
 */
- (void)setTitle:(NSString *)title {
    [super setTitle:title];
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.font = [UIFont boldSystemFontOfSize:16.0f];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.text = title;
    [titleLabel sizeToFit];
    
    self.navigationItem.titleView = titleLabel;
}

#pragma mark - NSNotifiction actions

//当切换主题时会调用
-(void)weiboNotification:(NSNotification *)notification{
    NSLog(@"切换主题");
}
@end
