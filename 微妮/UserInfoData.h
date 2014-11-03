//
//  UserInfoData.h
//  微妮
//
//  Created by 刘锦 on 14/10/30.
//  Copyright (c) 2014年 liujin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIHTTPRequest.h"
#import "WeiboApi.h"
#import "CONSTS.h"
@interface UserInfoData : NSObject<ASIHTTPRequestDelegate,WeiboRequestDelegate>
typedef void (^dataLoadComplete) (NSMutableDictionary *);
@property(nonatomic,strong)dataLoadComplete block;
-(void)getUserDataWithUrlStr:(NSString *)url;
-(void)getUserDataWithParams:(NSMutableDictionary *)dic AndApi:(NSString *)api;
@end
