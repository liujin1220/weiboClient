//
//  AuthorizeViewController.m
//  微妮
//
//  Created by 刘锦 on 14-10-15.
//  Copyright (c) 2014年 liujin. All rights reserved.
//

#import "AuthorizeViewController.h"
#import "SelectedWeiboName.h"
#import "ResponseParseMarco.h"

// 新浪
#define kSinaAccessTokenUrl         @"https://api.weibo.com/oauth2/access_token?"
#define kSinaCodeUrl                @"https://api.weibo.com/oauth2/authorize?"
// 腾讯
#define kTencentAccessTokenUrl      @"https://open.t.qq.com/cgi-bin/oauth2/access_token?"
#define kTencentCodeUrl             @"https://open.t.qq.com/cgi-bin/oauth2/authorize?"

@interface AuthorizeViewController () {
    NSString *_authriseURL;     // 请求code的url
    NSString *_accessTokenURL;  // 请求token的url
    NSString *_appKey;          // Appkey
    NSString *_appSecret;       // AppSecret
    NSString *_appRedirectURL;  // AppRedirectURL
}
@property (nonatomic, strong) UIWebView *mwebView;
@property (nonatomic, strong) NSString  *weiboName;

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

- (instancetype)initWithWeiboName:(NSString *)weiboName {
    self = [super init];
    if (self) {
        _weiboName = [[NSString alloc]initWithString:weiboName];
        [self setDataInfo:_weiboName];
    }
    return self;
}

-(void)setDataInfo:(NSString *)name {
    if ([name isEqualToString:@"新浪微博"]) {
        _authriseURL = kSinaCodeUrl;
        _accessTokenURL = kSinaAccessTokenUrl;
        _appKey = kSAppKey;
        _appSecret = kSAppSecret;
        _appRedirectURL = kSAppRedirectUrl;
    }else{
        _authriseURL = kTencentCodeUrl;
        _accessTokenURL = kTencentAccessTokenUrl;
        _appKey = kTAppKey;
        _appSecret = kTAppSecret;
        _appRedirectURL = kTAppRedirectUrl;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // 导航
    self.navigationItem.title = @"授权";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancelAction)];
    // WebView
    self.mwebView = [[UIWebView alloc]initWithFrame:self.view.frame];
    self.mwebView.delegate = self;
    self.mwebView.scalesPageToFit = YES;    // 自动对页面进行缩放以适应屏幕
    [self.view addSubview:_mwebView];
    // 请求
    NSString* authriseStr = [NSString stringWithFormat:
                   @"%@client_id=%@&redirect_uri=%@&response_type=code",_authriseURL,_appKey,_appRedirectURL];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:authriseStr]];
    [_mwebView loadRequest:request];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

/**
 *  取消授权
 */
-(void)cancelAction{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UIWebViewDelegate

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSString *tokenstring = webView.request.URL.absoluteString;
    if ([tokenstring hasPrefix:_appRedirectURL]) {
        // 找到"code = "的range
        NSRange rangeone = [tokenstring rangeOfString:@"code="];
        
        // 确定参数的值range
        NSRange range = NSMakeRange(rangeone.length+rangeone.location, tokenstring.length-(rangeone.length+rangeone.location));
        
        // 获取code的值
        NSString *code = [tokenstring substringWithRange:range];
        
        // 请求token
        [self requestAccessToken:code];
    }
}

#pragma mark - ASIFormDataRequest

/**
 *  新浪微博根据code请求到token----POST
 *
 *  @param code 请求的code
 */
-(void)requestAccessToken:(NSString *)code {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *parameters = @{@"client_id" : _appKey,
                                 @"client_secret" : _appSecret ,
                                 @"grant_type" : @"authorization_code",
                                 @"code" : code, @"redirect_uri" : _appRedirectURL};
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager POST:_accessTokenURL parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *responseString = [NSString stringWithString:operation.responseString];
        NSUserDefaults *userData = [NSUserDefaults standardUserDefaults];
        if ([_weiboName isEqualToString:@"新浪微博"]){
            // 新浪微博
            NSString *requestTmp = [NSString stringWithString:operation.responseString];
            NSData *responseData = [[NSData alloc] initWithData:[requestTmp dataUsingEncoding:NSUTF8StringEncoding]];
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableLeaves error:nil];
            if (![dic isKindOfClass:[NSNull class]]) {
                // 保存uid与access_token至UserDefault
                [userData setObject:[dic objectForKey:@"access_token"] forKey:@"token"];
                [userData setObject:[dic objectForKey:@"uid"] forKey:@"uid"];
            }
            
        }else{
            // 腾讯微博
            // 获取access_token、refresh_token和openid
            NSRange range_token = [responseString rangeOfString:@"access_token="];
            NSString *token = [responseString substringWithRange:NSMakeRange(range_token.location+range_token.length, 32)];
            NSRange range_refresh = [responseString rangeOfString:@"refresh_token="];
            NSString *refresh = [responseString substringWithRange:NSMakeRange(range_refresh.location+range_refresh.length, 32)];
            NSRange range_openid = [responseString rangeOfString:@"openid="];
            NSString *openid = [responseString substringWithRange:NSMakeRange(range_openid.location+range_openid.length, 32)];
            
            // 保存至UserDefault
            [userData setObject:token forKey:@"tencent_token"];
            [userData setObject:openid forKey:@"openid"];
            [userData setObject:refresh forKey:@"refresh_token"];
        }
        
        // 同步到磁盘
        [userData synchronize];
        
        // 设置当前微博
        [[SelectedWeiboName sharedWeiboName].weiboArray addObject:_weiboName];
        [SelectedWeiboName sharedWeiboName].weiboName = _weiboName;
        
        // 成功
        [self dismissViewControllerAnimated:YES completion:nil];
        self.block();

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

@end
