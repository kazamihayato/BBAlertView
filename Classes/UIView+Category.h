//
//  ycx-ios
//
//  Created by 优车享 on 15/9/15.
//  Copyright (c) 2015年 优车享. All rights reserved.
//

#import <UIKit/UIKit.h>

#define SCREEN_WIDTH                 [[UIScreen mainScreen] bounds].size.width

#define SCREEN_HEIGHT                [[UIScreen mainScreen] bounds].size.height

#define FONT_SYSTEM_SIZE(s)          [UIFont systemFontOfSize:s]

#define FONT_SYSTEM_BOLD_SIZE(s)     [UIFont boldSystemFontOfSize:s]

#define fontScale                    ((ceil(displayScale)-1)*2)

#define displayScale                 (nativeScale() / 2)

CGFloat nativeScale(void);

@interface UIView (Category)

- (void) addToSuperview;

- (void) springingAnimation;

@end







