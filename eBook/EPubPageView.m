//
//  EPubPageView.m
//  eBook
//
//  Created by LiuWu on 12-4-13.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "EPubPageView.h"

@implementation EPubPageView
@synthesize epub,webView,currentSpineIndex;
//@synthesize epubViewController;

- (EPubPageView *)initWithEPubPage:(NSInteger)index
{
    self = [super init];
    if (self) {
        currentSpineIndex = index;
        currentPageInSpineIndex = 0;
        pagesInCurrentSpineCount = 0;
        totalPagesCount = 0;
        //	searching = NO;
        
        //NSURL *url =[NSURL URLWithString:@"http://www.baidu.com"];
        //NSURLRequest *request =[NSURLRequest requestWithURL:url];
        webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, self.superview.bounds.size.width ,self.superview.bounds.size.height)];
        //    webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0,self.superview.bounds.size.width,self.superview.bounds.size.height)];
        [webView setAutoresizesSubviews:YES];
        [webView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
        [webView setBackgroundColor:[UIColor clearColor]];
        [webView setDelegate:self];
        //[webView loadRequest:request];
        [self addSubview:webView];
        
        //    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        //    [button setFrame:CGRectMake(100, 200, 100, 44)];
        //    [button setTitle:@"page" forState:UIControlStateNormal];
        //    [self addSubview:button];
        //    NSLog(@"page %d",self.tag);
        
        self.epub = [EPub sharedEpub];
        epubLoaded = YES;
        currentTextSize = 150;
        NSLog(@"============>%d",[self.epub.spineArray count]);
        //    
        //    NSURL *url = [NSURL fileURLWithPath:[[epub.spineArray objectAtIndex:5] spinePath]];
        //    NSLog(@"epubpage  --- url : %@",[url path]);
        //	[webView loadRequest:[NSURLRequest requestWithURL:url]];
        
        [self updatePagination];
    }
    return self;

}

- (void)load:(NSURL *)path atPageIndex:(int)pageIndex
{
	[webView loadRequest:[NSURLRequest requestWithURL:path]];
	currentPageInSpineIndex = pageIndex;
}

- (void) updatePagination{
	if(epubLoaded){
        if(!paginating){
            NSLog(@"Pagination Started!");
            paginating = YES;
            totalPagesCount=0;
            [self loadSpine:currentSpineIndex atPageIndex:currentPageInSpineIndex];
            [[epub.spineArray objectAtIndex:0] setDelegate:self];
            [[epub.spineArray objectAtIndex:0] loadChapterWithWindowSize:webView.bounds fontPercentSize:currentTextSize];
            //[currentPageLabel setText:@"?/?"];
        }
	}
}

- (void) chapterDidFinishLoad:(Chapter *)chapter{
    
    NSLog(@"EpubViewController - - > chapterDidFinishLoad");
    //总共的页书
    totalPagesCount+=chapter.pageCount;
    
    NSLog(@"totalPagesCount:  %d",totalPagesCount);
    
    //chapterIndex目录页码  
    //加载计算所有的文件需要的总页数
	if(chapter.chapterIndex + 1 < [epub.spineArray count]){
		[[epub.spineArray objectAtIndex:chapter.chapterIndex+1] setDelegate:self];
		[[epub.spineArray objectAtIndex:chapter.chapterIndex+1] loadChapterWithWindowSize:webView.bounds fontPercentSize:currentTextSize];
        //		[currentPageLabel setText:[NSString stringWithFormat:@"?/%d", totalPagesCount]];
	} else {
        //		[currentPageLabel setText:[NSString stringWithFormat:@"%d/%d",[self getGlobalPageCount], totalPagesCount]];
        //		[pageSlider setValue:(float)100*(float)[self getGlobalPageCount]/(float)totalPagesCount animated:YES];
        //		paginating = NO;
		NSLog(@"Pagination Ended!");
	}
}


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
//        [self initWithEPubPage:<#(NSInteger)#>];
        //根据
//        [self updatePagination];
    }
    return self;
}

//加载分页
- (void) loadSpine:(int)spineIndex atPageIndex:(int)pageIndex {
    //	[self loadSpine:spineIndex atPageIndex:pageIndex highlightSearchResult:nil];
    NSURL *url = [NSURL fileURLWithPath:[[epub.spineArray objectAtIndex:spineIndex] spinePath]];
    NSLog(@"epubpage  --- url : %@",[url path]);
	[webView loadRequest:[NSURLRequest requestWithURL:url]];
	currentPageInSpineIndex = pageIndex;
	currentSpineIndex = spineIndex;
}

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
	NSLog(@"pagesInCurrentSpineCount ---- %d",pagesInCurrentSpineCount);
	[self gotoPageInCurrentSpine:currentPageInSpineIndex];
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

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
