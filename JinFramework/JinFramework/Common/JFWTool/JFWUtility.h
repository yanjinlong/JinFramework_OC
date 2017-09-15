//
//  JFWUtility.h
//  JinFramework
//
//  Created by Jin on 2017/4/29.
//  Copyright © 2017年 Tribetech. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 一些设备的，获取时间、数值处理的公共方法封装
 */
@interface JFWUtility : NSObject

#pragma mark- 时间相关

/**
 获得当前时间戳

 @return 当前时间戳
 */
+ (NSString *)timestamp;

/**
 *  日期转换为字符串
 *
 *  @param date     日期
 *  @param format   格式字符串，默认是：yyyy-MM-dd HH:mm:ss
 *
 *  @return 转换后的日期字符串
 */
+ (NSString *)stringFromDate:(NSDate *)date format:(NSString *)format;

#pragma mark- app相关

#pragma mark- 设备相关

/**
 获得设备的唯一id
 
 @return 设备唯一id
 */
+ (NSString *)getDeviceCode;

/**
 保存设备Token
 
 @param deviceTokenStr 设备Token
 */
+ (void)saveDeviceTokenStr:(NSString *)deviceTokenStr;

/**
 获得设备toke
 
 @return 设备Token
 */
+ (NSString *)getDeviceTokenStr;

#pragma mark- 其他

/**
 *  获取一个随机整数，范围在[from,to），包括from，不包括to
 *
 *  @param from from 包括from
 *  @param to   to 不包括to
 *
 *  @return 随机整数
 */
+ (NSInteger)getRandomNumber:(NSInteger)from to:(NSInteger)to;

@end
