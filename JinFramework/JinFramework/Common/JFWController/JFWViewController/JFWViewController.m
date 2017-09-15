//
//  JFWViewController.m
//  JinFramework
//
//  Created by Jin on 2017/4/29.
//  Copyright © 2017年 Tribetech. All rights reserved.
//

#import "JFWViewController.h"
#import "AppDelegateBusiness.h"
#import "WSProgressHUD.h"
#import "JFWEmptyView.h"

#define NoNetViewTag             159
#define NoDataViewTag            283

/**
 部族科技的主控制器
 */
@interface JFWViewController ()

@property (strong, nonatomic) WSProgressHUD *hud;

@end

@implementation JFWViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.rt_disableInteractivePop = YES;    // 关掉rt的滑动返回选项，保留fd的
    [AppDelegateBusiness setNavStyle:self.navigationController];
    
    [self customView];
    [self customNavigationBar];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [self dismissLoading];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark - 基类代码，供子类继承使用

/**
 自定义的初始化试图的方法
 */
- (void)customView {
    
}

/**
 自定义的导航栏方法
 */
- (void)customNavigationBar {
    
}

#pragma mark - 封装/提炼 的方法

/**
 返回按钮的动作方法
 */
- (void)backButtonAction {
    [self.navigationController popViewControllerAnimated:YES];
}

/**
 设置默认的返回按钮
 */
- (void)setDefaultBackItem {
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithImage:[JFWUI backButtonItemImage]
                                                                   style:UIBarButtonItemStylePlain
                                                                  target:self
                                                                  action:@selector(backButtonAction)];
    
    [self.navigationItem setLeftBarButtonItem:backButton];
}

/**
 设置默认的标题
 
 @param title 标题
 */
- (void)setDefaultTitle:(NSString *)title {
    if ([title isKindOfClass:[NSNull class]] || !title) {
        return;
    }
    
    [self.navigationItem setTitle:title];
}

/**
 重新加载数据
 */
- (void)reloadNewData {
    
}

- (NSString *)description {
    return [NSString stringWithFormat:@"%@(%@)", [self.class description], [self descriptionCN]];
}

#pragma mark- JFWVCDescriptionInterface

/**
 控制器中文名描述
 
 @return 中文名描述
 */
- (NSString *)descriptionCN; {
    return @"控制器基类";
}

#pragma mark - 对没有网和没数据的表现

/**
 没有数据时显示的界面
 
 @param tipsText 提示标题
 @param forView 给哪个视图添加
 */
- (void)showNoDataView:(NSString *)tipsText forView:(UIView *)forView {
    JFWEmptyView *noDataView = [forView viewWithTag:NoDataViewTag];
    
    if (noDataView == nil) {
        noDataView = [[JFWEmptyView alloc] init];
        noDataView.tag = NoDataViewTag;
        noDataView.viewType = EmptyViewTypeNoData;
        noDataView.tipsText = tipsText;
        
        [forView addSubview:noDataView];
    }
}

/**
 隐藏没有数据的视图
 
 @param forView 给哪个视图添加
 */
- (void)hideNoDataView:(UIView *)forView {
    UIView *noDataView = [forView viewWithTag:NoDataViewTag];
    
    if (noDataView) {
        [noDataView removeFromSuperview];
    }
}

/**
 显示没有网络的视图
 */
- (void)showNoNetView {
    JFWEmptyView *noNetView = [self.view viewWithTag:NoNetViewTag];
    
    if (noNetView == nil) {
        noNetView = [[JFWEmptyView alloc] init];
        noNetView.tag = NoNetViewTag;
        
        @weakify(self)
        [noNetView setDidTouchViewBlock:^{
            @strongify(self)
            [self reloadNewData];
        }];
        
        [self.view addSubview:noNetView];
    }
}

/**
 隐藏没有网络的视图
 */
- (void)hideNoNetView {
    UIView *noNetView = [self.view viewWithTag:NoNetViewTag];
    
    if (noNetView) {
        [noNetView removeFromSuperview];
    }
}

#pragma mark - 提示指示器

/**
 显示加载指示器
 
 @param loadTips 加载提示：为nil时默认值是@"Loading..."
 */
- (void)showLoading:(NSString *)loadTips {
    NSString *loading = @"Loading...";
    
    if (loadTips && loadTips.length > 0) {
        loading = loadTips;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.hud showWithString:loading
                        maskType:WSProgressHUDMaskTypeClear
                     maskWithout:WSProgressHUDMaskWithoutNavigation];
    });
}

/**
 取消显示加载指示器
 */
- (void)dismissLoading {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.hud dismiss];
    });
}

/**
 就提示文字而已
 
 @param tips 提示
 */
- (void)showTextTips:(NSString *)tips {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.hud showImageNoAutoDismiss:nil
                                  status:tips
                                maskType:WSProgressHUDMaskTypeClear
                             maskWithout:WSProgressHUDMaskWithoutNavigation];
    });
}

/**
 提示文本，自动小时
 
 @param tips 提示内容
 */
- (void)showAutoDismissText:(NSString *)tips {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.hud showImage:nil
                     status:tips
                   maskType:WSProgressHUDMaskTypeClear
                maskWithout:WSProgressHUDMaskWithoutNavigation];
    });
}

/**
 显示成功
 
 @param tips 提示内容
 */
- (void)showSuccessTips:(NSString *)tips dismissBlock:(void(^)())dismissBlock {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.hud showSuccessWithString:tips];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self dismissLoading];
            
            if (dismissBlock) {
                dismissBlock();
            }
        });
    });
}

/**
 显示失败
 
 @param tips 失败提示内容
 */
- (void)showErrorTips:(NSString *)tips {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.hud showErrorWithString:tips];
    });
}

#pragma mark - NetworkDelegate

- (void)loadDataSuccess:(id)responseData identifier:(NSString *)identifier {
    // 能走这里证明有网络，需要把无网的视图干掉
    [self hideNoNetView];
    
    BOOL isSuccess = [JFWNetworkManager parseDataYESOrNO:responseData identifier:identifier];
    
    if (isSuccess) {
        NSDictionary *data = [responseData valueForKey:@"data"];
        [self parseData:data identifier:identifier];
    }
    else {
        NSString *message = [responseData valueForKey:@"message"];
        
        if (message.length == 0) {
            message = DefaultErrorTips;
        }
        
        [self showErrorTips:message];
    }
}

/**
 错误的捕捉
 
 @param error      错误
 @param identifier 方法名称
 */
- (void)loadDataFailure:(NSError *)error identifier:(NSString *)identifier {
    [self dismissLoading];
    
    // 弹出错误提示
    if (error.code == -1009 || error.code == -1003 || error.code == -1005 || error.code == -1001) {
        [self showNoNetView];
    }
    else {
        [self showErrorTips:DefaultErrorTips];
    }
}

#pragma mark - JFWViewControllerInterface

/**
 快捷解析数据的提炼，供子类继承
 
 @param body       正确数据的字典
 @param identifier 方法名
 */
- (void)parseData:(id)body identifier:(NSString *)identifier {
    
}

#pragma mark - 先pop再push

/**
 先pop再push的方法
 
 @param newVC 新的控制器
 */
- (void)popWithPush:(UIViewController *)newVC animated:(BOOL)animated {
    [self popWithPush:newVC withPopCount:1 animated:animated];
}

/**
 先pop再push的方法，添加了pop的视图数量
 
 @param newVC        新的控制器
 @param withPopCount pop的视图数量
 @param animated     是否开启动画
 */
- (void)popWithPush:(UIViewController *)newVC withPopCount:(NSInteger)withPopCount animated:(BOOL)animated{
    if (withPopCount > 0) {
        NSMutableArray *navVCArray = [[NSMutableArray alloc]
                                      initWithArray:self.rt_navigationController.viewControllers];
        
        for (int i = 0; i < withPopCount; i++) {
            [navVCArray removeObjectAtIndex:navVCArray.count - 1];
        }
        
        [navVCArray addObject:newVC];
        
        [self.rt_navigationController setViewControllers:navVCArray animated:animated];
    }
}

#pragma mark- 懒加载

- (WSProgressHUD *)hud {
    if (_hud == nil) {
        _hud = [[WSProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:_hud];
    }
    
    return _hud;
}

@end
