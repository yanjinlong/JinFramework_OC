//
//  TableItem.h
//  JinFramework
//
//  Created by Jin on 2017/4/29.
//  Copyright © 2017年 Tribetech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/**
 行item（常用）
 */
@interface TableRowItem : NSObject<NSCoding>

/**
 图标
 */
@property (strong, nonatomic) UIImage *icon;

/**
 文本
 */
@property (copy, nonatomic) NSString *text;

/**
 不常用，则在初始化不给予构造函数赋值
 */
@property (copy, nonatomic) NSString *desc;

/**
 关键code
 */
@property (copy, nonatomic) NSString *code;

/**
 初始化行item

 @param icon 图标
 @param text 文本
 @param code code
 @return 行item对象
 */
- (instancetype)initWithIcon:(UIImage *)icon text:(NSString *)text code:(NSString *)code;

/**
 静态的初始化行item
 
 @param icon 图标
 @param text 文本
 @param code code
 @return 行item对象
 */
+ (instancetype)itemWithIcon:(UIImage *)icon text:(NSString *)text code:(NSString *)code;

@end

/**
 组item（配合行item使用）
 */
@interface TableSectionItem : NSObject

/**
 初始化section

 @param code code
 @return 组item
 */
- (instancetype)initWithCode:(NSString *)code;

/**
 初始化section
 
 @param title 初始化section时的sectionTitle
 @return 组item
 */
- (instancetype)initWithTitle:(NSString *)title;

@property (strong, nonatomic) TableRowItem *sectionItem;
@property (strong, nonatomic) NSMutableArray<TableRowItem *> *rowItemArray;

@end
