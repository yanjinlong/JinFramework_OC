//
//  TCPlayerBottomView.m
//  TCPlayer
//
//  Created by  on 15/8/13.
//  Copyright (c) 2015年 . All rights reserved.
//

#import "TCPlayerBottomView.h"

#import "TCPlayerSlider.h"
#import <CoreMedia/CoreMedia.h>

#import "TCPlayerVideoTypeView.h"
#import "TCPlayItem.h"

#define RGBAColor(r,g,b,a)  [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]

@implementation TCPlayerBottomView


//#define height (46.0)
#define TC_CUR_PLAY_TIME_LABEL_LEFT_RATIO (0.13f)
#define TC_CUR_PLAY_TIME_LABEL_AND_SLIDER_MARGIN (5)
#define TC_SLIDER_AND_DURATION_LABEL_MARGIN (5)
#define TC_TIME_LABEL_FONT_SIZE (10)
#define TC_VIDEO_TYPE_FONT_SIZE (15)
#define TC_MOVIETIMECONTROL_HEIGHT (1)
#define TC_DURATION_LABEL_AND_VIDEO_TYPE_BTN_MARGIN (16)
#define TC_VIDEO_TYPE_BTN_RIGHT_MARGIN (16)


- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self.backgroundColor = RGBAColor(51, 51, 51, 0.8);
        
        _playPauseButton = [[UIButton alloc] init];
        [_playPauseButton setTitle:@"播放" forState:UIControlStateNormal];
        [_playPauseButton setTitle:@"暂停" forState:UIControlStateSelected];
        _playPauseButton.titleLabel.font = [UIFont systemFontOfSize:12];
        [_playPauseButton addTarget:self action:@selector(onClickPlayOrPause:) forControlEvents:UIControlEventTouchUpInside];
     //   _playPauseButton.backgroundColor = [UIColor redColor];
        [self addSubview:_playPauseButton];
        
        UIFont* timeLabelFont = [UIFont systemFontOfSize:TC_TIME_LABEL_FONT_SIZE];
        CGSize timeLabelSize;
        NSString* defaultTimeText = @" 00:00:00 ";
        BOOL isPreiOS7 = kCFCoreFoundationVersionNumber < kCFCoreFoundationVersionNumber_iOS_7_0;
        if (isPreiOS7) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
            timeLabelSize = [defaultTimeText sizeWithFont:timeLabelFont];
#pragma clang diagnostic pop
        }
        else
        {
            timeLabelSize = [defaultTimeText sizeWithAttributes:@{NSFontAttributeName:timeLabelFont}];
        }
        _curPlayTimeLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, timeLabelSize.width, timeLabelSize.height)];
        _curPlayTimeLabel.textColor = [UIColor whiteColor];
        _curPlayTimeLabel.textAlignment = NSTextAlignmentCenter;
        _curPlayTimeLabel.font = [UIFont systemFontOfSize:TC_TIME_LABEL_FONT_SIZE];
        _curPlayTimeLabel.text = @"00:00:00";
        [self addSubview:_curPlayTimeLabel];
        
        _movieTimeControl = [[TCPlayerSlider alloc] initWithFrame:CGRectZero];
        _movieTimeControl.continuous = YES;
        _movieTimeControl.maximumTrackTintColor = [UIColor blackColor];// RGBAColor(61,61,61,1);
        _movieTimeControl.loadTrackTintColor = [UIColor grayColor];
        [_movieTimeControl addTarget:self action:@selector(beginScrubbing:) forControlEvents:UIControlEventTouchDown];
        [_movieTimeControl addTarget:self action:@selector(scrubing:) forControlEvents:UIControlEventValueChanged];
        [_movieTimeControl addTarget:self action:@selector(endScrubbing:) forControlEvents:UIControlEventTouchUpOutside | UIControlEventTouchUpInside];
        [self addSubview:_movieTimeControl];
        
        
        _durationTimeLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, timeLabelSize.width, timeLabelSize.height)];
        _durationTimeLabel.textColor = [UIColor grayColor];
        _durationTimeLabel.textAlignment = NSTextAlignmentCenter;
        _durationTimeLabel.font = [UIFont systemFontOfSize:TC_TIME_LABEL_FONT_SIZE];
        _durationTimeLabel.text = @"00:00:00";
        [self addSubview:_durationTimeLabel];
        
        UIFont* videoTypeSelBtnFont = [UIFont systemFontOfSize:TC_VIDEO_TYPE_FONT_SIZE];
        NSString* defaultBtnText = @" 标清 ";
        CGSize videoTypeSelBtnSize;
        if (isPreiOS7) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
            videoTypeSelBtnSize = [defaultBtnText sizeWithFont:videoTypeSelBtnFont];
#pragma clang diagnostic pop
        }
        else
        {
            videoTypeSelBtnSize = [defaultBtnText sizeWithAttributes:@{NSFontAttributeName:videoTypeSelBtnFont}];
        }
        
        /*_videoTypeSelButn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_videoTypeSelButn addTarget:self action:@selector(onVideoTypeSelBtnClick) forControlEvents:UIControlEventTouchUpInside];
        _videoTypeSelButn.frame = CGRectMake(0, 0, videoTypeSelBtnSize.width, videoTypeSelBtnSize.height);
        [_videoTypeSelButn setTitle:defaultBtnText forState:UIControlStateNormal];
        _videoTypeSelButn.titleLabel.textColor = [UIColor whiteColor];
        _videoTypeSelButn.titleLabel.textAlignment = NSTextAlignmentCenter;
        _videoTypeSelButn.titleLabel.font = videoTypeSelBtnFont;
        [self addSubview:_videoTypeSelButn];*/
        
        _fullScreenButton = [[UIButton alloc] init];
        [_fullScreenButton addTarget:self action:@selector(onClickFullScreen) forControlEvents:UIControlEventTouchUpInside];
        _fullScreenButton.frame = CGRectMake(0, 0, videoTypeSelBtnSize.height, videoTypeSelBtnSize.height);
        [_fullScreenButton setImage:[UIImage imageNamed:@"notfull.png"] forState:UIControlStateNormal];
        [_fullScreenButton setImage:[UIImage imageNamed:@"full.png"] forState:UIControlStateSelected];
        [self addSubview:_fullScreenButton];
        
        [self disabledBottomView];
    }
    
    return self;
}

- (void)onClickPlayOrPause:(UIButton *)btn
{
    [_playerView playOrPause];
}

- (void)onClickFullScreen
{
    [_playerView changeToFullScreen:_fullScreenButton.selected];
//    if (_fullScreenButton.selected == YES) {
//        _playerView.backgroundColor = [UIColor clearColor];
//    }else{
//        _playerView.backgroundColor = [UIColor blackColor];
//    }
}

- (void)reset
{
    [self disabledBottomView];
    [self syncPlayState:NO];
    [self setCurPlayTime:0];
    [self setDuration:0];
    
//    TCPlayItem *item = (TCPlayItem *)_playerView.playingItem;
//    [_videoTypeSelButn setTitle:item.type forState:UIControlStateNormal];
}

- (void)enabledBottomView:(BOOL)isValidDuration;
{
    _playPauseButton.enabled = YES;
    _movieTimeControl.enabled = isValidDuration;
//    _videoTypeSelButn.enabled = YES;
}

- (void)disabledBottomView
{
    _playPauseButton.enabled = NO;
    _movieTimeControl.enabled = NO;
//    _videoTypeSelButn.enabled = NO;
}

- (void)layoutWithRecommendRect:(CGRect)rect
{
    rect.origin.y += rect.size.height - 46;
    rect.size.height = 46;
    self.frame = rect;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGRect bounds = self.bounds;
    CGFloat height = bounds.size.height;
    
    _playPauseButton.frame = CGRectMake(8, (bounds.size.height - 30)/2, 30, 30);
    
    float l = TC_CUR_PLAY_TIME_LABEL_LEFT_RATIO * bounds.size.width;
    
    //当前播放时间label
    _curPlayTimeLabel.frame = CGRectMake(l, height / 2 - _curPlayTimeLabel.frame.size.height / 2, _curPlayTimeLabel.frame.size.width, _curPlayTimeLabel.frame.size.height);
    l = CGRectGetMaxX(_curPlayTimeLabel.frame) + TC_CUR_PLAY_TIME_LABEL_AND_SLIDER_MARGIN;
    
    //视频类型选择按钮
    
    _fullScreenButton.frame = CGRectMake(bounds.size.width - _fullScreenButton.frame.size.width - TC_VIDEO_TYPE_BTN_RIGHT_MARGIN, 8, height - 2 * 8, height - 2 * 8);
    
    /*_videoTypeSelButn.frame = CGRectMake(_fullScreenButton.frame.origin.x - TC_VIDEO_TYPE_BTN_RIGHT_MARGIN - _videoTypeSelButn.frame.size.width, height / 2 - _videoTypeSelButn.frame.size.height / 2, _videoTypeSelButn.frame.size.width, _videoTypeSelButn.frame.size.height);
    
    //总时长label
    float r = CGRectGetMinX(_videoTypeSelButn.frame) - TC_DURATION_LABEL_AND_VIDEO_TYPE_BTN_MARGIN;
    _durationTimeLabel.frame = CGRectMake(r - _durationTimeLabel.frame.size.width, height / 2 - _durationTimeLabel.frame.size.height / 2, _durationTimeLabel.frame.size.width, _durationTimeLabel.frame.size.height);
    
    r = CGRectGetMinX(_durationTimeLabel.frame) - TC_SLIDER_AND_DURATION_LABEL_MARGIN;
    //进度条
    _movieTimeControl.frame = CGRectMake(l, (height - _movieTimeControl.bounds.size.height) / 2, r - l, height);*/
    float r = CGRectGetMinX(_fullScreenButton.frame) - TC_DURATION_LABEL_AND_VIDEO_TYPE_BTN_MARGIN;

    _durationTimeLabel.frame = CGRectMake(r - _durationTimeLabel.frame.size.width, height / 2 - _durationTimeLabel.frame.size.height / 2, _durationTimeLabel.frame.size.width, _durationTimeLabel.frame.size.height);
    
    r = CGRectGetMinX(_durationTimeLabel.frame) - TC_SLIDER_AND_DURATION_LABEL_MARGIN;
    //进度条
    _movieTimeControl.frame = CGRectMake(l, (height - _movieTimeControl.bounds.size.height) / 2, r - l, height);
}

//- (CGFloat)movieTimeControlWidth
//{
//    return _movieTimeControl.bounds.size.width;
//}

- (void)syncPlayState:(BOOL)isPlaying
{
    //    UIBarButtonItem* item = _playButton;
    //    if (isPlaying)
    //    {
    //        item = _pauseButton;
    //    }
    //
    //    NSMutableArray *toolbarItems = [NSMutableArray arrayWithArray:[_toolBar items]];
    //    if ([toolbarItems count] > 0 )
    //    {
    //        [toolbarItems replaceObjectAtIndex:0 withObject:item];
    //    }
    //    else
    //    {
    //        [toolbarItems addObject:item];
    //    }
    //    _toolBar.items = toolbarItems;
    
    _playPauseButton.selected = isPlaying;
}

//- (void)playControlButtonClick:(id)object
//{
//    [_playerView playOrPause];
//    if (object == _playButton)
//    {
//        if ([_movieTimeControl isInLimitState])
//        {
//            return;
//        }
//        //        if (_delegate && [_delegate respondsToSelector:@selector(onPlayBtnClicked)])
//        //        {
//        //            [_delegate onPlayBtnClicked];
//        //
//        //            [self syncPlayState:YES];
//        //        }
//
//        [_playerView play];
//    }
//    else if(object == _pauseButton)
//    {
//        //        if (_delegate && [_delegate respondsToSelector:@selector(onPauseBtnClicked)])
//        //        {
//        //            [_delegate onPauseBtnClicked];
//        //
//        //            [self syncPlayState:NO];
//        //        }
//        [_playerView pause];
//    }
//}

- (NSString*)getTimeShowText:(Float64)fPlaySeconds
{
    NSInteger nPlaySeconds = (NSInteger)fPlaySeconds;
    NSInteger hour = nPlaySeconds / 3600;
    NSInteger minute = (nPlaySeconds - hour * 3600) / 60;
    NSInteger  seconds = nPlaySeconds - hour * 3600 - minute * 60;
    //    if (fPlaySeconds > 0.000001) {
    //        seconds++;
    //    }
    NSString* timeText = [NSString stringWithFormat:@"%.02zd:%.02zd:%.02zd", hour, minute, seconds];
    
    return timeText;
}

- (void)setCurPlayTime:(Float64)fPlaySeconds
{
    if (fPlaySeconds < 0 || !isfinite(fPlaySeconds))
    {
        return;
    }
    _curPlayTimeLabel.text = [self getTimeShowText:fPlaySeconds];
}

- (void)setmovieTimeControlValue:(Float32)value
{
    if (value < 0 || value > 1)
    {
        return;
    }
    [_movieTimeControl setValue:value animated:YES];
    [_movieTimeControl setNeedsDisplay];
}

- (Float32)movieTimeControlValue
{
    return [_movieTimeControl value];
}

- (void)setmovieTimeControlMinValue:(Float32)minValue
{
    //    if (minValue < 0 )
    //    {
    //        return;
    //    }
    
    [_movieTimeControl setMinimumValue:minValue];
}

- (void)setmovieTimeControlMaxValue:(Float32)maxValue
{
    //    if (maxValue > 1)
    //    {
    //        return;
    //    }
    [_movieTimeControl setMaximumValue:maxValue];
}

- (Float32)movieTimeControlLimitValue
{
    return _movieTimeControl.limitValue;
}

- (void)setmovieTimeControlLimitValue:(Float32)limitValue
{
    _movieTimeControl.limitValue = limitValue;
}

- (Float32)movieTimeControlMinValue
{
    return _movieTimeControl.minimumValue;
}

- (Float32)movieTimeControlMaxValue
{
    return _movieTimeControl.maximumValue;
}

- (void)setDuration:(Float64)fPlaySeconds
{
    if (fPlaySeconds <= 0 || !isfinite(fPlaySeconds))
    {
        return;
    }
    _durationTimeLabel.text = [self getTimeShowText:fPlaySeconds];
}



/* The user is dragging the movie controller thumb to scrub through the movie. */
- (void)beginScrubbing:(id)sender
{
    //    if (_delegate && [_delegate respondsToSelector:@selector(beginScrubbing:)])
    //    {
    //        [_delegate beginScrubbing:self];
    //    }
    [self.playerView startSeek];
}

/* The user has released the movie thumb control to stop scrubbing through the movie. */
- (void)endScrubbing:(id)sender
{
    Float32 value = [self movieTimeControlValue];
    Float64 time = value *  [self.playerView duration];
    [self.playerView stopSeek:time];
}

/* Set the player current time to match the scrubber position. */
- (void)scrubing:(id)sender
{
    Float32 value = [self movieTimeControlValue];
    Float64 time = value *  [self.playerView duration];
    [self setCurPlayTime:time];
    
    //    CMTime beginPlayTime = CMTimeMakeWithSeconds(time, 600);
    //    NSInteger playTime = (NSInteger)(CMTimeGetSeconds(beginPlayTime));
    //
    //    Float32 value = [self movieTimeControlValue];
    //    Float64 time = value *  [self.playerView duration];
    //    if (_delegate && [_delegate respondsToSelector:@selector(scrubbing:)])
    //    {
    //        [_delegate scrubbing:self];
    //    }
}


- (void)onVideoTypeSelBtnClick
{
    TCPlayerVideoTypeView *mask = [[TCPlayerVideoTypeView alloc] init];
    [self.playerView showMask:mask];
}

- (void)setVideoTypeTitle:(NSString *)videoTypeTitle
{
//    [_videoTypeSelButn setTitle:videoTypeTitle forState:UIControlStateNormal];
}

- (NSString*)videoTypeTitle
{
//    return [_videoTypeSelButn titleForState:UIControlStateNormal];
    return nil;
}

// 设置BottomView 放大缩小按钮的放大与缩小图片
- (void)changeBottomFullImage:(UIImage *)amplifyImage notFullImage:(UIImage *)shrinkImage
{
    [_fullScreenButton setImage:amplifyImage forState:UIControlStateNormal];
    [_fullScreenButton setImage:shrinkImage forState:UIControlStateSelected];
}

- (void)changeFullScreenState:(BOOL)isFull
{
    _fullScreenButton.selected = isFull;
}


//====================

// 状态更新
- (void)updateOnPreparing
{
    [self enabledBottomView:NO];
    [self syncPlayState:NO];
//    TCPlayItem *item = (TCPlayItem *) _playerView.playingItem;
//    [_videoTypeSelButn setTitle:item.type forState:UIControlStateNormal];
}

- (void)updateOnPlayerFailed
{
    [self enabledBottomView:NO];
}

- (void)updateOnWillPlay
{
    
    NSInteger duration = _playerView.duration;
    if (duration > 0)
    {
        [self enabledBottomView:YES];
        [self syncPlayState:YES];
        //        [self setmovieTimeControlMinValue:0.0];
        //        [self setmovieTimeControlMaxValue:duration];
        [self setDuration:duration];
    }
    
//    TCPlayItem *item = (TCPlayItem *) _playerView.playingItem;
//    [_videoTypeSelButn setTitle:item.type forState:UIControlStateNormal];
    
}
- (void)updateOnPause
{
    [self syncPlayState:NO];
}
- (void)updateOnStop
{
    [self syncPlayState:NO];
}


- (void)updateOnCurrentTime:(NSInteger)time
{
    [self setCurPlayTime:time];
    
    NSInteger dura = [_playerView duration];
    
    if (dura > 0)
    {
        [self setmovieTimeControlValue:time*1.0/dura];
    }
}

- (void)updateOnBufferingProgress:(CGFloat)progress
{
    _movieTimeControl.loadValue = progress;
}

- (void)updateOnPlayOver
{
    [self updateOnCurrentTime:_playerView.currentTime];
    _movieTimeControl.loadValue = 0;
}

- (void)updateOnStateChanged:(TCPlayerState)state
{
    [self syncPlayState:[_playerView isPlaying]];
}


- (void)updateOnFullScreenChangeTo:(BOOL)full
{
    BOOL isFull = [_playerView isFullScreen];
    _fullScreenButton.selected = isFull;
}


@end
