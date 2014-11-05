//
//  tencentCell.h
//  微妮
//
//  Created by 刘锦 on 14/10/28.
//  Copyright (c) 2014年 liujin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImageView+WebCache.h"
@class RTLabel;
@interface tencentCell : UITableViewCell

//设置内容
-(void)setContent:(NSMutableDictionary*)dict;

//算出其高度
+(int)heightWith:(NSMutableDictionary*)dict;

//根据内容和缩图图算高度
+(int)heightText:(NSString*)text withpicArray:(NSArray*)picArray;


@end
