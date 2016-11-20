//
//  RNNCustomNavButton.m
//  ReactNativeNavigation
//
//  Created by Artal Druk on 07/10/2016.
//  Copyright © 2016 artal. All rights reserved.
//

#import "RNNCustomNavButtonManager.h"

static NSMutableDictionary *gCustomButtonsRegistry = nil;

@implementation RNNCustomNavButton

-(void)dealloc
{
    if(self.buttonId && gCustomButtonsRegistry[self.buttonId])
    {
        gCustomButtonsRegistry[self.buttonId] = nil;
    }
}

@end

@implementation RNNCustomNavButtonManager

RCT_EXPORT_MODULE()

- (UIView *)view
{
    return [[RNNCustomNavButton alloc] init];
}

RCT_EXPORT_VIEW_PROPERTY(callbackId, NSString)
RCT_CUSTOM_VIEW_PROPERTY(buttonId, NSString, RNNCustomNavButton)
{
    view.buttonId = [RCTConvert NSString:json];
    
    if(view.buttonId.length > 0)
    {
        if(gCustomButtonsRegistry == nil)
        {
            gCustomButtonsRegistry = [@{} mutableCopy];
        }
        gCustomButtonsRegistry[view.buttonId] = view;
    }
}

+(UIView*)buttonViewWithId:(NSString*)buttonId
{
    if(buttonId.length <= 0)
    {
        return nil;
    }
    
    UIView *button = gCustomButtonsRegistry[buttonId];
    gCustomButtonsRegistry[buttonId] = nil;
    [button removeFromSuperview];
    button.frame = CGRectMake(0, 0, button.frame.size.width, button.frame.size.height);
    return button;
}

@end
