//
//  TCCloudPlayerView.m
//  TCPlayerDemo
//
//  Created by  on 15/9/25.
//  Copyright © 2015年 . All rights reserved.
//

#import "TCCloudPlayerView.h"

@implementation TCCloudPlayerView


- (void)showMask:(UIView<TCMaskAbleView> *)mask at:(TCCloudPlayerMaskLocation)loc
{
    if (mask)
    {
        if (mask.superview)
        {
            [mask removeFromSuperview];
        }
        
        if (!_maskViews)
        {
            _maskViews = [NSMutableArray array];
        }
        
        [self addSubview:mask];
        [_maskViews addObject:mask];
        mask.playerView = self;
        
        switch (loc)
        {
            case ETCCloudPlayerMaskLocation_Front:
                [self bringSubviewToFront:mask];
                break;
            case ETCCloudPlayerMaskLocation_Back:
                [self sendSubviewToBack:mask];
                break;
            case ETCCloudPlayerMaskLocation_Middle:
                if (self.bottomView)
                {
                    [self insertSubview:mask belowSubview:self.bottomView];
                }
            default:
                break;
        }
        
        [mask layoutWithRecommendRect:self.bounds];
        [mask reload];
        
        if ([mask respondsToSelector:@selector(showAnimation)])
        {
            TCMaskViewAnimationAction showAnimation = [mask showAnimation];
            if (showAnimation)
            {
                showAnimation(mask, self, nil);
            }
        }
    }
}

- (void)showMask:(UIView<TCMaskAbleView> *)mask
{
    [self showMask:mask at:ETCCloudPlayerMaskLocation_Front];
}

@end
