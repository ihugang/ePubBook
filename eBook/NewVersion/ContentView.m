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
#import "ResManager.h"
#import "Book.h"

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
    
    
    
    
   
    //给页面添加UIMenuController
    UIMenuController *menuController = [UIMenuController sharedMenuController];
    UIMenuItem *copyMenu = [[UIMenuItem alloc] initWithTitle:@"复制" action:@selector(copyMenuPressed:)];
    UIMenuItem *noteMenu = [[UIMenuItem alloc] initWithTitle:@"重点" action:@selector(noteMenuPressed:)];
    UIMenuItem *bookPickMenu = [[UIMenuItem alloc] initWithTitle:@"书摘" action:@selector(bookPickMenuPressed:)];
    //becomFirstResponder方法，使view或者viewController的self成为第一响应者，可以在相应文件的任意地方调用实现该方法，不过建议与UIMenuController放在一起。
//    [self becomeFirstResponder];

    //添加menu到 UIMenuController中
    [menuController setMenuItems:[NSArray arrayWithObjects:copyMenu,noteMenu,bookPickMenu, nil]];
    [menuController setArrowDirection:UIMenuControllerArrowDown];
    //设置大小
//    [menuController setTargetRect:[self frame] inView: self];
    //设置显示的菜单，默认是第一菜单，要直接显示第二菜单，设置为NO
    [menuController setMenuVisible:NO animated:YES];
    //菜单项被选中时，菜单会自动隐藏，如果你不想让它自动隐藏
    menuController.menuVisible = YES;

    [copyMenu release];
    [noteMenu release];
    [bookPickMenu release];
}

//设置-(BOOL) canBecomeFirstResponder的返回值为YES
- (BOOL)canBecomeFirstResponder
{
//    [super canBecomeFirstResponder];
    return YES;
}
//重载函数,设置要显示的菜单项，返回值为YES。若不进行任何限制，则将显示系统自带的所有菜单项
- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    [super canPerformAction:action withSender:sender];
    if (action == @selector(copyMenuPressed:)||action == @selector(noteMenuPressed:)||action == @selector(bookPickMenuPressed:)) {
        return YES;
    }
    return NO; //隐藏系统默认的菜单项
}
//复制
- (void)copyMenuPressed:(id)sender
{
    //    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    //    [pasteboard setString:[[self textLabel]text]];
    NSLog(@"copyMenuPressed");
}
//重点
- (void)noteMenuPressed:(id)sender
{
    //加载js文件
    NSString *filePath  =  resPath(@"HighlightedString.js");
    
    NSLog(@"filepath:%@",filePath);
    NSData *fileData    = [NSData dataWithContentsOfFile:filePath];
    NSString *jsString  = [[NSMutableString alloc] initWithData:fileData encoding:NSUTF8StringEncoding];
    [curWebView stringByEvaluatingJavaScriptFromString:jsString];
    
    // 获取选取的文本
    NSString *startSearch1   = [NSString stringWithFormat:@"getHighlightedString()"];
    [curWebView stringByEvaluatingJavaScriptFromString:startSearch1];
    
    NSString *selectedText   = [NSString stringWithFormat:@"selectedText"];
    NSString * highlightedString = [curWebView stringByEvaluatingJavaScriptFromString:selectedText];
    NSLog(@"selectedTextString: ---  > %@",highlightedString);
    
    // 把选中的文本样式改变
    NSString *startSearch   = [NSString stringWithFormat:@"stylizeHighlightedString()"];
//    NSLog(@"Highlighted -- > %@",startSearch);
    [curWebView stringByEvaluatingJavaScriptFromString:startSearch];
    NSLog(@"noteMenuPressed");
}
//书摘
- (void)bookPickMenuPressed:(id)sender
{
    NSLog(@"bookPickMenuPressed");
}
//删除
- (void)removeAllHighlights
{
    // calls the javascript function to remove html highlights
    [curWebView stringByEvaluatingJavaScriptFromString:@"uiWebview_RemoveAllHighlights()"];
}

-(void)updateInfo:(NSDictionary*)aInfo{
   
}

-(void)showWithIndex:(int)aIndex{
    self.curLable.text =[NSString stringWithFormat:@"%d",aIndex];
    
    int tempSpineIndex = 0;//HTML
    int tempPageIndex = 0;//Page
    
    int perTotalIndex = -1;//temp
    int curTotalIndex = 0;//temp
    for (Chapter* chapter in curBook.chapters) {        
        curTotalIndex += chapter.pageCount;
        if (aIndex>perTotalIndex && aIndex<=curTotalIndex) {
            tempPageIndex = curTotalIndex-aIndex;
            break;
        }
        perTotalIndex+=curTotalIndex;
        tempSpineIndex++;
    }
    
    [self loadSpine:tempSpineIndex atPageIndex:tempPageIndex]; 
}

//加载分页
- (void) loadSpine:(int)spineIndex atPageIndex:(int)pageIndex {
    curSpineIndex = spineIndex;
    curPageIndex = pageIndex;
  //  pageCount, chapterIndex
    Chapter* chapter = [curBook.chapters objectAtIndex:spineIndex];
    
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
