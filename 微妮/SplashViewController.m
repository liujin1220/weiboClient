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

#define kWeiboReLogin @"kWeiboReLogin"
#define kGETTOKENINFO @"https://api.weibo.com/oauth2/get_token_info"

@interface SplashViewController (){
}
@end

@implementation SplashViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
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
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewDidAppear:(BOOL)animated{
    //检查新浪微博token有效性
    [self checkAuthValid];
}

#pragma mark - accessAction
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
#pragma mark - check
//新浪微博token有效性判断
-(void)checkAuthValid{
    NSUserDefaults *userData = [NSUserDefaults standardUserDefaults];
    if ([[userData objectForKey:@"token"] length] != 0) {
        //有账号，判断
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/plain"];
        NSDictionary *parameters = @{@"access_token": [userData objectForKey:@"token"]};
        [manager POST:kGETTOKENINFO parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            //NSLog(@"JSON: %@", responseObject);
            NSString *requestTmp = [NSString stringWithString:operation.responseString];
            NSData *resData = [[NSData alloc] initWithData:[requestTmp dataUsingEncoding:NSUTF8StringEncoding]];
            //将json数据转化为字典
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:resData options:NSJSONReadingMutableLeaves error:nil];//NSJSONSerialization提供了将JSON数据转换为Foundation对象（一般都是NSDictionary和NSArray）
            
            if ([dic objectForKey:@"expire_in"] >= 0) {
                //有效
                [[SelectedWeiboName sharedWeiboName].weiboArray addObject:@"新浪微博"];
            }
            //重刷腾讯微博
            [self refreshTencentWeibo];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@", error);
        }];
    }else{
        //重刷腾讯微博
        [self refreshTencentWeibo];
    }
}
//重刷腾讯微博
-(void)refreshTencentWeibo{
    NSUserDefaults *userData = [NSUserDefaults standardUserDefaults];
    if ([[userData objectForKey:@"refresh_token"] length] != 0) {
        NSString *requestStr = [NSString stringWithFormat:@"https://open.t.qq.com/cgi-bin/oauth2/access_token?client_id=%@&grant_type=refresh_token&refresh_token=%@",KTAppKey,[userData objectForKey:@"refresh_token"]];
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"application/x-www-form-urlencoded"];
        //跳过解析成json的步骤
        manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        [manager GET:requestStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            //NSLog(@"JSON: %@", responseObject);
            NSString *str = operation.responseString;
            //腾讯微博
            //获取access_token、refresh_token和openid
            //找到" access_token= "的range
            NSRange range_token = [str rangeOfString:@"access_token="];
            NSString *token = [str substringWithRange:NSMakeRange(range_token.location+range_token.length, 32)];
            
            NSRange range_refresh = [str rangeOfString:@"refresh_token="];
            NSString *refresh = [str substringWithRange:NSMakeRange(range_refresh.location+range_refresh.length, 32)];
            
            NSUserDefaults *userData = [NSUserDefaults standardUserDefaults];
            [userData setObject:token forKey:@"tencent_token"];
            [userData setObject:refresh forKey:@"refresh_token"];
            //同步到磁盘
            [userData synchronize];
            
            [[SelectedWeiboName sharedWeiboName].weiboArray addObject:@"腾讯微博"];
            //设置当前微博
            [SelectedWeiboName sharedWeiboName].weiboName = [[SelectedWeiboName sharedWeiboName].weiboArray objectAtIndex:0];
            //进入主视图
            [self accessToHomePage];
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@", error);
            //NSLog(@"%@",operation.responseString);
        }];
    }else{
        //进入登录页面
        [self accessToLoginView];
    }
}

@end
