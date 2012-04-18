//
//  ContentView.m
//  eBook
//
//  Created by loufq on 12-4-17.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ContentView.h"
#import "AppShare.h"
#import "EPub.h"
#import "Chapter.h"
@implementation ContentView
@synthesize curLable,curWebView;
- (void)dealloc{
    [super dealloc];
}
-(void)initLayout{
    // Do any additional setup after loading the view.
    curWebView = [[UIWebView alloc] init];

    //    [webView setBounds:CGRectMake(0, 0, 320, 480)];
    [curWebView setFrame:CGRectMake(40, 60, self.bounds.size.width, self.bounds.size.height)];
    [curWebView setDelegate:self];
    [curWebView setAutoresizesSubviews:YES];
    [curWebView setBackgroundColor:[UIColor clearColor]];//设置背景颜色
    [curWebView setOpaque:NO];//设置透明
    [curWebView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin];
    //    [self.view addSubview:webView];
    //去除webview中的scrollview
    UIScrollView* sv = nil;
	for (UIView* v in  curWebView.subviews) {
		if([v isKindOfClass:[UIScrollView class]]){
			sv = (UIScrollView*) v;
			sv.scrollEnabled = NO;//禁止滚动和回弹
			sv.bounces = NO;//禁止滚动
		}
	}
      [self addSubview:curWebView]; 
    self.curLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    [self addSubview:curLable]; 
}

-(void)updateInfo:(NSDictionary*)aInfo{
   
}

-(void)showWithIndex:(int)aIndex{
    self.curLable .text =[NSString stringWithFormat:@"%d",aIndex];
    
    int tempSpineIndex = 0;
    int tempPageIndex = 0;
    int tempTotalIndex = 0;
    BOOL foundPosition = NO;
    for (Chapter* chapter in share.ePub.spineArray) {
        tempPageIndex = 0;
        if (chapter.pageCount>0) {
            for (int iIndex=0; iIndex<chapter.pageCount; iIndex++) {
                if (tempTotalIndex==aIndex) {
                    //found position   
                    foundPosition = YES;
                    break;
                } 
                tempPageIndex++;
                tempTotalIndex++;
            }
        }else{
            if (tempSpineIndex==aIndex) {
                foundPosition = YES;
                 break;
            } 
        }
 
        if (foundPosition) {
            break;
        }
        
        tempSpineIndex++;
    }
    
    [self loadSpine:tempSpineIndex atPageIndex:tempPageIndex]; 
}

//加载分页
- (void) loadSpine:(int)spineIndex atPageIndex:(int)pageIndex {
    curSpineIndex = spineIndex;
    curPageIndex = pageIndex;
  //  pageCount, chapterIndex
    Chapter* chapter = [share.ePub.spineArray objectAtIndex:spineIndex];
    
    //[self loadSpine:spineIndex atPageIndex:pageIndex highlightSearchResult:nil];
    NSURL *url = [NSURL fileURLWithPath:chapter.spinePath];
	[curWebView loadRequest:[NSURLRequest requestWithURL:url]];
 
	//currentPageInSpineIndex = pageIndex;
	//currentSpineIndex = spineIndex;
}
- (void) gotoPageInCurrentSpine:(int)pageIndex{ 
	float pageOffset = pageIndex*curWebView.bounds.size.width;
    //设置页面依X轴来滚动
	NSString* goToOffsetFunc = [NSString stringWithFormat:@" function pageScroll(xOffset){ window.scroll(xOffset,0); } "];
	NSString* goTo =[NSString stringWithFormat:@"pageScroll(%f)", pageOffset]; 
	[curWebView stringByEvaluatingJavaScriptFromString:goToOffsetFunc];
	[curWebView stringByEvaluatingJavaScriptFromString:goTo];
	curWebView.hidden = NO;
	
}
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
  
    return YES;
}
- (void)webViewDidStartLoad:(UIWebView *)webView{

}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
      [self gotoPageInCurrentSpine:curPageIndex];
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{

}
@end
