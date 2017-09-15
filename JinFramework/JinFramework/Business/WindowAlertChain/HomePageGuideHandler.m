//
//  HomePageGuideConcreteHandler.m
//  JinFramework
//
//  Created by denghaishu on 2017/6/24.
//  Copyright © 2017年  Tribetech. All rights reserved.
//

#import "HomePageGuideHandler.h"

/**
 首页引导处理者
 */
@implementation HomePageGuideHandler

// 重写父类的处理方法
- (void)handlerOwnTask {
    if ([self isExistGuidePage]) {
        
    }
    else {
        [self.nextHandler handlerOwnTask];
    }
    
    return;
}

- (BOOL)isExistGuidePage {
    return NO;
}

@end
