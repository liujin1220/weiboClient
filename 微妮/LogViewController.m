//
//  LogViewController.m
//  微妮
//
//  Created by 刘锦 on 14-9-15.
//  Copyright (c) 2014年 liujin. All rights reserved.
//

#import "LogViewController.h"
#import "BlockButton.h"
#import "SelectedWeiboName.h"

#define KSCALE              (2/5.0)     // 比例
#define KLOGINBUTTONPOS     (2/5.0)     // 登陆按钮位置比例
#define KLOGINLABELHEIGHT   40          // 登陆按钮高度
#define KSELECTLABELHEIGHT  30          // 选择视图高度

@interface LogViewController ()

@property (strong, nonatomic) SelectView    *selectView;    // 选择视图
@property (strong, nonatomic) UILabel       *loginLabel;    // 登陆文本视图
@property (strong, nonatomic) UILabel       *selectLabel;   // 选择文本视图
@property (strong, nonatomic) UIButton      *sinaButton;    // 登陆新浪按钮
@property (strong, nonatomic) UIButton      *tencentButton; // 登陆腾讯按钮

@end

@implementation LogViewController

#pragma mark - lifeCircle

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // To Do
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationItem setTitle:@"微妮"];
    [self p_creatContentView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

/**
 *  设置内容
 */
-(void)p_creatContentView{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KDEVICEWIDTH, KDEVICEHEIGHT*(2/6.0))];
    view.backgroundColor = [UIColor colorWithRed:226/255.0 green:101/255.0 blue:20/255.0 alpha:1.0];
    [self.view addSubview:view];
    //登陆
    _loginLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, (1/7.0)*KDEVICEHEIGHT, KDEVICEWIDTH, KLOGINLABELHEIGHT)];
    [_loginLabel setText:@"微你"];
    [_loginLabel setFont:[UIFont systemFontOfSize:32.0]];
    [_loginLabel setTextAlignment:NSTextAlignmentCenter];
    [_loginLabel setTextColor:[UIColor whiteColor]];
    [self.view addSubview:_loginLabel];
    
    //选择登陆平台
    _selectLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 10+KLOGINLABELHEIGHT+(1/7.0)*KDEVICEHEIGHT, KDEVICEWIDTH, KSELECTLABELHEIGHT)];
    [_selectLabel setText:@"选择登陆平台"];
    [_selectLabel setFont:[UIFont systemFontOfSize:15.0]];
    [_selectLabel setTextColor:[UIColor colorWithRed:237/255.0 green:237/255.0 blue:237/255.0 alpha:1.0]];
    [_selectLabel setTextAlignment:NSTextAlignmentCenter];
    [self.view addSubview:_selectLabel];
    
    //新浪微博
    _sinaButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_sinaButton setBackgroundImage:[UIImage imageNamed:@"sina_login"] forState:UIControlStateNormal];
    [_sinaButton setFrame:CGRectMake((KDEVICEWIDTH-372*KSCALE)/2.0, KLOGINBUTTONPOS*KDEVICEHEIGHT, 372*KSCALE, 137*KSCALE)];
    [_sinaButton addTarget:self action:@selector(logSinaWeibo) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_sinaButton];
    
    //腾讯微博
    _tencentButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_tencentButton setFrame:CGRectMake((KDEVICEWIDTH-372*KSCALE)/2.0, KLOGINBUTTONPOS*KDEVICEHEIGHT+137*KSCALE+20, 372*KSCALE, 137*KSCALE)];
    [_tencentButton setBackgroundImage:[UIImage imageNamed:@"tencent_login"] forState:UIControlStateNormal];
    [_tencentButton addTarget:self action:@selector(logTencentWeibo) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_tencentButton];
}

#pragma mark - Button Actions

/**
 *  新浪认证
 */
- (void)logSinaWeibo{
    AuthorizeViewController *authVC = [[AuthorizeViewController alloc]initWithWeiboName:@"新浪微博"];
    UINavigationController *navC = [[UINavigationController alloc]initWithRootViewController:authVC];
    [self presentViewController:navC animated:YES completion:nil];
    authVC.block = ^(){
        [self accessToRootVC];
    };
}

/**
 *  腾讯认证
 */
- (void)logTencentWeibo{
    AuthorizeViewController *authVC = [[AuthorizeViewController alloc]initWithWeiboName:@"腾讯微博"];
    UINavigationController *navC = [[UINavigationController alloc]initWithRootViewController:authVC];
    [self presentViewController:navC animated:YES completion:nil];
    authVC.block = ^(){
        [self accessToRootVC];
    };
}

/**
 *  进入主视图
 */
-(void)accessToRootVC{
     [self presentViewController:(UIViewController *)[RootViewController sharedRootViewController].ddMenu animated:YES completion:nil];
}

@end
