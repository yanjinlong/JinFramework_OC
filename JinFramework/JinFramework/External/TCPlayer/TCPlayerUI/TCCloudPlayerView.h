//
//  TCCloudPlayerView.h
//  TCPlayerDemo
//
//  Created by  on 15/9/25.
//  Copyright © 2015年 . All rights reserved.
//

#import <TCPlayerSDK/TCPlayerSDK.h>

typedef NS_ENUM(int, TCCloudPlayerMaskLocation)
{
    ETCCloudPlayerMaskLocation_Front,      // 最顶层, bottomView前面
    ETCCloudPlayerMaskLocation_Back,       // 最底层, ctrlView前面
    ETCCloudPlayerMaskLocation_Middle,     // bottomView与ctrkView之间
};

@interface TCCloudPlayerView : TCPlayerView

/*
 - (void)showMask:(UIView<TCMaskAbleView> *)mask
 默认添加到最上层ETCCloudPlayerMaskLocation_Front
*/
- (void)showMask:(UIView<TCMaskAbleView> *)mask at:(TCCloudPlayerMaskLocation)loc;

@end
