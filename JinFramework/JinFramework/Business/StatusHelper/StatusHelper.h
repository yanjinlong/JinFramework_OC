//
//  StatusHelper.h
//  JinFramework
//
//  Created by Jin on 2017/6/1.
//  Copyright © 2017年  Tribetech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/**
 主要处理文本相关的帮助类，也有表情相关的
 */
@interface StatusHelper : NSObject

/**
 At正则 例如 @王思聪
 */
+ (NSRegularExpression *)regexAt;

/**
 话题正则 例如 #暖暖环游世界#
 */
+ (NSRegularExpression *)regexTopic;

/**
 表情正则 例如 [偷笑]
 */
+ (NSRegularExpression *)regexEmoticon;

/**
 获得表情的字典
 
 @return 表情字典
 */
+ (NSMutableDictionary *)getEmoticonDict;

/**
 获得表情的key数组
 
 @return 表情key数组
 */
+ (NSMutableArray *)getEmoticonKeyArray;

/**
 根据性别获得性别的图片

 @param gender 性别值 0女，1男，2保密
 @return 对应的性别图片
 */
+ (UIImage *)getGenderImageByGenderValue:(NSInteger)gender;

/**
 标签颜色数组
 
 @return 颜色数组
 */
+ (NSArray *)labelColorArray;

/**
 *  重置手机号码文本显示成   139****2342
 *
 *  @param phone 手机文本
 *
 *  @return 重置后的手机号码
 */
+ (NSString *)reSetPhoneText:(NSString *)phone;

/**
 验证手机号是否合法有效

 @param mobileNum 手机号
 @return YES有效 NO无效
 */
+ (BOOL)isValidPhoneNumber:(NSString *)mobileNum;

/**
 校验密码是否合法

 @param password 校验的密码
 @param resultStr 不合法时返回对应错误字符串
 @return YES 合法 NO不合法
 */
+ (BOOL)validPassWordCharacter:(NSString *)password result:(NSString **)resultStr;

/**
 检测输入框是否是金额的文本
 
 @param textField 文本框
 @param range 输入的位置
 @param string 输入的文本
 @param maxLength 长度控制
 @param isFirstZero 是否第一个是0
 @param isHaveDian 是否带点
 @return yes可以输入，no不可输入
 */
+ (BOOL)checkDecimalText:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string maxLength:(NSInteger)maxLength isFirstZero:(BOOL *)isFirstZero isHaveDian:(BOOL *)isHaveDian;

/**
 得到中英文混合字符串长度
 
 @param text 字符串
 @return 字符长度
 */
+ (NSInteger)getStringCharLength:(NSString *)text;

/**
 通过银行卡类型获得图标
 
 @param type 类型
 @return 图标
 */
+ (UIImage *)getBankImageByType:(NSInteger)type;

/**
 获取默认支付方式

 @return 支付方式数组
 */
+ (NSMutableArray *)getDefaultPayTypeArray;

/**
 获取资讯的来源描述

 @param source 来源类型 0新浪 1自编
 @return 来源字符串
 */
+ (NSString *)getNewsSourceByType:(NSInteger)source;

/**
 获取资讯的来源图标
 
 @param source 来源类型 0新浪 1自编
 @return 来源图标
 */
+ (UIImage *)getNewsSourceImageByType:(NSInteger)source;

#pragma mark- 阅读、评论和收藏等数量处理

/**
 *  阅读、评论和收藏等数量处理 超过一万 按 1.x亿 1.x万返回
 *
 *  @return 转换后阅读数字符串
 */
+ (NSString *)getFoldCount:(NSInteger)count;

@end
