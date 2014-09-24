//
//  SinaCell.h
//  SinaWeiboDemo
//
//  Created by iHope on 13-12-23.
//  Copyright (c) 2013年 任海丽. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImageView+LoadView.h"
#import "NSString+autoFit.h"

@interface SinaCell : UITableViewCell{
}

@property (nonatomic, retain) UIView *souceView;//总容器

@property (nonatomic, retain) UIImageView *photoImageView;//头像

@property (nonatomic, retain) UILabel *userNameLabel;//用户昵称

@property (nonatomic, retain) UILabel *timelabel;//时间

@property (nonatomic, retain) UILabel *sourceLabel;//来源

@property(nonatomic,retain) UITextView *textView;//正文内容

@property (nonatomic, retain) UIView *picUrlsView;//正文缩略图

@property (nonatomic, retain) UIView *retweetedView;//转发内容容器

@property(nonatomic,retain)UITextView *retweetedTextView;//转发内容

@property (nonatomic, retain) UIView *retweetedPicUrlsView;//转发内容缩略图

//设置内容
-(void)setContent:(NSMutableDictionary*)dict;

//算出其高度
+(int)heightWith:(NSMutableDictionary*)dict;

//根据内容和缩图图算高度
+(int)heightText:(NSString*)text withpicArray:(NSArray*)picArray;

//处理新浪时间
+(NSString*)formatDaySinaTime:(NSString*)createAt;

@end
