//
//  BBButton.h
//  BBAlerViewDemo
//
//  Created by 庄BB的MacBook on 16/3/15.
//  Copyright © 2016年 youchexiang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, ButtonStyle) {
    ButtonStyleFilled ,//填充
    ButtonStyleBorder,//边框
};

@interface BBButton : UIButton
@property (nonatomic, strong) UIColor * bgColor;
@property (nonatomic, assign) ButtonStyle buttonStyle;
@property (nonatomic, strong, readonly) CALayer        * layerBackground;
@end
