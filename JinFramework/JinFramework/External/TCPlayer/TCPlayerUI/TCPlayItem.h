//
//  TCPlayItem.h
//  TCPlayer
//
//  Created by  on 15/8/13.
//  Copyright (c) 2015年 . All rights reserved.
//

#import <Foundation/Foundation.h>
#import <TCPlayerSDK/TCPlayerSDK.h>


@interface TCPlayItem : NSObject<TCCanPlayAble>

@property (nonatomic, copy) NSString *type;                // 视频对应的类型描述，显示两个字(比如：高清,普通，流畅，源片等)
@property (nonatomic, copy) NSString *url;                 // 视频地址
@property (nonatomic, copy) NSString *fileID;              // 视频ID
@property (nonatomic, assign) NSUInteger startSeconds;     // 开始播放的时间
@property (nonatomic, assign) NSUInteger limitSeconds;     // 限制播放的时间
@property (nonatomic, assign) NSUInteger duration;         // 视频时长, 以播放器解析到的时间为主


@end

@interface TCPlayResItem : NSObject<TCPlayResAbleItem
/*, TCCanPlayAble*/
>

@property (nonatomic, copy) NSString *name;                // 视频标题
@property (nonatomic, strong) NSMutableArray *items;       // 同一视频，不同的TCCanPlayAble资源

//@property (nonatomic, assign) NSInteger playingIndex;      // 当前播放资源的Index

@end
