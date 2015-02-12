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

@end
