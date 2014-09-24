//
//  SinaCell.m
//  SinaWeiboDemo
//
//  Created by iHope on 13-12-23.
//  Copyright (c) 2013年 任海丽. All rights reserved.
//

#import "SinaCell.h"
/*
 UIView *souceView;//总容器
 UIImageView *photoImageView;//头像
 UILabel *userNameLabel;//用户昵称
 UILabel *timelabel;//时间
 UILabel *sourceLabel;//来源
 UITextView *textView;//内容
 UIView *picUrlsView;//缩略图
 UIView *retweetedView;//转发内容容器
 UITextView *retweetedTextView;//转发内容
 UIView *retweetedPicUrlsView;//转发内容缩略图
 */
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
    [self addSubview:_souceView];
    
    //头像
    _photoImageView = [[UIImageView alloc]initWithFrame:CGRectMake(5, 5, 40, 40)];
    [_souceView addSubview:_photoImageView];
    
    //用户昵称
    _userNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(5+40+10, 5, 200, 20)];
    _userNameLabel.backgroundColor = [UIColor clearColor];
    _userNameLabel.font = [UIFont fontWithName:@"Helvetica" size:15];
    _userNameLabel.textColor = [UIColor blackColor];
    [_souceView addSubview:_userNameLabel];
    
    //时间
    _timelabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 40+5, 300, 0)];
    _timelabel.backgroundColor = [UIColor clearColor];
    _timelabel.font = [UIFont systemFontOfSize:12];
    _timelabel.textColor = [UIColor orangeColor];
    [_souceView addSubview:_timelabel];
    
    //来源
    _sourceLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 0, 300, 10)];
    _sourceLabel.backgroundColor = [UIColor clearColor];
    _sourceLabel.font = [UIFont systemFontOfSize:12];
    _sourceLabel.textColor = [UIColor blackColor];
    [_souceView addSubview:_sourceLabel];
    
    //正文内容
    //初始化
	_textView = [[UITextView alloc]initWithFrame:CGRectMake(5, 40+10, 300, 300)];
    //设置字体名字和字体大小
    _textView.font = [UIFont systemFontOfSize:15];
    //设置字头颜色
    _textView.textColor = [UIColor blackColor];
    //设置背景
    _textView.backgroundColor = [UIColor clearColor];
    //是否可以拖动
    _textView.scrollEnabled = NO;
    //是否可编辑
    _textView.editable = NO;
    //放到视图中
    [_souceView addSubview:_textView];
    
    
    //缩略图
    _picUrlsView = [[UIView alloc]initWithFrame:CGRectMake(5, 0, 300, 0)];
    _picUrlsView.backgroundColor = [UIColor clearColor];
    [_souceView addSubview:_picUrlsView];
    
    //转发内容容器
    _retweetedView = [[UIView alloc]initWithFrame:CGRectMake(5, 0, 300, 0)];
    _retweetedView.backgroundColor = [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:0.5];
    [_souceView addSubview:_retweetedView];
    
    //转发内容
	_retweetedTextView = [[UITextView alloc]initWithFrame:CGRectMake(5, 5, 290, 0)];
    _retweetedTextView.font = [UIFont systemFontOfSize:15];
    _retweetedTextView.textColor = [UIColor blackColor];
    _retweetedTextView.backgroundColor = [UIColor clearColor];
    _retweetedTextView.scrollEnabled = NO;
    _retweetedTextView.editable = NO;
    [_retweetedView addSubview:_retweetedTextView];
    
    //转发内容缩略图
    _retweetedPicUrlsView = [[UIView alloc]initWithFrame:CGRectMake(5, 0, 290, 0)];
    _retweetedPicUrlsView.backgroundColor = [UIColor clearColor];
    [_retweetedView addSubview:_retweetedPicUrlsView];
}

-(void)setContent:(NSMutableDictionary*)dict
{
    /*获取所需信息*/
    //头像
    NSString *photoStr = [[dict objectForKey:@"user"] objectForKey:@"avatar_large"];
    //昵称
    NSString *userNameStr = [[dict objectForKey:@"user"] objectForKey:@"screen_name"];

    //时间
    NSString *timeStr = [dict objectForKey:@"created_at"];
    timeStr = [SinaCell formatDaySinaTime:timeStr];
    //来源
    NSString *sourceStr = [dict objectForKey:@"source"];
    //例如<a href=\"http://app.weibo.com/t/feed/3G5oUM\" rel=\"nofollow\">iPhone 5s</a>
    sourceStr = [sourceStr stringByReplacingOccurrencesOfString:@"</a>" withString:@""];
    sourceStr = [sourceStr substringFromIndex:[sourceStr rangeOfString:@">"].location+1];
    //正文
    NSString *textStr = [dict objectForKey:@"text"];
    //微博配图地址
    NSArray *picUrlsArray = [dict objectForKey:@"pic_urls"];
    //被转发原微博的作者姓名+正文retweetedTextStr+配图地址retweetedPicUrlsArray
    NSString *retweetedTextStr = nil;
    NSArray *retweetedPicUrlsArray = nil;
    if ([dict objectForKey:@"retweeted_status"]) {
        retweetedTextStr = [NSString stringWithFormat:@"@%@:",[[[dict objectForKey:@"retweeted_status"] objectForKey:@"user"] objectForKey:@"screen_name"]];
        retweetedTextStr = [retweetedTextStr stringByAppendingString:[[dict objectForKey:@"retweeted_status"] objectForKey:@"text"]];
        retweetedPicUrlsArray = [[dict objectForKey:@"retweeted_status"] objectForKey:@"pic_urls"];
    }
    
    int iTop = 5;
    //头像
    _photoImageView.frame = CGRectMake(5, iTop, 40, 40);
    [_photoImageView setImageWithURL:[NSURL URLWithString:photoStr]];
    
    //昵称
    CGSize uSize = [userNameStr sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(200, 20) lineBreakMode:NSLineBreakByCharWrapping];
    _userNameLabel.frame = CGRectMake(40+5+10, iTop, uSize.width, 20);
    _userNameLabel.text = userNameStr;
    
     iTop +=20;
    
    //时间
    CGSize tSize = [timeStr sizeWithFont:[UIFont systemFontOfSize:12] constrainedToSize:CGSizeMake(200, 20) lineBreakMode:NSLineBreakByCharWrapping];
    _timelabel.frame = CGRectMake(40+5+10, iTop, tSize.width, 20);
    _timelabel.text = timeStr;
    
    //来源
    CGSize sSize = [sourceStr sizeWithFont:[UIFont systemFontOfSize:12] constrainedToSize:CGSizeMake(200, 20) lineBreakMode:NSLineBreakByCharWrapping];
    _sourceLabel.frame = CGRectMake(_timelabel.frame.origin.x + _timelabel.frame.size.width+5, iTop, sSize.width, 20);
    _sourceLabel.text = sourceStr;
    
   iTop += 20 ;
    
    //正文内容容器
  iTop =  [self  addText:textStr andPicUrl:picUrlsArray withiTop:iTop withtextView:_textView  withPicView:_picUrlsView];
    
    //转发内容容器
//    UIImage *image = [UIImage imageNamed:@"rect"];
//    [image resizableImageWithCapInsets:UIEdgeInsetsMake(20, 10, 10, 10)];
//    UIImageView *imageView = [[UIImageView alloc]initWithImage:image];
    if (retweetedTextStr) {
        //如果有转发内容
        int rH = [self  addText:retweetedTextStr andPicUrl:retweetedPicUrlsArray withiTop:0  withtextView:_retweetedTextView withPicView:_retweetedPicUrlsView];
        _retweetedView.frame = CGRectMake(5, iTop, 300, rH);
        //imageView.frame = _retweetedTextView.frame;
       // [_retweetedTextView addSubview:imageView];
        iTop += rH;
    }
    
    iTop += 10;
    _souceView.frame = CGRectMake(5, 5, 310, iTop);
}    

//内容和配图的高度
-(int)addText:(NSString *)textStr andPicUrl:(NSArray *)picUrlsArray withiTop:(int)iTop withtextView:(UITextView*)textView withPicView:(UIView*)picView{
    
    //内容
    //自适应文字
    [textView setText:textStr];
    //CGFloat textViewHeight = textView.contentSize.height;
    CGSize frame=  [textStr boundingRectWithSize:CGSizeMake(300, MAXFLOAT) withTextFont:[UIFont systemFontOfSize:15.0] withLineSpacing:7.0];
    textView.frame = CGRectMake(5, iTop, 300, frame.height);
    
    iTop += frame.height;
    
    //缩略图
    int high = 0;
    int x = 0;
    int num = picUrlsArray.count/3;
    int hightImage =(300-6)/3;
    
    if (picUrlsArray && picUrlsArray.count!=0) {
        
        for (UIView *subView in picView.subviews) {
            //避免重用
            [subView removeFromSuperview];
        }
             //算出高度
        high=((num+1)*(hightImage+3));
        if (picUrlsArray.count%3 == 0) {
            high -=hightImage+3;
        }
        picView.frame = CGRectMake(5, iTop, 300, high);
        
        iTop+=high;
        
        //将图片加在容器上
        for (int i=0; i<picUrlsArray.count; i++) {
            NSString *strUrl = [[picUrlsArray objectAtIndex:i]objectForKey:@"thumbnail_pic"];
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
    int iTop = 5;
    iTop += 40;
    iTop += 10;
    
    iTop += [self heightText:[dict objectForKey:@"text"] withpicArray:[dict objectForKey:@"pic_urls"]];
    
    if ([dict objectForKey:@"retweeted_status"]) {
        iTop += [self heightText:[[dict objectForKey:@"retweeted_status"] objectForKey:@"text"] withpicArray:[[dict objectForKey:@"retweeted_status"] objectForKey:@"pic_urls"]];
    }
    return iTop;
}

//根据内容和缩图图算高度
+(int)heightText:(NSString*)text withpicArray:(NSArray*)picArray
{
    //内容
    int height = 10;
//    CGSize size = [text sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(200, CGFLOAT_MAX) lineBreakMode:NSLineBreakByCharWrapping];
    
    CGSize size = [text boundingRectWithSize:CGSizeMake(300, MAXFLOAT) withTextFont:[UIFont systemFontOfSize:15.0] withLineSpacing:7.0];
    height = size.height + 10;
    //图片是否有
    int num = picArray.count/3;
    int hightImage =(300-6)/3;
    if (picArray && picArray.count!=0) {
        height +=((num+1)*(hightImage+3));
        if (picArray.count%3 == 0) {
            height -=hightImage+3;
        }
    }
    //NSLog(@"%d",height);
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
    NSString *time =  [formatter2 stringFromDate:[formatter dateFromString:createAt]];
    return time;
}

@end
