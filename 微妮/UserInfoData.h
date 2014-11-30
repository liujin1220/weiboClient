//
//  UserInfoData.h
//  微妮
//
//  Created by 刘锦 on 14/10/30.
//  Copyright (c) 2014年 liujin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFHTTPRequestOperationManager.h"
#import "CONSTS.h"
@interface UserInfoData : NSObject
typedef void (^dataLoadComplete) (NSMutableDictionary *);
@property(nonatomic,strong)dataLoadComplete block;
-(void)getUserDataWithUrlStr:(NSString *)url;
@end
