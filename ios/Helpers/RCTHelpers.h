//
//  RCTHelpers.h
//  ReactNativeControllers
//
//  Created by Artal Druk on 25/05/2016.
//  Copyright © 2016 artal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RCTRootView.h"
#import "RCTScrollView.h"

@interface RCTHelpers : NSObject
+(BOOL)removeYellowBox:(RCTRootView*)reactRootView;
+(RCTScrollView*)getFirstScrollView:(RCTRootView*)reactRootView;
@end
