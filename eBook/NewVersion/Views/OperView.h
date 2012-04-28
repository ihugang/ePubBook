//
//  OperView.h
//  eBook
//
//  Created by loufq on 12-4-20.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
// 导航操作

#import "BaseView.h"
#import "ChapterListVC.h"
#import "FontView.h"

@class OperView;
@protocol OperViewDelegate <NSObject>

-(void)operView:(OperView*)navView changeToIndex:(int)pageIndex;

@end

@interface OperView : BaseView<ChapterListVCDelegate>{
    UIButton* btnFontSize;
    BOOL show;
    FontView *fv;
}

@property(nonatomic,assign)UIViewController* rootVC;


@property(nonatomic,assign)id<OperViewDelegate>delegate;
@end
