//
//  PersonalModel.h
//  微妮
//
//  Created by liujin on 15-2-10.
//  Copyright (c) 2015年 liujin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PersonalModel : NSObject

@property (nonatomic, strong) NSString *headUrl;            // 头像
@property (nonatomic, strong) NSString *nick;               // 昵称

@property (nonatomic, strong) NSString *attentionCount;     // 关注
@property (nonatomic, strong) NSString *followersCount;     // 粉丝
@property (nonatomic, strong) NSString *biFollowerscount;   // 互粉数
@property (nonatomic, strong) NSString *weiboCount;         // 微博数

@property (nonatomic, strong) NSString *gender;             // 性别
@property (nonatomic, strong) NSString *location;           // 所在地
@property (nonatomic ,strong) NSString *descripition;       // 描述
@property (nonatomic, strong) NSString *isVerified;         // 是否加V用户

- (void)setContentData:(NSDictionary *)dic;
@end
