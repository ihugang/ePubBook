//
//  RootVC.m
//  eBook
//
//  Created by loufq on 12-4-17.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "RootVC.h"
#import "ContentWrapperView.h"
#import "ChapterListVC.h"
#import "Bussicess.h"
#import "Book.h"

@implementation RootVC
@synthesize pageView,datasoucre;
- (void)dealloc {
    self.datasoucre = nil;
    [super dealloc];
}
 
-(void)addUI{
    [self.pageView removeFromSuperview];
    self.pageView =[[[ATPagingView alloc] initWithFrame:self.view.bounds] autorelease];
    self.pageView.delegate = self;
    self.pageView.pagesToPreload = 0;
    self.pageView.backgroundColor =[UIColor scrollViewTexturedBackgroundColor];
    [self.view insertSubview:self.pageView atIndex:0];
    [self.pageView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin];
    [self.pageView reloadData];
 
}

-(void)userTapOper:(UITapGestureRecognizer*)gesture{
    CGPoint p  =   [gesture locationInView:self.view];
    CGSize windowSize = self.view.bounds.size;

    float pos =  p.x/windowSize.width;
    
    if (pos<0.2&&self.pageView.currentPageIndex>0) {
         self.pageView.currentPageIndex-=1;
    }
    
    if (pos>0.8 && self.pageView.currentPageIndex<curBook.PageCount) {
        self.pageView.currentPageIndex+=1;
    }
    
    if (pos>0.4 && pos<0.6) {
        [self swichUI:!operViewShowed];
    }
}


- (void)viewDidLoad{
    [super viewDidLoad]; 
    self.view.backgroundColor =[UIColor scrollViewTexturedBackgroundColor];
    
    OperView* ov =[OperView createWithSize:CGSizeMake(self.view.width, 44)];
    ov.top = 20;
    operView = ov;
    ov.rootVC = self;
    ov.delegate=self;
    [self.view addSubview:ov];
    [ov setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin];
    
    NavView* nv =[NavView createWithSize:CGSizeMake(self.view.width, 44)];
    navView = nv;
    nv.bottom = self.view.height;
    nv.delegate=self;
    [self.view addSubview:nv];
    [nv setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin];
    
    //提示下载
    MBProgressHUD* hud =[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [hud setLabelText:@"正在解析"];
    parsing = NO;
    [Bussicess fetchBookInfo:^{///解析plist文件
        [hud setHidden:YES];
        parsing = YES;
        [self addUI]; 
        nv.count = curBook.PageCount;
    }]; 
    
    //添加上面的view 
//    operViewShowed = NO; 
    [self swichUI:NO];

    UITapGestureRecognizer* tapGesture =[[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userTapOper:)] autorelease];
    tapGesture.delegate = self;
    [self.view addGestureRecognizer:tapGesture]; 
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {

    if ([touch.view isKindOfClass:[UIButton class]]) 
    { 
		return NO;
    } 
    
    if ([touch.view isDescendantOfView:navView]||
        [touch.view isDescendantOfView:operView]
        ) {
        return NO;
    }
    return YES;
}

#pragma mark ATPagingView Delegate
- (NSInteger)numberOfPagesInPagingView:(ATPagingView *)pagingView{
    NSLog(@"RootVC ---- %d",curBook.PageCount);
    return curBook.PageCount;
}

- (UIView *)viewForPageInPagingView:(ATPagingView *)pagingView atIndex:(NSInteger)index{
    ContentWrapperView* cwv = (ContentWrapperView*)[pageView dequeueReusablePage];
    if (!cwv) {
         cwv = [ContentWrapperView createWithSize:pagingView.frame.size];
    }
    [cwv showWithPathIndex:index];
    return cwv;
}
-(void)pagesDidChangeInPagingView:(ATPagingView *)pagingView{
    
}
-(void)currentPageDidChangeInPagingView:(ATPagingView *)pagingView{
  

}
#pragma mark 旋转
-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation{
    if (!mf_IsPad) {
        return;
    }
    [super didRotateFromInterfaceOrientation:fromInterfaceOrientation];
    if (!parsing) {
        return;
    }
    int iCurIndex = self.pageView.currentPageIndex;
    [self addUI]; 
    self.pageView.currentPageIndex =  iCurIndex;

}
#pragma mark 导航条
-(void)navView:(NavView*)navView changeToIndex:(int)pageIndex{
    self.pageView.currentPageIndex = pageIndex;
    [self swichUI:!operViewShowed];
}
#pragma mark 操作条
-(void)operView:(OperView*)navView changeToIndex:(int)pageIndex{
//    [self swichUI:!operViewShowed];
}
#pragma mark 切换UI显示
-(void)swichUI:(BOOL)showOperView{
    operViewShowed = showOperView; 
    operView.hidden = !showOperView;
    navView.hidden = !showOperView;
    [[UIApplication sharedApplication]  setStatusBarHidden:!operViewShowed withAnimation:UIStatusBarAnimationSlide];
    if (showOperView) {
        
    }
    else{
        
    } 
}

@end
