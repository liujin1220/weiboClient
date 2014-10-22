//
//  AuthorizeViewController.h
//  微妮
//
//  Created by 刘锦 on 14-10-15.
//  Copyright (c) 2014年 liujin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CONSTS.h"
#import "RootViewController.h"
#import "ASIFormDataRequest.h"
@class AuthorizeData;
@class SelectedWeiboName;
@interface AuthorizeViewController : UIViewController<UIWebViewDelegate,ASIHTTPRequestDelegate>

@property(nonatomic,strong)UIWebView *mwebView;
@end
