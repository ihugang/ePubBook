//
//  FontView.m
//  eBook
//
//  Created by LiuWu on 12-4-26.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "FontView.h"
#import <QuartzCore/QuartzCore.h>

@implementation FontView

- (void)dealloc {
    [super dealloc];
}

-(void)initLayout
{
//    CALayer *layer = [[CALayer alloc] init];
    
    
    UIImageView *top = [[UIImageView alloc] initWithFrame:CGRectMake(50, 10, 40, 20)];
    [top setImage:skinImage(@"fontbar/jiantou.png")];
//    [self addSubview:top];
    
    
    
    UIImageView *buttom = [[UIImageView alloc] initWithFrame:CGRectMake(0, 18, self.bounds.size.width, self.bounds.size.height)];
    [buttom setImage:skinImage(@"fontbar/c0023.png")];
    //[self addSubview:buttom];
    
    CALayer *layer = [CALayer layer];
//    layer.borderColor = [UIColor blackColor].CGColor;
//    layer.borderWidth = 1;
    layer.cornerRadius = 10.0;//设置圆角
    layer.backgroundColor = [UIColor whiteColor].CGColor;
    layer.shadowOffset = CGSizeMake(0, 3);
    layer.shadowRadius = 5.0;
    layer.shadowColor = [UIColor blackColor].CGColor;
    layer.shadowOpacity = 0.8;
    layer.frame = CGRectMake(10, 20,self.bounds.size.width, self.bounds.size.height);
    [self.layer addSublayer:layer];
    
    CALayer *imageLayer =[CALayer layer];
    imageLayer.frame = CGRectMake(38, -17,40, 20);
    imageLayer.cornerRadius =10.0;
    imageLayer.contents =(id)skinImage(@"fontbar/jiantou.png").CGImage;
    imageLayer.masksToBounds =YES;
    [layer addSublayer:imageLayer];
    
    UIButton *aa = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [aa setFrame:CGRectMake(30, 30, 100, 44)];
    [aa setTitle:@"aaa" forState:UIControlStateNormal];
//    [self addSubview:aa];
    
//    UILabel *min = [[UILabel alloc] initWithFrame:CGRectMake(10, 30, 20, 20)];
//    [min setBackgroundColor:[UIColor colorWithPatternImage:skinImage(@"fontbar/c003.png")]];
//    [self addSubview:min];
    
    UIImageView *min = [[UIImageView alloc] initWithFrame:CGRectMake(15, 35, 15, 15)];
    [min setImage:skinImage(@"fontbar/c003.png")];
    [self addSubview:min];
    
    UIImageView *max = [[UIImageView alloc] initWithFrame:CGRectMake(self.bounds.size.width - 20, 30, 20, 20)];
    [max setImage:skinImage(@"fontbar/c004.png")];
    [self addSubview:max];
    
    UISlider *sliderA=[[UISlider alloc]initWithFrame:CGRectMake(35, 30, self.bounds.size.width - 60, 0)];
    sliderA.backgroundColor = [UIColor clearColor];
    sliderA.value=0.5;
    sliderA.minimumValue=0.0;
    sliderA.maximumValue=1.0;
    //左右轨的图片
    UIImage *stetchLeftTrack= skinImage(@"fontbar/c005.png");
    UIImage *stetchRightTrack = skinImage(@"fontbar/c006.png");
    [sliderA setMinimumTrackImage:stetchLeftTrack forState:UIControlStateNormal];
    [sliderA setMaximumTrackImage:stetchRightTrack forState:UIControlStateNormal];
    //滑块图片
    UIImage *thumbImage = skinImage(@"fontbar/c006-1.png");
    //注意这里要加UIControlStateHightlighted的状态，否则当拖动滑块时滑块将变成原生的控件
    [sliderA setThumbImage:thumbImage forState:UIControlStateHighlighted];
    [sliderA setThumbImage:thumbImage forState:UIControlStateNormal];
    //滑块拖动时的事件
    [sliderA addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    //滑动拖动后的事件
    [sliderA addTarget:self action:@selector(sliderDragUp:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:sliderA];
}

- (void)sliderValueChanged:(id)sender
{
    NSLog(@"sliderValueChanged");
}

- (void)sliderDragUp:(id)sender
{
    
}

@end
