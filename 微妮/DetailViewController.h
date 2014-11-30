//
//  DetailViewController.h
//  微妮
//
//  Created by 刘锦 on 14/11/12.
//  Copyright (c) 2014年 liujin. All rights reserved.
//

#import "BaseViewController.h"
#import "PullTableView.h"
@class weiboCell;
@class UserInfoData;
@class CommentCell;
@interface DetailViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate,PullTableViewDelegate>
@property(nonatomic,strong)NSMutableDictionary *singelWeiboData;
@end
