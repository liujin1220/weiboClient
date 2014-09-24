//
//  UIImageView+LoadView.h
//  网络图片加载
//
//  Created by 刘锦 on 14-3-10.
//  Copyright (c) 2014年 刘锦. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (LoadView)

-(void)setImageWithURL:(NSURL *)url;
-(void)load:(NSURL *)url;

@end
