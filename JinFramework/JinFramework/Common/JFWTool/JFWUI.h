//
//  JFWUI.h
//  JinFramework
//
//  Created by Jin on 2017/4/29.
//  Copyright © 2017年 Tribetech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "JFWDesignConfig.h"
#import "MJRefreshGifHeader.h"

/**
 提炼跟UI有关的公共多用的封装类
 */
@interface JFWUI : NSObject

/**
 返回按钮的图片
 
 @return 图片对象
 */
+ (UIImage *)backButtonItemImage;

/**
 打勾的默认视图，给tableviewcell使用

 @return 打勾图
 */
+ (UIImageView *)yesDefaultImage;

/**
 右上角三点更多的图片
 
 @return 图片对象
 */
+ (UIImage *)thirdPontItemImage;

/**
 拿到原图的渲染图片
 
 @param string 图片名称
 
 @return 原图图片对象
 */
+ (UIImage *)imageWithRenderingModeAlwaysOriginal:(NSString *)string;

/**
 改变图片颜色
 
 @param color 颜色对象
 @param image 图片对象
 
 @return 着了颜色的图片对象
 */
+ (UIImage *)imageWithColor:(UIColor *)color image:(UIImage *)image;

/**
 设置视图的圆角（高效率，低内存）
 
 @param view   视图对象
 @param radius 圆角角度
 */
+ (void)setViewRoundCorner:(UIView *)view radius:(CGFloat)radius;

/**
 设置label的中划线
 
 @param label label
 */
+ (void)setLabelMiddleLine:(UILabel *)label;

/**
 获得label的合适尺寸
 
 @param content    内容
 @param labelWidth label的宽度
 @param font       文本的字体
 
 @return label的合适尺寸
 */
+ (CGSize)getLabelFitSize:(NSString *)content labelWidth:(CGFloat)labelWidth font:(UIFont *)font;

/**
 固定高度，计算Label的宽度
 
 @param content     内容
 @param labelHeight Label的高度
 @param font        文本的字体
 
 @return Label的合适尺寸
 */
+ (CGSize)getLabelFitSize:(NSString *)content labelHeight:(CGFloat)labelHeight font:(UIFont *)font;

/**
 根据屏幕scale获得1像素的像素值

 @return 1像素的像素值
 */
+ (CGFloat)get1pxLinePixelValue;

/**
 获得系统线条的颜色值（iOS默认的那个）

 @return 系统线条颜色值
 */
+ (UIColor *)getLineColor;

/**
 默认的用户头像

 @return 用户头像
 */
+ (UIImage *)defaultUserIcon;

/**
 默认无图的占位图

 @return 占位图
 */
+ (UIImage *)defaultNoImagePic;

/**
 *  得到部族欧巴刷新的头部视图
 *
 *  @param target 动作目标者
 *  @param action 执行的方法
 *
 *  @return 头部刷新视图
 */
+ (MJRefreshGifHeader *)JFWRefreshHeader:(id)target refreshingAction:(SEL)action;

#pragma mark - 跳转有关

/**
 直接清除中间所有栈的控制器跳转到下一个控制器
 
 @param currentVC 当前控制器
 @param nextVC    下一个控制器
 */
+ (void)goToNextVCForCleanAllVC:(UIViewController *)currentVC nextVC:(UIViewController *)nextVC;

/**
 直接在push一个控制器
 
 @param vc 控制器
 @param animated 是否需要动画
 */
+ (void)pushNextVC:(UIViewController *)vc animated:(BOOL)animated;

/**
 先pop再push的方法
 
 @param newVC 新的控制器
 */
+ (void)popWithPush:(UIViewController *)newVC animated:(BOOL)animated;

/**
 获取导航栏
 
 @return 导航栏
 */
+ (UINavigationController *)getNavigationController;

/**
 获得最顶层的控制器
 */
+ (UIViewController *)getTopViewController;

@end
