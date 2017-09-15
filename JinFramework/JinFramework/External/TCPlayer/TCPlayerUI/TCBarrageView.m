//
//  TCBarrageView.m
//  TCPlayerDemo
//
//  Created by  on 15/10/26.
//  Copyright © 2015年 . All rights reserved.
//

#import "TCBarrageView.h"

@implementation TCBarrageItem

- (instancetype)init
{
    if (self = [super init])
    {
        _showDelay = 2 + arc4random()%4;
        _showTime = 3 + arc4random()%5;
    }
    return self;
}


@end

@implementation TCBarrageItemView

- (void)dealloc
{
    
}

- (CGSize)textSizeIn:(CGSize)size
{
    NSLineBreakMode breakMode = _barrageLabel.lineBreakMode;
    UIFont *font = _barrageLabel.font;
    
    CGSize contentSize = CGSizeZero;
    //    if ([IOSDeviceConfig sharedConfig].isIOS7)
    //    {
    NSMutableParagraphStyle* paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = breakMode;
    paragraphStyle.alignment = _barrageLabel.textAlignment;
    
    NSDictionary* attributes = @{NSFontAttributeName:font,
                                 NSParagraphStyleAttributeName:paragraphStyle};
    contentSize = [_barrageLabel.text boundingRectWithSize:size options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading) attributes:attributes context:nil].size;
    //    }
    //    else
    //    {
    //        contentSize = [self.text sizeWithFont:font constrainedToSize:size lineBreakMode:breakMode];
    //    }
    
    
    contentSize = CGSizeMake((int)contentSize.width + 8, (int)contentSize.height + 8);
    return contentSize;
}

#define kRandomFlatColor [UIColor colorWithRed:(arc4random()%255)/255.f green:(arc4random()%255)/255.f blue:(arc4random()%255)/255.f alpha:1.f]

- (instancetype)initWith:(TCBarrageItem *)item
{
    if (self = [super initWithFrame:CGRectZero])
    {
        UIFont *font = [UIFont systemFontOfSize:(arc4random()%5 + 12)];
        UIColor *color = kRandomFlatColor;
        
        _barrageLabel = [[UILabel alloc] init];
        _barrageLabel.font = font;
        _barrageLabel.textColor = color;
        _barrageLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_barrageLabel];
        
        _barrageLabel.text = item.text;
        
        CGSize size = [self textSizeIn:CGSizeMake(HUGE_VAL, 30)];
        self.bounds = CGRectMake(0, 0, size.width, size.height);
        _barrageLabel.frame = self.bounds;
        
        self.layer.cornerRadius = 2;
        self.layer.borderWidth = 1;
        self.layer.borderColor = [UIColor blackColor].CGColor;
        
        self.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.3];
        
        _item = item;
    }
    return self;
}

@end



@implementation TCBarrageView


- (void)layoutWithRecommendRect:(CGRect)rect
{
    self.frame = rect;
    
    rect = self.bounds;
    
    _backgroundView.frame = rect;
    
    rect = _backgroundView.bounds;
    
    _contentView.frame = CGRectMake(0, 0, rect.size.width, rect.size.height * 2/3);
    
    _closeButton.frame = CGRectMake(rect.size.width - 40, 10, 30, 30);
}

- (void)reset
{    
    [_itemsView removeAllObjects];
}

- (void)reload
{
    
}

- (void)showBarrage:(TCBarrageItem *)item
{
    TCBarrageItemView *view = [[TCBarrageItemView alloc] initWith:item];
    if (item.showDelay == 0)
    {
        [self showBarrageView:view];
    }
    else
    {
        if (!_itemsView)
        {
            _itemsView = [NSMutableArray array];
        }
        [_itemsView addObject:view];
        
        [self performSelector:@selector(showBarrageViewAfterDelay:) withObject:view afterDelay:item.showDelay];
    }
    
}

- (void)showBarrageViewAfterDelay:(TCBarrageItemView *)view
{
    [_itemsView removeObject:view];
    [self showBarrageView:view];
}
- (void)showBarrageView:(TCBarrageItemView *)view
{
    CGRect contentRect = _contentView.bounds;
    
    view.frame = CGRectMake(contentRect.origin.x + contentRect.size.width, arc4random()%((NSInteger)(contentRect.size.height - view.bounds.size.height)), view.bounds.size.width, view.bounds.size.height);
//    view.frame = CGRectMake(100, 30, view.bounds.size.width, view.bounds.size.height);
    
    [_contentView addSubview:view];
    [UIView animateWithDuration:view.item.showTime animations:^{
        [UIView setAnimationCurve:UIViewAnimationCurveLinear];
        view.frame = CGRectMake( - view.bounds.size.width, view.frame.origin.y, view.bounds.size.width, view.bounds.size.height);
    } completion:^(BOOL finished) {
        [view removeFromSuperview];
    }];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        _backgroundView = [[UIView alloc] init];
        [self addSubview:_backgroundView];
        
        _contentView = [[UIView alloc] init];
//        _contentView.backgroundColor = [UIColor lightGrayColor];
        _contentView.clipsToBounds = YES;
        [_backgroundView addSubview:_contentView];
        
        _closeButton = [UIButton buttonWithType:UIButtonTypeContactAdd];
        [_closeButton addTarget:self action:@selector(onClickClose) forControlEvents:UIControlEventTouchUpInside];
        [_backgroundView addSubview:_closeButton];
        
        
        
        self.showAnimation = ^(UIView<TCMaskAbleView> *maskViewSelf, UIView<TCPlayerSubAbleView> *inView, TCCompletionAction completion) {
            // 从顶部滑入
            TCBarrageView *mask = (TCBarrageView *)maskViewSelf;
            
            CGRect rect = mask.contentView.frame;
            CGRect nrect = rect;
            nrect.origin.y = -rect.size.height;
            mask.contentView.frame = nrect;
            
            mask.closeButton.hidden = YES;
            
            [UIView animateWithDuration:0.3 animations:^{
                mask.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.1];
                mask.contentView.frame = rect;
                
            } completion:^(BOOL finished) {
                mask.closeButton.hidden = NO;
                if (completion)
                {
                    completion();
                }
            }];
        };
        
        self.removeAnimation = ^(UIView<TCMaskAbleView> *maskViewSelf, UIView<TCPlayerSubAbleView> *inView, TCCompletionAction completion) {
            // 从顶部滑出
            TCBarrageView *mask = (TCBarrageView *)maskViewSelf;
            [UIView animateWithDuration:0.3 animations:^{
                mask.closeButton.hidden = YES;
                CGRect rect = mask.contentView.frame;
                CGRect nrect = rect;
                nrect.origin.y = -rect.size.height;
                mask.contentView.frame = nrect;
                
                mask.backgroundColor = [UIColor clearColor];
                
            } completion:^(BOOL finished) {
                if (completion)
                {
                    completion();
                }
            }];

        };
    }
    return self;
}

- (void)onClickClose
{
    [self.playerView removeMask:self];
}

@end
