//
//  CustomNavigationBar.m
//  eBook
//
//  Created by LiuWu on 12-5-14.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "CustomNavigationBar.h"

@implementation CustomNavigationBar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    UIImage *img  = skinImage(@"navbar/b002.png");
    [img drawInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    
}

@end
