//
//  SelectedWeiboName.h
//  微妮
//
//  Created by 刘锦 on 14/10/21.
//  Copyright (c) 2014年 liujin. All rights reserved.
//

#import <Foundation/Foundation.h>
#define kWeiboDidChangeNotification @"kThemeDidChangeNotification"

@interface SelectedWeiboName : NSObject<NSCopying>
@property(nonatomic,strong)NSMutableArray *weiboArray;
@property(nonatomic,strong)NSString *weiboName;
@property(nonatomic,strong)NSString *token;
@property(nonatomic,strong)NSString *uid;

+(SelectedWeiboName *)sharedWeiboName;
@end
