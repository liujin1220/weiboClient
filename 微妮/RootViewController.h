//
//  RootViewController.h
//  微妮
//
//  Created by 刘锦 on 14-10-16.
//  Copyright (c) 2014年 liujin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DDMenuController.h"
@class CustomTabBarViewController;
@class LeftViewController;
@class RightViewController;

@interface RootViewController : NSObject<NSCopying>
@property(nonatomic,strong)DDMenuController *ddMenu;

+(RootViewController *)sharedRootViewController;
@end
