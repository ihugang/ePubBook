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
    self.pageView.backgroundColor =[UIColor scrollViewTexturedBackgroundColor];
    [self.view insertSubview:self.pageView atIndex:0];
    [self.pageView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin];
    [self.pageView reloadData];
 
}

-(void)userTapOper:(UITapGestureRecognizer*)gesture{
    CGPoint p  =   [gesture locationInView:self.view];
    CGSize windowSize = self.view.bounds.size;

    float pos =  p.x/windowSize.width;
    
    if (pos<0.2) {
         
    }
    
    if (pos>0.8) {
        
    }
    
    if (pos>0.4 && pos<0.6) {
        //
        operViewShowed=!operViewShowed;
    }
}


- (void)viewDidLoad{
    [super viewDidLoad]; 
    self.view.backgroundColor =[UIColor scrollViewTexturedBackgroundColor];
    
    OperView* ov =[OperView createWithSize:CGSizeMake(self.view.width, 44)];
    ov.rootVC = self;
    ov.delegate=self;
    [self.view addSubview:ov];
    [ov setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin];
 
    NavView* nv =[NavView createWithSize:CGSizeMake(self.view.width, 44)];
    nv.bottom = self.view.height;
    nv.delegate=self;
    [self.view addSubview:nv];
    [nv setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin];
    
    //提示下载
    MBProgressHUD* hud =[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [hud setLabelText:@"正在解析"];
    parsing = NO;
    [Bussicess fetchBookInfo:^{
        [hud setHidden:YES];
        parsing = YES;
        [self addUI]; 
        nv.count = curBook.PageCount;
    }]; 
    
    //添加上面的view 
    operViewShowed = NO;  
    return;
    UITapGestureRecognizer* tapGesture =[[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userTapOper:)] autorelease];
    
    [self.view addGestureRecognizer:tapGesture]; 
}

- (NSInteger)numberOfPagesInPagingView:(ATPagingView *)pagingView{
    return curBook.PageCount;
}

- (UIView *)viewForPageInPagingView:(ATPagingView *)pagingView atIndex:(NSInteger)index{
    ContentWrapperView* cwv =[ContentWrapperView createWithSize:pagingView.frame.size];
    [cwv showWithPathIndex:index];
    return cwv;
}

-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation{
    [super didRotateFromInterfaceOrientation:fromInterfaceOrientation];
    if (!parsing) {
        return;
    }
    int iCurIndex = self.pageView.currentPageIndex;
    [self addUI]; 
    self.pageView.currentPageIndex =  iCurIndex;

}
-(void)navView:(NavView*)navView changeToIndex:(int)pageIndex{
    self.pageView.currentPageIndex = pageIndex;
}

-(void)operView:(OperView*)navView changeToIndex:(int)pageIndex{
    
}

@end
