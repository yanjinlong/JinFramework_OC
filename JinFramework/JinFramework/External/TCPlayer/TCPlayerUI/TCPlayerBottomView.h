//
//  TCPlayerBottomView.h
//  TCPlayer
//
//  Created by  on 15/8/13.
//  Copyright (c) 2015年 . All rights reserved.
//

#import <UIKit/UIKit.h>
#import <TCPlayerSDK/TCPlayerSDK.h>




@class TCPlayerSlider;

@interface TCPlayerBottomView : UIView<TCPlayerSubAbleView>
{
@protected

    UIButton            *_playPauseButton;
    UILabel             *_curPlayTimeLabel;
    TCPlayerSlider      *_movieTimeControl;
    UILabel             *_durationTimeLabel;
//    UIButton            *_videoTypeSelButn;
    UIButton            *_fullScreenButton;
    
@private
    __weak UIView<TCPlayerAbleView, TCPlayerEngine> *_playerView;
}

@property (nonatomic, weak) UIView<TCPlayerAbleView, TCPlayerEngine> *playerView;

- (Float32)movieTimeControlValue;
- (void)setCurPlayTime:(Float64)fPlaySeconds;

@end
