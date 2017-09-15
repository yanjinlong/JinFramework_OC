//
//  TCPlayerActionHandler.h
//  TCPlayerDemo
//
//  Created by  on 15/10/26.
//  Copyright © 2015年 . All rights reserved.
//

#import <Foundation/Foundation.h>
#import <TCPlayerSDK/TCPlayerSDK.h>


@interface TCPlayerActionHandler : NSObject<TCPlayerViewActionAble>

// 准备播放回调, 对应TCPlayerEngineDelegate onWillPlay;
@property (nonatomic, copy) TCPlayerViewActionBlock         playbackReadyBlock;

// 开始播放（暂停后恢复也会回调）, 对应 TCPlayerEngineDelegate onStateChanged:TCPlayerState_Play
@property (nonatomic, copy) TCPlayerViewActionBlock         playbackBeginBlock;

// 播放失败回掉, 对应 TCPlayerEngineDelegate - (void)onPlayerFailed:(id<TCPlayerEngine>)player errorType:(TCPlayerErrorType)errType
@property (nonatomic, copy) TCPlayerViewPlayFailedBlock     playbackFailedBlock;

// 播放结束, 对应 TCPlayerEngineDelegate  - (void)onPlayOver:(id<TCPlayerEngine>)player;
@property (nonatomic, copy) TCPlayerViewActionBlock         playbackEndBlock;

// 播放暂停回调, 对应 TCPlayerEngineDelegate onStateChanged:TCPlayerState_Paused 或 TCPlayerState_PauseByLimitTime， 具体状态查询state方法
@property (nonatomic, copy) TCPlayerViewActionBlock         playbackPauseBlock;

// 点击界面 bottomView 是否是隐藏
@property (nonatomic, copy) TCPlayerViewClickActionBlock    clickPlaybackViewblock;

// 点击界面 bottomView 是否是隐藏
@property (nonatomic, copy) TCPlayerViewActionBlock         showHideBottomViewblock;

// 全屏回调, isFullScreen查询是否全屏
@property (nonatomic, copy) TCPlayerViewActionBlock         enterExitFullScreenBlock;

// 缓冲提示
@property (nonatomic, copy) TCPlayerViewActionBlock         bufferingPlayBlock;

// 网络变化提示
@property (nonatomic, copy) TCPlayerNetworkBlock            networkStateBlock;

@end

