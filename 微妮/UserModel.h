//
//  userModel.h
//  微妮
//
//  Created by 刘锦 on 14/11/11.
//  Copyright (c) 2014年 liujin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserModel : NSObject
//头像
@property(nonatomic,strong)NSString *headImageUrl;
//昵称
@property(nonatomic,strong)NSString *nick;
//时间
@property(nonatomic,strong)NSString *time;
//来源
@property(nonatomic,strong)NSString *source;
//正文
@property(nonatomic,strong)NSString *mainBody;
//图片
@property(nonatomic,strong)NSArray *picUrls;
//转发的内容
@property(nonatomic,strong)NSString *retweetedText;
//转发的图片
@property(nonatomic,strong)NSArray *retweetedPicUrls;

/*
 * @brief   填充数据
 * @param   INPUT   dict 微博数据，name 微博名称
 * @return  无返回
*/
-(void)setContentData:(NSDictionary *)dict WithWeiboName:(NSString *)name;
@end
