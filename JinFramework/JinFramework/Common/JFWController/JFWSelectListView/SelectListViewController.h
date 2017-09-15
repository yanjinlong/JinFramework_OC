//
//  SelectListViewController.h
//  JinFramework
//
//  Created by Jin on 2017/6/6.
//  Copyright © 2017年  Tribetech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TableItem.h"
#import "JFWViewController.h"

#define KeyItem        @"item"
#define KeySelected    @"selected"

typedef NS_ENUM (NSInteger, SelectListStyle) {
    /**
     *  默认选中之后停留在原页面
     */
    SelectListStyleDefault = 0,
    
    /**
     *  选中之后自动返回上一页
     */
    SelectListStyleReturnAtOnce
};

/**
 列表选择的控制器
 */
@interface SelectListViewController : JFWViewController<UITableViewDataSource, UITableViewDelegate>

/**
 *  可以设置是否选择好自动返回上一页（默认自动返回，可设置为不返回）
 */
@property (nonatomic, assign) SelectListStyle selectListStyle;
@property (nonatomic, strong) TableRowItem *selectedItem;
@property (nonatomic, assign) BOOL isBackButtonClick;
@property (nonatomic, copy) void(^didSelectItemBlock)(TableRowItem *didSelectItem);

/**
 初始化方法，必须调用
 参数tableItemArray 为数据源，请保证每个item code 的唯一性
 参数selectedItem 为已选择的Item，设置为nil则未选择任何item;
 参数didSelectItemBlock 为选择Item之后的回调
 ps：目前只支持单选
 */
- (instancetype)initWithTitle:(NSString *)title
               tableItemArray:(NSArray *)tableItemArray
                 selectedItem:(TableRowItem *)selectedItem
           didSelectItemBlock:(void(^)(TableRowItem *didSelectItem))didSelectItemBlock;

/**
 回的事件
 */
- (void)backAction;

/**
 返回数据源（TableRowItem数组）
 
 @return 表格的数据源
 */
- (NSArray *)dataSourceArray;

@end
