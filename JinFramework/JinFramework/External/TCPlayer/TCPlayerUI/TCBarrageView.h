//
//  TCBarrageView.h
//  TCPlayerDemo
//
//  Created by  on 15/10/26.
//  Copyright © 2015年 . All rights reserved.
//

#import <UIKit/UIKit.h>
#import <TCPlayerSDK/TCPlayerSDK.h>


@interface TCBarrageItem : NSObject

@property (nonatomic, copy) NSString *text;      // 显示内容
@property (nonatomic, assign) CGFloat showDelay; // 显示延时时间，为0立即显示
@property (nonatomic, assign) CGFloat showTime;  // 界面上显示的时间

@end

@interface TCBarrageItemView : UIView
{
    @private
    UILabel *_barrageLabel;
}

@property (nonatomic, readonly) TCBarrageItem *item;

- (instancetype)initWith:(TCBarrageItem *)item;

@end

@interface TCBarrageView : UIView<TCMaskAbleView>

@property (nonatomic, weak) UIView<TCPlayerAbleView, TCPlayerEngine> *playerView;

// 添加到相应的控件后，由对应控件调用
@property (nonatomic, copy) TCMaskViewAnimationAction showAnimation;

@property (nonatomic, copy) TCMaskViewAnimationAction removeAnimation;

@property (nonatomic, strong) UIView *backgroundView;

@property (nonatomic, strong) UIView *contentView;

@property (nonatomic, strong) NSMutableArray *itemsView;    // 待显示的弹幕

@property (nonatomic, strong) UIButton *closeButton;

- (void)showBarrage:(TCBarrageItem *)item;


@end
