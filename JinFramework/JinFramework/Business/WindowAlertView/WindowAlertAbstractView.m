//
//  WindowAlertAbstractView.m
//  JinFramework
//
//  Created by 严锦龙 on 2018/10/30.
//  Copyright © 2018年 Jin. All rights reserved.
//

#import "WindowAlertAbstractView.h"

/**
 责任链抽象弹窗视图类
 */
@interface WindowAlertAbstractView()

@end

@implementation WindowAlertAbstractView

- (instancetype)init {
    if (_window == nil) {
        _window = [[UIApplication sharedApplication] keyWindow];
    }
    
    self = [super initWithFrame:CGRectMake(0, 0, _window.frame.size.width, _window.frame.size.height)];
    
    if (self) {
        [self customView];
    }
    
    return self;
}

/**
 自定义的初始化视图的方法
 */
- (void)customView {
    
}

- (void)show {
    [self.window addSubview:self];
}

- (void)dismiss {
    [self removeFromSuperview];
    
    // 处理下一个职责类的工作判断
    [self.alertChainHandler.nextHandler handlerOwnTask];
}

@end
