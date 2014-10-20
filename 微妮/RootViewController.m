//
//  RootViewController.m
//  微妮
//
//  Created by 刘锦 on 14-10-16.
//  Copyright (c) 2014年 liujin. All rights reserved.
//

#import "RootViewController.h"

static RootViewController *segtonInstance = nil;

@implementation RootViewController
+(RootViewController *)sharedRootViewController{
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
