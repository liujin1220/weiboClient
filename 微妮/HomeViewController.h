//
//  HomeViewController.h
//  微妮
//
//  Created by 刘锦 on 14/10/22.
//  Copyright (c) 2014年 liujin. All rights reserved.
//

#import "BaseViewController.h"
#import "SelectedWeiboName.h"
#import "PullTableView.h"
#import "ASIHTTPRequest.h"
#import "CONSTS.h"
@class weiboCell;
@class UserInfoData;

@interface HomeViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate,PullTableViewDelegate>

@end
