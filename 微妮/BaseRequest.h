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

typedef void (^RequestCompletionHandler) (NSDictionary *);

@interface BaseRequest : NSObject

@property (nonatomic, strong) RequestCompletionHandler completionHandler;

- (id)initWithURL:(NSString *)urlString;
- (void)GETRequestWithCompletionHandler:(RequestCompletionHandler)completion;
@end
