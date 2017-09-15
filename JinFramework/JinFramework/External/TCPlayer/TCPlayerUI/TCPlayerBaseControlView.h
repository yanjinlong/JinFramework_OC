//
//  TCPlayerBaseControlView.h
//  TCPlayer
//
//  Created by  on 15/8/13.
//  Copyright (c) 2015年 . All rights reserved.
//

#import <UIKit/UIKit.h>
#import <TCPlayerSDK/TCPlayerSDK.h>


/*
 * 功能介绍：
 * 1. 支持左半边上下滑动，调节明暗度
 * 2. 支持右半边上下滑动，调节音量
 * 3. 在屏幕上水平滑动，微调进度
 * 4. 全屏时，捏合或双击退出全屏
 */

@interface TCPlayerBaseControlView : UIControl<TCPlayerSubAbleView>
{
@protected
    UIPanGestureRecognizer      *_progessGesture;   // 微调手势
    UITapGestureRecognizer      *_tapGesture;       // 单击手势
    UITapGestureRecognizer      *_doubleTapGesture; // 双击手势
    UIPinchGestureRecognizer    *_pinchGesture;     // 捏合手势
}

@property (nonatomic, weak) UIView<TCPlayerAbleView, TCPlayerEngine> *playerView;

// 修改明暗度一次调节值，默认为0.05
// @param value (0, 1)
- (void)changeLuminaStep:(CGFloat)value;

// 修改音量一次调节值，默认为0.05
// @param value (0, 1)
- (void)changeVolumeStep:(CGFloat)value;

// 修改进度一次调节值，默认为1
// @param value > 0
- (void)changeTimeStep:(CGFloat)value;

// 单次调节明暗度，音量，进度需要滑动的距（单位像素），默认(5 * [UIScreen mainScreen].scale)
// @param value > 0
- (void)changeUnitPixel:(CGFloat)value;

// 明暗度最小值，默认最小为0.1
/// @param value (0, 1)
- (void)changeMinLumina:(CGFloat)value;

// 单击
- (void)onSingleClick;

// 双击
- (void)onDoubleClick;

// 捏合
- (void)onPinchClose;

@end
