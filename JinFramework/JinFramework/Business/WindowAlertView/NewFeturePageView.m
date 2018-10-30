//
//  NewFeturePageView.m
//  JinFramework
//
//  Created by 严锦龙 on 2018/10/30.
//  Copyright © 2018年 Jin. All rights reserved.
//

#import "NewFeturePageView.h"

@interface NewFeturePageView()<UIScrollViewDelegate>

@property (nonatomic, strong) NSArray *images;
@property (nonatomic, strong) UIScrollView *scrollview;
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, strong) UILabel *enterMainPageLabel;

@end

@implementation NewFeturePageView

- (void)customView {
    CGSize pageSize = CGSizeMake(self.window.bounds.size.width, self.window.bounds.size.height);
    
    _images = @[@"new_fetrue_1", @"new_fetrue_2", @"new_fetrue_3", @"new_fetrue_4"];
    
    _scrollview = [[UIScrollView alloc] initWithFrame:self.window.bounds];
    _scrollview.showsVerticalScrollIndicator = NO;
    _scrollview.showsHorizontalScrollIndicator = NO;
    _scrollview.bounces = NO;
    _scrollview.delegate = self;
    _scrollview.contentSize=CGSizeMake(pageSize.width * 4.0, pageSize.height);
    
    _scrollview.userInteractionEnabled = YES;
    _scrollview.pagingEnabled = YES;
    [self addSubview:_scrollview];
    
    float w = self.window.bounds.size.width;
    float h = self.window.bounds.size.height;
    
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
    [self addSubview:_pageControl];
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
    NSInteger currentPage = scrollView.contentOffset.x / self.window.bounds.size.width;
    _pageControl.currentPage = currentPage;
}

// 将背景视图隐藏 进入首页
- (void)tapEnterMainPageAciton:(id)sender {
    //放大渐变消失
    CGAffineTransform newTRansform = CGAffineTransformMakeScale(1.2, 1.2);
    
    [UIView animateWithDuration:0.5 animations:^{
        [self setTransform:newTRansform];
        [self setAlpha:0];
    } completion:^(BOOL finished) {
        [self dismiss];
        
        self.scrollview.delegate = nil;
        self.scrollview = nil;
    }];
}

@end
