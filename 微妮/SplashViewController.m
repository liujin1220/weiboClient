//
//  SplashViewController.m
//  微妮
//
//  Created by 刘锦 on 14-10-16.
//  Copyright (c) 2014年 liujin. All rights reserved.
//

#import "SplashViewController.h"
#import "DDMenuController.h"
#import "CustomTabBarViewController.h"
#import "AuthorizeData.h"
#import "LogViewController.h"
#import "RootViewController.h"

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
    UILabel *welcome = [[UILabel alloc]initWithFrame:CGRectMake(0, 100, self.view.bounds.size.width, 50)];
    [welcome setText:@"欢迎使用微妮"];
    [welcome setTextAlignment:NSTextAlignmentCenter];
    [self.view addSubview:welcome];
    //DDMenu
    DDMenuController *menu = [[DDMenuController alloc]init];
    CustomTabBarViewController *tab = [[CustomTabBarViewController alloc]init];
    menu.rootViewController = tab;
    [RootViewController sharedRootViewController].ddMenu =  menu;
}
- (void)viewDidAppear:(BOOL)animated{
     //判断授权是否有效
     [self isValid];
}
-(void)isValid{
    //判断腾讯微博
    NSString *tencentToken = [AuthorizeData sharedAuthorizeData].tencentToken;
    NSString *sinaToken = [AuthorizeData sharedAuthorizeData].sinaToken;
    if (![self isBlankString:tencentToken]) {
        //进入下一级视图
        [self accessToHomePage];
    }else if([self isBlankString:sinaToken]){
        //进入下一级视图
        [self accessToLoginView];
    }else{
        //判断新浪微博
        NSURL *urlString = [NSURL URLWithString:kGETTOKENINFO];
        ASIFormDataRequest *requestForm = [[ASIFormDataRequest alloc]initWithURL:urlString];
        [requestForm setPostValue:[AuthorizeData sharedAuthorizeData].sinaToken forKey:@"access_token"];
        [requestForm setDelegate:self];
        [requestForm startAsynchronous];
    }
}
- (BOOL) isBlankString:(NSString *)string {
    if (string == nil || string == NULL) {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        return YES;
    }
    return NO;
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

#pragma mark - ASIHTTPRequestDelegate
- (void)requestFinished:(ASIHTTPRequest *)request{
    //将json数据转化为字典
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:[request responseData] options:NSJSONReadingMutableLeaves error:nil];//NSJSONSerialization提供了将JSON数据转换为Foundation对象（一般都是NSDictionary和NSArray）
    NSLog(@"%@",dic);
    if ([dic objectForKey:@"expire_in"] >= 0) {
        //
        [self accessToHomePage];
    }else{
        [self accessToLoginView];
    }
}
- (void)requestFailed:(ASIHTTPRequest *)request{
    
}
@end
