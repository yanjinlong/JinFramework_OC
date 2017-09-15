//
//  TCPlayerSlider.h
//  TCPlayerSDK
//
//  Created by mysong on 15/6/6.
//  Copyright (c) 2015年 tencent. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TCPlayerSlider : UIControl
@property(nonatomic) CGFloat value;                                 // default 0.0. this value will be pinned to min/max
@property(nonatomic) CGFloat minimumValue;                          // default 0.0. the current value may change if outside new min value
@property(nonatomic) CGFloat maximumValue;                          // default 1.0. the current value may change if outside new max value

@property(nonatomic) CGFloat limitValue;

@property(nonatomic) CGFloat loadValue;

@property(nonatomic, retain) UIImage *minimumValueImage;          // default is nil. image that appears to left of control (e.g. speaker off)
@property(nonatomic, retain) UIImage *maximumValueImage;          // default is nil. image that appears to right of control (e.g. speaker max)

@property(nonatomic, getter = isContinuous) BOOL continuous;        // if set, value change events are generated any time the value changes due to dragging. default = YES

@property(nonatomic, retain) UIColor *minimumTrackTintColor NS_AVAILABLE_IOS(5_0) UI_APPEARANCE_SELECTOR;
@property(nonatomic, retain) UIColor *maximumTrackTintColor NS_AVAILABLE_IOS(5_0) UI_APPEARANCE_SELECTOR;
@property(nonatomic, retain) UIColor *loadTrackTintColor NS_AVAILABLE_IOS(5_0) UI_APPEARANCE_SELECTOR;
@property(nonatomic, retain) UIColor *thumbTintColor NS_AVAILABLE_IOS(5_0) UI_APPEARANCE_SELECTOR;

- (void)setValue:(CGFloat)value animated:(BOOL)animated; // move slider at fixed velocity (i.e. duration depends on distance). does not send action

// set the images for the slider. there are 3, the thumb which is centered by default and the track. You can specify different left and right track
// e.g blue on the left as you increase and white to the right of the thumb. The track images should be 3 part resizable (via UIImage's resizableImage methods) along the direction that is longer

//- (void)setThumbImage:(UIImage *)image forState:(UIControlState)state;
//- (void)setMinimumTrackImage:(UIImage *)image forState:(UIControlState)state;
//- (void)setMaximumTrackImage:(UIImage *)image forState:(UIControlState)state;

- (BOOL)isInLimitState;

@end
