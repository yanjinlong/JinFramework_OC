//
//  AccountManager.h
//  JinFramework
//
//  Created by Jin on 2017/5/2.
//  Copyright © 2017年 Tribetech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DiskCache.h"

/**
 持久化数据管理类
 */
@interface AccountManager : NSObject

/**
 是否登录

 @return yes已登录；no未登录
 */
+ (BOOL)isLogin;

/**
 退出登录
 */
+ (void)logout;

+ (NSString *)getAccessToken;
+ (NSString *)getRefreshToken;

+ (void)saveAccountModel:(NSDictionary *)model;

@end
