//
//  PopView.m
//  PopupViewDemo
//
//  Created by 刘锦 on 14-9-10.
//  Copyright (c) 2014年 liujin. All rights reserved.
//

#import "PopView.h"

#define KAppKey @"3185833614"
#define KAppRedirectURL @"https://api.weibo.com/oauth2/default.html"

@interface PopView ()

@property(nonatomic,strong)UIButton *dismissButton;

@end

@implementation PopView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        _mwebView = [[UIWebView  alloc]init];
        _mwebView.delegate = self;
        _mwebView.scalesPageToFit = YES;//自动对页面进行缩放以适应屏幕
        _mwebView.layer.cornerRadius = 10.0;
        _mwebView.layer.borderWidth = 2.0;
        NSString *authriseURL = [NSString stringWithFormat:
                                 @"https://api.weibo.com/oauth2/authorize?client_id=%@&redirect_uri=%@&response_type=code",KAppKey,KAppRedirectURL];
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:authriseURL]];
        [_mwebView loadRequest:request];
        
        _dismissButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_dismissButton setBackgroundImage:[UIImage imageNamed:@"dismiss"] forState:UIControlStateNormal];
        [_dismissButton addTarget:self action:@selector(dismissAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_mwebView];
        [self addSubview:_dismissButton];
    }
    return self;
}

- (void)dismissAction{
    _block();
}

- (void)layoutSubviews{
    [_dismissButton setFrame:CGRectMake(0, 0, 40, 40)];
    [_mwebView setFrame:CGRectMake(20, 20, self.bounds.size.width-40, self.bounds.size.height-40)];
}

#pragma mark - UIWebViewDelegate
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSString *tokenstring = webView.request.URL.absoluteString;
    NSLog(@"%@",tokenstring);
    if ([tokenstring hasPrefix:KAppRedirectURL]) {
        //找到"code = "的range
        NSRange rangeone = [tokenstring rangeOfString:@"code="];
        //确定参数的值range
        NSRange range = NSMakeRange(rangeone.length+rangeone.location, tokenstring.length-(rangeone.length+rangeone.location));
        //获取code的值
        NSString *code = [tokenstring substringWithRange:range];
        NSLog(@"code = %@",code);
        
        //成功授权，通知主页面进入下一级视图
        [self.delegate SinaOAuthFinishedWithCode:code];
    }
}

@end
