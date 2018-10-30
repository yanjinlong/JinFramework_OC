//
//  UpdatePageView.m
//  JinFramework
//
//  Created by 严锦龙 on 2018/10/30.
//  Copyright © 2018年 Jin. All rights reserved.
//

#import "UpdatePageView.h"

@interface UpdatePageView()

@property (strong, nonatomic) UIView *bgView;
@property (strong, nonatomic) UILabel *tipsLabel;
@property (strong, nonatomic) UIButton *nextButton;

@end

@implementation UpdatePageView

- (void)customView {
    self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6];
    
    _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 300)];
    _bgView.centerX = UI_SCREEN_FWIDTH / 2;
    _bgView.centerY = UI_SCREEN_FHEIGHT / 2;
    _bgView.backgroundColor = C12;
    [self addSubview:_bgView];
    
    _tipsLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 50)];
    _tipsLabel.centerX = _bgView.width / 2;
    _tipsLabel.centerY = _bgView.height / 2;
    _tipsLabel.font = FB1;
    _tipsLabel.textColor = C1;
    _tipsLabel.textAlignment = NSTextAlignmentCenter;
    _tipsLabel.text = @"升级提示";
    
    [_bgView addSubview:_tipsLabel];
    
    _nextButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
    [_nextButton setTitleColor:C1 forState:UIControlStateNormal];
    _nextButton.titleLabel.font = F4;
    [_nextButton setTitle:@"好，去升级" forState:UIControlStateNormal];
    [_nextButton addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    _nextButton.centerX = _bgView.width / 2;
    _nextButton.bottom = _bgView.height - 50;
    
    [_bgView addSubview:_nextButton];
}

@end
