//
//  TCPlayItem.m
//  TCPlayer
//
//  Created by  on 15/8/13.
//  Copyright (c) 2015年 . All rights reserved.
//

#import "TCPlayItem.h"

@implementation TCPlayItem

@end


@implementation TCPlayResItem


- (instancetype)init
{
    if (self = [super init])
    {
        _items = [NSMutableArray array];
    }
    return self;
}


//- (id<TCCanPlayAble>)playingItem
//{
//    id<TCCanPlayAble> item = nil;
//    if (_playingIndex >= 0 && _playingIndex < _items.count)
//    {
//        item = _items[_playingIndex];
//        
//    }
//    return item;
//}
//
//- (NSUInteger)limitSeconds
//{
//    id<TCCanPlayAble> item = [self playingItem];
//    
//    if ([item respondsToSelector:@selector(limitSeconds)])
//    {
//        return [item limitSeconds];
//    }
//    return 0;
//}
//
//- (NSString *)url
//{
//    id<TCCanPlayAble> item = [self playingItem];
//    return [item url];
//}
//
//- (void)setUrl:(NSString *)url
//{
//    // do nothing
//    id<TCCanPlayAble> item = [self playingItem];
//    [item setUrl:url];
//}
//
//
//
//
////@property (nonatomic, copy) NSString *type;                // 视频对应的类型描述，显示两个字(比如：高清,普通，流畅，源片等)
//- (NSString *)type
//{
//    return [(TCPlayItem *)[self playingItem] type];
//}
//
//- (void)setType:(NSString *)type
//{
//    return [(TCPlayItem *)[self playingItem] setType:type];
//}
////@property (nonatomic, copy) NSString *url;                 // 视频地址
////@property (nonatomic, copy) NSString *fileID;              // 视频ID
//- (NSString *)fileID
//{
//    return [(TCPlayItem *)[self playingItem] fileID];
//}
//
//- (void)setFileID:(NSString *)fileID
//{
//    return [(TCPlayItem *)[self playingItem] setFileID:fileID];
//}
////@property (nonatomic, assign) NSUInteger startSeconds;     // 开始播放的时间
//
//- (NSUInteger)startSeconds
//{
//    return [(TCPlayItem *)[self playingItem] startSeconds];
//}
//
//- (void)setStartSeconds:(NSUInteger)startSeconds
//{
//    return [(TCPlayItem *)[self playingItem] setStartSeconds:startSeconds];
//}
//
////@property (nonatomic, assign) NSUInteger limitSeconds;     // 限制播放的时间
//
//- (void)setLimitSeconds:(NSUInteger)limitSeconds
//{
//    return [(TCPlayItem *)[self playingItem] setLimitSeconds:limitSeconds];
//}
//
////@property (nonatomic, assign) NSUInteger duration;         // 视频时长, 以播放器解析到的时间为主
//
//- (NSUInteger)duration
//{
//    return [(TCPlayItem *)[self playingItem] duration];
//}
//
//- (void)setDuration:(NSUInteger)duration
//{
//    return [(TCPlayItem *)[self playingItem] setDuration:duration];
//}

@end