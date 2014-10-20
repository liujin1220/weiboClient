//
//  SplashViewController.h
//  微妮
//
//  Created by 刘锦 on 14-10-16.
//  Copyright (c) 2014年 liujin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeiboApi.h"
#import "ASIFormDataRequest.h"
@class DDMenuController;
@class RootViewController;
@class AuthorizeData;
@class LogViewController;
@class CustomTabBarViewController;

@interface SplashViewController : UIViewController<WeiboAuthDelegate,ASIHTTPRequestDelegate>
@property (nonatomic , strong) WeiboApi      *wbapi;
@end
