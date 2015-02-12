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
#import "AFHTTPRequestOperationManager.h"
@class AuthorizeData;
@class SelectedWeiboName;

typedef void (^weiboAuthorized)();

@interface AuthorizeViewController : UIViewController<UIWebViewDelegate>

@property (nonatomic, strong) weiboAuthorized block;

/**
 *  认证页面初始化
 *
 *  @param weiboName 微博名称
 *
 *  @return 对象
 */
- (instancetype)initWithWeiboName:(NSString *)weiboName;

@end
