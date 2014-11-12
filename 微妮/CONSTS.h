//
//  CONSTS.h
//  微妮
//
//  Created by 刘锦 on 14-9-11.
//  Copyright (c) 2014年 liujin. All rights reserved.
//

#ifndef ___CONSTS_h
#define ___CONSTS_h

#define KDEVICEHEIGHT  [UIScreen mainScreen].bounds.size.height
#define KDEVICEWIDTH [UIScreen mainScreen].bounds.size.width
//device size
#define KDEVICEHEIGHT [UIScreen mainScreen].bounds.size.height
#define KDEVICEWIDTH [UIScreen mainScreen].bounds.size.width
//weibo oAuthu 2.0

//sina
#define KSAppKey @"3185833614"
#define KSAppSecret @"826670a96e14c97aa7072618adb3f7cd"
#define KSAppRedirectURL @"https://api.weibo.com/oauth2/default.html"

//tencent
#define KTAppKey @"801541836"
#define KTAppSecret @"2712b4dc92bf431ace2982b0c1a5c7d8"
#define KTAppRedirectURL @"https://api.weibo.com/oauth2/default.html"
#endif

//NSUInteger-->NSUInteger
#if __LP64__ || TARGET_OS_EMBEDDED || TARGET_OS_IPHONE || TARGET_OS_WIN32 || NS_BUILD_32_LIKE_64
typedef unsigned long NSUInteger;
#else
typedef unsigned int NSUInteger;
#endif
