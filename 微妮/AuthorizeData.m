//
//  AuthorizeData.m
//  微妮
//
//  Created by 刘锦 on 14-9-26.
//  Copyright (c) 2014年 liujin. All rights reserved.
//

#import "AuthorizeData.h"

static AuthorizeData *segtonInstance = nil;

@implementation AuthorizeData

+(AuthorizeData *)sharedAuthorizeData{
    @synchronized(self){
        if (segtonInstance == nil) {
            segtonInstance = [[[self class]alloc]init];
        }
        return segtonInstance;
    }
}

#pragma mark - 下面的方法为了确保只有一个实例对象
+ (id) allocWithZone:(NSZone *)zone{
    @synchronized(self){
        if (segtonInstance == nil) {
            segtonInstance = [super allocWithZone:zone];
        }
    }
    return segtonInstance;
}

- (id)copyWithZone:(NSZone *)zone{
    return segtonInstance;
}

@end
