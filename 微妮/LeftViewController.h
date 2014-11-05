//
//  LeftViewController.h
//  微妮
//
//  Created by 刘锦 on 14/10/22.
//  Copyright (c) 2014年 liujin. All rights reserved.
//

#import "BaseViewController.h"
#import "WeiboApi.h"
#import "UIImageView+WebCache.h"
@class SelectedWeiboName;
@class UserInfoData;
@class AuthorizeViewController;
@interface LeftViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,WeiboAuthDelegate>
@property(nonatomic,strong)UITableView *tableView;
@property (nonatomic , retain) WeiboApi                    *txwbapi;
@end
