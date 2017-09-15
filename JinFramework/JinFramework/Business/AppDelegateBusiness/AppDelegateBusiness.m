//
//  AppDelegateBusiness.m
//  JinFramework
//
//  Created by Jin on 2017/5/2.
//  Copyright © 2017年 Tribetech. All rights reserved.
//

#import "AppDelegateBusiness.h"
#import "WindowAlertBusiness.h"
#import "NetworkManager.h"
#import "JFWConfig.h"
#import "JFWUI.h"

/**
 appdelegate 的业务处理类
 */
@interface AppDelegateBusiness ()

@property (nonatomic, strong) WindowAlertBusiness *windowAlertBusiness;
@property (nonatomic, strong) NetworkManager *network;

@end

@implementation AppDelegateBusiness

- (instancetype)init {
    self = [super init];
    
    if (self) {
        [self.windowAlertBusiness getWindowAlertMessageRequest];
    }
    
    return self;
}

#pragma mark - 设置导航栏样式

/**
 设置nav的样式
 
 @param nav nav控制器
 */
+ (void)setNavStyle:(UINavigationController *)nav {
    UIImageView *bgImageView;
    UIView *underLineView;
    UIView *navBGView;
    UIColor *tintColor = C3;
    UIColor *backgroundColor = C7;
    
    if (kiOS10Later) {
        nav.navigationBar.tintColor = tintColor;
        [nav.navigationBar setTitleTextAttributes:@{ NSForegroundColorAttributeName : tintColor }];
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
        
        // 背景视图的新对象
        navBGView = [[UIView alloc] initWithFrame:CGRectMake(0, -UI_STATUSBAR_HEIGHT,
                                                             UI_SCREEN_FWIDTH, UI_TOP_HEIGHT)];
        navBGView.backgroundColor = backgroundColor;
        
        // 图片背景
        bgImageView = [[UIImageView alloc] initWithFrame:navBGView.bounds];
        bgImageView.hidden = YES;
        [navBGView addSubview:bgImageView];
        bgImageView.userInteractionEnabled = NO;
        
        // 下划线
        CGFloat scale = [UIScreen mainScreen].scale;
        CGFloat height = 1 / scale;
        underLineView = [[UIView alloc] initWithFrame:CGRectMake(0, UI_TOP_HEIGHT,
                                                                 UI_SCREEN_FWIDTH, height)];
        underLineView.backgroundColor = [JFWUI getLineColor];
        [navBGView addSubview:underLineView];
        
        // 重置背景视图
        [nav.navigationBar setValue:navBGView forKey:@"backgroundView"];
    }
    else {
        nav.navigationBar.tintColor = tintColor;
        [nav.navigationBar setTitleTextAttributes:@{ NSForegroundColorAttributeName : tintColor }];
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
        [nav preferredStatusBarStyle];
        
        // 背景视图的新对象
        navBGView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, UI_SCREEN_FWIDTH, UI_TOP_HEIGHT)];
        navBGView.backgroundColor = backgroundColor;
        
        // 图片背景
        bgImageView = [[UIImageView alloc] initWithFrame:navBGView.bounds];
        bgImageView.hidden = YES;
        [navBGView addSubview:bgImageView];
        
        // 下划线
        CGFloat scale = [UIScreen mainScreen].scale;
        CGFloat height = [JFWUI get1pxLinePixelValue];
        underLineView = [[UIView alloc] initWithFrame:CGRectMake(0, UI_TOP_HEIGHT,
                                                                 UI_SCREEN_FWIDTH, height)];
        underLineView.backgroundColor = [JFWUI getLineColor];
        [navBGView addSubview:underLineView];
        
        // 对背景视图进行改造
        UIView *bgView = [nav.navigationBar valueForKey:@"backgroundView"];
        
        // 移除底部自带的底线，由我们自己额外添加一条底线来控制
        for (UIView *item in bgView.subviews) {
            if (item.frame.size.height * scale == 1) {
                [item removeFromSuperview];
                break;
            }
        }
        
        [bgView addSubview:navBGView];
    }
}

/**
 获得导航栏背景视图

 @param nav 导航栏
 @return 背景视图
 */
+ (UIView *)getNavigationBarBackgroundView:(UINavigationController *)nav {
    if (kiOS10Later) {
        UIView *bgView = [nav.navigationBar valueForKey:@"backgroundView"];
        return bgView;
    }
    else {
        UIView *bgView = [nav.navigationBar valueForKey:@"backgroundView"];
        
        if (bgView.subviews.count > 0) {
            return bgView.subviews[0];
        }
        else {
            return bgView;
        }
    }
}

#pragma mark - 弹窗业务

- (WindowAlertBusiness *)windowAlertBusiness {
    if (!_windowAlertBusiness) {
        _windowAlertBusiness = [[WindowAlertBusiness alloc] init];
    }
    
    return _windowAlertBusiness;
}

- (NetworkManager *)network {
    if (!_network) {
        _network = [[NetworkManager alloc] initWithDelegate:self];
    }
    
    return _network;
}

/**
 获取相关弹窗页面数据
 */
- (void)getChainViewRequest {
    [self.windowAlertBusiness getWindowAlertMessageRequest];
}

/**
 *  显示相关弹窗页面
 */
- (void)showChainView {
    [self.windowAlertBusiness showWindowAlert];
}

@end
