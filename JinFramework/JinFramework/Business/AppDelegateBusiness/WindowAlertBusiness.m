//
//  WindowAlertBusiness.m
//  JinFramework
//
//  Created by denghaishu on 2017/6/26.
//  Copyright © 2017年  Tribetech. All rights reserved.
//

#import "WindowAlertBusiness.h"
#import "NetworkManager.h"
#import "WindowAlertAbstractHandler.h"
#import "NewFeturePageHandler.h"
#import "UpdatePageHandler.h"
#import "HomePageGuideHandler.h"
#import "JFWConfig.h"

static NSString *const version  = @"sandbox_AppVersion";

/**
 *  处理弹窗的业务类
 */
@interface WindowAlertBusiness ()<NetworkDelegate>

@property (strong, nonatomic) NetworkManager *network;
@property (strong, nonatomic) WindowAlertAbstractHandler *firstHandler;

@end

@implementation WindowAlertBusiness

- (instancetype)init {
    self = [super init];
    
    if (self) {
        [self getWindowAlertMessageRequest];
    }
    
    return self;
}

#pragma mark - 懒加载

- (NetworkManager *)network {
    if (!_network) {
        _network = [[NetworkManager alloc] initWithDelegate:self];
    }
    
    return _network;
}

- (WindowAlertAbstractHandler *)alertHandler {
    if (_firstHandler == nil) {
        
        // 引导图
        _firstHandler = [[NewFeturePageHandler alloc] init];
        
        // 更新
        UpdatePageHandler *upDatePageHandler = [[UpdatePageHandler alloc] init];
        _firstHandler.nextHandler = upDatePageHandler;
        
        // 新功能引导
        HomePageGuideHandler *homeGuideHandler = [[HomePageGuideHandler alloc] init];
        upDatePageHandler.nextHandler = homeGuideHandler;
    }
    
    return _firstHandler;
}

#pragma mark - 获取相关弹窗页面数据

/**
 获取相关弹窗页面数据
 */
- (void)getWindowAlertMessageRequest {
    [self getAdvertInfo];   // 获取开机广告
    [self getGuidePage];    // 获取引导图信息
    [self getUpdateInfo];   // 获取是否右新版本提示
    [self getGuidePageInfo];    // 获取引导图信息
}

/**
 获取开机广告
 */
- (void)getAdvertInfo {
    
}

/**
 获取引导图信息
 */
- (void)getGuidePage {
    
}

/**
 获取新版本提示
 */
- (void)getUpdateInfo {
    
}

/**
 获取引导图信息
 */
- (void)getGuidePageInfo {
    
}

#pragma mark - 弹窗显示
/**
 *  显示相关弹窗页面
 */
- (void)showWindowAlert {
    [self.alertHandler handlerOwnTask];
}

@end
