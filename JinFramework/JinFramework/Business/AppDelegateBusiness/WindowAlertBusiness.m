//
//  WindowAlertBusiness.m
//  JinFramework
//
//  Created by denghaishu on 2017/6/26.
//  Copyright © 2017年  Tribetech. All rights reserved.
//

#import "WindowAlertBusiness.h"
#import "NetworkManager.h"
#import "WindowAlertHandler.h"
#import "AdvertiseBusiness.h"
#import "JFWConfig.h"

static NSString *const version  = @"sandbox_AppVersion";

/**
 *  处理弹窗的业务类
 */
@interface WindowAlertBusiness ()<NetworkDelegate>

@property (strong, nonatomic) NetworkManager *network;
@property (strong, nonatomic) AdvertPageHandler *adAlertHandler;

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

- (AdvertPageHandler *)alertHandler {
    if (!_adAlertHandler) {
        _adAlertHandler = [[AdvertPageHandler alloc] init];
        BOOL isHaveShowAdvertise = [AdvertiseBusiness isShowAdvertise];
        
        // 存在广告图则去处理看是图片还是视频
        if (isHaveShowAdvertise) {
            _adAlertHandler = [self handlerPlayStartVideoOrPicture];
        }
        
        // 引导图
        NewFeturePageHandler *newFeturePageHandler = [[NewFeturePageHandler alloc] init];
        _adAlertHandler.nextHandler = newFeturePageHandler;
        
        // 更新
        UpdatePageHandler *upDatePageHandler = [[UpdatePageHandler alloc] init];
        newFeturePageHandler.nextHandler = upDatePageHandler;
        
        // 新功能引导
        HomePageGuideHandler *homeGuideHandler = [[HomePageGuideHandler alloc] init];
        upDatePageHandler.nextHandler = homeGuideHandler;
    }
    
    return _adAlertHandler;
}

/**
 处理播放视频和启动图切换
 
 @return 返回starttime的额外多出时间
 */
- (AdvertPageHandler *)handlerPlayStartVideoOrPicture {
    // 1图片；2视频
    NSInteger type = [AdvertiseBusiness advertiseType];
    NSString *videoPath = [AdvertiseBusiness getAdvertiseVideoPath];
    UIImage *image = [AdvertiseBusiness getAdvertiseImage];
    AdvertPageHandler *adView;
    
    // 视频没下载好的则显示图片
    if (type == 1 && image) {
        // 图片
        adView = [[AdvertPageHandler alloc] initWithImage:image];
    }
    else if (type == 2 && videoPath) {
#warning 调试的时候注释掉，不然会崩溃
        // 视频
        adView = [[AdvertPageHandler alloc] initWithVideoPath:videoPath];
        
        UIWindow *window = [UIApplication sharedApplication].delegate.window;
        UIImageView *coverView = [[UIImageView alloc] init];
        coverView.frame = window.bounds;
        
        [self setCoverViewImage:coverView];
        [window addSubview:coverView];
        
        [adView setBeginPalyVideo:^{
            [UIView animateWithDuration:0.3 animations:^{
                coverView.alpha = 0;
            } completion:^(BOOL finished) {
                [coverView removeFromSuperview];
            }];
        }];
    }
    
    return adView;
}

/**
 设置覆盖图

 @param coverView 覆盖的视图
 */
- (void)setCoverViewImage:(UIImageView *)coverView {
    coverView.image = [UIImage imageNamed:@"launchNew"];
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
