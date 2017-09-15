//
//  JFWSheetBaseView.h
//  JinFramework
//
//  Created by Jin on 2017/6/7.
//  Copyright © 2017年 Tribetech. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  从下而上的弹出框的基类
 */
@interface JFWSheetBaseView : UIView

/**
 *  控制器
 */
@property (weak, nonatomic) UIViewController *topViewController;

/**
 *  展示view
 */
- (void)showSheet;

/**
 *  展示view，可以自定义关闭方法
 *
 *  @param aSelector 关闭后执行的方法
 *  @param target    执行方法的对象
 */
- (void)showSheetWithSelector:(SEL)aSelector target:(id)target;

/**
 *  关闭弹出框
 */
- (void)dismissSheet;

@end
