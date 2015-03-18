//
//  PersonalHeaderView.m
//  微妮
//
//  Created by liujin on 15-2-9.
//  Copyright (c) 2015年 liujin. All rights reserved.
//

#import "PersonalHeaderView.h"
#import "UIImageView+WebCache.h"

#define kAttentionButtonFontsize        15                          // 字体大小
#define kHeaderImageViewMargin          30                          // 图像上边距
#define kHeaderImageViewSideLength      80                          // 头像边长
#define kHeaderAndNickMargin            10                          // 头像和昵称间距
#define kNickLabelHeight                20                          // 昵称文本框宽
#define kNickAndAttentionMargin         13                          // 昵称和关注按钮间距
#define kAttentionButtonHeight          15                          // 关注按钮高度
#define kAttentionButtonWidth           50                          // 关注按钮宽度
#define kLinesWidth                     2.0f                        // 竖线的宽度
#define kAttentionButtonMargin          (self.frame.size.width - 3*(kAttentionButtonWidth))/4.0

@interface PersonalHeaderView ()
@property (nonatomic, strong) UIImageView   *headImageView;     // 头像
@property (nonatomic, strong) UILabel       *nickLabel;         // 昵称
@property (nonatomic, strong) UIButton      *attentionButton;   // 关注
@property (nonatomic, strong) UIButton      *followersButton;   // 粉丝
@property (nonatomic, strong) UIButton      *userPhotoButton;   // 相册
@property (nonatomic, strong) UIView        *lineView1;         // 竖线
@property (nonatomic, strong) UIView        *lineView2;         // 竖线
@end

@implementation PersonalHeaderView

#pragma mark - init

- (id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"user_background2"]];
        [self p_initView];
    }
    return self;
}
/**
 *  初始化视图
 */
- (void)p_initView{
    // 头像
    _headImageView = [[UIImageView alloc]init];
    [_headImageView clipsToBounds];
    [_headImageView.layer setMasksToBounds:YES];
    [_headImageView.layer setCornerRadius:kHeaderImageViewSideLength/2.0];
    [_headImageView setImage:[UIImage imageNamed:@"me_head_default"]];
    [self addSubview:_headImageView];
    // 昵称
    _nickLabel = [[UILabel alloc]init];
    [_nickLabel setTextAlignment:NSTextAlignmentCenter];
    [_nickLabel setTextColor:[UIColor whiteColor]];
    [_nickLabel sizeToFit];
    [self addSubview:_nickLabel];
    // 关注
    _attentionButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_attentionButton setTag:1001];
    [_attentionButton addTarget:self action:@selector(buttonTouchUp:) forControlEvents:UIControlEventTouchUpInside];
    [_attentionButton.titleLabel setFont:[UIFont systemFontOfSize:kAttentionButtonFontsize]];
    [_attentionButton setTitle:@"关注" forState:UIControlStateNormal];
    [_attentionButton setTitleColor:[UIColor blueColor] forState:UIControlStateHighlighted];
    [_attentionButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self addSubview:_attentionButton];
    // 粉丝
    _followersButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_followersButton addTarget:self action:@selector(buttonTouchUp:) forControlEvents:UIControlEventTouchUpInside];
    [_followersButton.titleLabel setFont:[UIFont systemFontOfSize:kAttentionButtonFontsize]];
    [_followersButton setTitle:@"粉丝" forState:UIControlStateNormal];
    [_followersButton setTitleColor:[UIColor blueColor] forState:UIControlStateHighlighted];
    [_followersButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_followersButton setTag:1002];
    [self addSubview:_followersButton];
    // 相册
    _userPhotoButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_userPhotoButton setTitle:@"相册" forState:UIControlStateNormal];
    [_userPhotoButton.titleLabel setFont:[UIFont systemFontOfSize:kAttentionButtonFontsize]];
    [_userPhotoButton addTarget:self action:@selector(buttonTouchUp:) forControlEvents:UIControlEventTouchUpInside];
    [_userPhotoButton.titleLabel sizeToFit];
    [_userPhotoButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_userPhotoButton setTitleColor:[UIColor blueColor] forState:UIControlStateHighlighted];
    [_userPhotoButton setTag:1003];
    [self addSubview:_userPhotoButton];
    // 竖线
    _lineView1 = [[UIView alloc]init];
    [_lineView1 setBackgroundColor:[UIColor whiteColor]];
    [self addSubview:_lineView1];
    
    _lineView2 = [[UIView alloc]init];
    [_lineView2 setBackgroundColor:[UIColor whiteColor]];
    [self addSubview:_lineView2];
}
#pragma mark - Public
/**
 *  设置内容
 */
- (void)setContentDataWithUserModel:(PersonalModel *)model{
    [self.nickLabel setText:model.nick];
    [self.headImageView setImageWithURL:[NSURL URLWithString:model.headUrl]placeholderImage:[UIImage imageNamed:@"user_background2"]];
}
#pragma mark - Button Action

- (void)buttonTouchUp:(UIButton *)button {
    [_buttonActionDelegate buttonActions:button];
}

#pragma mark - Layout

- (void)layoutSubviews{
    // 头像
    [self.headImageView setFrame:CGRectMake((self.frame.size.width - kHeaderImageViewSideLength)/2.0, kHeaderImageViewMargin, kHeaderImageViewSideLength, kHeaderImageViewSideLength)];
    // 昵称
    [self.nickLabel setFrame:CGRectMake(0, CGRectGetMaxY(_headImageView.frame) + kHeaderAndNickMargin, self.frame.size.width, kNickLabelHeight)];
    // 关注
    [self.attentionButton setFrame:CGRectMake(kAttentionButtonMargin, CGRectGetMaxY(_nickLabel.frame) + kNickAndAttentionMargin, kAttentionButtonWidth, kAttentionButtonHeight)];
    // 粉丝
    [self.followersButton setFrame:CGRectMake(CGRectGetMaxX(_attentionButton.frame) + kAttentionButtonMargin, CGRectGetMaxY(_nickLabel.frame) + kNickAndAttentionMargin, kAttentionButtonWidth, kAttentionButtonHeight)];
    // 相册
    [self.userPhotoButton setFrame:CGRectMake(CGRectGetMaxX(_followersButton.frame) + kAttentionButtonMargin, CGRectGetMaxY(_nickLabel.frame) + kNickAndAttentionMargin, kAttentionButtonWidth, kAttentionButtonHeight)];
    // 竖线
    [self.lineView1 setFrame:CGRectMake(CGRectGetMaxX(_attentionButton.frame) + (kAttentionButtonMargin - kLinesWidth)/2.0, CGRectGetMinY(_followersButton.frame), kLinesWidth, kAttentionButtonHeight)];
    [self.lineView2 setFrame:CGRectMake(CGRectGetMaxX(_followersButton.frame) + (kAttentionButtonMargin - kLinesWidth)/2.0, CGRectGetMinY(_followersButton.frame), kLinesWidth, kAttentionButtonHeight)];
}

#pragma mark - Draw

///**
// *  画两条竖线
// *
// *  @param rect N/A
// */
//- (void)drawRect:(CGRect)rect {
//    [[UIColor whiteColor]set];
//    
//    CGContextRef currentContext = UIGraphicsGetCurrentContext();
//    CGContextSetLineWidth(currentContext, kLinesWidth);
//    
//    CGFloat start_y = kHeaderImageViewMargin + kHeaderImageViewSideLength + kHeaderAndNickMargin +kNickLabelHeight + kNickAndAttentionMargin;
//    CGFloat start_x =  kAttentionButtonWidth + kAttentionButtonMargin - kLinesWidth/2.0;
//    
//    CGContextMoveToPoint(currentContext, start_x, start_y);
//    CGContextAddLineToPoint(currentContext, start_x, start_y + kAttentionButtonHeight);
//    
//    CGContextMoveToPoint(currentContext, start_x + kAttentionButtonWidth + kAttentionButtonMargin, start_y);
//    CGContextAddLineToPoint(currentContext, start_x + kAttentionButtonWidth + kAttentionButtonMargin, start_y + kAttentionButtonHeight);
//    
//    CGContextStrokePath(currentContext);
//    
//}

@end
