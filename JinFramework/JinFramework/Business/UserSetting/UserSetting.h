//
//  UserSetting.h
//  JinFramework
//
//  Created by Jin on 2017/5/2.
//  Copyright © 2017年 Tribetech. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 用户本地数据的业务类（主要是NSUserDefault的代码集中地）
 */
@interface UserSetting : NSObject

#pragma mark- 经纬度

/**
 保存纬度

 @param latitude 纬度
 */
+ (void)saveLatitude:(NSString *)latitude;

/**
 获取纬度

 @return 纬度
 */
+ (NSString *)getLatitude;

/**
 保存经度

 @param longitude 经度
 */
+ (void)saveLongitude:(NSString *)longitude;

/**
 获取经度

 @return 经度
 */
+ (NSString *)getLongitude;

#pragma mark- 人机交互的设置

/**
 设置人机交互设置所选项的值

 @param value 值
 */
+ (void)saveAIConfigSelected:(NSString *)value;

/**
 获取人机交互设置所选项的值

 @return 值
 */
+ (NSString *)getAIConfigSelected;

@end
