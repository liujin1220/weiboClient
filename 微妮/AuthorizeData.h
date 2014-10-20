//
//  AuthorizeData.h
//  微妮
//
//  Created by 刘锦 on 14-9-26.
//  Copyright (c) 2014年 liujin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AuthorizeData : NSObject<NSCopying>
@property(nonatomic,strong)NSString *sinaToken;
@property(nonatomic,strong)NSString *sinaUid;
@property(nonatomic,strong)NSString *tencentToken;
@property(nonatomic,strong)NSString *tencentUid;

+(AuthorizeData *)sharedAuthorizeData;
@end
