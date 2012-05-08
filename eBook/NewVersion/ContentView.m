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
#import "BookMark.h"
#import "SearchResult.h"
#import "UIWebView+SearchWebView.h"

@implementation ContentView
@synthesize curLable,curWebView,currentSearchResult;
- (void)dealloc{
    //释放掉通知
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"search" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"pageLoad" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"chapterListPageLoad" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"addBookMark" object:nil];
    [super dealloc];
}
-(void)initLayout{
    // Do any additional setup after loading the view.
    curWebView = [[UIWebView alloc] init];

    //    [webView setBounds:CGRectMake(0, 0, 320, 480)];
//    [curWebView setFrame:CGRectMake(40, 60, self.bounds.size.width, self.bounds.size.height)];
    [curWebView setFrame:CGRectMake(10, 10, self.bounds.size.width-20, self.bounds.size.height-20)];
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
    self.curLable.backgroundColor =[UIColor clearColor];
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
    
    curWebView.userInteractionEnabled = NO;
    
    //添加通知监听
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pageLoad:) name:@"pageLoad" object:nil];
    //监听目录跳转
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(chapterListPageLoad:) name:@"chapterListPageLoad" object:nil];
    //搜索
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(searchPageLoad:) name:@"search" object:nil];
    //添加书签
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addBookMark:) name:@"addBookMark" object:nil];
    
}
//添加书签
- (void)addBookMark:(NSNotification *)notification
{
    //获取书签列表
    [bookMarks getBookMark];
    NSString *nowPageIndex = [NSString stringWithFormat:@"%d",curPageIndex];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *localTime=[formatter stringFromDate: [NSDate date]];
    DebugLog(@"now  time ---> %@",localTime);
    
    if ([bookMarks.currentBookMark objectForKey:nowPageIndex] == nil) {
        //给当前页面添加书签
        NSDictionary *pageIndex = [[NSDictionary alloc] initWithObjectsAndKeys:nowPageIndex,@"pageIndex",localTime,@"time",@"asdfas",@"content", nil];
        [bookMarks.bookmarks setValue:pageIndex forKey:nowPageIndex];
        //排序
//        [bookMarks.bookmarks keysSortedByValueUsingSelector:@selector(compare:)];
        [bookMarks.bookmarks writeToFile:bookMarks.filename atomically:YES];
        DebugLog(@"---%@",bookMarks.bookmarks);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"pageChange" object:nowPageIndex];
    }else {
        DebugLog(@"remove bookmark");
        //取消当前页面标签
        [bookMarks.bookmarks removeObjectForKey:nowPageIndex];
        [bookMarks.bookmarks writeToFile:bookMarks.filename atomically:YES];
        //取消当前图片的书签
        [[NSNotificationCenter defaultCenter] postNotificationName:@"pageChange" object:nowPageIndex];
    }
    
     [formatter release];
}

- (void)pageLoad:(NSNotification *)notification
{
    NSLog(@"pageLoad --- %d",[[notification object] intValue]);
    NSLog(@"loadSpine curSpineIndex:%d , curPageIndex : %d",curSpineIndex,curPageIndex);
    //重新加载页面
//    [self showWithIndex:curSpineIndex];
    [self loadSpine:curSpineIndex atPageIndex:curPageIndex];
}
//目录页面跳转
- (void)chapterListPageLoad:(NSNotification *)notification
{
//    [self loadSpine:[[notification object] intValue] atPageIndex:0];
    [self showWithIndex:[[notification object] intValue]];
}

//搜索页面跳转
- (void)searchPageLoad:(NSNotification *)notification
{
    int chapterIndex = [[notification.userInfo objectForKey:@"chapterIndex"] intValue];
    int pageIndex = [[notification.userInfo objectForKey:@"pageIndex"] intValue];
//    NSLog(@"searchPageLoad:  index:%d   page:%d",chapterIndex,pageIndex);
    SearchResult *search = [notification.userInfo objectForKey:@"searchResult"];
    self.currentSearchResult = search;
    [self loadSpine:chapterIndex atPageIndex:pageIndex];
    
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"pageChange" object:[NSString stringWithFormat:@"%@",chapterIndex]];
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
    NSLog(@"contentView showWithIndex()");
    self.curLable.text =[NSString stringWithFormat:@"%d",aIndex];
    
    NSString *nowIndex = [NSString stringWithFormat:@"%d",aIndex];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"pageChange" object:nowIndex];
    
    int tempSpineIndex = 0;//HTML
    int tempPageIndex = 0;//Page
    
    int perTotalIndex = 0;//temp
    int curTotalIndex = 0;//temp
    for (Chapter* chapter in curBook.chapters) {   
        curTotalIndex += chapter.pageCount;
        
//        NSLog(@"contentview chapter path - >%@",chapter.spinePath);
        
        NSLog(@"Chapter.pageCount --- %d",chapter.pageCount);
        NSLog(@"contentView --> curTotalIndex : %d",curTotalIndex);
        if (aIndex>=perTotalIndex && aIndex<curTotalIndex) {
            tempPageIndex = aIndex - perTotalIndex;
            break;
        }
        perTotalIndex=curTotalIndex;
        tempSpineIndex++;
    }
    NSLog(@"perTotalIndex --- %d",perTotalIndex);
    NSLog(@"curTotalIndex --- %d",curTotalIndex);
    NSLog(@"showWithIndex loadSpine: %d  atPageIndex: %d",tempSpineIndex,tempPageIndex);
    
    [self loadSpine:tempSpineIndex atPageIndex:tempPageIndex]; 
}

//加载分页
- (void) loadSpine:(int)spineIndex atPageIndex:(int)pageIndex {
    NSLog(@"ContentView loadSpine atPageIndex");
    
    curSpineIndex = spineIndex;
    curPageIndex = pageIndex;  
    //添加当前选中的页面
    [[NSUserDefaults standardUserDefaults] setValue:[NSString stringWithFormat:@"%d",curSpineIndex] forKey:@"curSpineIndex"];
    
  //  pageCount, chapterIndex
    Chapter* chapter = [curBook.chapters objectAtIndex:spineIndex];
    
    //[self loadSpine:spineIndex atPageIndex:pageIndex highlightSearchResult:nil];
    NSURL *url = [NSURL fileURLWithPath:chapter.spinePath];
	[curWebView loadRequest:[NSURLRequest requestWithURL:url]];
 
	//currentPageInSpineIndex = pageIndex;
	//currentSpineIndex = spineIndex;
}

- (void) gotoPageInCurrentSpine:(int)pageIndex{ 
    
    NSLog(@"ContentView gotoPageInCurrentSpine");
    NSLog(@"=====第%d页,第%d页", curSpineIndex,curPageIndex);
    
    DebugLog(@"=====第%d页,第%d页", curSpineIndex,curPageIndex);
    
	float pageOffset = 0;
    if (!mf_IsPad || !share.isLandscape) {
        pageOffset = pageIndex*curWebView.bounds.size.width ;
    }
    else{
        pageOffset = pageIndex*curWebView.bounds.size.width + pageIndex *15;
    }
    NSLog(@"gotoPageInCurrentSpine pageOffset -> %f",pageOffset);
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
    NSLog(@"ContentView webViewDidStartLoad");
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
   /* */
    NSLog(@"ContentView webViewDidFinishLoad");
    
    if (!mf_IsPad || !share.isLandscape) {
        NSString *varMySheet = @"var mySheet = document.styleSheets[0];";
        
        NSString *addCSSRule =  @"function addCSSRule(selector, newRule) {"
        "if (mySheet.addRule) {"
        "mySheet.addRule(selector, newRule);"								// For Internet Explorer
        "} else {"
        "ruleIndex = mySheet.cssRules.length;"
        "mySheet.insertRule(selector + '{' + newRule + ';}', ruleIndex);"   // For Firefox, Chrome, etc.
        "}"
        "}";
        
        NSLog(@"================%f,%f",webView.frame.size.height,webView.frame.size.width);
        
        NSString *insertRule1 = [NSString stringWithFormat:@"addCSSRule('html', 'padding: 0px; height: %fpx; -webkit-column-gap: 0px; -webkit-column-width: %fpx;')", webView.frame.size.height, webView.frame.size.width];
        NSString *insertRule2 = [NSString stringWithFormat:@"addCSSRule('p', 'text-align: justify;')"];
        //NSString *setTextSizeRule = [NSString stringWithFormat:@"addCSSRule('body', '-webkit-text-size-adjust: %d%%;')", 94];
        NSString *setHighlightColorRule = [NSString stringWithFormat:@"addCSSRule('highlight', 'background-color: yellow;')"];
        
        //设置页面字体
        //设置页面文字尺寸
        NSString *setTextSizeRule = [NSString stringWithFormat:@"addCSSRule('body', '-webkit-text-size-adjust: %d%%;')",curBook.BodyFontSize];
        NSLog(@"curBook.BodyFontSize --- > %d",curBook.BodyFontSize);

        
        [webView stringByEvaluatingJavaScriptFromString:varMySheet];
        
        [webView stringByEvaluatingJavaScriptFromString:addCSSRule];
        
        [webView stringByEvaluatingJavaScriptFromString:insertRule1];
        
        [webView stringByEvaluatingJavaScriptFromString:insertRule2];
        
        [webView stringByEvaluatingJavaScriptFromString:setTextSizeRule];
        
        [webView stringByEvaluatingJavaScriptFromString:setHighlightColorRule];
        
        //加亮显示搜索的内容
        if(currentSearchResult!=nil){
            //	NSLog(@"Highlighting %@", currentSearchResult.originatingQuery);
            [webView highlightAllOccurencesOfString:currentSearchResult.originatingQuery];
        }
        
        NSString *xml = [webView stringByEvaluatingJavaScriptFromString:@"document.body.innerText"];
//        
        DebugLog(@"+++++++++++++++++%@",xml);
        
        //获取返回页面的总宽度
        int totalWidth = [[webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.scrollWidth"] intValue];
        //计算文件的页数
        int pageCount = totalWidth / webView.bounds.size.width;
        
        NSLog(@"Chapter %d: title: -> 包含：%d pages", curSpineIndex, pageCount);
        
        
    }
    else {  //加载css文件
        NSString *filePath  =  resPath(@"loadRes.js"); 
        NSData *fileData    = [NSData dataWithContentsOfFile:filePath];
        NSString *jsString  = [[NSMutableString alloc] initWithData:fileData encoding:NSUTF8StringEncoding];
        [curWebView stringByEvaluatingJavaScriptFromString:jsString];

        [curWebView stringByEvaluatingJavaScriptFromString:@"loadCss('split')"];
        
    }
    
    [self gotoPageInCurrentSpine:curPageIndex];
    
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    DebugLog(@"%@", @"ttt");
}
@end
