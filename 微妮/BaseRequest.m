//
//  UserInfoData.m
//  微妮
//
//  Created by 刘锦 on 14/10/30.
//  Copyright (c) 2014年 liujin. All rights reserved.
//

#import "BaseRequest.h"

@interface BaseRequest()
@property (nonatomic, strong) NSString *urlString;
@end

@implementation BaseRequest

- (id)initWithURL:(NSString *)urlString{
    if (self = [super init]) {
        _urlString = urlString;
    }
    return self;
}

#pragma requset
- (void)GETRequestWithCompletionHandler:(RequestCompletionHandler)completion {
    self.completionHandler = completion;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    //    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    //    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager GET:_urlString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *requestTmp = [NSString stringWithString:operation.responseString];
        NSData *resData = [[NSData alloc] initWithData:[requestTmp dataUsingEncoding:NSUTF8StringEncoding]];
        //将json数据转化为字典
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:resData options:NSJSONReadingMutableLeaves error:nil];
        if (_completionHandler) {
            _completionHandler(dic);
        }
        self.completionHandler = nil;
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Errordata: %@", operation.responseString);
    }];
}

-(void)getUserDataWithUrlStr:(NSString *)url{
}

@end
