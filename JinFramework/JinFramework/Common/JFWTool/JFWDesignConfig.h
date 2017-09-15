//
//  JFWDesignConfig.h
//  JinFramework
//
//  Created by Jin on 2017/5/2.
//  Copyright © 2017年 Tribetech. All rights reserved.
//

#import "UIColor+YYAdd.h"
#import "JFWConfig.h"

/**
 字号，针对屏幕适配了
 */
#define JFWFont(number) UI_SCREEN_FHEIGHT > 480.0 ? (UI_SCREEN_FHEIGHT < 736.0 ? (UI_SCREEN_FHEIGHT < 667.0 ? [UIFont systemFontOfSize:number - 1.0] : [UIFont systemFontOfSize:number]) : [UIFont systemFontOfSize:number + 2.0]) : [UIFont systemFontOfSize:number - 2.0]

/**
 加粗的字号，针对屏幕适配了
 */
#define JFWBoldFont(number) UI_SCREEN_FHEIGHT > 480.0 ? (UI_SCREEN_FHEIGHT < 736.0 ? (UI_SCREEN_FHEIGHT < 667.0 ? [UIFont boldSystemFontOfSize:number - 1.0] : [UIFont boldSystemFontOfSize:number]) : [UIFont boldSystemFontOfSize:number + 2.0]) : [UIFont boldSystemFontOfSize:number - 2.0]

/**
 cell的默认高度，针对屏幕适配了
 */
#define CellDefaultHeight       (50.0 * kJFWScreenScale)
#define SectionDefaultHeight    10
#define CellNullHeight          0.01

// 颜色
#define     C1          [UIColor colorWithHexString:@"f9ce31"]// 黄色，主色
#define     C2          [UIColor colorWithHexString:@"a3afc0"]// 淡黑
#define     C3          [UIColor colorWithHexString:@"232323"]// 黑色
#define     C4          [UIColor colorWithHexString:@"545961"]// 淡黑
#define     C5          [UIColor colorWithHexString:@"b1b2b5"]// 奶白
#define     C6          [UIColor colorWithHexString:@"edeff2"]// 背景灰
#define     C7          [UIColor colorWithHexString:@"ffffff"]// 白色
#define     C8          [UIColor colorWithHexString:@"7895be"]// 淡蓝色
#define     C9          [UIColor colorWithHexString:@"ffedbd"]// 淡黄
#define     C10         [UIColor colorWithHexString:@"bba364"]// 淡土黄
#define     C11         [UIColor colorWithHexString:@"727274"]// 深灰
#define     C12         [UIColor colorWithHexString:@"ff4444"]// 红色

// 字体
#define     F1          (JFWFont(20.0))
#define     F2          (JFWFont(18.0))
#define     F3          (JFWFont(16.0))
#define     F4          (JFWFont(15.0))
#define     F5          (JFWFont(14.0))
#define     F6          (JFWFont(13.0))
#define     F7          (JFWFont(12.0))
#define     F8          (JFWFont(11.0))
#define     F9          (JFWFont(10.0))

#define     FB1         (JFWBoldFont(20.0))
#define     FB2         (JFWBoldFont(18.0))
#define     FB3         (JFWBoldFont(16.0))
#define     FB4         (JFWBoldFont(15.0))
#define     FB5         (JFWBoldFont(14.0))
#define     FB6         (JFWBoldFont(13.0))
#define     FB7         (JFWBoldFont(12.0))
#define     FB8         (JFWBoldFont(11.0))
#define     FB9         (JFWBoldFont(10.0))

