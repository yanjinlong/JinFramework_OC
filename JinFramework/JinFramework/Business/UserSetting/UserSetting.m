//
//  UserSetting.m
//  JinFramework
//
//  Created by Jin on 2017/5/2.
//  Copyright © 2017年 Tribetech. All rights reserved.
//

#import "UserSetting.h"

static NSString *const kLatitude = @"kLatitude";
static NSString *const kLongitude = @"kLongitude";
static NSString *const kAIConfigSelected = @"kAIConfigSelected";

/**
 用户本地数据的业务类（主要是NSUserDefault的代码集中地）
 */
@implementation UserSetting

#pragma mark- 经纬度

/**
 保存纬度
 
 @param latitude 纬度
 */
+ (void)saveLatitude:(NSString *)latitude {
    [[NSUserDefaults standardUserDefaults] setValue:latitude forKey:kLatitude];
}

/**
 获取纬度
 
 @return 纬度
 */
+ (NSString *)getLatitude {
    return [[NSUserDefaults standardUserDefaults] objectForKey:kLatitude];
}

/**
 保存经度
 
 @param longitude 经度
 */
+ (void)saveLongitude:(NSString *)longitude {
    [[NSUserDefaults standardUserDefaults] setValue:longitude forKey:kLongitude];
}

/**
 获取经度
 
 @return 经度
 */
+ (NSString *)getLongitude {
    return [[NSUserDefaults standardUserDefaults] objectForKey:kLongitude];
}

#pragma mark- 人机交互的设置

/**
 设置人机交互设置所选项的值
 
 @param value 值
 */
+ (void)saveAIConfigSelected:(NSString *)value {
    [[NSUserDefaults standardUserDefaults] setValue:value forKey:kAIConfigSelected];
}

/**
 获取人机交互设置所选项的值
 
 @return 值
 */
+ (NSString *)getAIConfigSelected {
    return [[NSUserDefaults standardUserDefaults] objectForKey:kAIConfigSelected];
}

@end
