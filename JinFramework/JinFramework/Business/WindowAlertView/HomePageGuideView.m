//
//  HomePageGuideView.m
//  JinFramework
//
//  Created by 严锦龙 on 2018/10/30.
//  Copyright © 2018年 Jin. All rights reserved.
//

#import "HomePageGuideView.h"

@interface HomePageGuideView()

@property (strong, nonatomic) UILabel *tipsLabel;
@property (strong, nonatomic) UIButton *nextButton;

@end

@implementation HomePageGuideView

- (void)customView {
    self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6];
    
    _tipsLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 50)];
    _tipsLabel.centerX = UI_SCREEN_FWIDTH / 2;
    _tipsLabel.centerY = UI_SCREEN_FHEIGHT / 2;
    _tipsLabel.font = FB1;
    _tipsLabel.textColor = C7;
    _tipsLabel.textAlignment = NSTextAlignmentCenter;
    _tipsLabel.text = @"首页蒙版";
    
    [self addSubview:_tipsLabel];
    
    _nextButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
    [_nextButton setTitleColor:C7 forState:UIControlStateNormal];
    _nextButton.titleLabel.font = F4;
    [_nextButton setTitle:@"知道了" forState:UIControlStateNormal];
    [_nextButton addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    _nextButton.centerX = UI_SCREEN_FWIDTH / 2;
    _nextButton.bottom = UI_SCREEN_FHEIGHT - 50;
    
    [self addSubview:_nextButton];
}

@end
