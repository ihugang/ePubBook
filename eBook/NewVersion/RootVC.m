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
    [self.view addSubview:self.pageView];
    [self.pageView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin];
    [self.pageView reloadData];
 
    //添加上面的view 
}

- (void)viewDidLoad{
    [super viewDidLoad]; 
    //提示下载
    //[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [Bussicess fetchBookInfo:^{
        [self addUI];     
    }];
    
}

- (NSInteger)numberOfPagesInPagingView:(ATPagingView *)pagingView{
    return curBook.PageCount;
    //return self.datasoucre.count;
}

- (UIView *)viewForPageInPagingView:(ATPagingView *)pagingView atIndex:(NSInteger)index{
    ContentWrapperView* cwv =[ContentWrapperView createWithSize:pagingView.frame.size];
    [cwv showWithPathIndex:index];
    return cwv;
}

-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation{
    [super didRotateFromInterfaceOrientation:fromInterfaceOrientation];
    [self addUI];
}

@end
