//
//  UpdateConcreteHandler.m
//  JinFramework
//
//  Created by denghaishu on 2017/6/24.
//  Copyright © 2017年  Tribetech. All rights reserved.
//

#import "UpdatePageHandler.h"

/**
 升级提示处理者
 */
@implementation UpdatePageHandler

// 重写父类的处理方法
- (void)handlerOwnTask {
    if ([self isExistUpdatePage]) {
        
    }
    else {
        [self.nextHandler handlerOwnTask];
    }
    
    return;
}

- (BOOL)isExistUpdatePage {
    return NO;
}

@end
