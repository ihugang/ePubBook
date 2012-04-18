//
//  EPubViewController.m
//  eBook
//
//  Created by LiuWu on 12-4-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "EPubViewController.h"



@interface EPubViewController ()

@end

@implementation EPubViewController
@synthesize loadedEpub;
@synthesize webView;
@synthesize totalPagesCount;
//@synthesize epubPageView;
//@synthesize pagingView;


- (void) loadEpub
{
    currentSpineIndex = 0;
    currentPageInSpineIndex = 0;
    pagesInCurrentSpineCount = 0;
    totalPagesCount = 0;
    //	searching = NO;
    epubLoaded = NO;
    //解析epub
//    loadedEpub = [[EPub alloc] initWithEPub:[epubURL path]];
    loadedEpub = [EPub sharedEpub];//调用单例对象
    NSLog(@"EPubViewController -------》 loadEpub");
}

- (void) chapterDidFinishLoad:(Chapter *)chapter{
    
    NSLog(@"EpubViewController - - > chapterDidFinishLoad");
    //总共的页书
    totalPagesCount+=chapter.pageCount;
    //chapterIndex目录页码  
    //加载计算所有的文件需要的总页数
	if(chapter.chapterIndex + 1 < [loadedEpub.spineArray count]){
		[[loadedEpub.spineArray objectAtIndex:chapter.chapterIndex+1] setDelegate:self];
		[[loadedEpub.spineArray objectAtIndex:chapter.chapterIndex+1] loadChapterWithWindowSize:webView.bounds fontPercentSize:currentTextSize];
        //		[currentPageLabel setText:[NSString stringWithFormat:@"?/%d", totalPagesCount]];
	} else {
        //		[currentPageLabel setText:[NSString stringWithFormat:@"%d/%d",[self getGlobalPageCount], totalPagesCount]];
        //		[pageSlider setValue:(float)100*(float)[self getGlobalPageCount]/(float)totalPagesCount animated:YES];
        //		paginating = NO;
		NSLog(@"Pagination Ended!");
	}
}

//加载分页
- (void) loadSpine:(int)spineIndex atPageIndex:(int)pageIndex {
    //	[self loadSpine:spineIndex atPageIndex:pageIndex highlightSearchResult:nil];
    NSURL *url = [NSURL fileURLWithPath:[[loadedEpub.spineArray objectAtIndex:spineIndex] spinePath]];
    NSLog(@"epubViewcontroller ---- loadspine path:%@",[url path]);
	[webView loadRequest:[NSURLRequest requestWithURL:url]];
//    EPubPageView *pageView = [[[EPubPageView alloc] init] autorelease];
//    [pageView load:url atPageIndex:pageIndex];
     
	currentPageInSpineIndex = pageIndex;
	currentSpineIndex = spineIndex;
}

//跳转到指定的页面
//- (void) loadSpine:(int)spineIndex atPageIndex:(int)pageIndex highlightSearchResult:(SearchResult*)theResult{
//	
//	webView.hidden = YES;
//	
////	self.currentSearchResult = theResult;
////    
////	[chaptersPopover dismissPopoverAnimated:YES];
////	[searchResultsPopover dismissPopoverAnimated:YES];
//	
//	NSURL* url = [NSURL fileURLWithPath:[[loadedEpub.spineArray objectAtIndex:spineIndex] spinePath]];
//	[webView loadRequest:[NSURLRequest requestWithURL:url]];
//	currentPageInSpineIndex = pageIndex;
//	currentSpineIndex = spineIndex;
////	if(!paginating){
////		[currentPageLabel setText:[NSString stringWithFormat:@"%d/%d",[self getGlobalPageCount], totalPagesCount]];
////		[pageSlider setValue:(float)100*(float)[self getGlobalPageCount]/(float)totalPagesCount animated:YES];	
////	}
//}


- (void) updatePagination{
	if(epubLoaded){
        if(!paginating){
            NSLog(@"Pagination Started!");
            paginating = YES;
            totalPagesCount=0;
            [self loadSpine:currentSpineIndex atPageIndex:currentPageInSpineIndex];
            [[loadedEpub.spineArray objectAtIndex:0] setDelegate:self];
            [[loadedEpub.spineArray objectAtIndex:0] loadChapterWithWindowSize:webView.bounds fontPercentSize:currentTextSize];
            //[currentPageLabel setText:@"?/?"];
        }
	}
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self loadEpub];
    
    // Do any additional setup after loading the view.
    webView = [[UIWebView alloc] init];
    //    [webView setBounds:CGRectMake(0, 0, 320, 480)];
    [webView setFrame:CGRectMake(40, 60, self.view.bounds.size.width - 80, self.view.bounds.size.height - 120)];
    [webView setDelegate:self];
    [webView setAutoresizesSubviews:YES];
    [webView setBackgroundColor:[UIColor clearColor]];//设置背景颜色
    [webView setOpaque:NO];//设置透明
    [webView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin];
//    [self.view addSubview:webView];
    NSLog(@"_______________________");
    
    //去除webview中的scrollview
    UIScrollView* sv = nil;
	for (UIView* v in  webView.subviews) {
		if([v isKindOfClass:[UIScrollView class]]){
			sv = (UIScrollView*) v;
			sv.scrollEnabled = NO;//禁止滚动和回弹
			sv.bounces = NO;//禁止滚动
		}
	}
    
    currentTextSize = 150;
    //根据
//    [self updatePagination];
    epubLoaded = YES;
    //手势	
    UISwipeGestureRecognizer *rightSwipeRecognizer = [[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(gotoNextPage)] autorelease];
    [rightSwipeRecognizer setDirection:UISwipeGestureRecognizerDirectionLeft];
    
    UISwipeGestureRecognizer *leftSwipeRecognizer = [[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(gotoPrevPage)] autorelease];
    [leftSwipeRecognizer setDirection:UISwipeGestureRecognizerDirectionRight];
    
//    [webView addGestureRecognizer:rightSwipeRecognizer];
//	[webView addGestureRecognizer:leftSwipeRecognizer];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.pagingView.horizontal = YES;///设置为横向翻转
//    self.pagingView.currentPageIndex = 3;//设置默认是第几页开始
    [self currentPageDidChangeInPagingView:self.pagingView];
}

#pragma mark -
#pragma mark ATPagingViewDelegate methods
- (NSInteger)numberOfPagesInPagingView:(ATPagingView *)pagingView
{
//    return totalPagesCount;
//    return [epubPageView.epub.spineArray count];
//    return [loadedEpub.spineArray count];
    NSLog(@"count:---->%d",totalPagesCount);
    return [loadedEpub.spineArray count];

}

- (UIView *)viewForPageInPagingView:(ATPagingView *)pagingView atIndex:(NSInteger)index
{
    UIView *view = [pagingView dequeueReusablePage];
    if (view == nil) {
        view = [[[EPubPageView alloc] initWithEPubPage:index] autorelease];
//        view = self.view;
    }
    return view;
}

- (void)currentPageDidChangeInPagingView:(ATPagingView *)pagingView {
    NSLog(@"currentPageDidChangeInPagingView:%@",[NSString stringWithFormat:@"%d of %d", pagingView.currentPageIndex+1, pagingView.pageCount]);
//    [self loadSpine:pagingView.currentPageIndex+1 atPageIndex:pagingView.pageCount];
//    EPubPageView *pageView = [[[EPubPageView alloc] init] autorelease];
//    NSLog(@"aaaaa----%d",pageView.currentSpineIndex);
//    [pageView loadSpine:pagingView.currentPageIndex+1 atPageIndex:0];
//    pageView.currentSpineIndex += 1;
}

//- (void) slidingEnded:(id)sender{
//	int targetPage = (int)((pageSlider.value/(float)100)*(float)totalPagesCount);
//    if (targetPage==0) {
//        targetPage++;
//    }
//	int pageSum = 0;
//	int chapterIndex = 0;
//	int pageIndex = 0;
//	for(chapterIndex=0; chapterIndex<[loadedEpub.spineArray count]; chapterIndex++){
//		pageSum+=[[loadedEpub.spineArray objectAtIndex:chapterIndex] pageCount];
//		NSLog(@"Chapter %d, targetPage: %d, pageSum: %d, pageIndex: %d", chapterIndex, targetPage, pageSum, (pageSum-targetPage));
//		if(pageSum>=targetPage){
//			pageIndex = [[loadedEpub.spineArray objectAtIndex:chapterIndex] pageCount] - 1 - pageSum + targetPage;
//			break;
//		}
//	}
//	[self loadSpine:chapterIndex atPageIndex:pageIndex];
//}


- (void)webViewDidFinishLoad:(UIWebView *)theWebView{
	
	NSString *varMySheet = @"var mySheet = document.styleSheets[0];";
	
	NSString *addCSSRule =  @"function addCSSRule(selector, newRule) {"
	"if (mySheet.addRule) {"
	"mySheet.addRule(selector, newRule);"								// For Internet Explorer
	"} else {"
	"ruleIndex = mySheet.cssRules.length;"
	"mySheet.insertRule(selector + '{' + newRule + ';}', ruleIndex);"   // For Firefox, Chrome, etc.
	"}"
	"}";
	
	NSString *insertRule1 = [NSString stringWithFormat:@"addCSSRule('html', 'padding: 0px; height: %fpx; -webkit-column-gap: 0px; -webkit-column-width: %fpx;')", webView.frame.size.height, webView.frame.size.width];
	NSString *insertRule2 = [NSString stringWithFormat:@"addCSSRule('p', 'text-align: justify;')"];
	NSString *setTextSizeRule = [NSString stringWithFormat:@"addCSSRule('body', '-webkit-text-size-adjust: %d%%;')", currentTextSize];
	NSString *setHighlightColorRule = [NSString stringWithFormat:@"addCSSRule('highlight', 'background-color: yellow;')"];
    
	
	[webView stringByEvaluatingJavaScriptFromString:varMySheet];
	
	[webView stringByEvaluatingJavaScriptFromString:addCSSRule];
    
	[webView stringByEvaluatingJavaScriptFromString:insertRule1];
	
	[webView stringByEvaluatingJavaScriptFromString:insertRule2];
	
	[webView stringByEvaluatingJavaScriptFromString:setTextSizeRule];
	
	[webView stringByEvaluatingJavaScriptFromString:setHighlightColorRule];
	
    //	if(currentSearchResult!=nil){
    //        //	NSLog(@"Highlighting %@", currentSearchResult.originatingQuery);
    //        [webView highlightAllOccurencesOfString:currentSearchResult.originatingQuery];
    //	}
	
	
	int totalWidth = [[webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.scrollWidth"] intValue];
	pagesInCurrentSpineCount = (int)((float)totalWidth/webView.bounds.size.width);
	
	[self gotoPageInCurrentSpine:currentPageInSpineIndex];
}


- (void) gotoNextSpine {
	if(!paginating){
		if(currentSpineIndex+1<[loadedEpub.spineArray count]){
			[self loadSpine:++currentSpineIndex atPageIndex:0];
		}	
	}
}

- (void) gotoPrevSpine {
	if(!paginating){
		if(currentSpineIndex-1>=0){
			[self loadSpine:--currentSpineIndex atPageIndex:0];
		}	
	}
}

- (void) gotoNextPage {
	if(!paginating){
		if(currentPageInSpineIndex+1<pagesInCurrentSpineCount){
			[self gotoPageInCurrentSpine:++currentPageInSpineIndex];
		} else {
			[self gotoNextSpine];
		}		
	}
}

- (void) gotoPrevPage {
	if (!paginating) {
		if(currentPageInSpineIndex-1>=0){
			[self gotoPageInCurrentSpine:--currentPageInSpineIndex];
		} else {
			if(currentSpineIndex!=0){
				int targetPage = [[loadedEpub.spineArray objectAtIndex:(currentSpineIndex-1)] pageCount];
				[self loadSpine:--currentSpineIndex atPageIndex:targetPage-1];
			}
		}
	}
}

- (void) gotoPageInCurrentSpine:(int)pageIndex{
	if(pageIndex>=pagesInCurrentSpineCount){
		pageIndex = pagesInCurrentSpineCount - 1;
		currentPageInSpineIndex = pagesInCurrentSpineCount - 1;	
	}
	
	float pageOffset = pageIndex*webView.bounds.size.width;
    //设置页面依X轴来滚动
	NSString* goToOffsetFunc = [NSString stringWithFormat:@" function pageScroll(xOffset){ window.scroll(xOffset,0); } "];
	NSString* goTo =[NSString stringWithFormat:@"pageScroll(%f)", pageOffset];
	
	[webView stringByEvaluatingJavaScriptFromString:goToOffsetFunc];
	[webView stringByEvaluatingJavaScriptFromString:goTo];
	
    //	if(!paginating){
    //		[currentPageLabel setText:[NSString stringWithFormat:@"%d/%d",[self getGlobalPageCount], totalPagesCount]];
    //		[pageSlider setValue:(float)100*(float)[self getGlobalPageCount]/(float)totalPagesCount animated:YES];	
    //	}
	
	webView.hidden = NO;
	
}


- (void)dealloc
{
    [loadedEpub release];
    [super dealloc];
}

- (void)viewDidUnload
{
    loadedEpub = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
//    return (interfaceOrientation == UIInterfaceOrientationPortrait);
    return YES;
    
//    if (interfaceOrientation == UIDeviceOrientationPortrait || interfaceOrientation == UIDeviceOrientationPortraitUpsideDown) { 
//        //翻转为竖屏时 
//        //        [self setVerticalFrame]; 
//        [webView1 setFrame:CGRectMake(10, 10, self.view.bounds.size.width-20 /2, self.view.bounds.size.height-20)];
//        
//    }else if (interfaceOrientation==UIDeviceOrientationLandscapeLeft || interfaceOrientation == UIDeviceOrientationLandscapeRight) { 
//        //翻转为横屏时 
//        //        [self setHorizontalFrame]; 
//        [webView1 setFrame:CGRectMake(10,10, self.view.bounds.size.width  / 2.0 , self.view.bounds.size.height -10)];
//        
//        [webView2 setFrame:CGRectMake(self.view.bounds.size.width / 2.0 + 50, 10, self.view.bounds.size.width / 2.0 , self.view.bounds.size.height - 10)];
//        
//    } 

}

@end
