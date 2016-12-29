//
//  RCTScrollView+Hooks.h
//  ReactNativeControllers
//
//  Created by Artal Druk on 23/06/2016.
//  Copyright © 2016 artal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RCTScrollView.h"

extern NSString* const SCROLL_WILL_BEGIN_DRAG_NOTIFICATION;
extern NSString* const SCROLL_DID_END_DRAG_NO_DECELERATION_NOTIFICATION;

@interface RCTScrollView(ScrollingHooks)
+(void)swizzleScrollDelegateMethods;
@end
