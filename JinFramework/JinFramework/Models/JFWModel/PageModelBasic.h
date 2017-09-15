//
//  PageModelBasic.h
//  JinFramework
//
//  Created by Jin on 2017/5/2.
//  Copyright © 2017年 Tribetech. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 分页实体类
 */
@interface PageModelBasic : NSObject

/**
 每页数量多少条
 */
@property (assign, nonatomic) NSInteger pageSize;

/**
 当前第几页
 */
@property (assign, nonatomic) NSInteger pageIndex;

/**
 总共多少页
 */
@property (assign, nonatomic) NSInteger totalPage;

/**
 总共多少条数据
 */
@property (assign, nonatomic) NSInteger totalSize;

/**
 数据实体
 */
@property (strong, nonatomic) NSMutableArray *dataArray;

/**
 拷贝信息除了dataArray属性

 @param otherModel 另外一个实体对象
 */
- (void)copyInfoButDataArray:(PageModelBasic *)otherModel;

@end
