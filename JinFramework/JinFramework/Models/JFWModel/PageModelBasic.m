//
//  PageModelBasic.m
//  JinFramework
//
//  Created by Jin on 2017/5/2.
//  Copyright © 2017年 Tribetech. All rights reserved.
//

#import "PageModelBasic.h"

/**
 分页实体类
 */
@implementation PageModelBasic

- (instancetype)init {
    self = [super init];
    
    if (self) {
        // 帮忙初始化数组
        _dataArray = [NSMutableArray new];
    }
    
    return self;
}

/**
 拷贝信息除了dataArray属性
 
 @param otherModel 另外一个实体对象
 */
- (void)copyInfoButDataArray:(PageModelBasic *)otherModel {
    otherModel.pageIndex = self.pageIndex;
    otherModel.pageSize = self.pageSize;
    otherModel.totalPage = self.totalPage;
    otherModel.totalSize = self.totalSize;
}

@end
