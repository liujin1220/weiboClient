//
//  tencentCell.m
//  微妮
//
//  Created by 刘锦 on 14/10/28.
//  Copyright (c) 2014年 liujin. All rights reserved.
//

#import "tencentCell.h"
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
@implementation tencentCell

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self createView];
    }
    return self;
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
/*
 * dict         info        nick：昵称
 *                              head：头像
 *                              timestamp：时间
 *                              from：来源
 *                              image：图片
 *                              text：正文
 *                              type：类型 1-原创发表，2-转载，3-私信，4-回复，5-空回，6-提及，7-评论,
 *                              source：原微博（包含上述字段）          nick
 *                                                                                                   head
 *                                                                                                     ...
 *                  user
 */
-(void)setContent:(NSMutableDictionary*)info
{
    /*获取所需信息*/
    //头像
    NSString *photoStr =[NSString stringWithFormat:@"%@/50",[info objectForKey:@"head"]] ;
    //昵称
    NSString *userNameStr = [NSString stringWithString:[info objectForKey:@"nick"]];
    //时间
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[(NSNumber *)[info objectForKey:@"timestamp"] doubleValue]];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"MM-dd HH:mm";
    NSString *timeStr =  [formatter stringFromDate:date];
    //来源
    NSString *sourceStr = [NSString stringWithString:[info objectForKey:@"from"]];
    //正文
    NSString *textStr = [NSString stringWithString:[info objectForKey:@"text"]];
    //微博配图地址
    NSArray *picUrlsArray =[NSArray array];
    if ((NSNull *)[info objectForKey:@"image"] != [NSNull null]) {
        picUrlsArray = [info objectForKey:@"image"];
    }
    //转发微博
    //被转发原微博的作者姓名+正文retweetedTextStr+配图地址retweetedPicUrlsArray
    NSString *retweetedTextStr = [NSString string];
    NSArray *retweetedPicUrlsArray = [NSArray array];
    if ([[info objectForKey:@"type"]isEqualToNumber:[NSNumber numberWithInt:2]]) {
        //转载
        NSMutableDictionary *source = [NSMutableDictionary dictionaryWithDictionary:[info objectForKey:@"source"]];
        retweetedTextStr = [NSString stringWithFormat:@"@%@:",[source objectForKey:@"nick"]];
        retweetedTextStr = [retweetedTextStr stringByAppendingString:[source objectForKey:@"text"]];
        retweetedPicUrlsArray = [source objectForKey:@"image"];
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
    if ([[info objectForKey:@"type"]isEqualToNumber:[NSNumber numberWithInt:2]]) {
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
    int hightImage =(300-6)/3;
    if ((NSNull *)picUrlsArray != [NSNull null]) {
        int num = (int)picUrlsArray.count/3;
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
            NSString *strUrl = [NSString stringWithFormat:@"%@/460",[picUrlsArray objectAtIndex:i]] ;
            UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(x, (i/3)*(hightImage+3), hightImage, hightImage)];
            imageView.contentMode = UIViewContentModeScaleAspectFill;
            imageView.clipsToBounds = YES;
            imageView.userInteractionEnabled = NO;
            //头像  /50小   /180大
            // 微博中的图片 /160缩略图   /460大图   /2000原图
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
+(int)heightWith:(NSMutableDictionary*)info
{
    int iTop = 5;
    iTop += 40;
    iTop += 10;
    NSArray *picArr = [NSArray array];
    //判断是否为空
    if ((NSNull *)[info objectForKey:@"image"] != [NSNull null]) {
        picArr = [info objectForKey:@"image"];
    }
    iTop += [self heightText:[info objectForKey:@"text"] withpicArray:picArr];
    
    if ([[info objectForKey:@"type"]isEqualToNumber:[NSNumber numberWithInt:2]]) {
        iTop += [self heightText:[[info objectForKey:@"source"] objectForKey:@"text"] withpicArray:[[info objectForKey:@"source"] objectForKey:@"image"]];
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
    if ((NSNull *)picArray != [NSNull null]) {
        int num = (int)picArray.count/3;
        int hightImage =(300-6)/3;
        height +=((num+1)*(hightImage+3));
        if (picArray.count%3 == 0) {
            height -=hightImage+3;
        }
    }
    //NSLog(@"%d",height);
    return height;
}


@end
