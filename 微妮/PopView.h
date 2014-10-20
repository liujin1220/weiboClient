//
//  PopView.h
//  PopupViewDemo
//
//  Created by 刘锦 on 14-9-10.
//  Copyright (c) 2014年 liujin. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SinaOAuthFinishedDelegate <NSObject>
-(void)SinaOAuthFinishedWithCode:(NSString *)code;
@end

typedef void(^dismissViewBlock)(void);

@interface PopView : UIView<UIWebViewDelegate>
@property(nonatomic,strong)UIWebView *mwebView;
@property(nonatomic,copy)dismissViewBlock block;
@property(nonatomic,weak)id<SinaOAuthFinishedDelegate> delegate;
@end
