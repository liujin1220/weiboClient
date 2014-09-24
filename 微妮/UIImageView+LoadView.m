//
//  UIImageView+LoadView.m
//  网络图片加载
//
//  Created by 刘锦 on 14-3-10.
//  Copyright (c) 2014年 刘锦. All rights reserved.
//

#import "UIImageView+LoadView.h"

@implementation UIImageView (LoadView)

-(void)setImageWithURL:(NSURL *)url{
    //开启一个多线程
        [self performSelectorInBackground:@selector(load:) withObject:url];
}

-(void)load:(NSURL *)url{
    @autoreleasepool {
        NSData *data = [NSData dataWithContentsOfURL:url];
        UIImage *image = [UIImage imageWithData:data];
        //返回到主线程
        [self performSelectorOnMainThread:@selector(setImage:) withObject:image waitUntilDone:YES];
    }
}

@end
