//
//  TCPlayerVideoTypeView.h
//  TCPlayer
//
//  Created by  on 15/8/13.
//  Copyright (c) 2015年 . All rights reserved.
//

#import <UIKit/UIKit.h>
#import <TCPlayerSDK/TCPlayerSDK.h>

@interface TCPlayerVideoTypeView : UIView<TCMaskAbleView, UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate>
{
@private
    UIView *_tableContentView;
    UITableView *_tableView;
    NSArray *_videos;
    id<TCCanPlayAble> _selectedItem;
}
// show 之后自动设置，不需要手动设置
@property (nonatomic, weak) UIView<TCPlayerAbleView, TCPlayerEngine> *playerView;

// 添加到相应的控件后，由对应控件调用
@property (nonatomic, copy) TCMaskViewAnimationAction showAnimation;

@property (nonatomic, copy) TCMaskViewAnimationAction removeAnimation;

@end
