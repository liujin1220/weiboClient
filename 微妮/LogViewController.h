//
//  LogViewController.h
//  微妮
//
//  Created by 刘锦 on 14-9-15.
//  Copyright (c) 2014年 liujin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RootViewController.h"
#import "SelectView.h"
#import "CONSTS.h"
#import "WeiboApi.h"
#import "AuthorizeViewController.h"
@class AuthorizeData;
@class BlockButton;
@interface LogViewController : UIViewController<WeiboRequestDelegate,WeiboAuthDelegate>
@property (nonatomic , retain) WeiboApi                    *txwbapi;
@property(strong,nonatomic)SelectView *selectView;
@end
