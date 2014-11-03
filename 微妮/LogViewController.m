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
#define KSCALE (2/5.0)
#define KLOGINBUTTONPOS (2/5.0)
#define KLOGINLABELHEIGHT 40
#define KSELECTLABELHEIGHT 30

@interface LogViewController ()
@property(strong,nonatomic)UILabel *loginLabel;
@property(strong,nonatomic)UILabel *selectLabel;
@property(strong,nonatomic)UIButton *sinaButton;
@property(strong,nonatomic)UIButton *tencentButton;
@end

@implementation LogViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self.navigationItem setTitle:@"微妮"];
    }
    return self;
}
-(void)setContentView{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KDEVICEWIDTH, KDEVICEHEIGHT*(2/6.0))];
    view.backgroundColor = [UIColor colorWithRed:226/255.0 green:101/255.0 blue:20/255.0 alpha:1.0];
    [self.view addSubview:view];
    //登陆
    _loginLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, (1/7.0)*KDEVICEHEIGHT, KDEVICEWIDTH, KLOGINLABELHEIGHT)];
    [_loginLabel setText:@"微妮"];
   // [_loginLabel setBackgroundColor:[UIColor grayColor]];
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
    [_sinaButton addTarget:self action:@selector(LogSinaWeibo) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_sinaButton];
    
    //腾讯微博
    _tencentButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_tencentButton setFrame:CGRectMake((KDEVICEWIDTH-372*KSCALE)/2.0, KLOGINBUTTONPOS*KDEVICEHEIGHT+137*KSCALE+20, 372*KSCALE, 137*KSCALE)];
    [_tencentButton setBackgroundImage:[UIImage imageNamed:@"tencent_login"] forState:UIControlStateNormal];
    [_tencentButton addTarget:self action:@selector(LogTencentWeibo) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_tencentButton];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setContentView];
    if(self.txwbapi == nil)
    {
        self.txwbapi = [[WeiboApi alloc]initWithAppKey:KTAppKey andSecret:KTAppSecret andRedirectUri:REDIRECTURI andAuthModeFlag:0 andCachePolicy:0] ;
    }
}
//新浪认证
-(void)LogSinaWeibo{
    AuthorizeViewController *authVC = [[AuthorizeViewController alloc]init];
    UINavigationController *navC = [[UINavigationController alloc]initWithRootViewController:authVC];
    [self presentViewController:navC animated:YES completion:nil];
    authVC.block = ^(){
        [self AccessToRootVC];
    };
}
//腾讯认证
-(void)LogTencentWeibo{
    [_txwbapi loginWithDelegate:self andRootController:self];
}
//进入主视图
-(void)AccessToRootVC{
     [self presentViewController:(UIViewController *)[RootViewController sharedRootViewController].ddMenu animated:YES completion:nil];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark WeiboAuthDelegate
/**
 * @brief   授权成功后的回调
 * @param   INPUT   wbapi 成功后返回的WeiboApi对象，accesstoken,openid,refreshtoken,expires 等授权信息都在此处返回
 * @return  无返回
 */
- (void)DidAuthFinished:(WeiboApiObject *)wbobj
{
    //NSString *str = [[NSString alloc]initWithFormat:@"accesstoken = %@\r\n openid = %@\r\n appkey=%@ \r\n appsecret=%@ \r\n refreshtoken=%@ ", wbobj.accessToken, wbobj.openid, wbobj.appKey, wbobj.appSecret, wbobj.refreshToken];
    //NSLog(@"result = %@",str);
    //设置当前微博
    [[SelectedWeiboName sharedWeiboName].weiboArray addObject:@"腾讯微博"];
    [SelectedWeiboName sharedWeiboName].weiboName = @"腾讯微博";
    //保存
    NSUserDefaults *tencentData = [NSUserDefaults standardUserDefaults];
    [tencentData setObject:wbobj.accessToken forKey:@"tencentToken"];
    [tencentData setObject:wbobj.openid forKey:@"tencentUid"];
    //同步到磁盘
    [tencentData synchronize];
    //注意回到主线程，有些回调并不在主线程中，所以这里必须回到主线程
    dispatch_async(dispatch_get_main_queue(), ^{
        //进入下一级视图
        [self AccessToRootVC];
    });
}

/**
 * @brief   授权成功后的回调
 * @param   INPUT   error   标准出错信息
 * @return  无返回
 */
- (void)DidAuthFailWithError:(NSError *)error
{
    NSString *str = [[NSString alloc] initWithFormat:@"get token error, errcode = %@",error.userInfo];
    NSLog(@"%@",str);
    //注意回到主线程，有些回调并不在主线程中，所以这里必须回到主线程
    dispatch_async(dispatch_get_main_queue(), ^{
    });
}

@end
