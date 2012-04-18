//
//  RootVC.m
//  eBook
//
//  Created by loufq on 12-4-17.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "RootVC.h"
#import "ContentWrapperView.h"

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
}

- (void)viewDidLoad{
    [super viewDidLoad]; 
    [self addUI];
}

- (NSInteger)numberOfPagesInPagingView:(ATPagingView *)pagingView{
    return 100;
    return self.datasoucre.count;
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
