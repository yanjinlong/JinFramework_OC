//
//  WindowAlertAbstractHandler.h
//  JinFramework
//
//  Created by denghaishu on 2017/6/24.
//  Copyright © 2017年  Tribetech. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 责任链抽象处理者类
 */
@interface WindowAlertAbstractHandler : NSObject

@property (nonatomic, strong) WindowAlertAbstractHandler *nextHandler;

- (void)handlerOwnTask;

@end
