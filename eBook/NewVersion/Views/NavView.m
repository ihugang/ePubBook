//
//  NavView.m
//  eBook
//
//  Created by loufq on 12-4-20.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "NavView.h"

@implementation NavView

-(void)initLayout{
    CGRect frame =  [[UIScreen mainScreen] bounds];
    self.size =CGSizeMake(frame.size.width, 44);
 
    pageSlider = [[UISlider alloc] initWithFrame:CGRectMake(20, 10, self.bounds.size.width - 40, 10)];
    //滑块图片
    [pageSlider setThumbImage:[UIImage imageNamed:@"slider_ball.png"] forState:UIControlStateNormal];
	[pageSlider setMinimumTrackImage:[[UIImage imageNamed:@"orangeSlide.png"] stretchableImageWithLeftCapWidth:10 topCapHeight:0] forState:UIControlStateNormal];
	[pageSlider setMaximumTrackImage:[[UIImage imageNamed:@"yellowSlide.png"] stretchableImageWithLeftCapWidth:10 topCapHeight:0] forState:UIControlStateNormal];
    //滑块拖动时的事件
    [pageSlider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    //滑动拖动后的事件
    [pageSlider addTarget:self action:@selector(slidingEnded:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:pageSlider];
}

- (void)sliderValueChanged:(id)sender
{
    NSLog(@"sliderValueChanged");
}

- (void)slidingEnded:(id)sender
{
    NSLog(@"slidingEnded");
}

@end
