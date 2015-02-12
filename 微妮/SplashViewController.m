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
#define kGetTokenInfo @"https://api.weibo.com/oauth2/get_token_info"

@interface SplashViewController ()

@end

@implementation SplashViewController

#pragma mark - lifeCircle

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
    // 检查微博access_token有效期
    [self checkOAuthValid];
}

#pragma mark - accessAction

/**
 *  进入主界面
 */
- (void)accessToHomePage{
    [self presentViewController:(UIViewController *)[RootViewController sharedRootViewController].ddMenu animated:YES completion:nil];
}

/**
 *  进入登陆界面
 */
- (void)accessToLoginView{
    LogViewController *logVC = [[LogViewController alloc]init];
    [self presentViewController:logVC animated:YES completion:nil];
}

#pragma mark - checkOAuthValid

/**
 *  access_token有效性判断
 */
- (void)checkOAuthValid{
    dispatch_group_t group = dispatch_group_create();
    dispatch_group_async(group, dispatch_get_global_queue(0, 0), ^{
       //  新浪微博有效性判断
        [self checkSinaWeiboValid];
    });
    dispatch_group_async(group, dispatch_get_global_queue(0, 0), ^{
        // 腾讯微博有效性判断
        [self checkTencentWeiboValid];
    });
    dispatch_group_notify(group, dispatch_get_global_queue(0, 0), ^{
        // 汇总结果
        dispatch_async(dispatch_get_main_queue(), ^{
            // 回到主线程
            if (0 != [SelectedWeiboName sharedWeiboName].weiboArray.count) {
                // 设置当前微博
                [SelectedWeiboName sharedWeiboName].weiboName = [[SelectedWeiboName sharedWeiboName].weiboArray objectAtIndex:0];
                [self accessToHomePage];
            }else {
                [self accessToLoginView];
            }
        });
    });
}

/**
 *  检查新浪微博有效性
 */
- (void)checkSinaWeiboValid{
    NSUserDefaults *userData = [NSUserDefaults standardUserDefaults];
    // 判断账号是否存在
    if ([[userData objectForKey:@"token"] length] != 0) {
        // 第一步，创建URL
        NSURL *url = [NSURL URLWithString:kGetTokenInfo];
        
        // 第二步，创建请求
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
        [request setHTTPMethod:@"POST"];// 设置请求方式为POST
        NSString *parameters = [NSString stringWithFormat:@"access_token=%@",[userData objectForKey:@"token"]];
        NSData *data = [parameters dataUsingEncoding:NSUTF8StringEncoding];
        [request setHTTPBody:data];
        
        // 第三步，连接服务器
        NSError *error;
        NSData *receivedData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&error];
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:receivedData options:NSJSONReadingMutableLeaves error:nil];
        // 新浪微博有效期判断
        if ([dic objectForKey:@"expire_in"] >= 0) {
            [[SelectedWeiboName sharedWeiboName].weiboArray addObject:@"新浪微博"];
        }

//        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//        NSDictionary *parameters = @{@"access_token" : [userData objectForKey:@"token"]};
//        [manager POST:kGetTokenInfo parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
//            NSString *responseString = [NSString stringWithString:operation.responseString];
//            NSData *responseData = [[NSData alloc] initWithData:[responseString dataUsingEncoding:NSUTF8StringEncoding]];
//            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableLeaves error:nil];
//            // 新浪微博有效期判断
//            if ([dic objectForKey:@"expire_in"] >= 0) {
//                [[SelectedWeiboName sharedWeiboName].weiboArray addObject:@"新浪微博"];
//            }
//        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//            NSLog(@"Error: %@", error);
//        }];
    }
}

/**
 *  检查腾讯微博有效性
 */
- (void)checkTencentWeiboValid{
    NSUserDefaults *userData = [NSUserDefaults standardUserDefaults];
    if ([[userData objectForKey:@"refresh_token"] length] != 0) {
        // 第一步，创建URL
        NSString *requestStr = [NSString stringWithFormat:@"https://open.t.qq.com/cgi-bin/oauth2/access_token?client_id=%@&grant_type=refresh_token&refresh_token=%@",kTAppKey,[userData objectForKey:@"refresh_token"]];
        NSURL *url = [NSURL URLWithString:requestStr];
        
        // 第二步，通过URL创建网络请求
        // NSURLRequest初始化方法第一个参数：请求访问路径，第二个参数：缓存协议，第三个参数：网络请求超时时间（秒）
        
        NSURLRequest *request = [[NSURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:10];
        
        // 第三步，连接服务器
        NSError *error;
        NSData *received = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&error];
        NSString *str = [[NSString alloc]initWithData:received encoding:NSUTF8StringEncoding];
        // 获取access_token、refresh_token和openid
        NSRange range_token = [str rangeOfString:@"access_token="];
        NSString *token = [str substringWithRange:NSMakeRange(range_token.location+range_token.length, 32)];
        NSRange range_refresh = [str rangeOfString:@"refresh_token="];
        NSString *refresh = [str substringWithRange:NSMakeRange(range_refresh.location+range_refresh.length, 32)];
        NSUserDefaults *userData = [NSUserDefaults standardUserDefaults];
        // 保存在UserDefault
        [userData setObject:token forKey:@"tencent_token"];
        [userData setObject:refresh forKey:@"refresh_token"];
        [userData synchronize];
        [[SelectedWeiboName sharedWeiboName].weiboArray addObject:@"腾讯微博"];
        
//        NSString *requestStr = [NSString stringWithFormat:@"https://open.t.qq.com/cgi-bin/oauth2/access_token?client_id=%@&grant_type=refresh_token&refresh_token=%@",kTAppKey,[userData objectForKey:@"refresh_token"]];
//        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//        manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"application/x-www-form-urlencoded"];
//        // 跳过解析成json的步骤
//        manager.requestSerializer = [AFHTTPRequestSerializer serializer];
//        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
//        [manager GET:requestStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
//            NSString *str = operation.responseString;
//            // 腾讯微博
//            // 获取access_token、refresh_token和openid
//            NSRange range_token = [str rangeOfString:@"access_token="];
//            NSString *token = [str substringWithRange:NSMakeRange(range_token.location+range_token.length, 32)];
//            NSRange range_refresh = [str rangeOfString:@"refresh_token="];
//            NSString *refresh = [str substringWithRange:NSMakeRange(range_refresh.location+range_refresh.length, 32)];
//            NSUserDefaults *userData = [NSUserDefaults standardUserDefaults];
//            // 保存在UserDefault
//            [userData setObject:token forKey:@"tencent_token"];
//            [userData setObject:refresh forKey:@"refresh_token"];
//            [userData synchronize];
//            [[SelectedWeiboName sharedWeiboName].weiboArray addObject:@"腾讯微博"];
//        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//            NSLog(@"Error: %@", error);
//        }];
    }
}

@end
