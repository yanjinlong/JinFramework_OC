//
//  AdvertiseBusiness.h
//  NewMoonbasa
//
//  Created by JinMBS on 16/11/17.
//  Copyright © 2016年 JinMBS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/**
 启动广告的业务处理类
 */
@interface AdvertiseBusiness : NSObject

/**
 启动页类型
 
 @return 1图片；2视频
 */
+ (NSInteger)advertiseType;

/**
 *  获取广告页视频路径
 *
 *  @return 广告页视频路径
 */
+ (NSString *)getAdvertiseVideoPath;

/**
 获得启动页广告图片对象
 
 @return 广告图片对象
 */
+ (UIImage *)getAdvertiseImage;

/**
 是否显示启动广告
 
 @return yes显示；no不显示；
 */
+ (BOOL)isShowAdvertise;

/**
 保存启动广告数据

 @param dict 广告数据（接口返回）
 */
+ (void)saveAdvertiseData:(NSDictionary *)dict;

@end
