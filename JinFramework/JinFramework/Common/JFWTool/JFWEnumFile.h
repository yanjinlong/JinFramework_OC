//
//  JFWEnumFile.h
//  JinFramework
//
//  Created by denghaishu on 2017/6/12.
//  Copyright © 2017年  Tribetech. All rights reserved.
//

#ifndef JFWEnumFile_h
#define JFWEnumFile_h

/**
 导航栏推出新界面的方式

 - NavigationPushTypePush: push的方式（默认）
 - NavigationPushTypePresent: 从下往上的方式
 */
typedef NS_ENUM(NSInteger, NavigationPushType) {
    NavigationPushTypePush = 0,
    NavigationPushTypePresent
};

#endif /* JFWEnumFile_h */
