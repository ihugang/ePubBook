//
//  NavView.m
//  eBook
//
//  Created by loufq on 12-4-20.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "NavView.h"

@implementation NavView
@synthesize delegate,count;
- (void)dealloc {
    self.delegate = nil;
    [super dealloc];
}

-(void)initLayout{
    CGRect frame =  [[UIScreen mainScreen] bounds];
    self.size =CGSizeMake(frame.size.width, 40);
    
    UIImageView* iv = [UIImageView nodeWithImage:skinImage(@"navbar/b008.png")];
    [self addSubview:iv];
   // self.backgroundColor =[UIColor blueColor];
    
    pageSlider = [[UISlider alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width - 40, 10)];
    pageSlider.centerX = self.width/2;
    pageSlider.top = 30;
    //滑块图片
    [pageSlider setThumbImage:skinImage(@"navbar/b010.png") forState:UIControlStateNormal];
    
	[pageSlider setMinimumTrackImage:[skinImage(@"navbar/b011.png") stretchableImageWithLeftCapWidth:10 topCapHeight:0] forState:UIControlStateNormal];
	[pageSlider setMaximumTrackImage:[skinImage(@"navbar/b009.png")stretchableImageWithLeftCapWidth:10 topCapHeight:0] forState:UIControlStateNormal];
    //滑块拖动时的事件
    [pageSlider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    //滑动拖动后的事件
    [pageSlider addTarget:self action:@selector(slidingEnded:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:pageSlider];
    [pageSlider release];
}
 
-(void)setCount:(int)aCount{ 
    count = aCount;
    pageSlider.maximumValue = count;
}

- (void)sliderValueChanged:(id)sender
{
    //show pop view
    NSLog(@"sliderValueChanged");
}

- (void)slidingEnded:(UISlider*)sender
{
    NSLog(@"slidingEnded%1.2f---%1.2f",pageSlider.maximumValue,sender.value);
    if (self.delegate) {
        [self.delegate navView:self changeToIndex:[NF(sender.value) intValue]];
    }
}

@end
