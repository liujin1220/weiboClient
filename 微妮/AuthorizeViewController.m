//
//  AuthorizeViewController.m
//  微妮
//
//  Created by 刘锦 on 14-10-15.
//  Copyright (c) 2014年 liujin. All rights reserved.
//

#import "AuthorizeViewController.h"
#import "SelectedWeiboName.h"
#define KACCESSTOKEN @"https://api.weibo.com/oauth2/access_token"

@interface AuthorizeViewController ()

@end

@implementation AuthorizeViewController

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
    //导航
    self.navigationItem.title = @"授权";
    self.navigationItem.leftBarButtonItem =  [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancelAction)];
    _mwebView = [[UIWebView  alloc]initWithFrame:self.view.frame];
    _mwebView.delegate = self;
    _mwebView.scalesPageToFit = YES;//自动对页面进行缩放以适应屏幕
    [self.view addSubview:_mwebView];
//    _mwebView.layer.cornerRadius = 10.0;
//    _mwebView.layer.borderWidth = 2.0;
    NSString *authriseURL = [NSString stringWithFormat:
                             @"https://api.weibo.com/oauth2/authorize?client_id=%@&redirect_uri=%@&response_type=code",KSAppKey,KSAppRedirectURL];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:authriseURL]];
    [_mwebView loadRequest:request];
}
-(void)cancelAction{
    //取消
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIWebViewDelegate
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSString *tokenstring = webView.request.URL.absoluteString;
    NSLog(@"%@",tokenstring);
    if ([tokenstring hasPrefix:KSAppRedirectURL]) {
        //找到"code = "的range
        NSRange rangeone = [tokenstring rangeOfString:@"code="];
        //确定参数的值range
        NSRange range = NSMakeRange(rangeone.length+rangeone.location, tokenstring.length-(rangeone.length+rangeone.location));
        //获取code的值
        NSString *code = [tokenstring substringWithRange:range];
        NSLog(@"code = %@",code);
        //请求token
        [self requestSinaAccessToken:code];
    }
}

#pragma mark - ASIFormDataRequest
//根据code请求到token
-(void)requestSinaAccessToken:(NSString *)code{
    //请求
    NSURL *requestURL = [NSURL URLWithString:KACCESSTOKEN];
    ASIFormDataRequest *requestForm = [[ASIFormDataRequest alloc]initWithURL:requestURL];
    //设置包体（参数）
    [requestForm setPostValue:KSAppKey forKey:@"client_id"];
    [requestForm setPostValue:KSAppSecret forKey:@"client_secret"];
    [requestForm setPostValue:@"authorization_code" forKey:@"grant_type"];
    [requestForm setPostValue:code forKey:@"code"];
    [requestForm setPostValue:KSAppRedirectURL forKey:@"redirect_uri"];
    //设置代理
    [requestForm setDelegate:self];
    //开始异步请求
    [requestForm startAsynchronous];
}
#pragma mark - ASIHTTPRequestDelegate
- (void)requestFinished:(ASIHTTPRequest *)request{
    //将json数据转化为字典
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:[request responseData] options:NSJSONReadingMutableLeaves error:nil];//NSJSONSerialization提供了将JSON数据转换为Foundation对象（一般都是NSDictionary和NSArray）
    //保存
    NSUserDefaults *sinaData = [NSUserDefaults standardUserDefaults];
    [sinaData setObject:[dic objectForKey:@"access_token"] forKey:@"token"];
    [sinaData setObject:[dic objectForKey:@"uid"] forKey:@"uid"];
    //同步到磁盘
    [sinaData synchronize];
    //设置当前微博
    [[SelectedWeiboName sharedWeiboName].weiboArray addObject:@"新浪微博"];
    [SelectedWeiboName sharedWeiboName].weiboName = @"新浪微博";
    
    //成功
    [self dismissViewControllerAnimated:YES completion:nil];
    self.block();
}
- (void)requestFailed:(ASIHTTPRequest *)request{
    NSError *error = [request error];
    NSString *str = [[NSString alloc] initWithFormat:@"get token error, errcode = %@",error.userInfo];
    //输出错误信息
    NSLog(@"%@",str);
}
@end
