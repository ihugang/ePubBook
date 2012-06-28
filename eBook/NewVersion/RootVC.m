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
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"FontChange" object:nil];
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"landScape" object:nil];
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
    UIScrollView* sv =  [self.pageView valueForKey:@"_scrollView"];
    sv.backgroundColor = baseColor;
    self.pageView.delegate = self;
    self.pageView.currentPageIndex = self.lastPage.intValue;//设置默认的加载页面
    self.pageView.recyclingEnabled = NO;
    //self.pageView.pagesToPreload = 0;//前后方向加载不可见页数，第一次设置为0，只加载当前页面
//    self.pageView.backgroundColor =[UIColor whiteColor];
    self.pageView.backgroundColor = baseColor;
    [self.view insertSubview:self.pageView atIndex:0];
    [self.pageView setAutoresizesSubviews:YES];
    [self.pageView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin];
    [self.pageView reloadData];

}

-(void)userTapOper:(UITapGestureRecognizer*)gesture{
    CGPoint p  =   [gesture locationInView:self.view];
    CGSize windowSize = self.view.bounds.size;
    if (isLoyoutDebug) {
        DebugLog(@"userTapOper  p.x -> %f ",p.x);
        DebugLog(@"windowSize _ > %f",windowSize.width);
    } 
    
    float pos =  p.x/windowSize.width;
    if (isLoyoutDebug) {
        DebugLog(@"pos _ > %f",windowSize.width);
    }
    
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
//    [ov setAlpha:0.9];
    ov.rootVC = self;
    ov.delegate=self;
    [self.view addSubview:ov];
    [ov setAutoresizesSubviews:YES];
    [ov setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin];
    
    NavView* nv =[NavView createWithSize:CGSizeMake(self.view.width, 70)];
//    nv.bottom = self.view.height;
    nv.top = self.view.height - 70;
    navView = nv;
//    [nv setAlpha:0.9];
    nv.delegate=self;
//    [nv setBackgroundColor:[UIColor grayColor]];
    [self.view addSubview:nv];
    [nv setAutoresizesSubviews:YES];
    [nv setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin];
    
    self.lastPage = [[NSUserDefaults standardUserDefaults] objectForKey:@"curPageIndex"];
    if (lastPage == nil) {
        self.lastPage = @"0";//程序第一次加载，默认第0页开始
    }
    NSString *nowPageIndex = [[NSUserDefaults standardUserDefaults] objectForKey:@"currentPageIndex"];
    DebugLog(@"lastpage : %@,nowpage: %@ ",self.lastPage,nowPageIndex);
    //发送检查页面是否添加书签
    [[NSNotificationCenter defaultCenter] postNotificationName:@"sendPageToBookMark" object:self.lastPage];
    if (nowPageIndex==nil || ![nowPageIndex isEqualToString:self.lastPage]) {
        //添加当前加载的页面
        [[NSUserDefaults standardUserDefaults] setValue:self.lastPage forKey:@"currentPageIndex"];
        [[NSUserDefaults standardUserDefaults] synchronize];//写入数据
    }
    
    //提示下载
    MBProgressHUD* hud =[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [hud setLabelText:@"正在解析"];
    parsing = NO;
    [Bussicess fetchBookInfo:^{///解析plist文件
        [hud setHidden:YES];
//        parsing = YES;
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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fontChange:) name:@"FontChange" object:nil];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(test:) name:@"landScape" object:nil];

    
}

- (void)test:(NSNotification *)notification
{
    DebugLog(@"test ---> %d",[[notification object] intValue]);
    parsing = NO;
    self.pageView.currentPageIndex = [[notification object] intValue];
}

//目录列表页面跳转
- (void)fontChange:(NSNotification *)notification
{
    parsing = NO;
    self.pageView.currentPageIndex = [[notification object] intValue];
}

//目录列表页面跳转
- (void)chapterListPageLoad:(NSNotification *)notification
{
    parsing = NO;
    self.pageView.currentPageIndex = [[notification object] intValue];
}

//搜索页面跳转
- (void)searchPageLoad:(NSNotification *)notification
{
    parsing = NO;
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
    if ([self.view viewWithTag:1001]) {
        [self.view viewWithTag:1001].hidden = YES;
    }
    return YES;
}

#pragma mark ATPagingView Delegate
- (NSInteger)numberOfPagesInPagingView:(ATPagingView *)pagingView{
    NSLog(@"RootVC all pages ---- %d",curBook.PageCount);
    return curBook.PageCount;
}

- (UIView *)viewForPageInPagingView:(ATPagingView *)pagingView atIndex:(NSInteger)index{
    ContentWrapperView* cwv = (ContentWrapperView*)[pageView dequeueReusablePage];
    if (!cwv) {
         cwv = [ContentWrapperView createWithSize:pagingView.frame.size];
    }
    cwv.rootVC = self;
    [cwv showWithPathIndex:index];
    NSLog(@"viewForPageInPagingView currentpageIndex --%d",self.pageView.currentPageIndex);
    return cwv;
}

-(void)pagesDidChangeInPagingView:(ATPagingView *)pagingView{
//    self.pageView.currentPageIndex = 5;
    NSLog(@"pagesDidChangeInPagingView");
}
-(void)currentPageDidChangeInPagingView:(ATPagingView *)pagingView{
    #warning loufq debug return for iphone
//    return;//loufq debug
    if (parsing) {
        self.pageView.pagesToPreload = 2;//前后方向加载不可见页数
    }else {
        self.pageView.pagesToPreload = 0;//前后方向加载不可见页数
    }
   NSLog(@"currentPageDidChangeInPagingView  --> %d",pagingView.currentPageIndex);
    if (share.isLandscape) {
//        self.pageView.currentPageIndex = pagingView.currentPageIndex+2;
        //添加当前加载的页面
        [[NSUserDefaults standardUserDefaults] setValue:[NSString stringWithFormat:@"%d",pagingView.currentPageIndex] forKey:@"currentPageIndex"];
    }else {
        [[NSUserDefaults standardUserDefaults] setValue:[NSString stringWithFormat:@"%d",pagingView.currentPageIndex] forKey:@"currentPageIndex"];
    }
    //发送检查页面是否添加书签
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"pageChange" object:[NSString stringWithFormat:@"%d",pagingView.currentPageIndex]];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"sendPageToBookMark" object:[NSString stringWithFormat:@"%d",pagingView.currentPageIndex]];
    [[NSUserDefaults standardUserDefaults] synchronize];//写入数据
}
#pragma mark 旋转
-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation{
//    if (!mf_IsPad) {//设置iphone不能旋转
//        return;
//    }
//    if (fromInterfaceOrientation == UIInterfaceOrientationLandscapeLeft || fromInterfaceOrientation == UIInterfaceOrientationLandscapeRight) {
//        NSLog(@"===========> landscaptte ----");
//        
//        [self.view viewWithTag:300].hidden = NO;
//        [self.view viewWithTag:301].hidden = NO;
//        [self.view viewWithTag:301].frame = CGRectMake([self.view viewWithTag:302].right+40, 50, (self.view.bounds.size.width-80)/2.0-20, self.view.bounds.size.height-90);
//        [self.view viewWithTag:302].frame = CGRectMake(40, 50, (self.view.bounds.size.width-80)/2.0-20, self.view.bounds.size.height-90);
//    } else {
//        [self.view viewWithTag:300].hidden = YES;
//        [self.view viewWithTag:301].hidden = YES;
//    }
    
    NSString *nowPageIndex = [[NSUserDefaults standardUserDefaults] objectForKey:@"currentPageIndex"];
    //    int iCurIndex = self.pageView.currentPageIndex;
    //加载当前index也页面
    
    
    int iCurIndex = [nowPageIndex intValue];
    DebugLog(@"Root didRotateFromInterfaceOrientation --> %d",iCurIndex);
    self.pageView.currentPageIndex =  iCurIndex;
    self.lastPage = nowPageIndex;
    [super didRotateFromInterfaceOrientation:fromInterfaceOrientation];
    [self addUI];
    if (!parsing) {
        return;
    }
    
}
#pragma mark 导航条
-(void)navView:(NavView*)navView changeToIndex:(int)pageIndex{
    parsing = NO;
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
