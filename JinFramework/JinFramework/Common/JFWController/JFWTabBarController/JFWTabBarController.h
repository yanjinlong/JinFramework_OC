//
//  JFWTabBarController.h
//  JinFramework
//
//  Created by Jin on 2017/6/28.
//  Copyright © 2017年  Tribetech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JFWTabBarController : UITabBarController

/**
 自动显示或隐藏AI按钮
 */
@property (nonatomic, assign) BOOL resetAISlide;

/**
 设置未读消息数 label
 
 @parma num 未读数
 */
- (void)setUnreadMessageLabel:(NSInteger)num;

/**
 滑动scrollview时 设置智能助手按钮位置
 
 @param hidden 是否向右隐藏
 */
- (void)setAIButtonToSlide:(BOOL)hidden;

@end
