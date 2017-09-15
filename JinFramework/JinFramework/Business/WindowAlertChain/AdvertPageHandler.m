//
//  ADConcreteHandler.m
//  JinFramework
//
//  Created by denghaishu on 2017/6/24.
//  Copyright © 2017年  Tribetech. All rights reserved.
//

#import "AdvertPageHandler.h"
#import "JFWConfig.h"
#import <TCPlayerSDK/TCPlayerSDK.h>
#import "TCPlayItem.h"
#import "TCPlayerActionHandler.h"

@interface AdvertPageHandler()

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) NSTimer *showTimer;
@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) UIButton *removeButton;

@property (assign, nonatomic) int surplusTime;        //距离广告结束时间

@property (strong, nonatomic) TCPlayerView *playerView;
@property (copy, nonatomic) NSString *videoPath;

/**
 显示图片视图的图片对象
 */
@property (strong, nonatomic) UIImage *image;

@end

static AdvertPageHandler *advertiseManage;

/**
 广告处理者
 */
@implementation AdvertPageHandler

// 重写父类的处理方法
- (void)handlerOwnTask {
    if (self.image) {
        // 如果有图片则执行动画
        [self startAnimmation];
    }
    else if (self.videoPath) {
        // 如果是视频的则不需要其他操作
    }
    else {
        if (self.nextHandler) {
            // 如果有下一个处理者则下一个处理者执行
            [self.nextHandler handlerOwnTask];
        }
    }
}

/**
 启动带图片效果的
 
 @param image 图片
 
 @return 启动页的实体对象
 */
- (instancetype)initWithImage:(UIImage *)image {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        advertiseManage = [super init];
    });
    
    self.image = image;
    self.surplusTime = SHOWAD_TIME;
    [self createView];
    
    return advertiseManage;
}

/**
 启动带视频路径
 
 @param videoPath 视频路径
 
 @return 启动页的实体对象
 */
- (instancetype)initWithVideoPath:(NSString *)videoPath {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        advertiseManage = [super init];
    });
    
    self.videoPath = videoPath;
    self.surplusTime = VIDEO_SHOW_TIME;
    [self createVideoView];
    
    return advertiseManage;
}

#pragma mark - 创建视图

- (void)createView {
    _window = [UIApplication sharedApplication].delegate.window;
    _imageView = [[UIImageView alloc] initWithFrame:_window.bounds];
    _imageView.userInteractionEnabled = YES;
    _imageView.image = self.image;
    
    _removeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _removeButton.frame = CGRectMake(UI_SCREEN_FWIDTH - 75, 25, 70, 30);
    [_removeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _removeButton.layer.cornerRadius = 4.0;
    _removeButton.layer.borderWidth = 1.0;
    _removeButton.layer.borderColor = [UIColor whiteColor].CGColor;
    NSString *title = [NSString stringWithFormat:@"跳转 (%d)", _surplusTime];
    [_removeButton setTitle:title forState:UIControlStateNormal];
    
    _removeButton.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    _removeButton.titleLabel.font = [UIFont systemFontOfSize:14];
    
    [_removeButton addTarget:self action:@selector(removeButtonTouch:) forControlEvents:UIControlEventTouchUpInside];
    
    [_imageView addSubview:_removeButton];
    [_window addSubview:_imageView];
}

- (void)createVideoView {
    self.window = [UIApplication sharedApplication].delegate.window;
    
    self.playerView = [[TCPlayerView alloc] init];
    self.playerView.frame = self.window.bounds;
    
    TCPlayerActionHandler *handler = [[TCPlayerActionHandler alloc] init];
    handler.playbackBeginBlock =  ^(UIView<TCPlayerAbleView, TCPlayerEngine> *playerView) {
        NSLog(@"播放");
        
        [self startAnimmation];
        
        // 隐藏底图
        if (self.beginPalyVideo) {
            self. beginPalyVideo();
        }
    };
    
    handler.clickPlaybackViewblock = ^(UIView<TCPlayerAbleView, TCPlayerEngine> *playerView, NSInteger actionType) {
        // 不做任何动作
    };
    
    self.playerView.playAction = handler;
    
    TCPlayItem *item = [[TCPlayItem alloc] init];
    item.type = @"标清";
    item.url = self.videoPath;
    item.limitSeconds = VIDEO_SHOW_TIME;
    
    [self.playerView play:item];
    [self.window addSubview:self.playerView];
    
    // 添加关闭按钮
    _removeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _removeButton.frame = CGRectMake(UI_SCREEN_FWIDTH - 75, 25, 70, 30);
    [_removeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _removeButton.layer.cornerRadius = 4.0;
    _removeButton.layer.borderWidth = 1.0;
    _removeButton.layer.borderColor = [UIColor whiteColor].CGColor;
    NSString *title = [NSString stringWithFormat:@"跳转 (%d)", _surplusTime];
    [_removeButton setTitle:title forState:UIControlStateNormal];
    
    _removeButton.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    _removeButton.titleLabel.font = [UIFont systemFontOfSize:14];
    
    [_removeButton addTarget:self action:@selector(removeButtonTouch:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.playerView addSubview:_removeButton];
}

#pragma mark - 展示的方法

//定时器控制广告页停留时间
- (void)startAnimmation {
    _showTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(beginAnimmation) userInfo:nil repeats:YES];
}

- (void)beginAnimmation {
    if (_surplusTime == 0 && _showTimer) {
        [_showTimer invalidate];//停掉时间器
        _showTimer = nil;
        
        [self hide];
    }
    else if (_showTimer) {
        NSString *title = [NSString stringWithFormat:@"跳转 (%d)", _surplusTime];
        [_removeButton setTitle:title forState:UIControlStateNormal];
        _surplusTime --;
    }
}

- (void)removeButtonTouch:(UIButton *)sender {
    [_showTimer invalidate];//停掉时间器
    _showTimer = nil;
    
    [self hide];
}

/**
 *  隐藏广告页对外方法
 */
- (void)hide {
    _removeButton.hidden = YES;
    
    if (self.image) {
        //放大渐变消失
        CGAffineTransform newTRansform = CGAffineTransformMakeScale(1.2, 1.2);
        
        [UIView animateWithDuration:0.8 animations:^{
            [_imageView setTransform:newTRansform];
            [_imageView setAlpha:0];
        } completion:^(BOOL finished) {
            [_imageView removeFromSuperview];
            
            if (self.nextHandler) {
                // 如果有下一个处理者则下一个处理者执行
                [self.nextHandler handlerOwnTask];
            }
        }];
    }
    else if (self.videoPath) {
        //视频消失
        CGAffineTransform newTRansform = CGAffineTransformMakeScale(1.2, 1.2);
        
        [UIView animateWithDuration:0.8 animations:^{
            [self.playerView setTransform:newTRansform];
            [self.playerView setAlpha:0];
        } completion:^(BOOL finished) {
            [self.playerView removeFromSuperview];
            self.playerView = nil;
            
            if (self.nextHandler) {
                // 如果有下一个处理者则下一个处理者执行
                [self.nextHandler handlerOwnTask];
            }
        }];
    }
}

@end
