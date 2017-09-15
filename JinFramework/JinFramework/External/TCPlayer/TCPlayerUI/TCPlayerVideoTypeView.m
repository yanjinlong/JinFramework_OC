//
//  TCPlayerVideoTypeView.m
//  TCPlayer
//
//  Created by  on 15/8/13.
//  Copyright (c) 2015年 . All rights reserved.
//

#import "TCPlayerVideoTypeView.h"
#import <TCPlayerSDK/TCPlayerSDK.h>
#import "TCPlayItem.h"


@interface TCPlayerVideoTypeView ()

@property (nonatomic, strong) UIView *tableContentView;

@end

@implementation TCPlayerVideoTypeView

- (void)dealloc
{
    
}


#define TC_VIDEO_TYPE_VIEW_CELL_HTIGHT (50)
#define BACKGROUNDCOLOR ([UIColor colorWithRed:0 green:0 blue:0 alpha:0.8])

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.2];
        
        _tableContentView = [[UIView alloc] init];
        _tableContentView.backgroundColor = BACKGROUNDCOLOR;
        [self addSubview:_tableContentView];
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.backgroundColor = BACKGROUNDCOLOR;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        [_tableContentView addSubview:_tableView];
        
        
        self.showAnimation = ^(UIView<TCMaskAbleView> *maskViewSelf, UIView<TCPlayerSubAbleView> *inView, TCCompletionAction completion) {
            
            TCPlayerVideoTypeView *mask = (TCPlayerVideoTypeView *)maskViewSelf;
            mask.tableContentView.hidden = YES;
            mask.alpha = 0;
            
            [UIView animateWithDuration:0.25 animations:^{
                mask.alpha = 1;
            } completion:^(BOOL finished) {
                mask.tableContentView.hidden = NO;
                CGRect rect = mask.tableContentView.frame;
                rect.origin.x += rect.size.width;
                mask.tableContentView.frame = rect;
                
                [UIView animateWithDuration:0.25 animations:^{
                    CGRect rect = mask.tableContentView.frame;
                    rect.origin.x -= rect.size.width;
                    mask.tableContentView.frame = rect;
                } completion:^(BOOL finished) {
                    
                    if (completion)
                    {
                        completion();
                    }
                }];
            }];
            
        };
        
        self.removeAnimation = ^(UIView<TCMaskAbleView> *maskViewSelf, UIView<TCPlayerSubAbleView> *inView, TCCompletionAction completion) {
            
            
            TCPlayerVideoTypeView *mask = (TCPlayerVideoTypeView *)maskViewSelf;
            
            [UIView animateWithDuration:0.25 animations:^{
                CGRect rect = mask.tableContentView.frame;
                rect.origin.x += rect.size.width;
                mask.tableContentView.frame = rect;
            } completion:^(BOOL finished) {
                
                [UIView animateWithDuration:0.25 animations:^{
                    mask.alpha = 0;
                } completion:^(BOOL finished) {
                    if (completion)
                    {
                        completion();
                    }
                }];
            }];
        };
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]  initWithTarget:self action:@selector(onTap:)];
        tap.delegate = self;
        tap.numberOfTapsRequired = 1;
        tap.numberOfTouchesRequired = 1;
        [self addGestureRecognizer:tap];
    }
    
    return self;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    CGPoint p = [touch locationInView:self];
    if (CGRectContainsPoint(_tableContentView.frame, p))
    {
        return NO;
    }
    return YES;
}

- (void)onTap:(UITapGestureRecognizer *)ges
{
    if (ges.state == UIGestureRecognizerStateEnded)
    {
        [_playerView removeMask:self];
    }
}
- (void)reset
{
    [self reload];
}

- (void)reload
{
    TCPlayerView *view = (TCPlayerView *)self.playerView;
    id<TCPlayResAbleItem> res = [view videoResItem];
    id<TCCanPlayAble> playingItem = [view playingItem];
    
    
    if (res != nil || playingItem != nil) {
        if (res && [res items].count)
        {
            _videos = [res items];
        }
        else
        {
            if (playingItem)
            {
                _videos = [NSArray arrayWithObject:playingItem];
            }
        }
        
        _selectedItem = playingItem;
    }
    [self layoutSubviews];
    [_tableView reloadData];
}

- (void)layoutWithRecommendRect:(CGRect)rect
{
    self.frame = rect;
}

- (void)layoutSubviews
{
    CGSize viewSize = self.bounds.size;
    
    _tableContentView.frame = CGRectMake(viewSize.width - 100, 0, 100, viewSize.height);
    
    CGFloat tableViewHeight = _videos.count * TC_VIDEO_TYPE_VIEW_CELL_HTIGHT;
    
    viewSize = _tableContentView.bounds.size;
    _tableView.frame = CGRectMake(0, viewSize.height / 2 - tableViewHeight / 2, viewSize.width, tableViewHeight);
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return TC_VIDEO_TYPE_VIEW_CELL_HTIGHT;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellID"];
    
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellID"];
        cell.backgroundColor = BACKGROUNDCOLOR;
        cell.textLabel.font = [UIFont systemFontOfSize:20];
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    }
    
    TCPlayItem *info = [_videos objectAtIndex:indexPath.row];
    cell.textLabel.text = [info type];
    
    if (info == _selectedItem)
    {
        cell.textLabel.textColor = [UIColor colorWithRed:19/255.0 green:85/255.0 blue:203/255.0 alpha:1];
    }
    else
    {
        cell.textLabel.textColor = [UIColor whiteColor];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    id<TCCanPlayAble> info = [_videos objectAtIndex:indexPath.row];
    
    if (info != _selectedItem)
    {
        [_playerView play:info from:_playerView.currentTime];
    }
    
    [_playerView removeMask:self];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _videos.count;
}
@end
