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
#import "WeiboApi.h"
@class SinaCell;
@class tencentCell;
@interface HomeViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate,PullTableViewDelegate,ASIHTTPRequestDelegate,WeiboRequestDelegate>

@property(nonatomic,strong)PullTableView *pullTableView;
@property(nonatomic,retain)NSMutableArray *weiboData;
@end
