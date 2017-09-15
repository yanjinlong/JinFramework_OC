//
//  TCPlayerBaseControlView.m
//  TCPlayer
//
//  Created by  on 15/8/13.
//  Copyright (c) 2015年 . All rights reserved.
//

#import "TCPlayerBaseControlView.h"
#import <MediaPlayer/MPMusicPlayerController.h>

typedef NS_ENUM(NSUInteger, GestureOperateType) {
    GestureOperateType_Unknow,
    GestureOperateType_Lumina,  //亮度
    GestureOperateType_Progress,//进度
    GestureOperateType_Volume,  //音量
    
    GestureOperateType_VideoTypeSel,  // 侧滑出VideoTypeSel
};

@interface TCPlayerBaseControlView ()<UIGestureRecognizerDelegate>
{
    
@protected
    UIView                      *_luminaView;
    UIActivityIndicatorView     *_indicatorView;
    UILabel                     *_timeLabel;
    
    NSInteger                   _seekTime;
    CGFloat                     _lastScale;
    
@protected
    //  手势相关
    CGPoint     _startPnt;
    GestureOperateType _opType;
    BOOL        _isLeft;
    NSInteger   _oldTime;
    CGFloat     _oldLumina;
    CGFloat     _oldVolume;
    
    
@private
    
    
}

@property (nonatomic, strong) UIActivityIndicatorView *indicatorView;
@property(nonatomic, assign) CGFloat luminance;//亮度(0-1)

@property (nonatomic, assign) CGFloat luminaStep;
@property (nonatomic, assign) CGFloat volumeStep;
@property (nonatomic, assign) CGFloat timeStep;
@property (nonatomic, assign) CGFloat unitPixel;
@property (nonatomic, assign) CGFloat minLumina;


@end


@implementation TCPlayerBaseControlView



#define LUMINA_STEP 0.05
#define VOLUME_STEP 0.05

#define TIME_STEP 1.0

#define UNIT_PIXEL (5 * [UIScreen mainScreen].scale)

#define LUMINA_MIN_VALUE 0.1


- (void)dealloc
{
    //    NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(<#selector#>) object:<#(id)#>
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        _luminaStep = LUMINA_STEP;
        _volumeStep = VOLUME_STEP;
        _timeStep = TIME_STEP;
        _unitPixel = UNIT_PIXEL;
        _minLumina = LUMINA_MIN_VALUE;
        
        _luminaView = [[UIView alloc] initWithFrame:frame];
        _luminaView.alpha = 0;
        _luminaView.backgroundColor = [UIColor blackColor];
        _luminaView.userInteractionEnabled = NO;
        [self addSubview:_luminaView];
        
        _indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        [_indicatorView hidesWhenStopped];
        _indicatorView.frame = CGRectMake(0, 0, 200, 200);
        [self addSubview:_indicatorView];
        
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 32, 32)];
        _timeLabel.font = [UIFont systemFontOfSize:14.0];
        _timeLabel.textColor = [UIColor whiteColor];
        _timeLabel.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.5];
        _timeLabel.center = CGPointMake(self.bounds.size.width/2.0, 50);
        _timeLabel.hidden = YES;
        [self addSubview:_timeLabel];
        
        _tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickPlayView:)];
        _tapGesture.numberOfTapsRequired = 1;
        _tapGesture.numberOfTouchesRequired = 1;
        [self addGestureRecognizer:_tapGesture];
        
        //增加手势控制
        _progessGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(playViewPanGestureAction:)];
        _progessGesture.minimumNumberOfTouches = 1;
        _progessGesture.maximumNumberOfTouches = 1;
        _progessGesture.delegate = self;
        [self addGestureRecognizer:_progessGesture];
        
        [self addSwiftLeftGesture];
        
    }
    return self;
}


- (void)addSwiftLeftGesture
{
//    UISwipeGestureRecognizer *swipeGes = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(onSwipeLeft:)];
//    swipeGes.direction = UISwipeGestureRecognizerDirectionLeft;
//    [self addGestureRecognizer:swipeGes];
//    
//    [swipeGes requireGestureRecognizerToFail:_progessGesture];
}

- (void)onClick:(NSInteger)actiontype
{
    if (_playerView.playAction && [_playerView.playAction respondsToSelector:@selector(clickPlaybackViewblock)])
    {
        TCPlayerViewClickActionBlock block = [_playerView.playAction clickPlaybackViewblock];
        if (block)
        {
            block(_playerView, actiontype);
        }
    }
}

- (void)onSingleClick
{
    NSLog(@"单击播放器");
    [self onClick:0];
    [_playerView autoShowOrHideBottomView:5];
}

- (void)onDoubleClick
{
    NSLog(@"双击播放器");
    [_playerView changeToFullScreen:_doubleTapGesture != nil];
    [self onClick:1];
}

- (void)onPinchClose
{
    NSLog(@"捏合播放器");
    [_playerView changeToFullScreen:_pinchGesture != nil];
    [self onClick:2];
}



- (void)clickPlayView:(UITapGestureRecognizer *)tap
{
    if (tap.state == UIGestureRecognizerStateEnded)
    {
        [self onSingleClick];
    }
}

- (void)updateOnFullScreenChangeTo:(BOOL)toFull
{
    
    if (toFull)
    {
        if (_pinchGesture == nil && _doubleTapGesture == nil)
        {
            
            
            // 添加pinch手势
            // 放大缩小手势
            _pinchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(onPinchClose:)];
            [self addGestureRecognizer:_pinchGesture];
            _lastScale = 1.0;
            
            _doubleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onDoubleClose:)];
            _doubleTapGesture.numberOfTapsRequired = 2;
            [self addGestureRecognizer:_doubleTapGesture];
            
            [_tapGesture requireGestureRecognizerToFail:_doubleTapGesture];
        }
    }
    else
    {
        // 移除pinch手势
        [self removeGestureRecognizer:_pinchGesture];
        _pinchGesture = nil;
        [self removeGestureRecognizer:_doubleTapGesture];
        _doubleTapGesture = nil;
    }
    
}

- (void)onPinchClose:(UIPinchGestureRecognizer *)gesture
{
    if (gesture.state == UIGestureRecognizerStateChanged)
    {
        CGFloat scale = 1.0 - (_lastScale - [gesture scale]);
        
        if (scale < 0.8)
        {
            [_playerView changeToFullScreen:NO];
            [self onPinchClose];
        }
    }
}

- (void)onDoubleClose:(UITapGestureRecognizer *)tap
{
    if (tap.state == UIGestureRecognizerStateEnded)
    {
        [_playerView changeToFullScreen:NO];
        [self onDoubleClick];
        
    }
}


//- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
//{
//    if (_progessGesture == gestureRecognizer)
//    {
//        CGPoint startPoint = [touch locationInView:self];
//        CGRect rect = self.bounds;
//        CGRect rightRect = CGRectMake(rect.size.width * 0.9, 0, rect.size.width * 0.1, rect.size.height);
//        DebugLog(@"startpoint = %@ ctrlRect = %@  rightRect = %@", NSStringFromCGPoint(startPoint), NSStringFromCGRect(rect), NSStringFromCGRect(rightRect));
//        if (CGRectContainsPoint(rightRect, startPoint))
//        {
//            return NO;
//        }
//    }
//    
//    return YES;
//}

- (void)playViewPanGestureAction:(UIPanGestureRecognizer *)panGesture
{
    switch (panGesture.state)
    {
        case UIGestureRecognizerStateBegan:
        {
            _startPnt = [panGesture translationInView:self];
            _isLeft = [panGesture locationInView:self].x < CGRectGetMidX(self.bounds);
            
            _oldLumina = self.luminance;
            
            MPMusicPlayerController *mpc = [MPMusicPlayerController applicationMusicPlayer];
            //mpc.volume = 0;  //0.0~1.0
            
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated"
            _oldVolume = mpc.volume;
#pragma clang diagnostic pop
            
            _oldTime = [_playerView currentTime];
        }
            break;
        case UIGestureRecognizerStateChanged:
        {
            CGPoint curPnt = [panGesture translationInView:self];
            if (GestureOperateType_Unknow == _opType)
            {
                //检测_opType
                if (ABS(curPnt.x - _startPnt.x) > ABS(curPnt.y - _startPnt.y))
                {
                    _opType = GestureOperateType_Progress;
                }
                else
                {
                    //根据触发位置来决定（左边亮度，右边音量）
                    if (_isLeft)
                    {
                        _opType = GestureOperateType_Lumina;
                    }
                    else
                    {
                        _opType = GestureOperateType_Volume;
                    }
                }
            }
            [self dealWithOpType:_opType startPnt:_startPnt endPnt:curPnt];
        }
            break;
        case UIGestureRecognizerStateEnded:
        {
            if (GestureOperateType_Progress == _opType)
            {
                _timeLabel.hidden = YES;
                [_playerView seekToTime:_seekTime completion:nil];
                // 设置成0连续拖动时，会跳到起怒火位置播放
                // _seekTime = 0;
                _oldTime = 0;
            }
            _opType = GestureOperateType_Unknow;
        }
            break;
        case UIGestureRecognizerStateCancelled:
        {
            _opType = GestureOperateType_Unknow;
            _timeLabel.hidden = YES;
        }
            break;
        default:
        {
            _opType = GestureOperateType_Unknow;
        }
            break;
    }
}

- (BOOL)dealWithOpType:(GestureOperateType)opType startPnt:(CGPoint)start endPnt:(CGPoint)end
{
    if (opType == GestureOperateType_Progress)
    {
        CGFloat uint = (end.x - start.y) / _unitPixel;
        if (ABS(uint) < 1)
        {
            return NO;
        }
        [self updateTimeLabel:uint];
    }
    else
    {
        CGFloat uint = (end.y - start.y) / _unitPixel;
        if (ABS(uint) < 1)
        {
            return NO;
        }
        if (opType == GestureOperateType_Lumina)
        {
            [self changeLumina:-uint];
        }
        else
        {
            [self changeVolume:-uint];
        }
    }
    return NO;
}

#pragma mark - 播放控制 -
- (void)setLuminance:(CGFloat)luminance
{
    if (luminance < _minLumina)
    {
        luminance = _minLumina;
    }
    else if (luminance > 1)
    {
        luminance = 1;
    }
    _luminaView.alpha = (1 - luminance);
}

- (CGFloat)luminance
{
    return 1 - _luminaView.alpha;
}

- (void)changeLumina:(NSInteger)change
{
    self.luminance = _oldLumina + change * _luminaStep;
}

- (void)changeVolume:(NSInteger)change
{
    MPMusicPlayerController *mpc = [MPMusicPlayerController applicationMusicPlayer];
    
    float newVolume = _oldVolume + change * _volumeStep;
    if (newVolume > 1)
    {
        newVolume = 1;
    }
    else if (newVolume < 0)
    {
        newVolume = 0;
    }
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated"
    mpc.volume = newVolume;
#pragma clang diagnostic pop
}

//===================================

- (void)reset
{
    // do nothing
}

- (void)updateOnWillBuffering
{
    [_indicatorView startAnimating];
}

- (void)updateOnBufferingWhenPlayed
{
    [_indicatorView startAnimating];
}

- (void)updateOnWillPlay
{
    [_indicatorView stopAnimating];
}

- (void)updateOnPlayerFailed:(TCPlayerErrorType)type
{
    [_indicatorView stopAnimating];
}

- (void)updateOnStateChanged:(TCPlayerState)state
{
    if (state == TCPlayerState_Play && _indicatorView.isAnimating)
    {
        [_indicatorView stopAnimating];
    }
    else if (state == TCPlayerState_Stop)
    {
        [_indicatorView stopAnimating];
    }
}

- (void)layoutWithRecommendRect:(CGRect)rect
{
    self.frame = rect;
    
    _luminaView.frame = self.bounds;
    _indicatorView.center = self.center;
    _timeLabel.center = CGPointMake(self.bounds.size.width/2.0, 50);
}

- (void)updateTimeLabel:(NSInteger)change
{
    if (_playerView.isBuffering)
    {
        return;
    }
    
    _timeLabel.hidden = NO;

    NSString *timeString = nil;
    NSInteger time = _oldTime + change;
    
    if (time < 0)
    {
        time = 0;
    }
    else if (time > [_playerView duration])
    {
        time = [_playerView duration];
    }
    
    if (time == 0)
    {
    
    }
    _seekTime = time;
    
    timeString = [NSString stringWithFormat:@"%02zd:%02zd:%02zd", time / 3600, time %3600 /60, time % 60];
    _timeLabel.text = timeString;
    [_timeLabel sizeToFit];
}


// 修改明暗度一次调节值，默认为0.05
// @param value (0, 1)
- (void)changeLuminaStep:(CGFloat)value
{
    if (value > 0 && value < 1)
    {
        _luminaStep = value;
    }
}

// 修改音量一次调节值，默认为0.05
// @param value (0, 1)
- (void)changeVolumeStep:(CGFloat)value
{
    if (value > 0 && value < 1)
    {
        _volumeStep = value;
    }
}

// 修改进度一次调节值，默认为1
// @param value > 0
- (void)changeTimeStep:(CGFloat)value
{
    if (value > 0)
    {
        _timeStep = value;
    }
}

// 单次调节明暗度，音量，进度需要滑动的距（单位像素），默认(5 * [UIScreen mainScreen].scale)
// @param value > 0
- (void)changeUnitPixel:(CGFloat)value
{
    if (_unitPixel > 0)
    {
        _unitPixel = value;
    }
}

// 明暗度最小值，默认最小为0.1
// @param value (0, 1)
- (void)changeMinLumina:(CGFloat)value
{
    if (value > 0 && value < 1)
    {
        _minLumina = value;
    }
}

@end