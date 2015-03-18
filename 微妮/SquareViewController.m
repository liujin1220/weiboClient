//
//  SquareViewController.m
//  微妮
//
//  Created by 刘锦 on 14/10/22.
//  Copyright (c) 2014年 liujin. All rights reserved.
//

#import "SquareViewController.h"

#import "SquareViewController.h"
#import "NearbyWeiboMapViewController.h"

@interface SquareViewController ()
//附近的微博
@property(nonatomic,strong)UIButton *nearbyWeiboButton;
@property(nonatomic,strong)UILabel *nearbyWeiboLabel;
//附近的人
@property(nonatomic,strong)UIButton *nearbyPeopleButton;
@property(nonatomic,strong)UILabel *nearbyPeopleLabel;
@end

@implementation SquareViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"广场"];
    //附近的微博
    _nearbyWeiboButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_nearbyWeiboButton setFrame:CGRectMake(10, 64+10, 70, 70)];
    [_nearbyWeiboButton setBackgroundImage:[UIImage imageNamed:@"附近微博.jpg"] forState:UIControlStateNormal];
    [_nearbyWeiboButton setTag:100];
    [_nearbyWeiboButton addTarget:self action:@selector(nearbyWeiboAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_nearbyWeiboButton];
    
    _nearbyWeiboLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 64+10+70+10, 70, 20)];
    [_nearbyWeiboLabel setText:@"附近微博"];
    [_nearbyWeiboLabel setFont:[UIFont systemFontOfSize:13.0]];
    [_nearbyWeiboLabel setTextAlignment:NSTextAlignmentCenter];
    [self.view addSubview:_nearbyWeiboLabel];
    
    //附近的人
    _nearbyPeopleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_nearbyPeopleButton setFrame:CGRectMake(10+70+20, 64+10, 70, 70)];
    [_nearbyPeopleButton setBackgroundImage:[UIImage imageNamed:@"附近的人.jpg"] forState:UIControlStateNormal];
    [_nearbyPeopleButton setTag:101];
    [_nearbyPeopleButton addTarget:self action:@selector(nearbyPeopleAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_nearbyPeopleButton];
    
    _nearbyPeopleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10+70+20, 64+10+70+10, 70, 20)];
    [_nearbyPeopleLabel setText:@"附近的人"];
    [ _nearbyPeopleLabel setFont:[UIFont systemFontOfSize:13.0]];
    [_nearbyPeopleLabel setTextAlignment:NSTextAlignmentCenter];
    [self.view addSubview:_nearbyPeopleLabel];
    
    //设置按钮的阴影
    for (int i = 100; i<102; i++) {
        UIButton *button = (UIButton *)[self.view viewWithTag:i];
        button.layer.shadowColor = [UIColor blackColor].CGColor;
        button.layer.shadowOffset = CGSizeMake(2, 2);//阴影的偏移量
        button.layer.shadowOpacity = 1;//阴影的透明度
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
#pragma mark - push
//附近微博
-(void)nearbyWeiboAction:(UIButton *)button{
    NearbyWeiboMapViewController *nearbyWeiboMapVC = [[NearbyWeiboMapViewController alloc]init];
    [self.navigationController pushViewController:nearbyWeiboMapVC animated:YES];
}
//附近的人
-(void)nearbyPeopleAction:(UIButton *)button{
    
}

#pragma mark - NSNotifiction actions
//当切换主题时会调用
-(void)weiboNotification:(NSNotification *)notification{
    //NSLog(@"square切换主题");
    //请求数据
}

@end
