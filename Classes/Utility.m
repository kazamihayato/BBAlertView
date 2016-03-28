//
//  Utility.m
//  BBAlerViewDemo
//
//  Created by 优车享 on 16/3/9.
//  Copyright © 2016年 youchexiang. All rights reserved.
//

#import "Utility.h"

@implementation Utility

+(CGFloat)heightWithString:(NSString*)string fontSize:(CGFloat)fontSize width:(CGFloat)width
{
    NSDictionary *attrs = @{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]};
    return  [string boundingRectWithSize:CGSizeMake(width, 0) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attrs context:nil].size.height;
}

@end
