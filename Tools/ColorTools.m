//
//  ColorTools.m
//  viewpager
//
//  Created by Apple on 14-8-26.
//  Copyright (c) 2014年 com.sxtv2. All rights reserved.
//

#import "ColorTools.h"

@implementation ColorTools

+ (UIColor *)colorFromHexRGB:(NSString *)inColorString
{
    if (!inColorString || [inColorString length] < 6) {
        return [UIColor clearColor];
    }
    UIColor *result = nil;
    unsigned int colorCode = 0;
    unsigned char redByte, greenByte, blueByte;
    
    if (nil != inColorString)
    {
        NSScanner *scanner = [NSScanner scannerWithString:inColorString];
        (void) [scanner scanHexInt:&colorCode]; // ignore error
    }
    redByte = (unsigned char) (colorCode >> 16);
    greenByte = (unsigned char) (colorCode >> 8);
    blueByte = (unsigned char) (colorCode); // masks off high bits
    result = [UIColor
              colorWithRed: (float)redByte / 0xff
              green: (float)greenByte/ 0xff
              blue: (float)blueByte / 0xff
              alpha:1.0];
    return result;
}

+ (UIColor *)colorFromHexARGB:(NSString *)inColorString
{
    if (!inColorString || [inColorString length] < 8) {
        return [UIColor clearColor];
    }
    UIColor *result = nil;
    unsigned long long colorCode = 0;
    unsigned char alphaByte, redByte, greenByte, blueByte;
    
    if (nil != inColorString)
    {
        NSScanner *scanner = [NSScanner scannerWithString:inColorString];
        [scanner scanHexLongLong:&colorCode]; // ignore error
    }
    alphaByte = (unsigned char) (colorCode >> 24);
    redByte = (unsigned char) (colorCode >> 16);
    greenByte = (unsigned char) (colorCode >> 8);
    blueByte = (unsigned char) (colorCode); // masks off high bits
    result = [UIColor
              colorWithRed: (float)redByte / 0xff
              green: (float)greenByte/ 0xff
              blue: (float)blueByte / 0xff
              alpha:(float)alphaByte / 0xff];
    return result;
}

+ (UIColor *)colorFromHexRGB:(NSString *)inColorString alpha:(CGFloat)alpha
{
    if (!inColorString || [inColorString length] < 6) {
        return [UIColor clearColor];
    }
    UIColor *result = nil;
    unsigned int colorCode = 0;
    unsigned char redByte, greenByte, blueByte;
    
    if (nil != inColorString)
    {
        NSScanner *scanner = [NSScanner scannerWithString:inColorString];
        (void) [scanner scanHexInt:&colorCode]; // ignore error
    }
    redByte = (unsigned char) (colorCode >> 16);
    greenByte = (unsigned char) (colorCode >> 8);
    blueByte = (unsigned char) (colorCode); // masks off high bits
    result = [UIColor
              colorWithRed: (float)redByte / 0xff
              green: (float)greenByte/ 0xff
              blue: (float)blueByte / 0xff
              alpha:alpha];
    return result;
}

@end
