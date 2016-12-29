//
//  RCTScrollView+Hooks.m
//  ReactNativeControllers
//
//  Created by Artal Druk on 23/06/2016.
//  Copyright © 2016 artal. All rights reserved.
//

#import "RCTScrollView+Hooks.h"
#import <objc/runtime.h>

NSString* const SCROLL_WILL_BEGIN_DRAG_NOTIFICATION = @"ScrollingHooks_ScrollViewWillBeginDragNotifcation";
NSString* const SCROLL_DID_END_DRAG_NO_DECELERATION_NOTIFICATION = @"ScrollingHooks_ScrollWillEndDragNotifcation";

@implementation RCTScrollView(ScrollingHooks)
- (void)my_scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self my_scrollViewWillBeginDragging:scrollView];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:SCROLL_WILL_BEGIN_DRAG_NOTIFICATION object:scrollView];
}

-(void)my_scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self my_scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
    
    if (!decelerate)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:SCROLL_DID_END_DRAG_NO_DECELERATION_NOTIFICATION object:scrollView];
    }
}

+(void)swizzleScrollDelegateMethods
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = [RCTScrollView class];
        method_exchangeImplementations(class_getInstanceMethod(class, @selector(scrollViewWillBeginDragging:)), class_getInstanceMethod(class, @selector(my_scrollViewWillBeginDragging:)));
        method_exchangeImplementations(class_getInstanceMethod(class, @selector(scrollViewDidEndDragging:willDecelerate:)), class_getInstanceMethod(class, @selector(my_scrollViewDidEndDragging:willDecelerate:)));
    });
}

@end
