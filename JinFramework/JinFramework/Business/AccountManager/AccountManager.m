//
//  AccountManager.m
//  JinFramework
//
//  Created by Jin on 2017/5/2.
//  Copyright © 2017年 Tribetech. All rights reserved.
//

#import "AccountManager.h"
#import "NSObject+YYAdd.h"
#import "JFWConfig.h"

/**
  持久化数据管理类
 */
@interface AccountManager ()

@end

@implementation AccountManager

+ (BOOL)isLogin {
    return NO;
}

+ (void)logout {
    
}

+ (NSString *)getAccessToken {
    return nil;
}

+ (NSString *)getRefreshToken {
    return nil;
}

+ (void)saveAccountModel:(NSDictionary *)model {
    
}

@end
