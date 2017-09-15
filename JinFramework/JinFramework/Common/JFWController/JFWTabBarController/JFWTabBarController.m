//
//  JFWTabBarController.m
//  JinFramework
//
//  Created by Jin on 2017/4/29.
//  Copyright © 2017年 Tribetech. All rights reserved.
//

#import "JFWTabBarController.h"
#import "JFWUI.h"
#import "AppDelegateBusiness.h"
#import "JFWNetworkManager.h"
#import "NotificationCenter.h"

#import "TestViewController.h"

/**
 部族欧巴的tabbar控制器
 */
@interface JFWTabBarController ()<NetworkDelegate>

@property (strong, nonatomic) TestViewController *homeVC;
@property (strong, nonatomic) TestViewController *aiVC;
@property (strong, nonatomic) TestViewController *messageVC;
@property (strong, nonatomic) TestViewController *mineVC;

@property (strong, nonatomic) UILabel *unreadMSgLabel;
@property (strong, nonatomic) JFWNetworkManager *network;

@end

@implementation JFWTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initData];
    [self initView];
    
    [NotificationCenter addGoToLoginObserver:self selector:@selector(showLoginVC)];
    [NotificationCenter addLoginSuccessObserver:self selector:@selector(loginSuccess)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}

- (void)initData {
    _network = [[JFWNetworkManager alloc] initWithDelegate:self];
}

- (void)initView {
    self.homeVC = [TestViewController new];
    self.aiVC = [TestViewController new];
    self.messageVC = [TestViewController new];
    self.mineVC = [TestViewController new];
    
    self.viewControllers = @[self.homeVC, self.aiVC, self.messageVC, self.mineVC];
    [self setAllControllerTabBarItemFontAttribute];
    [self setAllControllerTabBarItemImageAttribute];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    // 未读消息数label
    _unreadMSgLabel  = [[UILabel alloc] init];
    _unreadMSgLabel.frame = CGRectMake(UI_SCREEN_FWIDTH / 4.0 * 2.5 + 10.0, 5.0 , 20.0, 20.0);
    _unreadMSgLabel.layer.cornerRadius = 10.0;
    _unreadMSgLabel.layer.masksToBounds = YES;
    _unreadMSgLabel.textAlignment = NSTextAlignmentCenter;
    _unreadMSgLabel.font = [UIFont systemFontOfSize:9.0];
    _unreadMSgLabel.textColor = C7;
    _unreadMSgLabel.adjustsFontSizeToFitWidth = YES;
    _unreadMSgLabel.backgroundColor = [UIColor redColor];
    _unreadMSgLabel.hidden = YES;
    [self.tabBar addSubview:_unreadMSgLabel];
}

- (void)dealloc {
    [NotificationCenter removeGoToLoginObserver:self];
    [NotificationCenter removeLoginSuccessObserver:self];
}

#pragma mark - tab的图片设置

/**
 设置所有控制器的tabbaritem属性
 */
- (void)setAllControllerTabBarItemImageAttribute {
    [self setControllerTabBarItemAttribute:self.homeVC
                                     title:@"连接"
                                     image:@"footer_lianjie"
                               selectImage:@"footer_lianjieHL"
                                   withTag:0];
    [self setControllerTabBarItemAttribute:self.aiVC
                                     title:@"智能助手"
                                     image:@"footer_xingqu"
                               selectImage:@"footer_xingquHL"
                                   withTag:0];
    [self setControllerTabBarItemAttribute:self.messageVC
                                     title:@"消息"
                                     image:@"footer_xiaoxi"
                               selectImage:@"footer_xiaoxiHL"
                                   withTag:0];
    [self setControllerTabBarItemAttribute:self.mineVC
                                     title:@"我"
                                     image:@"footer_wo"
                               selectImage:@"footer_woHL"
                                   withTag:0];
}

/**
 设置控制器的tabbaritem的属性
 
 @param controller  控制器对象
 @param title       标题
 @param image       默认图片
 @param selectImage 选中的图片
 @param tag         tag值
 */
- (void)setControllerTabBarItemAttribute:(UIViewController *)controller
                                   title:(NSString *)title
                                   image:(NSString *)image
                             selectImage:(NSString *)selectImage
                                 withTag:(NSInteger)tag {
    controller.tabBarItem.tag = tag;
    controller.tabBarItem.title = title;
    
    controller.tabBarItem.image = [JFWUI imageWithRenderingModeAlwaysOriginal:image];
    controller.tabBarItem.selectedImage = [JFWUI imageWithRenderingModeAlwaysOriginal:selectImage];
}

#pragma mark - tab的字体设置

/**
 设置主页面的tabbar的属性
 */
- (void)setAllControllerTabBarItemFontAttribute {
    UIColor *titleColor = C3;
    UIColor *titleHLColor = C1;
    
    [self setTabBarItemTextAttribute:self.homeVC.tabBarItem
                         normalColor:titleColor
                       selectedColor:titleHLColor];
    [self setTabBarItemTextAttribute:self.aiVC.tabBarItem
                         normalColor:titleColor
                       selectedColor:titleHLColor];
    [self setTabBarItemTextAttribute:self.messageVC.tabBarItem
                         normalColor:titleColor
                       selectedColor:titleHLColor];
    [self setTabBarItemTextAttribute:self.mineVC.tabBarItem
                         normalColor:titleColor
                       selectedColor:titleHLColor];
}

/**
 设置tabbaritem的文本属性
 
 @param item          tabbaritem
 @param normalColor   正常颜色值
 @param selectedColor 选中颜色值
 */
- (void)setTabBarItemTextAttribute:(UITabBarItem *)item normalColor:(UIColor *)normalColor
                     selectedColor:(UIColor *)selectedColor {
    [item setTitleTextAttributes:@{ NSForegroundColorAttributeName : normalColor ,
                                    NSFontAttributeName : [UIFont boldSystemFontOfSize:11.0f] }
                        forState:UIControlStateNormal];
    
    [item setTitleTextAttributes:@{ NSForegroundColorAttributeName : selectedColor ,
                                    NSFontAttributeName : [UIFont boldSystemFontOfSize:11.0f] }
                        forState:UIControlStateSelected];
}

#pragma mark- 业务逻辑

/**
 设置未读消息数 label
 
 @parma num 未读数
 */
- (void)setUnreadMessageLabel:(NSInteger)num {
    num > 0 ? (_unreadMSgLabel.hidden = NO) : (_unreadMSgLabel.hidden = YES);
    
    if (num > 0 && num <= 99) {
        _unreadMSgLabel.text = [NSString stringWithFormat:@"%ld", (long)num];
    }
    else if (num > 99 ) {
        _unreadMSgLabel.text = @"99+";
    }
}

/**
 是否需要显示UI
 
 @return YES
 */
- (BOOL)resetAISlide {
    // 如果按钮当前在屏幕之外
    
    return YES;
}

/**
 滑动scrollview时 设置智能助手按钮位置
 
 @param hidden 是否向右隐藏
 */
- (void)setAIButtonToSlide:(BOOL)hidden {
    // 隐藏

}

/**
 跳到登录界面
 */
- (void)showLoginVC {
    
}

/**
 退出
 */
- (void)logout {
    [self setUnreadMessageLabel:0];
}

/**
 登录成功
 */
- (void)loginSuccess {
    
}

#pragma mark- NetworkDelegate

- (void)loadDataSuccess:(id)responseData identifier:(NSString *)identifier {
    BOOL isSuccess = [JFWNetworkManager parseDataYESOrNO:responseData identifier:identifier];
    
    if (isSuccess) {
        if ([identifier isEqualToString:@"unreadMessage"]) {
            
        }
    }
}

- (void)loadDataFailure:(NSError *)error identifier:(NSString *)identifier {
    [self setUnreadMessageLabel:0];
}

@end
