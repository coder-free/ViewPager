//
//  StringTools.h
//  viewpager
//
//  Created by Apple on 15/3/17.
//  Copyright (c) 2015年 com.test. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface StringTools : NSObject

+ (CGSize)sizeWithString:(NSString *)string font:(UIFont *)font constrainedToSize:(CGSize)size lineBreakMode:(NSLineBreakMode)lineBreakMode;

+ (CGSize)sizeWithString:(NSString *)string font:(UIFont *)font constrainedToSize:(CGSize)size;

+ (CGSize)sizeWithString:(NSString *)string font:(UIFont *)font;

@end
