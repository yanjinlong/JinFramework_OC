//
//  SelectListViewController.m
//  JinFramework
//
//  Created by Jin on 2017/6/6.
//  Copyright © 2017年  Tribetech. All rights reserved.
//

#import "SelectListViewController.h"
#import "AppDelegateBusiness.h"

/**
 列表选择的控制器
 */
@interface SelectListViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSMutableArray *dataArray;
@property (strong, nonatomic) NSString *titleStr;

@end

@implementation SelectListViewController

- (instancetype)initWithTitle:(NSString *)title
               tableItemArray:(NSArray *)tableItemArray
                 selectedItem:(TableRowItem *)selectedItem
           didSelectItemBlock:(void(^)(TableRowItem *didSelectItem))didSelectItemBlock {
    self = [self initWithNibName:@"SelectListViewController" bundle:nil];
    
    if (self) {
        _titleStr = title;
        _didSelectItemBlock = didSelectItemBlock;
        _selectedItem = selectedItem;
        
        if (_dataArray == nil) {
            _dataArray = [[NSMutableArray alloc] init];
        }
        
        _isBackButtonClick = NO;
        _selectListStyle = SelectListStyleReturnAtOnce;
        
        for (NSInteger j = 0; j < [tableItemArray count]; j++) {
            TableRowItem *item = [tableItemArray objectAtIndex:j];
            NSMutableDictionary *itemDict = [[NSMutableDictionary alloc] init];
            [itemDict setObject:item forKey:KeyItem];
            NSString *selected = @"NO";
            
            if (_selectedItem && [_selectedItem.code isEqualToString:item.code]){
                selected = @"YES";
            }
            
            [itemDict setObject:selected forKey:KeySelected];
            
            [_dataArray addObject:itemDict];
        }
        
        self.view.backgroundColor = C6;
        self.tableView.backgroundColor = C6;
    }
    
    return self;
}

- (void)customView {
    
}

- (void)customNavigationBar {
    [self setDefaultBackItem];
    [self setDefaultTitle:_titleStr];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [AppDelegateBusiness setNavStyle:self.navigationController];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    if (_didSelectItemBlock && _isBackButtonClick == NO) {
        _didSelectItemBlock(_selectedItem);
    }
    
    _isBackButtonClick = NO;
}

/**
 重写返回按钮的事件
 */
- (void)backAction {
    _isBackButtonClick = YES;
    
    if (_didSelectItemBlock) {
        _didSelectItemBlock(_selectedItem);
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

/**
 返回数据源（TableRowItem数组）
 
 @return 表格的数据源
 */
- (NSArray *)dataSourceArray {
    return _dataArray;
}

#pragma mark - UITableViewDataSource, UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray ? [_dataArray count] : 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:cellIdentifier];
    }
    
    NSDictionary *itemDict = [_dataArray objectAtIndex:indexPath.row];
    TableRowItem *item = [itemDict objectForKey:KeyItem];
    NSString *selected = [itemDict objectForKey:KeySelected];
    
    if ([selected isEqualToString:@"YES"]) {
        cell.accessoryView = [JFWUI yesDefaultImage];
    }
    else {
        cell.accessoryView = nil;
    }
    
    cell.textLabel.text = item.text;
    cell.imageView.image = item.icon;
    cell.textLabel.font = F4;
    cell.textLabel.textColor = C3;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSMutableDictionary *selectedItemDict = [_dataArray objectAtIndex:indexPath.row];
    TableRowItem *selectedItem = [selectedItemDict objectForKey:KeyItem];
    
    for (NSInteger i = 0; i < [_dataArray count]; i++) {
        NSMutableDictionary *itemDict = [_dataArray objectAtIndex:i];
        TableRowItem *item = [itemDict objectForKey:KeyItem];
        NSString *sel = @"NO";
        
        if ([item.code isEqualToString:selectedItem.code]) {
            sel = @"YES";
        }
        
        [itemDict setObject:sel forKey:KeySelected];
    }
    
    _selectedItem = selectedItem;
    [_tableView reloadData];
    
    if (_selectListStyle == SelectListStyleReturnAtOnce) {
        [self backAction];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return CellDefaultHeight;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsMake(0, 15, 0, 15)];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsMake(0, 15, 0, 15)];
    }
}

@end
