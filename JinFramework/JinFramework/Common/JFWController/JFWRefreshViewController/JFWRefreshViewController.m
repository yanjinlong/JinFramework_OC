//
//  JFWRefreshViewController.m
//  JinFramework
//
//  Created by Jin on 2017/4/29.
//  Copyright © 2017年 Tribetech. All rights reserved.
//

#import "JFWRefreshViewController.h"

#define NoMoreDataTipsHeight            50
#define NoMoreDataTipsLabelTag          546

/**
 主的上下拉刷新的控制器，提供一些简单的抽离封装
 */
@interface JFWRefreshViewController ()

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UICollectionView *collectionView;

@end

@implementation JFWRefreshViewController

/**
 停止刷新
 */
- (void)stopLoading {
    if (self.tableView) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView.mj_footer endRefreshing];
            [self.tableView.mj_header endRefreshing];
        });
    }
    else if (self.collectionView) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.collectionView.mj_footer endRefreshing];
            [self.collectionView.mj_header endRefreshing];
        });
    }
}

/**
 隐藏加载更多的脚部视图
 */
- (void)setupLoadMoreView {
    // 判断是否有下一页,隐藏底部
    if (self.pageModel.pageIndex < self.pageModel.totalPage &&
        self.pageModel.dataArray.count != 0) {
        self.hasMore = YES;
        self.footerView.hidden = NO;
        
        [self hideNoMoreDataTips];
    }
    else {
        self.hasMore = NO;
        self.footerView.hidden = YES;
        
        if (self.pageModel.dataArray.count >= 10) {
            [self showNoMoreDataTips:nil];
        }
    }
}

/**
 显示没有更多数据的提示（设置table的tableFooterView）
 
 @param tips 提示描述
 */
- (void)showNoMoreDataTips:(NSString *)tips {
    UILabel *tipsLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0,
                                                                   _tableView.frame.size.width, NoMoreDataTipsHeight)];
    tipsLabel.text = tips ? tips : [NSString stringWithFormat:@"共 %ld 条内容",
                                    (unsigned long)self.pageModel.dataArray.count];
    tipsLabel.textAlignment = NSTextAlignmentCenter;
    tipsLabel.backgroundColor = [UIColor clearColor];
    tipsLabel.textColor = [UIColor lightGrayColor];
    tipsLabel.font = [UIFont systemFontOfSize:15];
    tipsLabel.tag = NoMoreDataTipsLabelTag;
    
    [_tableView setTableFooterView:tipsLabel];
}

/**
 隐藏没有更多的提示
 */
- (void)hideNoMoreDataTips {
    UIView *tipsLabel = _tableView.tableFooterView;
    
    if (tipsLabel.tag == NoMoreDataTipsLabelTag) {
        _tableView.tableFooterView = nil;
    }
}

/**
 设置需要刷新的表格
 
 @param tableView 表格对象
 */
- (void)setRefreshTableView:(UITableView *)tableView {
    // 初始化数据对象
    self.pageModel = [PageModelBasic new];
    
    // 设置过了就不设置了
    if (_tableView == nil) {
        _tableView = tableView;
        
        if (_pullDown) {
            // 下拉刷新
            _headerView = [JFWUI JFWRefreshHeader:self
                                 refreshingAction:@selector(loadNewData)];
            _tableView.mj_header = self.headerView;
        }
        
        if (_pullUp) {
            // 上拉加载更多
            _footerView = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self
                                                               refreshingAction:@selector(loadMoreData)];
            _tableView.mj_footer = self.footerView;
            _footerView.hidden = YES;
        }
    }
}

/**
 设置需要刷新的collectionView
 
 @param collectionView 需要刷新的collectionView
 */
- (void)setRefreshCollectionView:(UICollectionView *)collectionView {
    // 初始化数据对象
    self.pageModel = [PageModelBasic new];
    
    // 设置过了就不设置了
    if (_collectionView == nil) {
        _collectionView = collectionView;
        
        if (_pullDown) {
            // 下拉刷新
            _headerView = [MJRefreshGifHeader headerWithRefreshingTarget:self
                                                        refreshingAction:@selector(loadNewData)];
            _collectionView.mj_header = self.headerView;
        }
        
        if (_pullUp) {
            // 上拉加载更多
            _footerView = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self
                                                               refreshingAction:@selector(loadMoreData)];
            _collectionView.mj_footer = self.footerView;
            _footerView.hidden = YES;
        }
    }
}

/**
 加载最新
 */
- (void)loadNewData {
    //    NSLog(@"加载最新");
}

/**
 加载更多
 */
- (void)loadMoreData {
    //    NSLog(@"加载更多");
}

#pragma mark - JFWViewControllerInterface

- (void)loadDataSuccess:(id)responseData identifier:(NSString *)identifier {
    BOOL isSuccess = [JFWNetworkManager parseDataYESOrNO:responseData identifier:identifier];
    [self hideNoNetView];
    [self stopLoading];
    
    if (isSuccess) {
        [self parseData:responseData identifier:identifier];
    }
    else {
        NSString *message = [responseData valueForKey:@"message"];
        
        if (message.length == 0) {
            message = DefaultErrorTips;
        }
        
        [self showErrorTips:message];
    }
}

- (void)loadDataFailure:(NSError *)error identifier:(NSString *)identifier {
    [super loadDataFailure:error identifier:identifier];
    
    // 请求失败了也要停止loading的视图
    [self stopLoading];
}

@end
