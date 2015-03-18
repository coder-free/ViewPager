//
//  ColorTools.h
//  viewpager
//
//  Created by Apple on 14-8-26.
//  Copyright (c) 2014年 com.sxtv2. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ColorTools : NSObject

+ (UIColor *)colorFromHexRGB:(NSString *)inColorString;

+ (UIColor *)colorFromHexARGB:(NSString *)inColorString;

+ (UIColor *)colorFromHexRGB:(NSString *)inColorString alpha:(CGFloat)alpha;

@end
