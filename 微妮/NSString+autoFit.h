//
//  NSString+autoFit.h
//  textViewTest
//
//  Created by 刘锦 on 14-4-13.
//  Copyright (c) 2014年 刘锦. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (autoFit)
-(NSMutableAttributedString *)attributedStringFromStingWithFont:(UIFont *)font
withLineSpacing:(CGFloat)lineSpacing;
-(CGSize)boundingRectWithSize:(CGSize)size
withTextFont:(UIFont *)font
withLineSpacing:(CGFloat)lineSpacing;
@end
