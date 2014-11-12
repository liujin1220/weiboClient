//
//  userModel.m
//  微妮
//
//  Created by 刘锦 on 14/11/11.
//  Copyright (c) 2014年 liujin. All rights reserved.
//

#import "userModel.h"

@implementation userModel
-(instancetype)init{
    self = [super init];
    if (self) {
        _picUrls = [[NSArray alloc]init];
        _retweetedPicUrls = [[NSArray alloc]init];
    }
    return self;
}
-(void)setContentData:(NSDictionary *)dict WithWeiboName:(NSString *)name{
    if ([name isEqualToString:@"新浪微博"]) {
        _headImageUrl = [NSString stringWithFormat:@"%@",[[dict objectForKey:@"user"] objectForKey:@"avatar_large"]];
        _nick = [NSString stringWithFormat:@"%@",[[dict objectForKey:@"user"] objectForKey:@"screen_name"]];
        _time = [NSString stringWithFormat:@"%@",[self formatDaySinaTime:[dict objectForKey:@"created_at"]]];
        _source = [NSString stringWithFormat:@"%@",[dict objectForKey:@"source"]];
        //例如<a href=\"http://app.weibo.com/t/feed/3G5oUM\" rel=\"nofollow\">iPhone 5s</a>
        _source = [_source stringByReplacingOccurrencesOfString:@"</a>" withString:@""];
        _source = [_source substringFromIndex:[_source rangeOfString:@">"].location+1];
        _picUrls = [dict objectForKey:@"pic_urls"];
        _mainBody = [dict objectForKey:@"text"];
        if ([dict objectForKey:@"retweeted_status"]) {
            _retweetedText = [NSString stringWithFormat:@"@%@:%@",[[[dict objectForKey:@"retweeted_status"] objectForKey:@"user"] objectForKey:@"screen_name"],[[dict objectForKey:@"retweeted_status"] objectForKey:@"text"]];
            _retweetedPicUrls = [[dict objectForKey:@"retweeted_status"] objectForKey:@"pic_urls"];
        }
    }else{
        //腾讯微博
        _headImageUrl = [NSString stringWithFormat:@"%@/50",[dict objectForKey:@"head"]];
        _nick = [dict objectForKey:@"nick"];
        NSDate *txdate = [NSDate dateWithTimeIntervalSince1970:[(NSNumber *)[dict objectForKey:@"timestamp"] doubleValue]];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"MM-dd HH:mm";
        _time =  [formatter stringFromDate:txdate];
        _source = [dict objectForKey:@"from"];
        _mainBody = [dict objectForKey:@"text"];
        _picUrls = [dict objectForKey:@"image"];
        if ([[dict objectForKey:@"type"]isEqualToNumber:[NSNumber numberWithInt:2]]) {
            //转载
            NSMutableDictionary *source = [NSMutableDictionary dictionaryWithDictionary:[dict objectForKey:@"source"]];
            _retweetedText = [NSString stringWithFormat:@"@%@:",[source objectForKey:@"nick"]];
            _retweetedText = [_retweetedText stringByAppendingString:[source objectForKey:@"text"]];
            _retweetedPicUrls = [source objectForKey:@"image"];
        }
    }
}
//美国时间，处理新浪
-(NSString*)formatDaySinaTime:(NSString*)createAt
{
    //NSDateFormatter格式化参数
    //yy: 年的后2位
    //yyyy: 完整年
    //MM: 月，显示为1-12
    //MMM: 月，显示为英文月份简写,如 Jan
    //MMMM: 月，显示为英文月份全称，如 Janualy
    //dd: 日，2位数表示，如02
    //d: 日，1-2位显示，如 2
    //EEE: 简写星期几，如Sun
    //EEEE: 全写星期几，如Sunday
    //aa: 上下午，AM/PM
    //H: 时，24小时制，0-23
    //K：时，12小时制，0-11
    //m: 分，1-2位
    //mm: 分，2位
    //s: 秒，1-2位
    //ss: 秒，2位
    //S: 毫秒
    //Z:时区
    //Thu Dec 19 11:57:36 +0800 2013   -->EEE MMM d HH:mm:ss Z yyy
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"EEE MMM d HH:mm:ss Z yyyy";
    formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    NSDateFormatter *formatter2 = [[NSDateFormatter alloc] init];
    formatter2.dateFormat = @"MM-dd HH:mm";
    NSString *time =  [NSString stringWithFormat:@"%@",[formatter2 stringFromDate:[formatter dateFromString:createAt]]];
    return time;
}
@end
