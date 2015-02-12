//
//  SelectedWeiboName.m
//  微妮
//
//  Created by 刘锦 on 14/10/21.
//  Copyright (c) 2014年 liujin. All rights reserved.
//

#import "SelectedWeiboName.h"

static SelectedWeiboName *segtonInstance = nil;

@implementation SelectedWeiboName

- (id)init{
    self = [super init];
    if (self != nil) {
        _weiboArray = [[NSMutableArray alloc]init];
    }
    return self;
}
+ (SelectedWeiboName *)sharedWeiboName{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        segtonInstance = [[self alloc]init];
    });
    return segtonInstance;
}

+ (id)allocWithZone:(NSZone *)zone{
    @synchronized(self){
        if (nil == segtonInstance) {
            segtonInstance = [super allocWithZone:zone];
        }
    }
    return segtonInstance;
}

#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone{
    return segtonInstance;
}
@end
