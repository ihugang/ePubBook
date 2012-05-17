//
//  ContentView.m
//  eBook
//
//  Created by loufq on 12-4-17.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ContentView.h"
#import "AllHeader.h"
#import "AppShare.h"
#import "EPub.h"
#import "Chapter.h"
#import "Book.h"
#import "BookMark.h"
#import "BookPick.h"
#import "SearchResult.h"
#import "UIWebView+SearchWebView.h"
#import "Tags.h"
#import "TagsHelper.h"
#import <QuartzCore/QuartzCore.h>

@implementation ContentView
@synthesize curLable,curWebView,currentSearchResult,jquery,menuController,classId,contentText;
- (void)dealloc{
    //释放掉通知
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"searchText" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"pageLoad" object:nil];
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
    self.menuController = [UIMenuController sharedMenuController];
    UIMenuItem *copyMenu = [[UIMenuItem alloc] initWithTitle:@"复制" action:@selector(copyMenuPressed:)];
    UIMenuItem *noteMenu = [[UIMenuItem alloc] initWithTitle:@"书摘" action:@selector(bookPickMenuPressed:)];
    UIMenuItem *bookPickMenu = [[UIMenuItem alloc] initWithTitle:@"批注" action:@selector(commentPressed:)];
    UIMenuItem *removeMenu = [[UIMenuItem alloc] initWithTitle:@"删除" action:@selector(removePressed:)];
    //becomFirstResponder方法，使view或者viewController的self成为第一响应者，可以在相应文件的任意地方调用实现该方法，不过建议与UIMenuController放在一起。
//    [self becomeFirstResponder];
    //设置大小
//    CGRect selectionRect = CGRectMake(100, 100, 100,30);
//    [menuController setTargetRect:selectionRect inView: self.superview];
    
    //设置显示的菜单，默认是第一菜单，要直接显示第二菜单，设置为NO
//    [menuController setMenuVisible:NO animated:YES];
    //菜单项被选中时，菜单会自动隐藏，如果你不想让它自动隐藏
    //    menuController.menuVisible = NO;
    //添加menu到 UIMenuController中
    [menuController setMenuItems:[NSArray arrayWithObjects:copyMenu,noteMenu,bookPickMenu,removeMenu, nil]];
    [menuController setArrowDirection:UIMenuControllerArrowDown];
    
    [copyMenu release];
    [noteMenu release];
    [bookPickMenu release];
    [removeMenu release];
       
//    curWebView.userInteractionEnabled = NO;
    
    //给webView添加UIGestureRecognizer
    UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressWebView:)];
    [self.curWebView addGestureRecognizer:longPressGesture];
//    [longPressGesture release];
    
    //添加通知监听
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pageLoad:) name:@"pageLoad" object:nil];
    //搜索
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(searchPageLoad:) name:@"searchText" object:nil];
    //添加书签
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addBookMark:) name:@"addBookMark" object:nil];
    
}

- (void)longPressWebView:(UILongPressGestureRecognizer *)gestureRecognizer {
    NSLog(@"LONG PRESS");
    if ([gestureRecognizer state] == UIGestureRecognizerStateBegan) {
        [self becomeFirstResponder];
         CGPoint location = [gestureRecognizer locationInView:[gestureRecognizer view]];
         [self.menuController setTargetRect:CGRectMake(location.x, location.y, 0, 0) inView:[gestureRecognizer view]];
        //    CGRect selectionRect = CGRectMake(mouseX, mouseY, 30,20);
        //    [menuController setTargetRect:selectionRect inView: self];
        //设置显示位置  
        //    //        [menuController setTargetRect:self.frame inView: self];
        [self.menuController setMenuVisible:YES animated:YES];
    }
}

//添加书签
- (void)addBookMark:(NSNotification *)notification
{
    //获取书签列表
    [bookMarks getBookMark];
    NSString *npageIndex = [notification object];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *localTime=[formatter stringFromDate: [NSDate date]];
    
    DebugLog(@"addBookMark ----> %d",npageIndex);
    Chapter* chapter = [curBook.chapters objectAtIndex:curSpineIndex];
//    DebugLog(@"title  ---- %@",chapter.title);
    
    //给当前页面添加书签
    NSDictionary *pageIndex = [[NSDictionary alloc] initWithObjectsAndKeys:npageIndex,@"pageIndex",localTime,@"time",chapter.title,@"content", nil];
    [bookMarks.bookmarks setValue:pageIndex forKey:npageIndex];
    
//    DebugLog(@"array ---%@",bookMarks.bookmarks);
    [bookMarks.bookmarks writeToFile:bookMarks.filename atomically:YES];
    
    [formatter release];
}

//字体改变，重新加载页面
- (void)pageLoad:(NSNotification *)notification
{
    NSLog(@"pageLoad --- %d",[[notification object] intValue]);
    NSLog(@"loadSpine curSpineIndex:%d , curPageIndex : %d",curSpineIndex,curPageIndex);
    //重新加载页面
//    [self showWithIndex:curSpineIndex];
    
    //发送通知，就是说此时要调用观察者处的方
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"fontChange" object:[[NSUserDefaults standardUserDefaults] objectForKey:@"curPageIndex"]];
    [self loadSpine:curSpineIndex atPageIndex:curPageIndex];
}

//搜索页面跳转
- (void)searchPageLoad:(NSNotification *)notification
{
    SearchResult *search = [notification object];
    DebugLog(@"searchPageLoad - SearchResult:%@",search);
    self.currentSearchResult = search;
//    [self loadSpine:chapterIndex atPageIndex:pageIndex];
}

//设置-(BOOL) canBecomeFirstResponder的返回值为YES
- (BOOL)canBecomeFirstResponder
{
    [super canBecomeFirstResponder];
    return YES;
}
//重载函数,设置要显示的菜单项，返回值为YES。若不进行任何限制，则将显示系统自带的所有菜单项
- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    [super canPerformAction:action withSender:sender];
    if (action == @selector(copyMenuPressed:)||action == @selector(commentPressed:)||action == @selector(bookPickMenuPressed:)||action == @selector(removePressed:)) {
        return YES;
    }else {
//        [super canPerformAction:action withSender:sender];
        return NO; //隐藏系统默认的菜单项
    }
}
//复制
- (void)copyMenuPressed:(id)sender
{
    //    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    //    [pasteboard setString:[[self textLabel]text]];
    NSLog(@"copyMenuPressed");
}
//书摘
- (void)bookPickMenuPressed:(id)sender
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
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyyMMddHHmmss"];
    NSString *classTime=[formatter stringFromDate: [NSDate date]];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *localTime = [formatter stringFromDate:[NSDate date]];
    NSLog(@"----> %@",localTime);
    
    NSString *className =  [@"uiWebviewHighlight" stringByAppendingFormat:classTime];
    NSString *startSearch   = [NSString stringWithFormat:@"stylizeHighlightedString('%@')",className];
//    NSLog(@"Highlighted -- > %@",startSearch);
    [curWebView stringByEvaluatingJavaScriptFromString:startSearch];
    NSLog(@"noteMenuPressed");
    
    //获取书摘列表
    [bookPick getBookPick];
    
    NSString *npageIndex = [[NSUserDefaults standardUserDefaults] objectForKey:@"curPageIndex"];
    NSLog(@" npageIndex --> %@",npageIndex);
    //给当前页面添加书摘
    NSDictionary *pageIndex = [[NSDictionary alloc] initWithObjectsAndKeys:npageIndex,@"pageIndex",className,@"className",localTime,@"time",highlightedString,@"content", nil];
    [bookPick.currentBookPick setValue:pageIndex forKey:className];
    //写入document文件
    [bookPick.currentBookPick writeToFile:bookPick.filename atomically:YES];
    
    //把html保存到原来的html
    NSString* newHTML = [curWebView stringByEvaluatingJavaScriptFromString:@"document.documentElement.innerHTML"];
    NSLog(@"newHtml text --> %@",newHTML);
    Chapter* chapter = [curBook.chapters objectAtIndex:curSpineIndex];
    //把修改后的文件保存到原来的html
    [newHTML writeToFile:chapter.spinePath atomically:YES encoding:4 error:nil];
    
}
//批注
- (void)commentPressed:(id)sender
{
    NSLog(@"commentPressed");
    UITextView *textView = [[[UITextView alloc] initWithFrame:CGRectMake(self.bounds.size.width/2 - 100, mouseY-10, 200, -100  )] autorelease];
    textView.textColor = [UIColor blackColor];//设置textview里面的字体颜色
    textView.font = [UIFont fontWithName:@"Arial" size:18.0];//设置字体名字和字体大小
    textView.layer.cornerRadius = 6;
    textView.tag = 999;
    textView.layer.masksToBounds = YES;
//    textView.delegate = self;//设置它的委托方法
    textView.editable = YES; //是否可编辑
    [textView becomeFirstResponder];
    textView.backgroundColor = [UIColor orangeColor];//设置它的背景颜色
    textView.returnKeyType = UIReturnKeyDefault;//返回键的类型
    textView.keyboardType = UIKeyboardTypeDefault;//键盘类型
    [self addSubview:textView];
    
}

//删除
- (void)removePressed:(id)sender
{
    DebugLog(@"classname --> %@",classId);
    DebugLog(@"contentText --> %@",contentText);
    if (classId != nil && contentText != nil) {
        NSString* js = [NSString stringWithFormat:@"removetheClass('%@')",classId];
        [curWebView stringByEvaluatingJavaScriptFromString:js];
        NSString* newHTML = [curWebView stringByEvaluatingJavaScriptFromString:@"document.documentElement.innerHTML"];
        NSLog(@"newHtml text --> %@",newHTML);
        
        //获取书摘列表
        //    [bookPick getBookPick];
        //    [bookPick.currentBookPick removeObjectForKey:classId];
        //    //写入document文件
        //    [bookPick.currentBookPick writeToFile:bookPick.filename atomically:YES];
        //    
        //    //把html保存到原来的html
        //    Chapter* chapter = [curBook.chapters objectAtIndex:curSpineIndex];
        //    //把修改后的文件保存到原来的html
        //    [newHTML writeToFile:chapter.spinePath atomically:YES encoding:4 error:nil];
    }else {
        NSLog(@"None to delete!");
    }
}

//删除
- (void)removeAllHighlights
{
    // calls the javascript function to remove html highlights
    [curWebView stringByEvaluatingJavaScriptFromString:@"uiWebview_RemoveAllHighlights()"];
}

-(void)updateInfo:(NSDictionary*)aInfo{
   
}

-(void)showWithIndex:(int)aIndex {
    NSLog(@"contentView showWithIndex()");
    //添加当前浏览的页面
    [[NSUserDefaults standardUserDefaults] setValue:[NSString stringWithFormat:@"%d",aIndex] forKey:@"curPageIndex"];
    [[NSUserDefaults standardUserDefaults] synchronize];//写入数据
    
    self.curLable.text =[NSString stringWithFormat:@"%d",aIndex];
    NSString *nowPageIndex = [NSString stringWithFormat:@"%d",aIndex];
    DebugLog(@"showWithIndex aIndex -- > %@",nowPageIndex);
    [[NSNotificationCenter defaultCenter] postNotificationName:@"pageChange" object:nowPageIndex];
    
    int tempSpineIndex = 0;//HTML
    int tempPageIndex = 0;//Page
    
    int perTotalIndex = 0;//temp
    int curTotalIndex = 0;//temp
    for (Chapter* chapter in curBook.chapters) {   
        curTotalIndex += chapter.pageCount;
        if (aIndex>=perTotalIndex && aIndex<curTotalIndex) {
            tempPageIndex = aIndex - perTotalIndex;
            break;
        }
        perTotalIndex=curTotalIndex;
        tempSpineIndex++;
    }
//    NSLog(@"perTotalIndex --- %d",perTotalIndex);
//    NSLog(@"curTotalIndex --- %d",curTotalIndex);
    NSLog(@"showWithIndex loadSpine: %d  atPageIndex: %d",tempSpineIndex,tempPageIndex);
    
    [self loadSpine:tempSpineIndex atPageIndex:tempPageIndex]; 
}

//加载分页
- (void) loadSpine:(int)spineIndex atPageIndex:(int)pageIndex {
    NSLog(@"ContentView loadSpine atPageIndex");
    
    curSpineIndex = spineIndex;
    curPageIndex = pageIndex;  
    
    //添加当前选中的页面，对应目录列表中当前选中的行
    [[NSUserDefaults standardUserDefaults] setValue:[NSString stringWithFormat:@"%d",curSpineIndex] forKey:@"curSpineIndex"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
  //  pageCount, chapterIndex
    Chapter* chapter = [curBook.chapters objectAtIndex:spineIndex];
    
    //[self loadSpine:spineIndex atPageIndex:pageIndex highlightSearchResult:nil];
    NSURL *url = [NSURL fileURLWithPath:chapter.spinePath];
	[curWebView loadRequest:[NSURLRequest requestWithURL:url]];
}

- (void) gotoPageInCurrentSpine:(int)pageIndex{ 
    
    NSLog(@"ContentView gotoPageInCurrentSpine");
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

//这个方法是网页中的每一个请求都会被触发的 
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    NSLog(@"test -------------》 ");
    NSString *requestString = [[request URL] absoluteString];
	NSArray *components = [requestString componentsSeparatedByString:@":"];
    NSLog(@"requestString --> %@",requestString);

	if ([components count] > 2 && [requestString hasPrefix:@"ibooks:"]) {
		// document.location = "iBooks:" + "tags:" + randomCssClass + ":" + selectText; 
        NSString* clssName =[components objectAtIndex:2];
        NSString* txt =[components objectAtIndex:3]; 
        mouseX = [[components objectAtIndex:4] floatValue];
        mouseY = [[components objectAtIndex:5] floatValue];
        if (txt.length<10) {
            return NO;
        }
        
        self.classId = clssName;
        self.contentText = txt;
//        UIMenuController *theMenu = [UIMenuController sharedMenuController];
       
//        [theMenu setTargetRect:selectionRect inView:self];
//        [theMenu setMenuVisible:YES animated:YES];
        [self becomeFirstResponder];
        CGRect selectionRect = CGRectMake(mouseX, mouseY, 30,20);
        [menuController setTargetRect:selectionRect inView: self];
        //设置显示位置  
//        [menuController setTargetRect:self.frame inView: self];
        [self.menuController setMenuVisible:YES animated:YES];
        
//        [[TagsHelper sharedInstanse] addTagWithClassId:clssName txt:txt];
        //保存html－－
        
//        Chapter* chapter = [curBook.chapters objectAtIndex:curSpineIndex];
//        NSLog(@"now ----> %@",chapter.spinePath);
//        NSString *aa = [NSString stringWithContentsOfFile:chapter.spinePath encoding:NSUTF8StringEncoding error:nil];
        
//        NSString* newHTML = [webView stringByEvaluatingJavaScriptFromString:@"document.body.outerHTML"];//获取页面所有代码
//        NSString* newHTML = [webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.innerHTML"];
//        NSLog(@"newHtml text --> %@",newHTML);
//         NSURL *url = [NSURL fileURLWithPath:chapter.spinePath];
//        [curWebView loadRequest:[NSURLRequest requestWithURL:url]];
//        [curWebView loadHTMLString:newHTML baseURL:url];
//        
//        NSString *filePath  =  resPath(@"loadRes.js"); 
//        NSData *fileData    = [NSData dataWithContentsOfFile:filePath];
//        NSString *jsString  = [[NSMutableString alloc] initWithData:fileData encoding:NSUTF8StringEncoding];
//        [curWebView stringByEvaluatingJavaScriptFromString:jsString];
//        
//        [curWebView stringByEvaluatingJavaScriptFromString:@"loadCss('css_0')"];
//        [curWebView stringByEvaluatingJavaScriptFromString:@"loadCss('css_1')"];
//        [curWebView stringByEvaluatingJavaScriptFromString:@"loadCss('css_2')"];
//        [curWebView stringByEvaluatingJavaScriptFromString:@"loadCss('split')"];
        
//        NSString* path = docPath(@"Res/test.htm");
//        [newHTML writeToFile:chapter.spinePath atomically:YES encoding:4 error:nil];
        NSLog(@"Save---%@",@"");
		return NO;
	}
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
        
//        NSString *xml = [webView stringByEvaluatingJavaScriptFromString:@"document.body.innerText"];
//        
//        DebugLog(@"+++++++++++++++++%@",xml);
        
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
    
    [self inject];
    //加载内容
    NSArray* list =[[TagsHelper sharedInstanse] getTagsInfo];
    for (Tags* tag in list) {
        NSString* js = [NSString stringWithFormat:@"loadBeforeTag('%@')",tag.className];
        [curWebView stringByEvaluatingJavaScriptFromString:js];
    }
    
    [self gotoPageInCurrentSpine:curPageIndex];
    
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    DebugLog(@"%@", @"didFailLoadWithError");
}

- (void) inject{
    if (!injected) {
        [self setupJavascript]; 
    }
    
	if (!injected) {
		[curWebView stringByEvaluatingJavaScriptFromString:jquery];
        [curWebView stringByEvaluatingJavaScriptFromString:@"loadjscssfile('css.css', 'css')"];
		injected = YES; 
	} 
}

- (void) setupJavascript {
    /*
     <script type="text/javascript" src="jquery-1.7.2.js"></script> 
     <script type="text/javascript" src="rangy.js"></script>
     <script type="text/javascript" src="injection.js"></script>
     */
	NSFileManager *fileManager = [NSFileManager defaultManager]; 
    
	NSString *jqueryFilePath =resPath(@"Res/jquery-1.7.2.js");
//    NSLog(@"jqueryFilePath  %@",jqueryFilePath);
    
	BOOL jqueryFileExists = [fileManager fileExistsAtPath:jqueryFilePath];
	if (! jqueryFileExists) {
		NSLog(@"The jquery file does not exist.");
		return;
	} 
    
    NSData *jqueryFileData = [fileManager contentsAtPath:jqueryFilePath];
	NSString *jqueryFileContentsAsString = [[NSString alloc] initWithData:jqueryFileData encoding:NSASCIIStringEncoding]; 
	// injection.js
	NSString *injectionFilePath = resPath(@"Res/rangy.js");
//    NSLog(@"injectionFilePath  %@",injectionFilePath);
	
	BOOL injectionFileExists = [fileManager fileExistsAtPath:injectionFilePath]; 
	if (! injectionFileExists) {
		NSLog(@"The injection file does not exist.");
		return;
	} 
	NSData *injectionFileData = [fileManager contentsAtPath:injectionFilePath];
	NSString *injectionFileContentsAsString = [[NSString alloc] initWithData:injectionFileData encoding:NSASCIIStringEncoding]; 
    
    self.jquery = [jqueryFileContentsAsString stringByAppendingString:injectionFileContentsAsString];
    
    jqueryFileData = [fileManager contentsAtPath:jqueryFilePath];
    jqueryFileContentsAsString = [[NSString alloc] initWithData:jqueryFileData encoding:NSASCIIStringEncoding]; 
	// injection.js
    injectionFilePath = resPath(@"Res/injection.js");
	
	injectionFileExists = [fileManager fileExistsAtPath:injectionFilePath]; 
	if (! injectionFileExists) {
		NSLog(@"The injection file does not exist.");
		return;
	} 
    
    injectionFileData = [fileManager contentsAtPath:injectionFilePath];
    injectionFileContentsAsString = [[NSString alloc] initWithData:injectionFileData encoding:NSASCIIStringEncoding];
    
	// concat the two files
	self.jquery = [self.jquery stringByAppendingString:injectionFileContentsAsString];
}

@end
