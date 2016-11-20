//
//  RNNCustomNavButton.h
//  ReactNativeNavigation
//
//  Created by Artal Druk on 07/10/2016.
//  Copyright © 2016 artal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RCTViewManager.h"

@interface RNNCustomNavButton : UIView
@property (nonatomic, strong) NSString *buttonId;
@property (nonatomic, strong) NSString *callbackId;
@end

@interface RNNCustomNavButtonManager : RCTViewManager
+(UIView*)buttonViewWithId:(NSString*)buttonId;
@end
