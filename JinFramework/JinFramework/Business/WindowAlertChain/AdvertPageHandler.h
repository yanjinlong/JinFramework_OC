//
//  ADConcreteHandler.h
//  JinFramework
//
//  Created by denghaishu on 2017/6/24.
//  Copyright © 2017年  Tribetech. All rights reserved.
//

#import "WindowAlertAbstracttHandler.h"
#import <UIKit/UIKit.h>

#define SHOWAD_TIME         3
#define VIDEO_SHOW_TIME     10

/**
 广告处理者
 */
@interface AdvertPageHandler : WindowAlertAbstracttHandler

/**
 启动带图片效果的
 
 @param image 图片
 
 @return 启动页的实体对象
 */
- (instancetype)initWithImage:(UIImage *)image;

/**
 启动带视频路径
 
 @param videoPath 视频路径
 
 @return 启动页的实体对象
 */
- (instancetype)initWithVideoPath:(NSString *)videoPath;

/**
 开始播放视频时的bolck
 */
@property (copy, nonatomic) void(^beginPalyVideo)();

@end
