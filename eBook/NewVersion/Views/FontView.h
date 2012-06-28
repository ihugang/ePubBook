//
//  FontView.h
//  eBook
//
//  Created by LiuWu on 12-4-26.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "BaseView.h"

@interface FontView : BaseView
{
    UIButton *minButton;
    UIButton *middleButton;
    UIButton *maxButton;
    UISlider *sliderA;
    NSString *curPageIndex;
}
@property(nonatomic,retain) NSString *curPageIndex;
@property(nonatomic,retain) NSString *curChapterIndex;
@property(nonatomic,retain) NSString *curChapterPageIndex;

@end
