//
//  NotificationCenter.h
//  JinFramework
//
//  Created by Jin on 2017/5/2.
//  Copyright © 2017年 Tribetech. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 集中的通知代码地，对外提供业务方法
 */
@interface NotificationCenter : NSObject

#pragma mark- 跳转到登录需求

/**
 post跳转到登录 （涉及标记账户在其他设备登录的问题，此处仅供接口请求时根据错误码来调用）
 */
+ (void)postGoToLogin;

/**
 *  添加跳转到登录的监听
 *
 *  @param observer  监听的对象
 *  @param aSelector 执行的方法
 */
+ (void)addGoToLoginObserver:(id)observer selector:(SEL)aSelector;

/**
 *  移除跳转到登录的监听
 *
 *  @param observer  监听的对象
 */
+ (void)removeGoToLoginObserver:(id)observer;

#pragma mark- 登录成功

/**
 post登录成功
 */
+ (void)postLoginSuccess;

/**
 *  添加登录成功的监听
 *
 *  @param observer  监听的对象
 *  @param aSelector 执行的方法
 */
+ (void)addLoginSuccessObserver:(id)observer selector:(SEL)aSelector;

/**
 *  移除登录成功的监听
 *
 *  @param observer  监听的对象
 */
+ (void)removeLoginSuccessObserver:(id)observer;

@end
