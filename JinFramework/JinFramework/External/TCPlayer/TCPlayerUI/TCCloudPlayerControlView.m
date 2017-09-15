//
//  TCCloudPlayerControlView.m
//  TCPlayerDemo
//
//  Created by  on 15/9/25.
//  Copyright © 2015年 . All rights reserved.
//

#import "TCCloudPlayerControlView.h"



#import "TCPlayerVideoTypeView.h"



@implementation TCCloudPlayerControlView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.enableSwipeLeft = YES;
    }
    
    return self;
}

- (void)onSwipeLeft
{
    if (![self.playerView isBuffering])
    {
        TCPlayerVideoTypeView *mask = [[TCPlayerVideoTypeView alloc] init];
        [self.playerView showMask:mask];
    }
}

- (void)setEnableSwipeLeft:(BOOL)enableSwipeLeft
{
    _enableSwipeLeft = enableSwipeLeft;
    
    if (_enableSwipeLeft)
    {
        if (!_swipeLeftGesture)
        {
            [self  addSwiftLeftGesture];
        }
    }
    else
    {
        [self removeGestureRecognizer:_swipeLeftGesture];
    }
}

- (void)onSwipeLeft:(UISwipeGestureRecognizer *)ges
{
    if (ges.state == UIGestureRecognizerStateEnded)
    {
        [self onSwipeLeft];
    }
}

- (void)addSwiftLeftGesture
{
    if (_enableSwipeLeft)
    {
        _swipeLeftGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(onSwipeLeft:)];
        _swipeLeftGesture.direction = UISwipeGestureRecognizerDirectionLeft;
        [self addGestureRecognizer:_swipeLeftGesture];
        [_swipeLeftGesture requireGestureRecognizerToFail:_progessGesture];
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if (_progessGesture == gestureRecognizer)
    {
        CGPoint startPoint = [touch locationInView:self];
        CGRect rect = self.bounds;
        CGRect rightRect = CGRectMake(rect.size.width * 0.9, 0, rect.size.width * 0.1, rect.size.height);
        if (CGRectContainsPoint(rightRect, startPoint))
        {
            return NO;
        }
    }
    return YES;
}


@end