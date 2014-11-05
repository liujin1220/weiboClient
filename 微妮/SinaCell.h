//
//  SinaCell.h
//  SinaWeiboDemo
//
//  Created by iHope on 13-12-23.
//  Copyright (c) 2013年 任海丽. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImageView+WebCache.h"
@class RTLabel;
@interface SinaCell : UITableViewCell{
}

//设置内容
-(void)setContent:(NSMutableDictionary*)dict;

//算出其高度
+(int)heightWith:(NSMutableDictionary*)dict;

//根据内容和缩图图算高度
+(int)heightText:(NSString*)text withpicArray:(NSArray*)picArray;

//处理新浪时间
+(NSString*)formatDaySinaTime:(NSString*)createAt;

@end
