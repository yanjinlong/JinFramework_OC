//
//  AppDelegate.m
//  JinFramework
//
//  Created by Jin on 2017/7/19.
//  Copyright © 2017年 Jin. All rights reserved.
//

#import "AppDelegate.h"
#import "AFNetworkActivityIndicatorManager.h"
#import "AFNetworking.h"
#import "AppDelegateBusiness.h"
#import "RTRootNavigationController.h"
#import "JFWTabBarController.h"
#import "IQKeyboardManager.h"
#import "JFWUI.h"

@interface AppDelegate ()

@property (strong, nonatomic) AppDelegateBusiness *delegateBusiness;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    JFWTabBarController *tabBarVC = [JFWTabBarController new];
    RTRootNavigationController *navVC = [[RTRootNavigationController alloc] initWithRootViewController:tabBarVC];
    
    [self initClient:launchOptions];
    
    [self.window setRootViewController:navVC];
    [self.window makeKeyAndVisible];
    
    // 展示相关弹窗视图
    [self.delegateBusiness showChainView];

    return YES;
}

#pragma mark- 初始化

/**
 初始化客户端
 */
- (void)initClient:(NSDictionary *)launchOptions {
    self.delegateBusiness = [[AppDelegateBusiness alloc] init];
    
    [self configIQKeyboard];
}

/**
 配置键盘管理者
 */
- (void)configIQKeyboard {
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.shouldResignOnTouchOutside = YES; // 控制点击背景是否收起键盘
    manager.toolbarDoneBarButtonItemText = @"完成";
    manager.toolbarTintColor = C3;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark-监听网络

- (void)isNetworking {
    // 开启网络指示器
    AFNetworkReachabilityManager *afNetworkReachabilityManager = [AFNetworkReachabilityManager sharedManager];
    
    [afNetworkReachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusReachableViaWWAN:
            case AFNetworkReachabilityStatusReachableViaWiFi:
                // 有网
                break;
            case AFNetworkReachabilityStatusNotReachable:
            default:
                // 无网
                break;
        }
    }];
    
    // 开始监听
    [afNetworkReachabilityManager startMonitoring];
    
}

@end
