//
//  WeiboAnnotation.h
//  微妮
//
//  Created by 刘锦 on 14/12/1.
//  Copyright (c) 2014年 liujin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "userModel.h"
@interface WeiboAnnotation : NSObject<MKAnnotation>
@property(nonatomic,retain)UserModel *weiboModel;
-(id)initWithWeibo:(UserModel *)weibo;
@end
