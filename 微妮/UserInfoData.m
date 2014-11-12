//
//  UserInfoData.m
//  微妮
//
//  Created by 刘锦 on 14/10/30.
//  Copyright (c) 2014年 liujin. All rights reserved.
//

#import "UserInfoData.h"

@interface UserInfoData()
@property(nonatomic,strong)NSString *userNick;
@property(nonatomic,strong)NSString *userHead;
@end

@implementation UserInfoData
#pragma requset
-(void)getUserDataWithUrlStr:(NSString *)url{
     [self request:[NSURL URLWithString:url]];
}
//新浪微博
#pragma mark - ASIHTTPRequest
-(void)request:(NSURL *)urlStr{
    //请求
    ASIHTTPRequest *requestForm = [[ASIHTTPRequest alloc]initWithURL:urlStr];
    //设置代理
    [requestForm setDelegate:self];
    //开始异步请求
    [requestForm startAsynchronous];
}
#pragma mark - ASIHTTPRequestDelegate
- (void)requestFinished:(ASIHTTPRequest *)request{
    //将json数据转化为字典
    NSMutableDictionary *dic = [NSJSONSerialization JSONObjectWithData:[request responseData] options:NSJSONReadingMutableLeaves error:nil];//NSJSONSerialization提供了将JSON数据转换为Foundation对象（一般都是NSDictionary和NSArray）
    _block(dic);
}
- (void)requestFailed:(ASIHTTPRequest *)request{
    NSError *error = [request error];
    NSString *str = [[NSString alloc] initWithFormat:@"get token error, errcode = %@",error.userInfo];
    //输出错误信息
    NSLog(@"%@",str);
}
#pragma mark - WeiboRequestDelegate
- (void)didReceiveRawData:(NSData *)data reqNo:(int)reqno{
        //NSString *strResult = [[NSString alloc] initWithBytes:[data bytes] length:[data length] encoding:NSUTF8StringEncoding];
        //NSLog(@"%@",strResult);
    if (reqno) {
        NSMutableDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
        _block(dic);
    }
    //注意回到主线程，有些回调并不在主线程中，所以这里必须回到主线程
    dispatch_async(dispatch_get_main_queue(), ^{
    });
    
}
- (void)didFailWithError:(NSError *)error reqNo:(int)reqno{
    NSString *str = [[NSString alloc] initWithFormat:@"refresh token error, errcode = %@",error.userInfo];
    NSLog(@"%@",str);
    //注意回到主线程，有些回调并不在主线程中，所以这里必须回到主线程
    dispatch_async(dispatch_get_main_queue(), ^{
        
    });
}


@end
