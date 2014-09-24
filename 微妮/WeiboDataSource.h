//
//  WeiboDataSource.h
//  微妮
//
//  Created by 刘锦 on 14-9-15.
//  Copyright (c) 2014年 liujin. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^TableViewCellConfigureBlock)(id cell, id item);
@interface WeiboDataSource : NSObject  <UITableViewDataSource>

@end
