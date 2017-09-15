//
//  JFWSheetBaseView.m
//  JinFramework
//
//  Created by Jin on 2017/6/7.
//  Copyright © 2017年 Tribetech. All rights reserved.
//

#import "JFWSheetBaseView.h"
#import "JFWUI.h"
#import "JGActionSheet.h"
#import "UINavigationController+FDFullscreenPopGesture.h"
#import "JFWConfig.h"

/**
 *  从下而上的弹出框的基类
 */
@interface JFWSheetBaseView()

@property (strong, nonatomic) JGActionSheet *sheet;

@end

@implementation JFWSheetBaseView

- (instancetype)init {
    self = [super init];
    
    if (self) {
        [self initBaseView];
    }
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        [self initBaseView];
    }
    
    return self;
}

- (void)initBaseView {
    _topViewController = [JFWUI getTopViewController];
    
    JGActionSheetSection *selectSection = [JGActionSheetSection sectionWithTitle:nil
                                                                         message:nil
                                                                     contentView:self];
    
    _sheet = [JGActionSheet actionSheetWithSections:@[selectSection]];
}

/**
 *  展示view
 */
- (void)showSheet {
    [self showSheetWithSelector:@selector(dismissSheet) target:self];
}

/**
 *  展示view，可以自定义关闭方法
 *
 *  @param aSelector 关闭后执行的方法
 *  @param target    执行方法的对象
 */
- (void)showSheetWithSelector:(SEL)aSelector target:(id)target {
    __weak typeof (self) weakSelf = self;
    
    [_sheet setOutsidePressBlock:^(JGActionSheet *sheet) {
        // 执行用户的方法
        if ([target respondsToSelector:aSelector]) {
            [target performSelector:aSelector withObject:nil afterDelay:0.0];
        }
        
        // 开启掉滑动返回
        weakSelf.topViewController.fd_interactivePopDisabled = NO;
    }];
    
    [_sheet showInView:weakSelf.topViewController.navigationController.view animated:YES];
    // 禁用掉滑动返回
    weakSelf.topViewController.fd_interactivePopDisabled = YES;
}

/**
 *  关闭弹出框
 */
- (void)dismissSheet {
    if (_sheet && _sheet.visible) {
        [_sheet dismissAnimated:YES];
        
        // 开启掉滑动返回
        self.topViewController.fd_interactivePopDisabled = NO;
    }
}

@end
