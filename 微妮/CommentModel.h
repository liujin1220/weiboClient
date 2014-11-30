//
//  CommentModel.h
//  微妮
//
//  Created by 刘锦 on 14/11/13.
//  Copyright (c) 2014年 liujin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommentModel : NSObject
@property(nonatomic,strong)NSString *headUrl;//头像
@property(nonatomic,strong)NSString *nick;//昵称
@property(nonatomic,strong)NSString *mainText;
@property(nonatomic,strong)NSString *time;//时间
@property(nonatomic,strong)NSString *source;//来源

/*
 * @brief   填充数据
 * @param   INPUT   dict 微博数据，name 微博名称
 * @return  无返回
 */
-(void)setContentData:(NSDictionary *)dict WithWeiboName:(NSString *)name;
@end
