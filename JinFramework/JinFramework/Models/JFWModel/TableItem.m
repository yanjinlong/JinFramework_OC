//
//  TableItem.m
//  JinFramework
//
//  Created by Jin on 2017/4/29.
//  Copyright © 2017年 Tribetech. All rights reserved.
//

#import "TableItem.h"

/**
 行item（常用）
 */
@implementation TableRowItem

/**
 初始化行item
 
 @param icon 图标
 @param text 文本
 @param code code
 @return 行item对象
 */
- (instancetype)initWithIcon:(UIImage *)icon text:(NSString *)text code:(NSString *)code {
    self = [super init];
    
    if (self) {
        self.icon = icon;
        self.text = text;
        self.code = code;
    }
    
    return self;
}

/**
 静态的初始化行item
 
 @param icon 图标
 @param text 文本
 @param code code
 @return 行item对象
 */
+ (instancetype)itemWithIcon:(UIImage *)icon text:(NSString *)text code:(NSString *)code {
    return [[self alloc] initWithIcon:icon text:text code:code];
}

#pragma mark- NSCoding

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.text forKey:@"text"];
    [aCoder encodeObject:self.icon forKey:@"icon"];
    [aCoder encodeObject:self.desc forKey:@"desc"];
    [aCoder encodeObject:self.code forKey:@"code"];
}

- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    
    if (self) {
        self.text = [aDecoder decodeObjectForKey:@"text"];
        self.icon = [aDecoder decodeObjectForKey:@"icon"];
        self.desc = [aDecoder decodeObjectForKey:@"desc"];
        self.code = [aDecoder decodeObjectForKey:@"code"];
    }
    
    return self;
}

@end

/**
 组item（配合行item使用）
 */
@implementation TableSectionItem

/**
 默认初始化行数（初始化行item数组）

 @return 组item对象
 */
- (instancetype)init {
    self = [super init];
    
    if (self) {
        self.rowItemArray = [NSMutableArray<TableRowItem *> new];
    }
    
    return self;
}

/**
 初始化section
 
 @param code code
 @return 组item
 */
- (instancetype)initWithCode:(NSString *)code {
    self = [self init];
    
    if (self) {
        self.sectionItem = [[TableRowItem alloc] initWithIcon:nil text:@"" code:code];
    }
    
    return self;
}

/**
 初始化section

 @param title 初始化section时的sectionTitle
 @return 组item
 */
- (instancetype)initWithTitle:(NSString *)title {
    self = [self init];
    
    if (self) {
        self.sectionItem = [[TableRowItem alloc] initWithIcon:nil text:title code:@""];
    }
    
    return self;
}

@end
