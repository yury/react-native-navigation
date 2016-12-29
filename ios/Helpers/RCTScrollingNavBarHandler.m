//
//  RCTScrollingNavBarHandler.m
//  ReactNativeControllers
//
//  Created by Artal Druk on 14/07/2016.
//  Copyright © 2016 artal. All rights reserved.
//

#import "RCTScrollingNavBarHandler.h"
#import "RCTScrollView+Hooks.h"
#import "RCTHelpers.h"

@interface RCTScrollingNavBarHandler()
@property (nonatomic, strong) UIViewController *viewController;
@property (nonatomic, strong) RCTScrollView *rctScrollView;
@property (nonatomic) CGFloat statusBarHeight;
@property (nonatomic) CGFloat lastScrollViewYOffset;
@property (nonatomic) CGRect originalNavBarFrame;
@property (nonatomic) CGRect originalViewFrame;
@property (nonatomic, strong) NSArray *navbarSubViews;
@end

@implementation RCTScrollingNavBarHandler

-(instancetype)initWithViewController:(UIViewController*)viewController
{
    RCTScrollView *rctScrollView = [RCTHelpers getFirstScrollView:viewController.view];
    if(!rctScrollView)
    {
        return nil;
    }
    
    self = [super init];
    if (self)
    {
        if (viewController.navigationController.navigationBar != nil && !viewController.navigationController.navigationBar.hidden)
        {
            self.navbarSubViews = [self getAllNonBackgroundSubviewsForView:viewController.navigationController.navigationBar];
            
            self.statusBarHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
            self.viewController = viewController;
            self.originalNavBarFrame = self.viewController.navigationController.navigationBar.frame;
            self.originalViewFrame = self.viewController.view.frame;
            self.rctScrollView = rctScrollView;
            if (self.rctScrollView != nil)
            {
                self.lastScrollViewYOffset = self.rctScrollView.scrollView.contentOffset.y;
                
                [[NSNotificationCenter defaultCenter] addObserver:self
                                                         selector:@selector(onScrollWillBeginDrag:)
                                                             name:SCROLL_WILL_BEGIN_DRAG_NOTIFICATION
                                                           object:nil];
                
                [[NSNotificationCenter defaultCenter] addObserver:self
                                                         selector:@selector(onScrollDidEndDragNoDeceleration:)
                                                             name:SCROLL_DID_END_DRAG_NO_DECELERATION_NOTIFICATION
                                                           object:nil];
                
                [self.rctScrollView.scrollView addObserver:self
                                                forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld
                                                   context:nil];
                
                [RCTScrollView swizzleScrollDelegateMethods];
            }
        }
    }
    return self;
}

- (void)dealloc
{
    self.viewController.navigationController.navigationBar.frame = self.originalNavBarFrame;
    self.viewController.view.frame = self.originalViewFrame;
    [self updateBarButtonItems:1];
    
    if (self.rctScrollView != nil)
    {
        [self.rctScrollView.scrollView removeObserver:self forKeyPath:@"contentOffset" context:nil];
        self.rctScrollView = nil;
    }
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(BOOL)isValidForScrolling:(UIScrollView*)scrollView
{
    return (scrollView == self.rctScrollView.scrollView && self.viewController.navigationController != nil);
}

#pragma mark - ScrollView notifications

-(void)onScrollWillBeginDrag:(NSNotification*)notification
{
    UIScrollView *scrollView = (UIScrollView*)notification.object;
    if (![self isValidForScrolling:scrollView])
    {
        return;
    }
    
    self.lastScrollViewYOffset = scrollView.contentOffset.y;
}

-(void)onScrollDidEndDragNoDeceleration:(NSNotification*)notification
{
    UIScrollView *scrollView = (UIScrollView*)notification.object;
    if (![self isValidForScrolling:scrollView])
    {
        return;
    }
    
    CGRect frame = self.viewController.navigationController.navigationBar.frame;
    if (frame.origin.y < self.statusBarHeight)
    {
        [self animateNavBarTo:-(frame.size.height - (self.statusBarHeight + 1))];
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    UIScrollView *scrollView = (UIScrollView*)object;
    if (![self isValidForScrolling:scrollView])
    {
        return;
    }
    
    CGRect frame = self.viewController.navigationController.navigationBar.frame;
    CGFloat size = frame.size.height - (self.statusBarHeight + 1);
    CGFloat framePercentageHidden = ((self.statusBarHeight - frame.origin.y) / (frame.size.height - 1));
    CGFloat scrollOffset = scrollView.contentOffset.y;
    CGFloat scrollDiff = scrollOffset - self.lastScrollViewYOffset;
    CGFloat scrollHeight = scrollView.frame.size.height;
    CGFloat scrollContentSizeHeight = scrollView.contentSize.height + scrollView.contentInset.bottom;
    
    if (scrollOffset <= -scrollView.contentInset.top)
    {
        frame.origin.y = self.statusBarHeight;
    }
    else if ((scrollOffset + scrollHeight) >= scrollContentSizeHeight)
    {
        frame.origin.y = -size;
    }
    else
    {
        frame.origin.y = MIN(self.statusBarHeight, MAX(-size, frame.origin.y - scrollDiff));
    }
    
    self.viewController.navigationController.navigationBar.frame = frame;
    [self updateBarButtonItems:(1 - framePercentageHidden)];
    self.lastScrollViewYOffset = scrollOffset;
    
    CGRect viewFrame = self.viewController.view.frame;
    viewFrame.origin.y = frame.origin.y - self.originalNavBarFrame.origin.y;
    viewFrame.size.height = self.originalViewFrame.size.height - viewFrame.origin.y;
    self.viewController.view.frame = viewFrame;
}

#pragma mark - helper methods

- (void)animateNavBarTo:(CGFloat)y
{
    [UIView animateWithDuration:0.2 animations:^
    {
        CGRect frame = self.viewController.navigationController.navigationBar.frame;
        CGFloat alpha = (frame.origin.y >= y ? 0 : 1);
        frame.origin.y = y;
        [self.viewController.navigationController.navigationBar setFrame:frame];
        [self updateBarButtonItems:alpha];
    }];
}

- (void)updateBarButtonItems:(CGFloat)alpha
{
    [self.navbarSubViews enumerateObjectsUsingBlock:^(UIView* subview, NSUInteger i, BOOL *stop)
    {
        subview.alpha = alpha;
    }];
}

-(NSArray*)getAllNonBackgroundSubviewsForView:(UIView*)view
{
    NSMutableArray *allSubviews = [NSMutableArray new];
    for (UIView *subview in view.subviews)
    {
        if (subview.frame.size.width != view.frame.size.width && subview.frame.size.height != view.frame.size.height && subview.alpha != 0 && !subview.hidden)
        {
            [allSubviews addObject:subview];
        }
        [allSubviews addObjectsFromArray:[self getAllNonBackgroundSubviewsForView:subview]];
    }
    return allSubviews;
}

@end
