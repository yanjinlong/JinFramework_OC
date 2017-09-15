//
//  TCPlayerSlider.m
//  TCPlayerSDK
//
//  Created by mysong on 15/6/6.
//  Copyright (c) 2015年 tencent. All rights reserved.
//

#define PROGRESS_HEIGHT 1.0
#define THUMB_IMAGE_HEIGHT 24.0

#import "TCPlayerSlider.h"

static UIImage *ImageWithColor(UIColor *color, CGSize size)
{
    UIImage *img = nil;
    
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, rect);
    img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return img;
}

@interface TCPlayerSlider()
{
    CALayer *_minimumTrackLayer;
    CALayer *_maximumTrackLayer;
    CALayer *_loadTrackLayer;
    
    UIImageView *_thumbView;
    
    CGPoint     _preMovePoint;
    
    
    BOOL _isActionFromTouch;
}
@end

@implementation TCPlayerSlider

- (void)sendAction:(SEL)action to:(id)target forEvent:(UIEvent *)event
{
    if (_isActionFromTouch)
    {
        [super sendAction:action to:target forEvent:event];
    }
}

- (id)initWithFrame:(CGRect)frame
{
    frame.size.height = 34;
    if (frame.size.width < 100)
    {
        frame.size.width = 100;
    }
    
    self = [super initWithFrame:frame];
    if (self)
    {
        [self loadView];
    }
    return self;
}

- (void)loadView
{
    _minimumValue = 0;
    _maximumValue = 1.0;
    
    _thumbTintColor = [UIColor whiteColor];
    _minimumTrackTintColor = [UIColor blueColor];
    _maximumTrackTintColor = [UIColor lightGrayColor];
    
    _minimumTrackLayer = [[CALayer alloc] init];
    _minimumTrackLayer.backgroundColor = _minimumTrackTintColor.CGColor;
    
    _loadTrackLayer = [[CALayer alloc] init];
    _loadTrackLayer.backgroundColor = _loadTrackTintColor.CGColor;
    
    _maximumTrackLayer = [[CALayer alloc] init];
    _maximumTrackLayer.backgroundColor = _maximumTrackTintColor.CGColor;
    
    [self.layer addSublayer:_maximumTrackLayer];
    [self.layer addSublayer:_loadTrackLayer];
    [self.layer addSublayer:_minimumTrackLayer];
    
    _thumbView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, THUMB_IMAGE_HEIGHT, THUMB_IMAGE_HEIGHT)];
    [self addSubview:_thumbView];
}

- (void)setBounds:(CGRect)bounds
{
    bounds.size.height = 34;
    [super setBounds:bounds];
}

- (void)setFrame:(CGRect)frame
{
    frame.size.height = 34;
    [super setFrame:frame];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGSize size = self.bounds.size;
    
    _maximumTrackLayer.frame = CGRectMake(0, (size.height-PROGRESS_HEIGHT)/2.0, size.width, PROGRESS_HEIGHT);
    
    CGFloat playWidth = 0;
    CGFloat loadWidth = 0;
    float total = _maximumValue - _minimumValue;
    
    if (total > 0)
    {
        playWidth = [self trackLength] * (_value - _minimumValue) / total;
        loadWidth = self.bounds.size.width * (_loadValue - _minimumValue) / total;
    }
    
    _minimumTrackLayer.frame = CGRectMake(0, (size.height - PROGRESS_HEIGHT)/2.0, playWidth, PROGRESS_HEIGHT);
    _loadTrackLayer.frame = CGRectMake(0, (size.height - PROGRESS_HEIGHT)/2.0, loadWidth, PROGRESS_HEIGHT);
    
    _thumbView.frame = CGRectMake(playWidth, (size.height - THUMB_IMAGE_HEIGHT)/2.0, THUMB_IMAGE_HEIGHT, THUMB_IMAGE_HEIGHT);
    if (!_thumbView.image)
    {
        _thumbView.image = ImageWithColor(_thumbTintColor, _thumbView.bounds.size);
        _thumbView.layer.cornerRadius = _thumbView.bounds.size.width/2.0;
        _thumbView.clipsToBounds = YES;
    }
}

- (void)setValue:(CGFloat)value
{
    [self setValue:value animated:NO];
}

- (void)setValue:(CGFloat)value animated:(BOOL)animated
{
    [self willChangeValueForKey:@"value"];
    CGSize size = self.bounds.size;
    
    if (value < _minimumValue)
    {
        value = _minimumValue;
    }
    
    CGFloat maxValue = 0;
    if (_limitValue > 0)
    {
        maxValue = MIN(_limitValue, _maximumValue);
    }
    else
    {
        maxValue = _maximumValue;
    }
    
    
    if (value > maxValue)
    {
        value = maxValue;
    }
    
    CGFloat playWidth = [self trackLength] * (value - _minimumValue);
    
    _minimumTrackLayer.bounds = CGRectMake(0, 0, playWidth, _minimumTrackLayer.bounds.size.height);
    
    _thumbView.center = CGPointMake(playWidth + _thumbView.bounds.size.width/2.0, size.height/2.0);
    
    if (animated) {
        
    }
    
    _value = value;
    [self didChangeValueForKey:@"value"];
}

- (void)setLoadValue:(CGFloat)loadValue
{
    _loadValue = loadValue;
    [self layoutIfNeeded];
}

- (CGFloat)trackLength
{
    return self.bounds.size.width - _thumbView.bounds.size.width;
}

- (CGRect)trackRect
{
    return CGRectMake(0, 0, self.bounds.size.width - _thumbView.bounds.size.width, self.bounds.size.height);
}

#pragma mark - 颜色 -
- (void)setMinimumTrackTintColor:(UIColor *)minimumTrackTintColor
{
    _minimumTrackTintColor = minimumTrackTintColor;
    _minimumTrackLayer.backgroundColor = minimumTrackTintColor.CGColor;
}

- (void)setMaximumTrackTintColor:(UIColor *)maximumTrackTintColor
{
    _maximumTrackTintColor = maximumTrackTintColor;
    _maximumTrackLayer.backgroundColor = maximumTrackTintColor.CGColor;
}

- (void)setLoadTrackTintColor:(UIColor *)loadTrackTintColor
{
    _loadTrackTintColor = loadTrackTintColor;
    _loadTrackLayer.backgroundColor = loadTrackTintColor.CGColor;
}

#pragma mark - 事件 -

- (void)sendActionsForControlEvents:(UIControlEvents)controlEvents
{
    _isActionFromTouch = YES;
    [super sendActionsForControlEvents:controlEvents];
    _isActionFromTouch = NO;
}

- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    CGPoint point = [touch locationInView:self];
    
    CGFloat width = self.bounds.size.height;
    CGRect thumbRect = CGRectMake(_thumbView.center.x - width/2.0, 0, width, width);
    BOOL begin = CGRectContainsPoint(thumbRect, point);
    if (begin)
    {
        _preMovePoint = point;
        [self sendActionsForControlEvents:UIControlEventTouchDown];
        
        return YES;
    }
    else
    {
        CGPoint point = [touch locationInView:self];
        CGFloat value = point.x / [self trackLength];
        if (_limitValue > 0 && value >= _limitValue)
        {
            return NO;
        }
        self.value =  value;
        
        [self sendActionsForControlEvents:UIControlEventTouchDown];
        if (self.isContinuous)
        {
            [self sendActionsForControlEvents:UIControlEventValueChanged];
        }
        [self sendActionsForControlEvents:UIControlEventTouchUpInside];
        
        return NO;
    }
}

- (BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    CGPoint point = [touch locationInView:self];
    self.value +=  (point.x - _preMovePoint.x) / [self trackLength];
    _preMovePoint = point;
    
    if (self.isContinuous)
    {
        [self sendActionsForControlEvents:UIControlEventValueChanged];
    }
    return YES;
}

- (void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    CGPoint point = [touch locationInView:self];
    BOOL inside = CGRectContainsPoint(self.bounds, point);
    [self sendActionsForControlEvents:inside ? UIControlEventTouchUpInside : UIControlEventTouchUpOutside];
}

- (void)cancelTrackingWithEvent:(UIEvent *)event
{
    [self sendActionsForControlEvents:UIControlEventTouchCancel];
}

#pragma mark - 接口 -
- (BOOL)isInLimitState
{
    return _limitValue > 0 && _value >= _limitValue;
}
@end
