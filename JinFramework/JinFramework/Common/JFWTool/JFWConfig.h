//
//  JFWConfig.h
//  JinFramework
//
//  Created by Jin on 2017/4/29.
//  Copyright © 2017年 Tribetech. All rights reserved.
//

#import "YYKit.h"

/** 设备相关 */
#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
#define iPhone6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) : NO)
#define iPhone6P ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size) : NO)

/** UI 界面大小 */
#define UI_SCREEN_FWIDTH    (kScreenWidth)               //界面的宽度
#define UI_SCREEN_FHEIGHT   (kScreenHeight)              //界面的高度

/**
 状态栏高度
 */
#define UI_STATUSBAR_HEIGHT             [UIApplication sharedApplication].statusBarFrame.size.height
/**
 导航栏高度
 */
#define UI_NAVBAR_HEIGHT                44.0
/**
 下面板块拦高度
 */
#define UI_TABBAR_HEIGHT                49.0
/**
 顶部高度，由状态栏和导航栏组成
 */
#define UI_TOP_HEIGHT                   (UI_STATUSBAR_HEIGHT + UI_NAVBAR_HEIGHT)

/**
 适配屏幕的基数
 */
#define kJFWScreenScale                 UI_SCREEN_FWIDTH / 375.0

/**
 判断对象是否为空
 */
#define IsStrEmpty(objStr)		(![objStr isKindOfClass:[NSString class]] || objStr == nil || [objStr length] <= 0 || [objStr isEqualToString:@"<null>"])

#define IsDicEmpty(objDict)		(![objDict isKindOfClass:[NSDictionary class]] || objDict == nil || [objDict count] <= 0)

#define IsArrEmpty(objArray)	(![objArray isKindOfClass:[NSArray class]] || objArray == nil || [objArray count] <= 0)

#define IsNumEmpty(objNum)		(![objNum isKindOfClass:[NSNumber class]] || objNum == nil)

#define IsDataEmpty(objData)		(![objData isKindOfClass:[NSData class]] || objData == nil || [objData length] <= 0)

#define IsSetEmpty(objData)		(![objData isKindOfClass:[NSSet class]] || objData == nil || [objData count] <= 0)

/**
 验证码倒计时
 */
#define SMSTIMECOUNT 60

/**
 人工热线
 */
#define CustomerSevicePhoneNum  @"020-29015851"

/**
 默认的异常提示
 */
#define DefaultErrorTips    @"网络异常，请稍后再试！"

/**
 支付用的回调Scheme

 @return Scheme
 */
#define PayAppURLScheme     @"payNewBusMan"
