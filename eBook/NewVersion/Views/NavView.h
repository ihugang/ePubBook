//
//  NavView.h
//  eBook
//
//  Created by loufq on 12-4-20.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//  页面跳转

#import "BaseView.h"

@class NavView;
@protocol NavViewDelegate <NSObject>

-(void)navView:(NavView*)navView changeToIndex:(int)pageIndex;

@end


@interface NavView : BaseView{
    UISlider *pageSlider;
    
}
@property(nonatomic,retain) UISlider *pageSlider;
@property(nonatomic,assign)int value;
@property(nonatomic,assign)int count;

@property(nonatomic,assign)id<NavViewDelegate>delegate;



@end
