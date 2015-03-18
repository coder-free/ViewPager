//
//  StringTools.m
//  viewpager
//
//  Created by Apple on 15/3/17.
//  Copyright (c) 2015年 com.test. All rights reserved.
//

#import "StringTools.h"

@implementation StringTools

#pragma mark -
#pragma mark stringSize

+ (CGSize)sizeWithString:(NSString *)string font:(UIFont *)font constrainedToSize:(CGSize)size lineBreakMode:(NSLineBreakMode)lineBreakMode {
    if (!string) {
        return CGSizeMake(0, 0);
    }
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, size.width, 1)];
    label.font = font;
    label.lineBreakMode = lineBreakMode;
    label.text = string;
    label.numberOfLines = 0;
    CGRect rect2 = [label textRectForBounds:CGRectMake(0, 0, size.width, size.height) limitedToNumberOfLines:NSIntegerMax];
    return rect2.size;
}

+ (CGSize)sizeWithString:(NSString *)string font:(UIFont *)font constrainedToSize:(CGSize)size
{
    if (!string || [string length] <= 0) {
        return CGSizeMake(0, 0);
    }
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, size.width, 1)];
    label.font = font;
    label.text = string;
    label.numberOfLines = 0;
    CGRect rect2 = [label textRectForBounds:CGRectMake(0, 0, size.width, size.height) limitedToNumberOfLines:NSIntegerMax];
    return rect2.size;
}

+ (CGSize)sizeWithString:(NSString *)string font:(UIFont *)font {
    if (!string) {
        return CGSizeMake(0, 0);
    }
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGFLOAT_MAX, 1)];
    label.font = font;
    label.text = string;
    label.numberOfLines = 0;
    CGRect rect2 = [label textRectForBounds:CGRectMake(0, 0, CGFLOAT_MAX, CGFLOAT_MAX) limitedToNumberOfLines:NSIntegerMax];
    return rect2.size;
}

@end
