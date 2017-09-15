//
//  JFWEmptyView.m
//  JinFramework
//
//  Created by Jin on 2017/5/3.
//  Copyright © 2017年 Tribetech. All rights reserved.
//

#import "JFWEmptyView.h"
#import "JFWUI.h"
#import "JFWConfig.h"

/**
 空视图（无网，无数据）
 */
@interface JFWEmptyView()

@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) UILabel *tipsLabel;

@end

@implementation JFWEmptyView

- (instancetype)init {
    self = [super initWithFrame:[UIScreen mainScreen].bounds];
    
    if (self) {
        [self initView];
    }
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        [self initView];
    }
    
    return self;
}

/**
 初始化视图
 */
- (void)initView {
    self.backgroundColor = [UIColor whiteColor];
    CGFloat width = 60 * kJFWScreenScale;
    CGFloat height = width;
    
    // 图标
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    self.imageView.center = CGPointMake(UI_SCREEN_FWIDTH / 2, UI_SCREEN_FHEIGHT / 2 - height);
    [self addSubview:self.imageView];
    
    // 文本
    self.tipsLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.imageView.bottom,
                                                               UI_SCREEN_FWIDTH, 28)];
    self.tipsLabel.textAlignment = NSTextAlignmentCenter;
    self.tipsLabel.textColor = C3;
    self.tipsLabel.font = F4;
    [self addSubview:self.tipsLabel];
}

- (void)drawRect:(CGRect)rect {
    NSString *imageName = @"noNet";
    NSString *tipsText = @"网络不给力，点击屏幕重试";
    
    if (self.viewType == EmptyViewTypeNoData) {
        imageName = @"noData";
        tipsText = @"暂无数据";
        
        if (self.tipsText.isNotBlank) {
            tipsText = self.tipsText;
        }
    }
    else {
        // 只有无网才可以点击屏幕进行重试
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithActionBlock:^(id _Nonnull sender) {
            if (self.didTouchViewBlock) {
                self.didTouchViewBlock();
            }
        }];
        
        self.userInteractionEnabled = YES;
        [self addGestureRecognizer:tap];
    }
    
    UIImage *image = [UIImage imageNamed:imageName];
    self.imageView.image = image;

//    if (self.viewType == EmptyViewTypeNoData) {
//        self.imageView.image = image;
//    }
//    else {
//        self.imageView.image = [JFWUI imageWithColor:[JFWUI getLineColor] image:image];
//    }
    
    self.tipsLabel.text = tipsText;
}

@end
