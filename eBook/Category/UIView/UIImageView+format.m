//
//  UIImage+format.m
//  AirMenu120
//
//  Created by Lee on 11-10-17.
//  Copyright (c) 2011年 Codans. All rights reserved.
//

#import "UIImageView+format.h"
#import <QuartzCore/QuartzCore.h>
@implementation UIImageView (format)
- (UIImage *)getImageFromView
{
    UIGraphicsBeginImageContext(self.bounds.size);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}
@end
