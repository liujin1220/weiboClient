//
//  UserInfoData.m
//  微妮
//
//  Created by 刘锦 on 14/10/30.
//  Copyright (c) 2014年 liujin. All rights reserved.
//

#import "UserInfoData.h"

@interface UserInfoData()
@end

@implementation UserInfoData
#pragma requset
-(void)getUserDataWithUrlStr:(NSString *)url{
     [self request:url];
}
//新浪微博
#pragma mark - ASIHTTPRequest
-(void)request:(NSString *)urlStr{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
//    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager GET:urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //NSLog(@"JSON: %@", responseObject);
        //将json数据转化为字典
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        NSString *requestTmp = [NSString stringWithString:operation.responseString];
        NSData *resData = [[NSData alloc] initWithData:[requestTmp dataUsingEncoding:NSUTF8StringEncoding]];
        //将json数据转化为字典
        dic = [NSJSONSerialization JSONObjectWithData:resData options:NSJSONReadingMutableLeaves error:nil];//NSJSONSerialization提供了将JSON数据转换为Foundation对象（一般都是NSDictionary和NSArray））
        _block(dic);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //NSLog(@"Error: %@", error);
        NSLog(@"Errordata: %@", operation.responseString);
    }];
}

@end
