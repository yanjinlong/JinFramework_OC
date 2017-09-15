//
//  JFWRefreshViewController.h
//  JinFramework
//
//  Created by Jin on 2017/4/29.
//  Copyright © 2017年 Tribetech. All rights reserved.
//

#import "JFWViewController.h"
#import "PageModelBasic.h"
#import "MJRefresh.h"

/**
 主的上下拉刷新的控制器，提供一些简单的抽离封装
 使用方法，①设置支持下拉，上拉等选择；②调用setRefreshTableView方法
 */
@interface JFWRefreshViewController : JFWViewController

/**
 是否支持下拉刷新
 */
@property (nonatomic, assign) BOOL pullDown;

/**
 是否支持上拉加载
 */
@property (nonatomic, assign) BOOL pullUp;

/**
 是否存在更多
 */
@property (nonatomic, assign) BOOL hasMore;

@property (nonatomic, strong) MJRefreshGifHeader *headerView;
@property (nonatomic, strong) MJRefreshAutoNormalFooter *footerView;

/**
 分页数据
 */
@property (nonatomic, strong) PageModelBasic *pageModel;

/**
 停止刷新
 */
- (void)stopLoading;

/**
 隐藏加载更多的脚部视图
 */
- (void)setupLoadMoreView;

/**
 显示没有更多数据的提示（设置table的tableFooterView）
 
 @param tips 提示描述
 */
- (void)showNoMoreDataTips:(NSString *)tips;
- (void)hideNoMoreDataTips;

/**
 设置需要刷新的表格
 
 @param tableView 表格对象
 */
- (void)setRefreshTableView:(UITableView *)tableView;

/**
 设置需要刷新的collectionView
 
 @param collectionView 需要刷新的collectionView
 */
- (void)setRefreshCollectionView:(UICollectionView *)collectionView;

#pragma mark - 上下拉刷新所执行的方法

/**
 加载最新
 */
- (void)loadNewData;

/**
 加载更多
 */
- (void)loadMoreData;

@end
