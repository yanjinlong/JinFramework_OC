//
//  ExceptionConcreteHandler.m
//  JinFramework
//
//  Created by denghaishu on 2017/6/24.
//  Copyright © 2017年  Tribetech. All rights reserved.
//

#import "WindowAlertHandler.h"

/**
 责任链最后的处理器 如打印或上报本次处理异常等
 */
@implementation WindowAlertHandler

// 重写父类的处理方法
- (void)handlerOwnTask {
    NSLog(@"哎呀，这个问题我处理不了。。");
    
    return;
}

@end
