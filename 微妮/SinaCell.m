//
//  SinaCell.m
//  SinaWeiboDemo
//
//  Created by iHope on 13-12-23.
//  Copyright (c) 2013年 任海丽. All rights reserved.
//

#import "SinaCell.h"
#import "RTLabel.h"
@interface SinaCell ()
@property (nonatomic, retain) UIView *souceView;//总容器

@property (nonatomic, retain) UIImageView *photoImageView;//头像

@property (nonatomic, retain) RTLabel *userNameLabel;//用户昵称

@property (nonatomic, retain) RTLabel *timelabel;//时间

@property (nonatomic, retain) RTLabel *sourceLabel;//来源

@property(nonatomic,retain) RTLabel *mainBodyLabel;//正文内容

@property (nonatomic, retain) UIView *picUrlsView;//正文缩略图

@property (nonatomic, retain) UIView *retweetedView;//转发内容容器

@property(nonatomic,retain)RTLabel *retweetedLabel;//转发内容

@property (nonatomic, retain) UIView *retweetedPicUrlsView;//转发内容缩略图

@end
@implementation SinaCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self createView];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)createView
{
    //总容器
    _souceView = [[UIView alloc]initWithFrame:CGRectMake(5, 5, 310, 0)];
    _souceView.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:_souceView];
    
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
    _retweetedView = [[UIView alloc]initWithFrame:CGRectMake(5, 0, 300, 0)];
    _retweetedView.backgroundColor = [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:0.5];
    [_souceView addSubview:_retweetedView];
    
    //转发内容
	_retweetedLabel = [[RTLabel alloc]initWithFrame:CGRectMake(5, 5, 300, 0)];
    _retweetedLabel.font = [UIFont systemFontOfSize:14];
    _retweetedLabel.textColor = [UIColor blackColor];
    _retweetedLabel.backgroundColor = [UIColor clearColor];
    [_retweetedView addSubview:_retweetedLabel];
    
    //转发内容缩略图
    _retweetedPicUrlsView = [[UIView alloc]initWithFrame:CGRectMake(5, 0, 300, 0)];
    _retweetedPicUrlsView.backgroundColor = [UIColor clearColor];
    [_retweetedView addSubview:_retweetedPicUrlsView];
}

-(void)setContent:(NSMutableDictionary*)dict
{
    /*获取所需信息*/
    //头像
    NSString *photoStr = [NSString stringWithFormat:@"%@",[[dict objectForKey:@"user"] objectForKey:@"avatar_large"]];
    //昵称
    NSString *userNameStr = [NSString stringWithFormat:@"%@",[[dict objectForKey:@"user"] objectForKey:@"screen_name"]];

    //时间
    NSString *timeStr = [[NSString alloc]init];
    timeStr = [SinaCell formatDaySinaTime:[dict objectForKey:@"created_at"]];
    //来源
    NSString *sourceStr = [NSString stringWithFormat:@"%@",[dict objectForKey:@"source"]];
    //例如<a href=\"http://app.weibo.com/t/feed/3G5oUM\" rel=\"nofollow\">iPhone 5s</a>
    sourceStr = [sourceStr stringByReplacingOccurrencesOfString:@"</a>" withString:@""];
    sourceStr = [sourceStr substringFromIndex:[sourceStr rangeOfString:@">"].location+1];
    
    //正文
    NSString *textStr = [NSString stringWithFormat:@"%@",[dict objectForKey:@"text"]];
    //微博配图地址
    NSArray *picUrlsArray = [NSArray arrayWithArray: [dict objectForKey:@"pic_urls"]];
    //被转发原微博的作者姓名+正文retweetedTextStr+配图地址retweetedPicUrlsArray
    NSString *retweetedTextStr = [[NSString alloc]init];
    NSArray *retweetedPicUrlsArray = [NSArray array];
    if ([dict objectForKey:@"retweeted_status"]) {
        retweetedTextStr = [NSString stringWithFormat:@"@%@:%@",[[[dict objectForKey:@"retweeted_status"] objectForKey:@"user"] objectForKey:@"screen_name"],[[dict objectForKey:@"retweeted_status"] objectForKey:@"text"]];
        retweetedPicUrlsArray = [[dict objectForKey:@"retweeted_status"] objectForKey:@"pic_urls"];
    }
    
    int iTop = 5;
    //头像
    _photoImageView.frame = CGRectMake(5, iTop, 40, 40);
    [_photoImageView setImageWithURL:[NSURL URLWithString:photoStr]];
    
    //昵称
    _userNameLabel.text = userNameStr;
    CGSize uSize = _userNameLabel.optimumSize;
    _userNameLabel.frame = CGRectMake(40+5+10, iTop+(20-uSize.height)/2, uSize.width, uSize.height);
   
     iTop +=20;
    
    //时间
    _timelabel.text = timeStr;
    CGSize tSize = _timelabel.optimumSize;
    _timelabel.frame = CGRectMake(40+5+10, iTop+(20-tSize.height)/2, tSize.width, 20);
    
    //来源
     _sourceLabel.text = sourceStr;
    CGSize sSize = _sourceLabel.optimumSize;
    _sourceLabel.frame = CGRectMake(_timelabel.frame.origin.x + _timelabel.optimumSize.width+10, iTop+(20-sSize.height)/2, sSize.width, 20);
   
   iTop += 30 ;
    
    //正文内容容器
    iTop =  [self  addText:textStr andPicUrl:picUrlsArray withiTop:iTop withtextView:_mainBodyLabel  withPicView:_picUrlsView];
    
    if (retweetedTextStr) {
        //如果有转发内容
        iTop+=10;
        int rH = [self  addText:retweetedTextStr andPicUrl:retweetedPicUrlsArray withiTop:0  withtextView:_retweetedLabel withPicView:_retweetedPicUrlsView];
        _retweetedView.frame = CGRectMake(5, iTop, 300, rH);
        iTop += rH;
    }
    _souceView.frame = CGRectMake(5, 5, 310, iTop);
}    

//内容和配图的高度
-(int)addText:(NSString *)textStr andPicUrl:(NSArray *)picUrlsArray withiTop:(int)iTop withtextView:(RTLabel*)mainBodyLabel withPicView:(UIView*)picView{
    
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
        picView.frame = CGRectMake(5, iTop, 300, high);
        
        iTop+=high;
        
        //将图片加在容器上
        for (int i=0; i<count; i++) {
            NSString *strUrl = [NSString stringWithFormat:@"%@",[[picUrlsArray objectAtIndex:i]objectForKey:@"thumbnail_pic"]];
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

//计算出高度
+(int)heightWith:(NSMutableDictionary*)dict
{
    int iTop = 10;
    iTop += 40;
    iTop += 10;
    //判断是否为空
    if ((NSNull *)[dict objectForKey:@"pic_urls"] != [NSNull null]){
        iTop += [self heightText:[dict objectForKey:@"text"] withpicArray:[dict objectForKey:@"pic_urls"]];
    }
    
    if ([dict objectForKey:@"retweeted_status"]) {
        iTop += [self heightText:[[dict objectForKey:@"retweeted_status"] objectForKey:@"text"] withpicArray:[[dict objectForKey:@"retweeted_status"] objectForKey:@"pic_urls"]];
        iTop+=10;
    }
    iTop+=10;
    return iTop;
}

//根据内容和缩图图算高度
+(int)heightText:(NSString*)text withpicArray:(NSArray*)picArray
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


//美国时间，处理新浪
+(NSString*)formatDaySinaTime:(NSString*)createAt
{
    //NSDateFormatter格式化参数
    //yy: 年的后2位
    //yyyy: 完整年
    //MM: 月，显示为1-12
    //MMM: 月，显示为英文月份简写,如 Jan
    //MMMM: 月，显示为英文月份全称，如 Janualy
    //dd: 日，2位数表示，如02
    //d: 日，1-2位显示，如 2
    //EEE: 简写星期几，如Sun
    //EEEE: 全写星期几，如Sunday
    //aa: 上下午，AM/PM
    //H: 时，24小时制，0-23
    //K：时，12小时制，0-11
    //m: 分，1-2位
    //mm: 分，2位
    //s: 秒，1-2位
    //ss: 秒，2位   
    //S: 毫秒
    //Z:时区
    //Thu Dec 19 11:57:36 +0800 2013   -->EEE MMM d HH:mm:ss Z yyy
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"EEE MMM d HH:mm:ss Z yyyy";
    formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    NSDateFormatter *formatter2 = [[NSDateFormatter alloc] init];
    formatter2.dateFormat = @"MM-dd HH:mm";
    NSString *time =  [NSString stringWithFormat:@"%@",[formatter2 stringFromDate:[formatter dateFromString:createAt]]];
    return time;
}

@end
