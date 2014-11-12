//
//  AuthorizeViewController.m
//  微妮
//
//  Created by 刘锦 on 14-10-15.
//  Copyright (c) 2014年 liujin. All rights reserved.
//

#import "AuthorizeViewController.h"
#import "SelectedWeiboName.h"
//新浪
#define KSINAACCESSTOKENURL @"https://api.weibo.com/oauth2/access_token?"
#define KSINACODEURL @"https://api.weibo.com/oauth2/authorize?"
//腾讯
#define KTENCENTACCESSTOKENURL @"https://open.t.qq.com/cgi-bin/oauth2/access_token?"
#define KTENCENTCODEURL @"https://open.t.qq.com/cgi-bin/oauth2/authorize?"

@interface AuthorizeViewController (){
    //请求code的url
    NSString *authriseURL;
    //请求token的url
    NSString *access_tokenURL;
    //Appkey
    NSString *appKey;
    //AppSecret
    NSString *appSecret;
    //AppRedirectURL
    NSString *appRedirectURL;
}
@property(nonatomic,strong)UIWebView *mwebView;
@property(nonatomic,strong)NSString *weiboName;
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
- (instancetype)initWithWeiboName:(NSString *)weiboName{
    self = [super init];
    if (self) {
        _weiboName = [[NSString alloc]initWithString:weiboName];
        [self setDataInfo:_weiboName];
    }
    return self;
}
-(void)setDataInfo:(NSString *)name{
    if ([name isEqualToString:@"新浪微博"]) {
        authriseURL = KSINACODEURL;
        access_tokenURL = KSINAACCESSTOKENURL;
        appKey = KSAppKey;
        appSecret = KSAppSecret;
        appRedirectURL = KSAppRedirectURL;
    }else{
        authriseURL = KTENCENTCODEURL;
        access_tokenURL = KTENCENTACCESSTOKENURL;
        appKey = KTAppKey;
        appSecret = KTAppSecret;
        appRedirectURL = KTAppRedirectURL;
    }
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

    NSString* authriseStr = [NSString stringWithFormat:
                   @"%@client_id=%@&redirect_uri=%@&response_type=code",authriseURL,appKey,appRedirectURL];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:authriseStr]];
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
    //NSLog(@"%@",tokenstring);
    if ([tokenstring hasPrefix:appRedirectURL]) {
        //找到"code = "的range
        NSRange rangeone = [tokenstring rangeOfString:@"code="];
        //确定参数的值range
        NSRange range = NSMakeRange(rangeone.length+rangeone.location, tokenstring.length-(rangeone.length+rangeone.location));
        //获取code的值
        NSString *code = [tokenstring substringWithRange:range];
        NSLog(@"code = %@",code);
        //请求token
        [self requestAccessToken:code];
    }
}

#pragma mark - ASIFormDataRequest
//新浪微博根据code请求到token----POST
-(void)requestAccessToken:(NSString *)code{
    //请求
    NSURL *requestURL = [NSURL URLWithString:access_tokenURL];
    ASIFormDataRequest *requestForm = [[ASIFormDataRequest alloc]initWithURL:requestURL];
    //设置包体（参数）
    [requestForm setPostValue:appKey forKey:@"client_id"];
    [requestForm setPostValue:appSecret forKey:@"client_secret"];
    [requestForm setPostValue:@"authorization_code" forKey:@"grant_type"];
    [requestForm setPostValue:code forKey:@"code"];
    [requestForm setPostValue:appRedirectURL forKey:@"redirect_uri"];
    //设置代理
    [requestForm setDelegate:self];
    //开始异步请求
    [requestForm startAsynchronous];
}

#pragma mark - ASIHTTPRequestDelegate
- (void)requestFinished:(ASIHTTPRequest *)request{
    NSString *str = [[NSString alloc] initWithData:[request responseData] encoding:NSUTF8StringEncoding];
    NSUserDefaults *userData = [NSUserDefaults standardUserDefaults];
    if ([_weiboName isEqualToString:@"新浪微博"]){
        //新浪微博
        //将json数据转化为字典
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:[request responseData] options:NSJSONReadingMutableLeaves error:nil];//NSJSONSerialization提供了将JSON数据转换为Foundation对象（一般都是NSDictionary和NSArray）
        [userData setObject:[dic objectForKey:@"access_token"] forKey:@"token"];
        [userData setObject:[dic objectForKey:@"uid"] forKey:@"uid"];
    }else{
        //腾讯微博
        NSLog(@"tencnet---%@",str);
        //获取access_token、refresh_token和openid
        //找到" access_token= "的range
        NSRange range_token = [str rangeOfString:@"access_token="];
        NSString *token = [str substringWithRange:NSMakeRange(range_token.location+range_token.length, 32)];
        
        NSRange range_refresh = [str rangeOfString:@"refresh_token="];
        NSString *refresh = [str substringWithRange:NSMakeRange(range_refresh.location+range_refresh.length, 32)];
        
        NSRange range_openid = [str rangeOfString:@"openid="];
        NSString *openid = [str substringWithRange:NSMakeRange(range_openid.location+range_openid.length, 32)];
        
        [userData setObject:token forKey:@"tencent_token"];
        [userData setObject:openid forKey:@"openid"];
        [userData setObject:refresh forKey:@"refresh_token"];
    }
    //同步到磁盘
    [userData synchronize];
    //设置当前微博
    [[SelectedWeiboName sharedWeiboName].weiboArray addObject:_weiboName];
    [SelectedWeiboName sharedWeiboName].weiboName = _weiboName;
    
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
