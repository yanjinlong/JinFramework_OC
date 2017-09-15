//
//  JFWUI.m
//  JinFramework
//
//  Created by Jin on 2017/4/29.
//  Copyright © 2017年 Tribetech. All rights reserved.
//

#import "JFWUI.h"
#import "JFWTabBarController.h"
#import "RTRootNavigationController.h"
#import "JFWConfig.h"

/**
 提炼跟UI有关的公共多用的封装类
 */
@implementation JFWUI

/**
 返回按钮的图片
 
 @return 图片对象
 */
+ (UIImage *)backButtonItemImage {
    return [UIImage imageNamed:@"login_backButton"];
}

/**
 打勾的默认视图，给tableviewcell使用
 
 @return 打勾图
 */
+ (UIImageView *)yesDefaultImage {
    return [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"new_selcetedIcon"]];
}

/**
 右上角三点更多的图片
 
 @return 图片对象
 */
+ (UIImage *)thirdPontItemImage {
    return [UIImage imageNamed:@"three_point_more"];
}

/**
 拿到原图的渲染图片
 
 @param string 图片名称
 
 @return 原图图片对象
 */
+ (UIImage *)imageWithRenderingModeAlwaysOriginal:(NSString *)string {
    return [[UIImage imageNamed:string] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
}

/**
 改变图片颜色
 
 @param color 颜色对象
 @param image 图片对象
 
 @return 着了颜色的图片对象
 */
+ (UIImage *)imageWithColor:(UIColor *)color image:(UIImage *)image {
    UIGraphicsBeginImageContextWithOptions(image.size, NO, image.scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, 0, image.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextSetBlendMode(context, kCGBlendModeNormal);
    CGRect rect = CGRectMake(0, 0, image.size.width, image.size.height);
    CGContextClipToMask(context, rect, image.CGImage);
    [color setFill];
    CGContextFillRect(context, rect);
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

/**
 设置视图的圆角（高效率，低内存）
 
 @param view   视图对象
 @param radius 圆角角度
 */
+ (void)setViewRoundCorner:(UIView *)view radius:(CGFloat)radius {
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:view.bounds
                                                   byRoundingCorners:UIRectCornerAllCorners
                                                         cornerRadii:CGSizeMake(radius, radius)];
    
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    //设置大小
    maskLayer.frame = view.bounds;
    //设置图形样子
    maskLayer.path = maskPath.CGPath;
    view.layer.mask = maskLayer;
}

/**
 设置label的中划线
 
 @param label label
 */
+ (void)setLabelMiddleLine:(UILabel *)label {
    CGFloat length = label.text.length;
    
    NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:label.text];
    [attri addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle) range:NSMakeRange(0, length)];
    [attri addAttribute:NSStrikethroughColorAttributeName value:label.textColor range:NSMakeRange(0, length)];
    
    [label setAttributedText:attri];
}

/**
 获得label的合适尺寸,固定宽度，计算宽度
 
 @param content    内容
 @param labelWidth label的宽度
 @param font       文本的字体
 
 @return label的合适尺寸
 */
+ (CGSize)getLabelFitSize:(NSString *)content labelWidth:(CGFloat)labelWidth font:(UIFont *)font {
    CGSize size = CGSizeMake(labelWidth, MAXFLOAT); // 设置一个行高上限
    CGSize returnSize;
    
    NSDictionary *attribute = @{ NSFontAttributeName: font };
    returnSize = [content boundingRectWithSize:size
                                       options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                    attributes:attribute
                                       context:nil].size;
    
    return returnSize;
}

/**
 固定高度，计算Label的宽度
 
 @param content     内容
 @param labelHeight Label的高度
 @param font        文本的字体
 
 @return Label的合适尺寸
 */
+ (CGSize)getLabelFitSize:(NSString *)content labelHeight:(CGFloat)labelHeight font:(UIFont *)font {
    CGSize size = CGSizeMake(MAXFLOAT, labelHeight);
    CGSize returnSize;
    
    NSDictionary *attribute = @{ NSFontAttributeName: font };
    returnSize = [content boundingRectWithSize:size
                                       options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                    attributes:attribute
                                       context:nil].size;
    
    return returnSize;
}

/**
 根据屏幕scale获得1像素的像素值
 
 @return 1像素的像素值
 */
+ (CGFloat)get1pxLinePixelValue {
    return 1.0 / kScreenScale;
}

/**
 获得系统线条的颜色值（iOS默认的那个）
 
 @return 系统线条颜色值
 */
+ (UIColor *)getLineColor {
    return [UIColor colorWithHexString:@"C8C7CC"];
}

/**
 默认的用户头像
 
 @return 用户头像
 */
+ (UIImage *)defaultUserIcon {
    return [UIImage imageNamed:@"icon_user"];
}

/**
 默认无图的占位图
 
 @return 占位图
 */
+ (UIImage *)defaultNoImagePic {
    return [UIImage imageNamed:@"xxx"];
}

/**
 *  得到部族欧巴刷新的头部视图
 *
 *  @param target 动作目标者
 *  @param action 执行的方法
 *
 *  @return 头部刷新视图
 */
+ (MJRefreshGifHeader *)JFWRefreshHeader:(id)target refreshingAction:(SEL)action {
    // 正常的是返回机器人蹦跑
    NSArray *imageStrArray = @[@"headerRefresh3", @"headerRefresh2", @"headerRefresh1"];
    CGFloat pullingDuration = 0.5;
    CGFloat refreshingDuration = 0.3;
    
    MJRefreshGifHeader *refreshView = [MJRefreshGifHeader headerWithRefreshingTarget:target
                                                                    refreshingAction:action];
    NSMutableArray *imageArray = [NSMutableArray new];
    UIImage *item1;
    
    for (NSInteger i = 0; i < imageStrArray.count; i++) {
        NSString *item = imageStrArray[i];
        UIImage *image = [UIImage imageNamed:item];
        
        if (i == 0) {
            item1 = image;
        }
        
        [imageArray addObject:image];
    }
    
    if (item1) {
        [refreshView setImages:@[item1] forState:MJRefreshStateIdle];
    }
    
    [refreshView setImages:imageArray duration:pullingDuration forState:MJRefreshStatePulling];
    [refreshView setImages:imageArray duration:refreshingDuration forState:MJRefreshStateRefreshing];
    
    refreshView.lastUpdatedTimeLabel.font = F7;
    refreshView.lastUpdatedTimeLabel.textColor = C4;
    
    return refreshView;
}

#pragma mark - 跳转有关

/**
 直接清除中间所有栈的控制器跳转到下一个控制器
 
 @param currentVC 当前控制器
 @param nextVC    下一个控制器
 */
+ (void)goToNextVCForCleanAllVC:(UIViewController *)currentVC nextVC:(UIViewController *)nextVC {
    NSMutableArray *vcArray = [NSMutableArray new];
    UIViewController *vc0 = currentVC.rt_navigationController.viewControllers[0];
    
    if (vc0) {
        // 判断是否不为nil才添加到数组中，不然会崩溃
        [vcArray addObject:vc0];
    }
    
    [vcArray addObject:nextVC];
    
    [currentVC.rt_navigationController setViewControllers:vcArray animated:YES];
}

/**
 直接在push一个控制器
 
 @param vc 控制器
 @param animated 是否需要动画
 */
+ (void)pushNextVC:(UIViewController *)vc animated:(BOOL)animated {
    RTRootNavigationController *naVC = (RTRootNavigationController *)[JFWUI getNavigationController];
    
    if (naVC) {
        [naVC pushViewController:vc animated:animated];
    }
}

/**
 先pop再push的方法
 
 @param newVC 新的控制器
 */
+ (void)popWithPush:(UIViewController *)newVC animated:(BOOL)animated {
    UINavigationController *nav = [JFWUI getNavigationController];
    
    NSMutableArray *navVCArray = [[NSMutableArray alloc] initWithArray:nav.viewControllers];
    
    [navVCArray removeObjectAtIndex:navVCArray.count - 1];
    [navVCArray addObject:newVC];
    
    [nav setViewControllers:navVCArray animated:animated];
}

/**
 获取导航栏
 
 @return 导航栏
 */
+ (UINavigationController *)getNavigationController {
    UIWindow *window = [UIApplication sharedApplication].windows[0];
    UINavigationController *naVC = (UINavigationController *)window.rootViewController;
    
    return naVC;
}

/**
 获得最顶层的控制器
 */
+ (UIViewController *)getTopViewController {
    RTRootNavigationController *navVC = (RTRootNavigationController *)[JFWUI getNavigationController];
    id vc = navVC.rt_topViewController;
    
    if ([vc isKindOfClass:[JFWTabBarController class]]) {
        // 如果是JFWTabBarController的话则拿到当前选中的控制器
        return ((JFWTabBarController *)vc).selectedViewController;
    }
    else {
        return navVC.rt_topViewController;
    }
}

@end
