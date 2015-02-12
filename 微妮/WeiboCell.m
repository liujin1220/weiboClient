//
//  weiboCell.m
//  微妮
//
//  Created by 刘锦 on 14/11/11.
//  Copyright (c) 2014年 liujin. All rights reserved.
//

#import "WeiboCell.h"
#import "RTLabel.h"
#import "UserModel.h"

@interface WeiboCell(){
    UserModel *_model;       // 用户模型
    NSString  *_weiboName;   // 微博名称
}
@property (nonatomic, retain) UIView        *souceView;            // 总容器
@property (nonatomic, retain) UIImageView   *photoImageView;       // 头像
@property (nonatomic, retain) RTLabel       *userNameLabel;        // 用户昵称
@property (nonatomic, retain) RTLabel       *timelabel;            // 时间
@property (nonatomic, retain) RTLabel       *sourceLabel;          // 来源
@property (nonatomic, retain) RTLabel       *mainBodyLabel;        // 正文内容
@property (nonatomic, retain) UIView        *picUrlsView;          // 正文缩略图
@property (nonatomic, retain) UIView        *retweetedView;        // 转发内容容器
@property (nonatomic, retain) RTLabel       *retweetedLabel;       // 转发内容
@property (nonatomic, retain) UIView        *retweetedPicUrlsView; // 转发内容缩略图

@end

@implementation WeiboCell

#pragma mark - init

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _model = [[UserModel alloc]init];
        _weiboName = [SelectedWeiboName sharedWeiboName].weiboName;
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
    _photoImageView = [[UIImageView alloc]initWithFrame:CGRectMake(5, 5, 40, 40)];
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
    _mainBodyLabel = [[RTLabel alloc]initWithFrame:CGRectMake(5, 40+10, 300, 300)];
    //设置字体名字和字体大小
    _mainBodyLabel.font = [UIFont systemFontOfSize:14.0];
    //设置字头颜色
    _mainBodyLabel.textColor = [UIColor blackColor];
    //设置背景
    _mainBodyLabel.backgroundColor = [UIColor clearColor];
    //放到视图中
    [_souceView addSubview:_mainBodyLabel];
    
    //缩略图
    _picUrlsView = [[UIView alloc]initWithFrame:CGRectMake(5, 0, 300, 0)];
    _picUrlsView.backgroundColor = [UIColor clearColor];
    [_souceView addSubview:_picUrlsView];
    
    //转发内容容器
    _retweetedView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 300, 0)];
    _retweetedView.backgroundColor = [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:0.5];
    [_souceView addSubview:_retweetedView];
    
    //转发内容
    _retweetedLabel = [[RTLabel alloc]initWithFrame:CGRectMake(0, 5, 300, 0)];
    _retweetedLabel.font = [UIFont systemFontOfSize:14];
    _retweetedLabel.textColor = [UIColor blackColor];
    _retweetedLabel.backgroundColor = [UIColor clearColor];
    [_retweetedView addSubview:_retweetedLabel];
    
    //转发内容缩略图
    _retweetedPicUrlsView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 300, 0)];
    _retweetedPicUrlsView.backgroundColor = [UIColor clearColor];
    [_retweetedView addSubview:_retweetedPicUrlsView];
    
    [self.contentView addSubview:_souceView];
}

#pragma mark - Public

/**
 *  设置内容
 *
 *  @param dict 内容
 */
-(void)setContentData:(NSDictionary *)dict{
    [_model setContentData:dict WithWeiboName:_weiboName];
    int iTop = 5;
    //头像
    _photoImageView.frame = CGRectMake(5, iTop, 40, 40);
    [_photoImageView setImageWithURL:[NSURL URLWithString:_model.headImageUrl]];
    
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
    _sourceLabel.frame = CGRectMake(_timelabel.frame.origin.x + _timelabel.optimumSize.width+10, iTop+40-sSize.height-1, sSize.width, 20);
    
    iTop += 50 ;
    
    //正文内容容器
    iTop = [self addText:_model.mainBody andPicUrl:_model.picUrls withiTop:iTop withtextView:_mainBodyLabel  withPicView:_picUrlsView];
    
    if (_model.retweetedText) {
        //如果有转发内容
        iTop += 10;
        int rH = [self  addText:_model.retweetedText andPicUrl:_model.retweetedPicUrls withiTop:0  withtextView:_retweetedLabel withPicView:_retweetedPicUrlsView];
        _retweetedView.frame = CGRectMake(0, iTop, 300, rH);
        iTop += rH;
    }
    _souceView.frame = CGRectMake(5, 5, 310, iTop);
}

/**
 *  填充内容
 *
 *  @param textStr       正文文本
 *  @param picUrlsArray  图片数组
 *  @param iTop          起始高度
 *  @param mainBodyLabel 正文容器
 *  @param picView       图片容器
 *
 *  @return 高度
 */
- (int)addText:(NSString *)textStr
     andPicUrl:(NSArray *)picUrlsArray
      withiTop:(int)iTop
  withtextView:(RTLabel*)mainBodyLabel
   withPicView:(UIView*)picView{
    
    //文字
    [mainBodyLabel setText:textStr];
    CGSize frame = mainBodyLabel.optimumSize;
    mainBodyLabel.frame = CGRectMake(5, iTop, 300, frame.height);
    
    iTop += frame.height;
    
    //缩略图
    int high = 0;
    int x = 0;
    NSUInteger count = 0;//图片数
    //判断配图数组是否为空
    if ((NSNull *)picUrlsArray != [NSNull null]){
        count = picUrlsArray.count;
        int hightImage =(300-6)/3;//图片长、宽
        int num  = (int)count/3;//图片数量
        if (count) {
            high+=10;
            iTop+=10;
            for (UIView *subView in picView.subviews) {
                //避免重用
                [subView removeFromSuperview];
            }
            //算出高度
            high=((num+1)*(hightImage+3));
            if (picUrlsArray.count%3 == 0) {
                high -=hightImage+3;
            }
        }
#warning 图片左边距大小不一
        picView.frame = CGRectMake(5, iTop, 300, high);
        
        iTop+=high;

        //将图片加在容器上
        for (int i=0; i<count; i++) {
            NSString *strUrl = [NSString string];
            if ([_weiboName isEqualToString:@"腾讯微博"]){
              strUrl = [NSString stringWithFormat:@"%@/460",[picUrlsArray objectAtIndex:i]];
            }else{
               strUrl = [NSString stringWithFormat:@"%@",[[picUrlsArray objectAtIndex:i]objectForKey:@"thumbnail_pic"]];
            }
            UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(x, (i/3)*(hightImage+3), hightImage, hightImage)];
            imageView.contentMode = UIViewContentModeScaleAspectFill;
            imageView.clipsToBounds = YES;
            imageView.userInteractionEnabled = NO;
            [imageView setImageWithURL:[NSURL URLWithString:strUrl]];
            
            x+=hightImage+3;
            if ((i+1)%3 == 0) {
                x = 0;
            }
            [picView addSubview:imageView];
        }
        
    }
    
    return iTop;
}

#pragma mark - 计算高度

/**
 *  计算微博cell的高度
 *
 *  @param dict 内容
 *  @param name 微博名称
 *
 *  @return cell高度
 */
+(int)heightWith:(NSMutableDictionary*)dict WithWeiboName:(NSString *)name{
    int height;
    if ([name isEqualToString:@"新浪微博"]) {
        height = [WeiboCell sinaHeightWith:dict];
    }else{
        height = [WeiboCell tencentHeightWith:dict];
    }
    return height;
}

/**
 *  计算出新浪微博cell的高度
 *
 *  @param dict 内容
 *
 *  @return 新浪微博cell的高度
 */
+(int)sinaHeightWith:(NSMutableDictionary*)dict
{
    int iTop = 10;
    iTop += 40;
    iTop += 10;
    //判断是否为空
    if ((NSNull *)[dict objectForKey:@"pic_urls"] != [NSNull null]){
        iTop += [WeiboCell heightText:[dict objectForKey:@"text"] withpicArray:[dict objectForKey:@"pic_urls"]];
    }
    
    if ([dict objectForKey:@"retweeted_status"]) {
        iTop += [WeiboCell heightText:[[dict objectForKey:@"retweeted_status"] objectForKey:@"text"] withpicArray:[[dict objectForKey:@"retweeted_status"] objectForKey:@"pic_urls"]];
        iTop+=10;
    }
    iTop+=10;
    return iTop;
}

/**
 *  计算出腾讯微博cell的高度
 *
 *  @param info 内容
 *
 *  @return 腾讯微博cell的高度
 */
+(int)tencentHeightWith:(NSMutableDictionary*)info
{
    int iTop = 10;
    iTop += 40;
    iTop += 10;
    NSArray *picArr = [NSArray array];
    //判断是否为空
    if ((NSNull *)[info objectForKey:@"image"] != [NSNull null]) {
        picArr = [info objectForKey:@"image"];
    }
    iTop += [WeiboCell heightText:[info objectForKey:@"text"] withpicArray:picArr];
    if ([[info objectForKey:@"type"]isEqualToNumber:[NSNumber numberWithInt:2]]) {
        iTop += [WeiboCell heightText:[[info objectForKey:@"source"] objectForKey:@"text"] withpicArray:[[info objectForKey:@"source"] objectForKey:@"image"]];
        iTop+=15;
    }
    iTop+=10;
    return iTop;
}

/**
 *  根据内容和缩图图算高度
 *
 *  @param text     内容
 *  @param picArray 图片
 *
 *  @return 高度
 */
+ (int)heightText:(NSString*)text withpicArray:(NSArray*)picArray
{
    //内容
    int height = 0;
    RTLabel *testLabel = [[RTLabel alloc]initWithFrame:CGRectMake(0, 0, 300, 0)];
    testLabel.text = text;
    [testLabel setFont:[UIFont systemFontOfSize:14.0]];
    CGSize size = testLabel.optimumSize;
    height += size.height;
    //图片是否有
    if ((NSNull *)picArray != [NSNull null]){
        if (picArray.count) {
            height+=10;
            int num = (int)picArray.count/3;
            int hightImage =(300-6)/3;
            height +=((num+1)*(hightImage+3));
            if (picArray.count%3 == 0) {
                height -=hightImage+3;
            }
        }
    }
    return height;
}

@end
