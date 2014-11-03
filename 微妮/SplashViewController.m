//
//  SplashViewController.m
//  微妮
//
//  Created by 刘锦 on 14-10-16.
//  Copyright (c) 2014年 liujin. All rights reserved.
//

#import "SplashViewController.h"
#import "LogViewController.h"
#import "RootViewController.h"
#import "SelectedWeiboName.h"

#define kGETTOKENINFO @"https://api.weibo.com/oauth2/get_token_info"
@interface SplashViewController ()

@end

@implementation SplashViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
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
    self.view.backgroundColor = [UIColor whiteColor];
    
    if(self.wbapi == nil)
    {
        self.wbapi = [[WeiboApi alloc]initWithAppKey:KTAppKey andSecret:KTAppSecret andRedirectUri:REDIRECTURI andAuthModeFlag:0 andCachePolicy:0] ;
    }
    
    UILabel *welcome = [[UILabel alloc]initWithFrame:CGRectMake(0, 100, self.view.bounds.size.width, 50)];
    [welcome setText:@"欢迎使用微妮"];
    [welcome setTextAlignment:NSTextAlignmentCenter];
    [self.view addSubview:welcome];
}
- (void)viewDidAppear:(BOOL)animated{
    //检查新浪微博token有效性
    [self checkAuthValid];
}

//新浪微博token有效性判断
-(void)checkAuthValid{
    NSUserDefaults *sinaData = [NSUserDefaults standardUserDefaults];
    if ([[sinaData objectForKey:@"token"] length] != 0) {
        //有账号，判断
        NSURL *urlString = [NSURL URLWithString:kGETTOKENINFO];
        ASIFormDataRequest *requestForm = [[ASIFormDataRequest alloc]initWithURL:urlString];
        [requestForm setPostValue:[sinaData objectForKey:@"token"] forKey:@"access_token"];
        [requestForm setDelegate:self];
        [requestForm startAsynchronous];
    }else{
        //判断腾讯微博
        [_wbapi checkAuthValid:TCWBAuthCheckServer andDelegete:self];
    }
}
//进入主页面
-(void)accessToHomePage{
    [self presentViewController:(UIViewController *)[RootViewController sharedRootViewController].ddMenu animated:YES completion:nil];
}
//进入登陆页面
-(void)accessToLoginView{
    //登陆
    LogViewController *logVC = [[LogViewController alloc]init];
    [self presentViewController:logVC animated:YES completion:nil];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - WeiboAuthDelegate
/**
 * @brief   选择使用服务器验证token有效性（checkAuthValid）时，需实现此回调
 * @param   INPUT   bResult   检查结果，yes 为有效，no 为无效
 * @param   INPUT   strSuggestion 当bResult 为no 时，此参数为建议。
 * @return  无返回
 */
-(void)didCheckAuthValid:(BOOL)bResult suggest:(NSString *)strSuggestion
{
    NSString *str = [[NSString alloc] initWithFormat:@"ret=%d, suggestion = %@", bResult, strSuggestion];
    NSLog(@"腾讯微博授权有效性判断%@",str);
    if (bResult) {
        //加
        [[SelectedWeiboName sharedWeiboName].weiboArray addObject:@"腾讯微博"];
    }
    //注意回到主线程，有些回调并不在主线程中，所以这里必须回到主线程
    dispatch_async(dispatch_get_main_queue(), ^{
        //判断loginWeiboName是否为空
        if ([[SelectedWeiboName sharedWeiboName].weiboArray count] == 0) {
            //进入登陆页面
            [self accessToLoginView];
        }else{
            //进入主页面
            //设置当前微博
            [SelectedWeiboName sharedWeiboName].weiboName = [[SelectedWeiboName sharedWeiboName].weiboArray objectAtIndex:0];
            [self accessToHomePage];
        }
    });
}
#pragma mark - ASIHTTPRequestDelegate
- (void)requestFinished:(ASIHTTPRequest *)request{
    //将json数据转化为字典
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:[request responseData] options:NSJSONReadingMutableLeaves error:nil];//NSJSONSerialization提供了将JSON数据转换为Foundation对象（一般都是NSDictionary和NSArray）
    NSLog(@"%@",dic);
    if ([dic objectForKey:@"expire_in"] >= 0) {
        //有效
        [[SelectedWeiboName sharedWeiboName].weiboArray addObject:@"新浪微博"];
    }
    //判断腾讯微博
    [_wbapi checkAuthValid:TCWBAuthCheckServer andDelegete:self];
}
- (void)requestFailed:(ASIHTTPRequest *)request{
    
}
@end
