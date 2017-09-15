//
//  NotificationCenter.m
//  JinFramework
//
//  Created by Jin on 2017/5/2.
//  Copyright © 2017年 Tribetech. All rights reserved.
//

#import "NotificationCenter.h"
#import "AccountManager.h"

static NSString *const kGoToLogin = @"kGoToLogin";
static NSString *const kLogin = @"kLogin";

/**
 集中的通知代码地，对外提供业务方法
 */
@implementation NotificationCenter

#pragma mark- 跳转到登录需求

/**
 post跳转到登录
 */
+ (void)postGoToLogin {
    [[NSNotificationCenter defaultCenter] postNotificationName:kGoToLogin object:nil];
    [AccountManager logout];
}

/**
 *  添加跳转到登录的监听
 *
 *  @param observer  监听的对象
 *  @param aSelector 执行的方法
 */
+ (void)addGoToLoginObserver:(id)observer selector:(SEL)aSelector {
    [[NSNotificationCenter defaultCenter] addObserver:observer selector:aSelector name:kGoToLogin object:nil];
}

/**
 *  移除跳转到登录的监听
 *
 *  @param observer  监听的对象
 */
+ (void)removeGoToLoginObserver:(id)observer {
    [[NSNotificationCenter defaultCenter] removeObserver:observer name:kGoToLogin object:nil];
}

#pragma mark- 登录成功

/**
 post登录成功
 */
+ (void)postLoginSuccess {
    [[NSNotificationCenter defaultCenter] postNotificationName:kLogin object:nil];
}

/**
 *  添加登录成功的监听
 *
 *  @param observer  监听的对象
 *  @param aSelector 执行的方法
 */
+ (void)addLoginSuccessObserver:(id)observer selector:(SEL)aSelector {
    [[NSNotificationCenter defaultCenter] addObserver:observer selector:aSelector name:kLogin object:nil];
}

/**
 *  移除登录成功的监听
 *
 *  @param observer  监听的对象
 */
+ (void)removeLoginSuccessObserver:(id)observer {
    [[NSNotificationCenter defaultCenter] removeObserver:observer name:kLogin object:nil];
}

@end
