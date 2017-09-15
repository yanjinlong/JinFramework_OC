//
//  JFWEmptyView.h
//  JinFramework
//
//  Created by Jin on 2017/5/3.
//  Copyright © 2017年 Tribetech. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 空视图的界面类型

 - EmptyViewTypeNoNet: 无网
 - EmptyViewTypeNoData: 无数据
 */
typedef NS_ENUM(NSInteger, EmptyViewType) {
    EmptyViewTypeNoNet,
    EmptyViewTypeNoData,
};

/**
 空视图（无网，无数据）
 */
@interface JFWEmptyView : UIView

/**
 点击了屏幕触发block
 */
@property (copy, nonatomic) void(^didTouchViewBlock)();
@property (assign, nonatomic) EmptyViewType viewType;
@property (copy, nonatomic) NSString *tipsText;

@end
