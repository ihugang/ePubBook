//
//  UIView+Rim.m
//  Dolphin_Server2
//
//  Created by apple on 11-7-9.
//  Copyright 2011年 E0571. All rights reserved.
//

#import "UIView+Rim.h"
#import <QuartzCore/QuartzCore.h>

@implementation UIView (Rim)   
- (void)addRoundedCornersToCardWithRadius:(CGFloat)radius SetColor:(UIColor*)color SetWidth:(CGFloat)width
{  
    CALayer *layer = self.layer;  
    layer.borderColor = color.CGColor;
    layer.borderWidth = width;  
    layer.cornerRadius = radius;  
    layer.masksToBounds = YES;  
    self.clipsToBounds = YES;  
}   
@end 