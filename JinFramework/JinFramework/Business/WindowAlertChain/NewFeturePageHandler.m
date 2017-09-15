//
//  GuidePageConcreteHandler.m
//  JinFramework
//
//  Created by denghaishu on 2017/6/24.
//  Copyright © 2017年  Tribetech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewFeturePageHandler.h"
#import "JFWDesignConfig.h"
#import "JFWUI.h"
#import "UIApplication+YYAdd.h"

/**
 引导页处理者
 */
@interface NewFeturePageHandler () <UIScrollViewDelegate>

@property (nonatomic, strong) UIWindow *window;
@property (nonatomic, strong) UIView *bgview;
@property (nonatomic, strong) NSArray *images;
@property (nonatomic, strong) UIScrollView *scrollview;
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, strong) UILabel *enterMainPageLabel;

@end

@implementation NewFeturePageHandler

// 重写父类的处理方法
- (void)handlerOwnTask {
    // 有新版本需要 处理
    if ([self isNewest]) {
        [self showNewFeture];
    }
    else {
        [self.nextHandler handlerOwnTask];
    }
    
    return;
}

// 显示引导图
- (void)showNewFeture {
    _window = [UIApplication sharedApplication].delegate.window;
    
    CGSize pageSize = CGSizeMake(_window.bounds.size.width, _window.bounds.size.height);
    // 承载scrollview、pageControl的背景视图
    _bgview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, pageSize.width, pageSize.height)];
    
    _window = [UIApplication sharedApplication].delegate.window;
    _images = @[@"new_fetrue_1", @"new_fetrue_2", @"new_fetrue_3", @"new_fetrue_4"];
    
    _scrollview = [[UIScrollView alloc] initWithFrame:_window.bounds];
    _scrollview.showsVerticalScrollIndicator = NO;
    _scrollview.showsHorizontalScrollIndicator = NO;
    _scrollview.bounces = NO;
    _scrollview.delegate=self;
    _scrollview.contentSize=CGSizeMake(pageSize.width * 4.0, pageSize.height);
    
    _scrollview.userInteractionEnabled = YES;
    _scrollview.pagingEnabled = YES;
    [_bgview addSubview:_scrollview];
    
    float w = _window.bounds.size.width;
    float h = _window.bounds.size.height;
    
    for (NSInteger i = 0; i < _images.count; i++) {
        CGRect rect = CGRectMake(i * w, 0, w, h);
        UIImageView *iv = [[UIImageView alloc] initWithFrame:rect] ;
        iv.image = [UIImage imageNamed:[_images objectAtIndex:i]];
        [_scrollview addSubview:iv];
        
        if (_images.lastObject == [_images objectAtIndex:i]) {
            [self setupEnterMainPageLabel:iv];
        }
    }
    
    // 分页控制器初始化
    _pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(pageSize.width / 2.0 - 50.0, pageSize.height - 40.0, 100, 20)];
    _pageControl.currentPageIndicatorTintColor = C1;
    _pageControl.pageIndicatorTintColor = C6;
    
    _pageControl.numberOfPages = _images.count;
    [_bgview addSubview:_pageControl];
    
    [_window addSubview:_bgview];
}

// 设置 进入体验按钮
- (void)setupEnterMainPageLabel:(UIView *)imageView {
    imageView.userInteractionEnabled = YES;
    
    _enterMainPageLabel = [[UILabel alloc] init];
    _enterMainPageLabel.font = F4;
    _enterMainPageLabel.textColor = C8;
    _enterMainPageLabel.text = @"进入体验";
    _enterMainPageLabel.textAlignment = NSTextAlignmentCenter;
    _enterMainPageLabel.userInteractionEnabled = YES;
    
    _enterMainPageLabel.bottom = UI_SCREEN_FHEIGHT - 100.0;
    _enterMainPageLabel.width = 115.0;
    _enterMainPageLabel.height = 33.0;
    _enterMainPageLabel.left = (UI_SCREEN_FWIDTH - _enterMainPageLabel.width) * 0.5;
    
    _enterMainPageLabel.layer.borderColor = C8.CGColor;
    _enterMainPageLabel.layer.borderWidth = 1.0;
    _enterMainPageLabel.layer.cornerRadius = 11.5;
    
    [_enterMainPageLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapEnterMainPageAciton:)]];
    [imageView addSubview:_enterMainPageLabel];
}

// 改变分页控制器当前页码
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    NSInteger currentPage = scrollView.contentOffset.x / _window.bounds.size.width;
    _pageControl.currentPage = currentPage;
}

// 将背景视图异常 进入首页
- (void)tapEnterMainPageAciton:(id)sender {
    //放大渐变消失
    CGAffineTransform newTRansform = CGAffineTransformMakeScale(1.2, 1.2);
    
    [UIView animateWithDuration:0.5 animations:^{
        [_bgview setTransform:newTRansform];
        [_bgview setAlpha:0];
    } completion:^(BOOL finished) {
        [self.bgview removeFromSuperview];
        self.bgview = nil;
        self.scrollview.delegate = nil;
        self.scrollview = nil;
    }];
}

// 是否有新引导图需要显示
- (BOOL)isNewest {
    BOOL isNewest = NO;
    
    NSString *version = [UIApplication sharedApplication].appVersion;
    
    // 存在沙盒的版本信息
    NSString *hisVersion = [[NSUserDefaults standardUserDefaults] objectForKey:version];
    
    if (![version isEqualToString:hisVersion]) {
        isNewest = YES;
        // 存新版本
        [[NSUserDefaults standardUserDefaults] setValue:version forKey:version];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    return isNewest;
}

@end
