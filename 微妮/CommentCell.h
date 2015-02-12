//
//  CommentCell.h
//  微妮
//
//  Created by 刘锦 on 14/11/13.
//  Copyright (c) 2014年 liujin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIButton+WebCache.h"
#import "SelectedWeiboName.h"
@class CommentModel;
@class RTLabel;

@interface CommentCell : UITableViewCell

/*
 * @brief   填充数据
 * @param   INPUT   dict 微博数据
 * @return  无返回
 */
- (void)setContentData:(NSDictionary *)dict;

/*
 * @brief   计算高度
 * @param   INPUT   dict 微博数据,name 微博名称
 * @return  无返回
 */
+ (int)heightWith:(NSMutableDictionary*)dict WithWeiboName:(NSString *)name;

@end
