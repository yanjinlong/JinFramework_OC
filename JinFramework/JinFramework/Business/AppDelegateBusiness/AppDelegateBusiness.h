//
//  AppDelegateBusiness.h
//  JinFramework
//
//  Created by Jin on 2017/5/2.
//  Copyright © 2017年 Tribetech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/**
 appdelegate 的业务处理类
 */
@interface AppDelegateBusiness : NSObject

#pragma mark - 设置导航栏样式

/**
 设置nav的样式
 
 @param nav nav控制器
 */
+ (void)setNavStyle:(UINavigationController *)nav;

#pragma mark - 弹窗业务

/**
 获取相关弹窗页面数据
 */
- (void)getChainViewRequest;


/**
 *  显示相关弹窗页面
 */
- (void)showChainView;

@end
