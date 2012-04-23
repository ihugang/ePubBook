//
//  UIButton+Additions.m
//  iMenuPod
//
//  Created by yangxh yang on 11-9-9.
//  Copyright 2011年 e0571.com. All rights reserved.
//

#import "UIButton+Additions.h"

@implementation UIButton (UIButton_Additions)

- (void)setTitleForAllState:(NSString *)title
{
    [self setTitle:title forState:UIControlStateNormal];
	[self setTitle:title forState:UIControlStateSelected];
	[self setTitle:title forState:UIControlStateHighlighted];
	[self setTitle:title forState:UIControlStateDisabled];
}

@end
