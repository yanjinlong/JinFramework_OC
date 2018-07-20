//
//  JFWViewController.h
//  JinFramework
//
//  Created by Jin on 2017/4/29.
//  Copyright © 2017年 Tribetech. All rights reserved.
//

#ifdef DEBUG
#define NSLog(...) NSLog(__VA_ARGS__)
#else
#define NSLog(...)
#endif

#import <UIKit/UIKit.h>
#import "JFWNetworkManager.h"
#import "UINavigationController+FDFullscreenPopGesture.h"
#import "RTRootNavigationController.h"
#import "JFWConfig.h"
#import "JFWUI.h"
#import "AccountManager.h"

/**
 接口定义，供子类实现用的一些方法
 */
@protocol JFWViewControllerInterface <NSObject>

/**
 快捷解析数据的提炼，供子类继承
 
 @param body         正确数据的字典
 @param identifier   方法名
 */
- (void)parseData:(id)body identifier:(NSString *)identifier;

@end

/**
 控制器的中文描述接口，给埋点的控制器使用提交信息给服务器
 */
@protocol JFWVCDescriptionInterface <NSObject>

/**
 控制器中文名描述（子类需重写才可）
 
 @return 中文名描述
 */
- (NSString *)descriptionCN;

@end

/**
 部族科技的主控制器
 */
@interface JFWViewController : UIViewController<NetworkDelegate, JFWViewControllerInterface, JFWVCDescriptionInterface>

#pragma mark - 设置导航栏样式

/**
 设置nav的样式
 
 @param nav nav控制器
 */
+ (void)setNavStyle:(UINavigationController *)nav;

#pragma mark - 基类代码，供子类继承使用

/**
 自定义的初始化视图的方法
 */
- (void)customView;

/**
 自定义的导航栏方法
 */
- (void)customNavigationBar;

#pragma mark - 封装/提炼 的方法

/**
 返回按钮的动作方法
 */
- (void)backButtonAction;

/**
 设置默认的返回按钮
 */
- (void)setDefaultBackItem;

/**
 设置默认的标题
 
 @param title 标题
 */
- (void)setDefaultTitle:(NSString *)title;

/**
 重新加载数据
 */
- (void)reloadNewData;

#pragma mark - 对没有网和没数据的表现

/**
 没有数据时显示的界面
 
 @param tipsText 提示标题
 @param forView 给哪个视图添加
 */
- (void)showNoDataView:(NSString *)tipsText forView:(UIView *)forView;

/**
 隐藏没有数据的视图
 
 @param forView 给哪个视图添加
 */
- (void)hideNoDataView:(UIView *)forView;

/**
 显示没有网络的视图
 */
- (void)showNoNetView;

/**
 隐藏没有网络的视图
 */
- (void)hideNoNetView;

#pragma mark - 提示指示器

/**
 显示加载指示器
 
 @param loadTips 加载提示：为nil时默认值是Loading
 */
- (void)showLoading:(NSString *)loadTips;

/**
 取消显示加载指示器
 */
- (void)dismissLoading;

/**
 就提示文字而已
 
 @param tips 提示
 */
- (void)showTextTips:(NSString *)tips;

/**
 提示文本，自动消失
 
 @param tips 提示内容
 */
- (void)showAutoDismissText:(NSString *)tips;

/**
 显示成功
 
 @param tips 提示内容
 */
- (void)showSuccessTips:(NSString *)tips dismissBlock:(void(^)())dismissBlock;

/**
 显示失败
 
 @param tips 失败提示内容
 */
- (void)showErrorTips:(NSString *)tips;

#pragma mark - 先pop再push

/**
 先pop再push的方法
 
 @param newVC    新的控制器
 @param animated 是否开启动画
 */
- (void)popWithPush:(UIViewController *)newVC animated:(BOOL)animated;

/**
 先pop再push的方法，添加了pop的视图数量，数量必须大于=1
 
 @param newVC        新的控制器
 @param withPopCount pop的视图数量
 @param animated     是否开启动画
 */
- (void)popWithPush:(UIViewController *)newVC withPopCount:(NSInteger)withPopCount
           animated:(BOOL)animated;

@end
