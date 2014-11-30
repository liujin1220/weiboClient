//
//  CommentModel.m
//  微妮
//
//  Created by 刘锦 on 14/11/13.
//  Copyright (c) 2014年 liujin. All rights reserved.
//

#import "CommentModel.h"

@implementation CommentModel
-(void)setContentData:(NSDictionary *)dict WithWeiboName:(NSString *)name{
    if ([name isEqualToString:@"新浪微博"]) {
        //        created_at	string	评论创建时间
        //        text	string	评论的内容
        //        source	string	评论的来源
        //        user:
        //                    profile_image_url	 string	用户头像地址（中图），50×50像素
        //                    screen_name	string	用户昵称
        _headUrl = [NSString stringWithFormat:@"%@",[[dict objectForKey:@"user"]objectForKey:@"profile_image_url"]];
        _nick = [NSString stringWithFormat:@"%@",[[dict objectForKey:@"user"]objectForKey:@"screen_name"]];
        _time = [NSString stringWithFormat:@"%@",[self formatDaySinaTime:[dict objectForKey:@"created_at"]]];
        _source = [NSString stringWithFormat:@"%@",[dict objectForKey:@"source"]];
        _source = [_source stringByReplacingOccurrencesOfString:@"</a>" withString:@""];
        _source = [_source substringFromIndex:[_source rangeOfString:@">"].location+1];
        _mainText = [NSString stringWithFormat:@"%@",[dict objectForKey:@"text"]];
    }else{
        //        info :
        //        {
        //            text : 微博内容
        //            from : 来源
        //            timestamp : 服务器时间戳
        //            nick : 发表人昵称
        //            head : 发表者头像url
        //        }
        _headUrl = [NSString stringWithFormat:@"%@/50",[dict objectForKey:@"head"]];
        _source = [NSString stringWithFormat:@"%@",[dict objectForKey:@"from"]];
        _nick = [NSString stringWithFormat:@"%@",[dict objectForKey:@"nick"]];
        _mainText = [NSString stringWithFormat:@"%@",[dict objectForKey:@"text"]];
        NSDate *txdate = [NSDate dateWithTimeIntervalSince1970:[(NSNumber *)[dict objectForKey:@"timestamp"] doubleValue]];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"MM-dd HH:mm";
        _time =  [formatter stringFromDate:txdate];
    }
}
//美国时间，处理新浪
-(NSString*)formatDaySinaTime:(NSString*)createAt
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"EEE MMM d HH:mm:ss Z yyyy";
    formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    NSDateFormatter *formatter2 = [[NSDateFormatter alloc] init];
    formatter2.dateFormat = @"MM-dd HH:mm";
    NSString *time =  [NSString stringWithFormat:@"%@",[formatter2 stringFromDate:[formatter dateFromString:createAt]]];
    return time;
}
@end
