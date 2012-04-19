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
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 44)];
    [topView setBackgroundColor:[UIColor grayColor]];
    menuButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [menuButton setFrame:CGRectMake(0, 0, 50, 40)];
    [menuButton setTitle:@"目录" forState:UIControlStateNormal];
    [menuButton addTarget:self action:@selector(showChapterIndex:) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:menuButton];
    [self.view addSubview:topView];
    
    UIView *downView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height - 44, self.view.bounds.size.width, 44)];
    [downView setBackgroundColor:[UIColor grayColor]];
    pageSlider = [[UISlider alloc] initWithFrame:CGRectMake(20, 10, self.view.bounds.size.width - 40, 10)];
     //滑块图片
    [pageSlider setThumbImage:[UIImage imageNamed:@"slider_ball.png"] forState:UIControlStateNormal];
	[pageSlider setMinimumTrackImage:[[UIImage imageNamed:@"orangeSlide.png"] stretchableImageWithLeftCapWidth:10 topCapHeight:0] forState:UIControlStateNormal];
	[pageSlider setMaximumTrackImage:[[UIImage imageNamed:@"yellowSlide.png"] stretchableImageWithLeftCapWidth:10 topCapHeight:0] forState:UIControlStateNormal];
    //滑块拖动时的事件
    [pageSlider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    //滑动拖动后的事件
    [pageSlider addTarget:self action:@selector(slidingEnded:) forControlEvents:UIControlEventTouchUpInside];

    [downView addSubview:pageSlider];
    
    [self.view addSubview:downView];
}
//显示目录页面
- (void)showChapterIndex:(id)sender
{
    if(chaptersPopover==nil){
        ChapterListVC *chapterList = [[ChapterListVC alloc] init];
        chaptersPopover = [[UIPopoverController alloc] initWithContentViewController:chapterList];
        ////内容大小
//        [chaptersPopover setPopoverContentSize:CGSizeMake(400, 600)];
        //修改UIPopoverController里面导航部分的背景颜色
        [[[chaptersPopover contentViewController] view] setBackgroundColor:[UIColor whiteColor]];
        [chapterList release];
    }
    if ([chaptersPopover isPopoverVisible]) {
        //消失popover
		[chaptersPopover dismissPopoverAnimated:YES];
	}else{
        //展现popover
//		[chaptersPopover presentPopoverFromBarButtonItem:menuButton permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        [chaptersPopover presentPopoverFromRect:menuButton.bounds inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
	}

}

- (void)sliderValueChanged:(id)sender
{
    NSLog(@"sliderValueChanged");
}

- (void)slidingEnded:(id)sender
{
    NSLog(@"slidingEnded");
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
