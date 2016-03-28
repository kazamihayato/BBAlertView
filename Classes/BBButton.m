//
//  BBButton.m
//  BBAlerViewDemo
//
//  Created by 庄BB的MacBook on 16/3/15.
//  Copyright © 2016年 youchexiang. All rights reserved.
//

#import "BBButton.h"

@interface BBButton ()
@property (nonatomic, strong) UIColor        * disableColor;
@end


@implementation BBButton

-(instancetype)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    if (self)
    {
        _layerBackground                    = [CALayer layer];
        [self.layer insertSublayer:self.layerBackground atIndex:0];
        self.layerBackground.frame          = self.bounds;
        self.layerBackground.masksToBounds  = YES;
        self.layerBackground.cornerRadius   = 3.0f;
    }
    return self;
}
-(void)setButtonStyle:(ButtonStyle)buttonStyle
{
    
    switch (buttonStyle) {
        case ButtonStyleFilled:
        {
            [self.layerBackground setBackgroundColor:self.bgColor.CGColor];
            [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            self.layer.borderColor = [UIColor clearColor].CGColor;
            self.layer.borderWidth = 0.0f;
            
            
        }
            break;
        case ButtonStyleBorder:
        {
            [self setTitleColor:_bgColor forState:UIControlStateNormal];
            
            self.layerBackground.borderColor   = _bgColor.CGColor;
            self.layerBackground.borderWidth   = 0.75f;
        }
            break;
        default:
            break;
    }
}
@end
