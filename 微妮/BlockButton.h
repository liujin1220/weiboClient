//
//  BlockButton.h
//  BlockDemo
//
//  Created by 刘锦 on 14-5-9.
//  Copyright (c) 2014年 刘锦. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BlockButton;
typedef void(^TouchBlock) (BlockButton *);
@interface BlockButton : UIButton
@property(nonatomic,copy )TouchBlock block;
@end
