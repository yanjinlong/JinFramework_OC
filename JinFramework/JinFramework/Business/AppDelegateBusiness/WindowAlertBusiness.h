//
//  WindowAlertBusiness.h
//  JinFramework
//
//  Created by denghaishu on 2017/6/26.
//  Copyright © 2017年  Tribetech. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  处理弹窗的业务类
 */
@interface WindowAlertBusiness : NSObject

/**
 *  获得弹窗信息请求
 */
- (void)getWindowAlertMessageRequest;

/**
 *  显示弹窗
 */
- (void)showWindowAlert;

@end
