//
//  DiskCache.h
//  JinFramework
//
//  Created by Jin on 2017/5/23.
//  Copyright © 2017年 Tribetech. All rights reserved.
//

#import "YYDiskCache.h"

/**
 部族科技的闪存缓存类
 */
@interface DiskCache : YYDiskCache

/**
 单例入口

 @return 缓存类对象
 */
+ (instancetype)shareCache;

@end
