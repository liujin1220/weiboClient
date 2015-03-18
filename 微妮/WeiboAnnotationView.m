//
//  WeiboAnnotationView.m
//  微妮
//
//  Created by 刘锦 on 14/12/1.
//  Copyright (c) 2014年 liujin. All rights reserved.
//

#import "WeiboAnnotationView.h"
#import "WeiboAnnotation.h"
#import "userModel.h"

@interface WeiboAnnotationView(){
    UIImageView *userImage;//用户图像
    UIImageView *weiboImage;//微博图片视图
    UILabel *textLabel;//微博内容
}

@end

@implementation WeiboAnnotationView

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        //
    }
    return self;
}
-(id)initWithAnnotation:(id<MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if (self!=nil) {
        [self initView];
    }
    return self;
}
-(void)initView{
    userImage = [[UIImageView alloc]initWithFrame:CGRectZero];
    userImage.layer.borderColor = [UIColor whiteColor].CGColor;
    userImage.layer.borderWidth = 1.0;
    
    weiboImage = [[UIImageView alloc]initWithFrame:CGRectZero];
    //weiboImage.contentMode = UIViewContentModeScaleAspectFit;
    weiboImage.backgroundColor = [UIColor blackColor];
    
    textLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    textLabel.font = [UIFont systemFontOfSize:12.0];
    textLabel.textColor = [UIColor whiteColor];
    textLabel.backgroundColor = [UIColor clearColor];
    textLabel.numberOfLines = 3;
    
    [self addSubview:userImage];
    [self addSubview:weiboImage];
    [self addSubview:textLabel];
}
-(void)layoutSubviews{
    [super layoutSubviews];
    WeiboAnnotation *weiboAnnotation = self.annotation;
    UserModel *weibo = nil;
    if ([weiboAnnotation isKindOfClass:[WeiboAnnotation class]]) {
        weibo = weiboAnnotation.weiboModel;
    }
    NSString *thumbnailImage = weibo.thumbnailImage;
    if ( ![thumbnailImage isEqual:@"(null)"]) {
        if (thumbnailImage.length > 0) {
            //带微博图片
            //显示正方形图片
            self.image = [UIImage imageNamed:@"nearby_map_photo_bg"];
            //加载微博图片
            weiboImage.frame = CGRectMake(15, 15, 90, 85);
            [weiboImage setImageWithURL:[NSURL URLWithString:thumbnailImage]];
            //加载用户图像
            userImage.frame = CGRectMake(70, 70, 30, 30);
            NSString *usrUrl = weibo.headImageUrl;
            [userImage setImageWithURL:[NSURL URLWithString:usrUrl]];
            
            textLabel.hidden = YES;
        }
    }else{
        //不带微博视图
        self.image = [UIImage imageNamed:@"nearby_map_content"];
        //加载用户图像
        userImage.frame = CGRectMake(20, 20, 45, 45);
        NSString *usrUrl = weibo.headImageUrl;
        [userImage setImageWithURL:[NSURL URLWithString:usrUrl]];
        
        textLabel.frame = CGRectMake(45+20+5, 20, 110, 45);
        textLabel.text = weibo.mainBody;
        
        textLabel.hidden = NO;
        weiboImage.hidden = YES;
    }
}
@end
