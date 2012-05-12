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
#import "SearchVC.h"
#import "SettingVC.h"
#import "BooksListVC.h"

@class OperView;
@protocol OperViewDelegate <NSObject>

-(void)operView:(OperView*)navView changeToIndex:(int)pageIndex;
-(void)operViewTappedToDissmiss;

@end

@interface OperView : BaseView<ChapterListVCDelegate,SearchVCDelegate>{
    UIButton* btnFontSize;
    BOOL show;
    FontView *fv;
    UINavigationController *navController;
    UIButton *bookMark;
    UIButton *fontsize;
}

@property(nonatomic,assign)UIViewController* rootVC;
@property(nonatomic,retain) NSString *currentPageIndex;


@property(nonatomic,assign)id<OperViewDelegate>delegate;
@end
