//
//  PersonalModel.m
//  微妮
//
//  Created by liujin on 15-2-10.
//  Copyright (c) 2015年 liujin. All rights reserved.
//

#import "PersonalModel.h"

@implementation PersonalModel
- (void)setContentData:(NSDictionary *)dic{
    /*dic
     *  screen_name:昵称
     *  avatar_large：头像
     *  gender:性别
     *  description:描述
     *  location:所在地
     *  （BOOL)verified：是否加V
     *  followers_count：粉丝数
     *  friends_count：关注数
     *  statuses_count:微博数
     *  bi_followers_count：互粉
     
     */
    self.headUrl = [NSString stringWithFormat:@"%@",[dic objectForKey:@"avatar_large"]];
    self.nick = [NSString stringWithFormat:@"%@",[dic objectForKey:@"screen_name"]];
    self.attentionCount = [NSString stringWithFormat:@"%@",[dic objectForKey:@"friends_count"]];
    self.followersCount = [NSString stringWithFormat:@"%@",[dic objectForKey:@"followers_count"]];
    self.biFollowerscount = [NSString stringWithFormat:@"%@",[dic objectForKey:@"bi_followers_count"]];
    self.weiboCount = [NSString stringWithFormat:@"%@",[dic objectForKey:@"statuses_count"]];
    self.gender = [NSString stringWithFormat:@"%@",[[dic objectForKey:@"gender"] isEqualToString:@"f"] ? @"女" : @"男"];
    self.location = [NSString stringWithFormat:@"%@",[dic objectForKey:@"location"]];
    self.descripition = [NSString stringWithFormat:@"%@",[dic objectForKey:@"description"]];
    self.isVerified = [NSString stringWithFormat:@"%@",[dic objectForKey:@"verified"]];
;
}
@end
