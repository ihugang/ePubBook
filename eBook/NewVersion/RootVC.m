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
@synthesize pageView,datasoucre,lastPage;
- (void)dealloc {
    self.datasoucre = nil;
    //释放掉通知
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"searchPageIndex" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"chapterListPageLoad" object:nil];
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"fontChange" object:nil];
    [super dealloc];
}
 
-(void)addUI{
    //最后一次加载的页面
//    NSString *lastPage = [[NSUserDefaults standardUserDefaults] objectForKey:@"curPageIndex"];
    DebugLog(@"lastPageIndex ---> %@",lastPage);
//    if (lastPage == nil) {
//        lastPage = @"0";//程序第一次加载，默认第0页开始
//    }
    [self.pageView removeFromSuperview];
    self.pageView =[[[ATPagingView alloc] initWithFrame:self.view.bounds] autorelease];
    self.pageView.delegate = self;
    self.pageView.pagesToPreload = 0;
    self.pageView.currentPageIndex = self.lastPage.intValue;//设置默认的加载页面
//    self.pageView.backgroundColor =[UIColor whiteColor];
    self.pageView.backgroundColor = baseColor;
    [self.view insertSubview:self.pageView atIndex:0];
    [self.pageView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin];
    [self.pageView reloadData];
 
    
    NSLog(@"addUI");
}

-(void)userTapOper:(UITapGestureRecognizer*)gesture{
    CGPoint p  =   [gesture locationInView:self.view];
    CGSize windowSize = self.view.bounds.size;
    
    DebugLog(@"userTapOper  p.x -> %f ",p.x);
    DebugLog(@"windowSize _ > %f",windowSize.width);

    float pos =  p.x/windowSize.width;
     DebugLog(@"pos _ > %f",windowSize.width);
    
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
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.view.top = 0;
    navView.bottom = self.view.height;
}

- (void)viewWillDisappear:(BOOL)animated{
     [super viewWillDisappear:animated];
    [self swichUI:NO];
}

- (void)viewDidLoad{
    [super viewDidLoad]; 
    self.view.backgroundColor = baseColor;
//    self.view.backgroundColor = [UIColor whiteColor];
    OperView* ov =[OperView createWithSize:CGSizeMake(self.view.width, 44)];
    ov.top = 19;
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
    
    self.lastPage = [[NSUserDefaults standardUserDefaults] objectForKey:@"curPageIndex"];
    if (lastPage == nil) {
        self.lastPage = @"0";//程序第一次加载，默认第0页开始
    }
    
    //提示下载
    MBProgressHUD* hud =[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [hud setLabelText:@"正在解析"];
    parsing = NO;
    [Bussicess fetchBookInfo:^{///解析plist文件
        [hud setHidden:YES];
        parsing = YES;
        [self addUI]; 
        nv.count = curBook.PageCount;
        //设置拖动条的默认值
        nv.value = self.lastPage.intValue;
    }]; 
    
    //添加上面的view 
//    operViewShowed = NO; 
    [self swichUI:NO];
    UITapGestureRecognizer* tapGesture =[[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userTapOper:)] autorelease];
    tapGesture.delegate = self;
    [self.view addGestureRecognizer:tapGesture]; 
    
    //监听目录跳转
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(chapterListPageLoad:) name:@"chapterListPageLoad" object:nil];
    //搜索
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(searchPageLoad:) name:@"searchPageIndex" object:nil];
    //字体改变
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fontChange:) name:@"fontChange" object:nil];
    
}

//目录列表页面跳转
- (void)fontChange:(NSNotification *)notification
{
    self.pageView.currentPageIndex = [[notification object] intValue];
}

//目录列表页面跳转
- (void)chapterListPageLoad:(NSNotification *)notification
{
    self.pageView.currentPageIndex = [[notification object] intValue];
}

//搜索页面跳转
- (void)searchPageLoad:(NSNotification *)notification
{
    self.pageView.currentPageIndex = [[[notification userInfo] objectForKey:@"chapterPageIndex"] intValue];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"searchText" object:[[notification userInfo] objectForKey:@"searchResult"]];
}

-(void)operViewTappedToDissmiss{
    [self swichUI:NO];
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {

    if (touch.tapCount == 2) {
        [self swichUI:!operViewShowed];
        return NO;
    }
    if ([touch.view isKindOfClass:[UIButton class]]) 
    { 
		return NO;
    } 
    
    if ([touch.view isDescendantOfView:navView]||
        [touch.view isDescendantOfView:operView]
        ) {
        //隐藏掉字体设置窗体
        [self.view viewWithTag:1001].hidden = YES;
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
    NSLog(@"viewForPageInPagingView");
    return cwv;
}

-(void)pagesDidChangeInPagingView:(ATPagingView *)pagingView{
//    self.pageView.currentPageIndex = 5;
    NSLog(@"pagesDidChangeInPagingView");
}
-(void)currentPageDidChangeInPagingView:(ATPagingView *)pagingView{
   NSLog(@"currentPageDidChangeInPagingView");

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
