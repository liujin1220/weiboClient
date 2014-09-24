//
//  LogViewController.m
//  微妮
//
//  Created by 刘锦 on 14-9-15.
//  Copyright (c) 2014年 liujin. All rights reserved.
//

#import "LogViewController.h"
#import "BlockButton.h"
#define KICONWIDTH 80
#define KLOGINBUTTON 100

@interface LogViewController ()
@property(nonatomic,strong)UIImageView *iconImageView;
@property(nonatomic,strong)BlockButton *loginButton;
@property(nonatomic,strong)UILabel *usernameLabel;
@end

@implementation LogViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)loadView{
    [super loadView];
    //图标
    _iconImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"me_head_default.png"]];
    _iconImageView.layer.cornerRadius = KICONWIDTH/2;
    _iconImageView.layer.masksToBounds = YES;
    [self.view addSubview:_iconImageView];
    //登陆、注册
    _loginButton = [BlockButton buttonWithType:UIButtonTypeRoundedRect];
    [_loginButton setTitle:@"登陆/注册" forState:UIControlStateNormal];
    __block LogViewController *blockself = self;
    __block WeiboApi *wbapi = _txwbapi;
    _loginButton.block = ^(BlockButton *button){
        //进行登陆操作
        [wbapi loginWithDelegate:blockself andRootController:blockself];
    };
    [self.view addSubview:_loginButton];
    //用户名
    _usernameLabel = [[UILabel alloc]init];
    [_usernameLabel setFont:[UIFont systemFontOfSize:15]];
    [_usernameLabel setTextAlignment:NSTextAlignmentCenter];
    [self.view addSubview:_usernameLabel];
}
-(void)setContent{
    [_iconImageView setFrame:CGRectMake((KDEVICEWIDTH-KICONWIDTH)/2.0, KDEVICEHEIGHT/4.0, KICONWIDTH, KICONWIDTH)];
    [_loginButton setFrame:CGRectMake((self.view.bounds.size.width - KLOGINBUTTON)/2.0, KDEVICEHEIGHT/4.0 +KICONWIDTH+ 10, KLOGINBUTTON, 50)];
   }
- (void)viewDidLoad
{
    [super viewDidLoad];
    if(self.txwbapi == nil)
    {
        self.txwbapi = [[WeiboApi alloc]initWithAppKey:KTAppKey andSecret:KTAppSecret andRedirectUri:REDIRECTURI andAuthModeFlag:0 andCachePolicy:0] ;
    }

    [self setContent];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)showMsg:(NSString *)msg
{
}
#pragma mark WeiboRequestDelegate

/**
 * @brief   接口调用成功后的回调
 * @param   INPUT   data    接口返回的数据
 * @param   INPUT   request 发起请求时的请求对象，可以用来管理异步请求
 * @return  无返回
 */
- (void)didReceiveRawData:(NSData *)data reqNo:(int)reqno
{
    NSString *strResult = [[NSString alloc] initWithBytes:[data bytes] length:[data length] encoding:NSUTF8StringEncoding];
    
    NSLog(@"result = %@",strResult);
    
    //注意回到主线程，有些回调并不在主线程中，所以这里必须回到主线程
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self showMsg:strResult];
    });
    
}
/**
 * @brief   接口调用失败后的回调
 * @param   INPUT   error   接口返回的错误信息
 * @param   INPUT   request 发起请求时的请求对象，可以用来管理异步请求
 * @return  无返回
 */
- (void)didFailWithError:(NSError *)error reqNo:(int)reqno
{
    NSString *str = [[NSString alloc] initWithFormat:@"refresh token error, errcode = %@",error.userInfo];
    
    //注意回到主线程，有些回调并不在主线程中，所以这里必须回到主线程
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self showMsg:str];
    });
}



#pragma mark WeiboAuthDelegate

/**
 * @brief   重刷授权成功后的回调
 * @param   INPUT   wbapi 成功后返回的WeiboApi对象，accesstoken,openid,refreshtoken,expires 等授权信息都在此处返回
 * @return  无返回
 */
- (void)DidAuthRefreshed:(WeiboApiObject *)wbobj
{
    
    
    //UISwitch
    NSString *str = [[NSString alloc]initWithFormat:@"accesstoken = %@\r openid = %@\r appkey=%@ \r appsecret=%@\r",wbobj.accessToken, wbobj.openid, wbobj.appKey, wbobj.appSecret];
    
    NSLog(@"result = %@",str);
    
    //注意回到主线程，有些回调并不在主线程中，所以这里必须回到主线程
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self showMsg:str];
    });
    
}

/**
 * @brief   重刷授权失败后的回调
 * @param   INPUT   error   标准出错信息
 * @return  无返回
 */
- (void)DidAuthRefreshFail:(NSError *)error
{
    NSString *str = [[NSString alloc] initWithFormat:@"refresh token error, errcode = %@",error.userInfo];
    
    //注意回到主线程，有些回调并不在主线程中，所以这里必须回到主线程
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self showMsg:str];
    });
}

/**
 * @brief   授权成功后的回调
 * @param   INPUT   wbapi 成功后返回的WeiboApi对象，accesstoken,openid,refreshtoken,expires 等授权信息都在此处返回
 * @return  无返回
 */
- (void)DidAuthFinished:(WeiboApiObject *)wbobj
{
    NSString *str = [[NSString alloc]initWithFormat:@"accesstoken = %@\r\n openid = %@\r\n appkey=%@ \r\n appsecret=%@ \r\n refreshtoken=%@ ", wbobj.accessToken, wbobj.openid, wbobj.appKey, wbobj.appSecret, wbobj.refreshToken];
    
    NSLog(@"result = %@",str);
    
    //注意回到主线程，有些回调并不在主线程中，所以这里必须回到主线程
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self showMsg:str];
    });
    
    
    // NSLog(@"after add pic");
}

/**
 * @brief   授权成功后的回调
 * @param   INPUT   wbapi   weiboapi 对象，取消授权后，授权信息会被清空
 * @return  无返回
 */
- (void)DidAuthCanceled:(WeiboApi *)wbapi_
{
    
}

/**
 * @brief   授权成功后的回调
 * @param   INPUT   error   标准出错信息
 * @return  无返回
 */
- (void)DidAuthFailWithError:(NSError *)error
{
    NSString *str = [[NSString alloc] initWithFormat:@"get token error, errcode = %@",error.userInfo];
    
    //注意回到主线程，有些回调并不在主线程中，所以这里必须回到主线程
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self showMsg:str];
    });
}

/**
 * @brief   授权成功后的回调
 * @param   INPUT   error   标准出错信息
 * @return  无返回
 */
-(void)didCheckAuthValid:(BOOL)bResult suggest:(NSString *)strSuggestion
{
    NSString *str = [[NSString alloc] initWithFormat:@"ret=%d, suggestion = %@", bResult, strSuggestion];
    //注意回到主线程，有些回调并不在主线程中，所以这里必须回到主线程
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self showMsg:str];
    });
}


@end
