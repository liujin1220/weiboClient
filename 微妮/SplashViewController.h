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
#import "CONSTS.h"
@class DDMenuController;
@class RootViewController;
@class LogViewController;
@class CustomTabBarViewController;
@class SplashViewController;
@class SelectedWeiboName;

@interface SplashViewController : UIViewController<WeiboAuthDelegate,ASIHTTPRequestDelegate>
@property (nonatomic , strong) WeiboApi      *wbapi;
@end
