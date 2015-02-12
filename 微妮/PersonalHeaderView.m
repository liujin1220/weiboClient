//
//  PersonalHeaderView.m
//  微妮
//
//  Created by liujin on 15-2-9.
//  Copyright (c) 2015年 liujin. All rights reserved.
//

#import "PersonalHeaderView.h"

#define kHeaderImageViewHeight 10.0

@interface PersonalHeaderView ()

@property (nonatomic, strong) UIImageView   *headImageView;     // 头像
@property (nonatomic, strong) UILabel       *nickLabel;         // 昵称
@property (nonatomic, strong) UIButton      *attentionButton;   // 关注
@property (nonatomic, strong) UIButton      *followersButton;   // 粉丝

@end

@implementation PersonalHeaderView

#pragma mark - init

- (id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
    }
    return self;
}
/**
 *  初始化视图
 */
- (void)p_initView{
    // 头像
    self.headImageView = [[UIImageView alloc]init];
    [self.headImageView.layer setCornerRadius:kHeaderImageViewHeight/2.0];
    [self addSubview:_headImageView];
    // 昵称
    self.nickLabel = [[UILabel alloc]init];
    [self.nickLabel setTextAlignment:NSTextAlignmentCenter];
    [self addSubview:_nickLabel];
    // 关注
    self.attentionButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.attentionButton addTarget:self action:@selector(pushAttentionViewController) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_attentionButton];
    // 粉丝
    self.followersButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.followersButton addTarget:self action:@selector(pushFollowersButtonViewController) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_followersButton];
}
#pragma mark - Public
/**
 *  设置内容
 */
- (void)setContentDataWithUserModel{
    
}

#pragma mark - Button Actions
/**
 *  进入关注页面
 */
- (void)pushAttentionViewController{
    
}
/**
 *  进入粉丝页面
 */
- (void)pushFollowersButtonViewController{
    
}

#pragma mark - Layout

- (void)layoutSubviews{
    
}

#pragma mark - Draw

- (void)drawRect:(CGRect)rect{
    // 画一条竖线
}

@end
