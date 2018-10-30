//
//  WindowAlertAbstractView.h
//  JinFramework
//
//  Created by 严锦龙 on 2018/10/30.
//  Copyright © 2018年 Jin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WindowAlertAbstractHandler.h"
#import "YYKit.h"
#import "JFWConfig.h"
#import "JFWUI.h"

/**
 责任链抽象弹窗视图类
 */
@interface WindowAlertAbstractView : UIView

/**
 关联的职责对象
 */
@property (weak, nonatomic) WindowAlertAbstractHandler *alertChainHandler;
@property (weak, nonatomic) UIWindow *window;

/**
 自定义的初始化视图的方法
 */
- (void)customView;

/**
 展示视图
 */
- (void)show;

/**
 移除视图
 */
- (void)dismiss;

@end
