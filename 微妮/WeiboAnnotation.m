//
//  WeiboAnnotation.m
//  微妮
//
//  Created by 刘锦 on 14/12/1.
//  Copyright (c) 2014年 liujin. All rights reserved.
//

#import "WeiboAnnotation.h"

@interface WeiboAnnotation()
@property(nonatomic)CLLocationCoordinate2D coordinate;

@end

@implementation WeiboAnnotation
-(id)initWithWeibo:(UserModel *)weibo{
    self = [super init];
    if (self!=nil) {
        self.weiboModel = weibo;
    }
    return self;
}
-(void)setWeiboModel:(UserModel *)weiboModel{
    if (_weiboModel != weiboModel) {
        _weiboModel = weiboModel;
    }
    //null   -->NSNull
    NSDictionary *geo = weiboModel.geo;
    if ([geo isKindOfClass:[NSDictionary class]]) {
        //取值
        NSArray *coord = [geo objectForKey:@"coordinates"];
        if (coord.count == 2) {
            float lat = [[coord objectAtIndex:0]floatValue];
            float lon = [[coord objectAtIndex:1]floatValue];
            _coordinate = CLLocationCoordinate2DMake(lat, lon);
        }
    }
}
@end
