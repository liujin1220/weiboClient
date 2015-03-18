//
//  PersonalHeaderView.h
//  微妮
//
//  Created by liujin on 15-2-9.
//  Copyright (c) 2015年 liujin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PersonalModel.h"

@protocol ButtonActionDalegate;

@interface PersonalHeaderView : UIView

@property (nonatomic, weak) id <ButtonActionDalegate> buttonActionDelegate;

- (void)setContentDataWithUserModel:(PersonalModel *)model;

@end


@protocol ButtonActionDalegate <NSObject>

- (void)buttonActions:(UIButton *)button;

@end