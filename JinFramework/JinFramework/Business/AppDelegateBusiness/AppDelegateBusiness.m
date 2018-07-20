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
