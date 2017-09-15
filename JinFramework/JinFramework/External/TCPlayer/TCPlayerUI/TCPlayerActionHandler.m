//
//  TCPlayerActionHandler.m
//  TCPlayerDemo
//
//  Created by  on 15/10/26.
//  Copyright © 2015年 . All rights reserved.
//

#import "TCPlayerActionHandler.h"


@implementation TCPlayerActionHandler

- (void)dealloc
{
    _playbackReadyBlock = nil;
    _playbackBeginBlock = nil;
    _playbackFailedBlock = nil;
    _playbackEndBlock = nil;
    _playbackPauseBlock = nil;
    _clickPlaybackViewblock = nil;
    _enterExitFullScreenBlock = nil;
    _bufferingPlayBlock = nil;
    _networkStateBlock = nil;
}
@end