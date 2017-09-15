//
//  DiskCache.m
//  JinFramework
//
//  Created by Jin on 2017/5/23.
//  Copyright © 2017年 Tribetech. All rights reserved.
//

#import "DiskCache.h"

/**
 部族科技的闪存缓存类
 */
@interface DiskCache()

@end

static DiskCache *cache;

@implementation DiskCache

/**
 单例入口
 
 @return 缓存类对象
 */
+ (instancetype)shareCache {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString *path = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
        
        cache = [[DiskCache alloc] initWithPath:[NSString stringWithFormat:@"%@/%@", path, @"JFWCache"]];
    });
    
    return cache;
}

@end
