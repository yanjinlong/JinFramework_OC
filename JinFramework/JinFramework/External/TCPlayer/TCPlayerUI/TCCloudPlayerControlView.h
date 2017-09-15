//
//  TCCloudPlayerControlView.h
//  TCPlayerDemo
//
//  Created by  on 15/9/25.
//  Copyright © 2015年 . All rights reserved.
//

#import "TCPlayerBaseControlView.h"

// 在屏幕最右端(0.9 - 1)处向左滑时，出现视频显示界面

// 主要功能 在播放器控制界面上临时显示用户自定义控件

@interface TCCloudPlayerControlView : TCPlayerBaseControlView
{
@protected
    UISwipeGestureRecognizer *_swipeLeftGesture;
}

// 默认为YES
@property (nonatomic, assign) BOOL enableSwipeLeft;


@end
