//
//  UIColor+Random.m
//  QuartzFun
//
//  Created by Kim Topley on 6/19/14.
//  Copyright (c) 2014 Apress. All rights reserved.
//
#import "UIColor+Random.h"

@implementation UIColor (Random)

+ (UIColor *)randomColor {
    CGFloat red = (CGFloat)(arc4random() % 256)/255;
    CGFloat blue = (CGFloat)(arc4random() % 256)/255;
    CGFloat green = (CGFloat)(arc4random() % 256)/255;
    return [UIColor colorWithRed:red green:green blue:blue alpha:1.0f];
}

@end
