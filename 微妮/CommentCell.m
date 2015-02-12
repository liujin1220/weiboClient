//
//  CommentCell.m
//  微妮
//
//  Created by 刘锦 on 14/11/13.
//  Copyright (c) 2014年 liujin. All rights reserved.
//

#import "CommentCell.h"
#import "CommentModel.h"
#import "RTLabel.h"

@interface CommentCell(){
    CommentModel *_model; // 评论模型
}
@property (nonatomic, retain) UIView    *souceView;         // 总容器
@property (nonatomic, retain) UIButton  *photoImageView;    // 头像
@property (nonatomic, retain) RTLabel   *userNameLabel;     // 用户昵称
@property (nonatomic, retain) RTLabel   *timelabel;         // 时间
@property (nonatomic, retain) RTLabel   *sourceLabel;       // 来源
@property (nonatomic, retain) RTLabel   *mainBodyLabel;     // 正文内容

@end

@implementation CommentCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

#pragma mark - init

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _model = [[CommentModel alloc]init];
        [self _initView];
    }
    return self;
}

/**
 *  初始化子视图
 */
- (void)_initView{
    //总容器
    _souceView = [[UIView alloc]initWithFrame:CGRectMake(5, 5, 310, 0)];
    _souceView.backgroundColor = [UIColor clearColor];
    
    //头像
    _photoImageView = [UIButton buttonWithType:UIButtonTypeCustom];
    [_photoImageView setFrame:CGRectMake(5, 5, 40, 40)];
    [_souceView addSubview:_photoImageView];
    
    //用户昵称
    _userNameLabel = [[RTLabel alloc]initWithFrame:CGRectMake(5+40+10, 5, 200, 20)];
    _userNameLabel.backgroundColor = [UIColor clearColor];
    _userNameLabel.font = [UIFont systemFontOfSize:15.0];
    _userNameLabel.textColor = [UIColor blackColor];
    [_souceView addSubview:_userNameLabel];
    
    //时间
    _timelabel = [[RTLabel alloc]initWithFrame:CGRectMake(5, 40+5, 300, 0)];
    _timelabel.backgroundColor = [UIColor clearColor];
    _timelabel.font = [UIFont systemFontOfSize:12];
    _timelabel.textColor = [UIColor orangeColor];
    [_souceView addSubview:_timelabel];
    
    //来源
    _sourceLabel = [[RTLabel alloc]initWithFrame:CGRectMake(5, 0, 300, 10)];
    _sourceLabel.backgroundColor = [UIColor clearColor];
    _sourceLabel.font = [UIFont systemFontOfSize:12];
    _sourceLabel.textColor = [UIColor darkGrayColor];
    [_souceView addSubview:_sourceLabel];
    
    //正文内容
    //初始化
    _mainBodyLabel = [[RTLabel alloc]initWithFrame:CGRectMake(50, 40+10, 250, 0)];
    //设置字体名字和字体大小
    _mainBodyLabel.font = [UIFont systemFontOfSize:14.0];
    //设置字头颜色
    _mainBodyLabel.textColor = [UIColor blackColor];
    //设置背景
    _mainBodyLabel.backgroundColor = [UIColor clearColor];
    //放到视图中
    [_souceView addSubview:_mainBodyLabel];
    
    [self.contentView addSubview:_souceView];
}

#pragma mark - Public

/**
 *  设置内容
 *
 *  @param dict 内容
 */
- (void)setContentData:(NSDictionary *)dict{
    [_model setContentData:dict WithWeiboName:[SelectedWeiboName sharedWeiboName].weiboName];
    int iTop = 5;
    //头像
    _photoImageView.frame = CGRectMake(5, iTop, 40, 40);
    [_photoImageView setImageWithURL:[NSURL URLWithString:_model.headUrl]];
    
    //昵称
    _userNameLabel.text = _model.nick;
    CGSize uSize = _userNameLabel.optimumSize;
    _userNameLabel.frame = CGRectMake(40+5+10, iTop+1, uSize.width, uSize.height);
    
    //时间
    _timelabel.text = _model.time;
    CGSize tSize = _timelabel.optimumSize;
    _timelabel.frame = CGRectMake(40+5+10, iTop+40-tSize.height-1, tSize.width, 20);
    
    //来源
    _sourceLabel.text = _model.source;
    CGSize sSize = _sourceLabel.optimumSize;
    _sourceLabel.frame = CGRectMake(_timelabel.frame.origin.x + tSize.width+10, iTop+40-tSize.height-1, sSize.width, 20);
    
    iTop += 50 ;
    
    //正文内容容器
    _mainBodyLabel.text = _model.mainText;
    CGSize mSize = _mainBodyLabel.optimumSize;
    _mainBodyLabel.frame = CGRectMake(50, iTop, mSize.width, mSize.height);
    
    _souceView.frame = CGRectMake(5, 5, 310, iTop);
}

/**
 *  根据内容计算cell高度
 *
 *  @param dict 内容
 *  @param name 微博名称
 *
 *  @return 高度
 */

+ (int)heightWith:(NSMutableDictionary*)dict WithWeiboName:(NSString *)name{
    int height = 0;
    RTLabel *mainTextLabel = [[RTLabel alloc]initWithFrame:CGRectMake(0, 0, 250, 0)];
    mainTextLabel.text = [dict objectForKey:@"text"];
    height = mainTextLabel.optimumSize.height;
    return height + 70;
}

@end
