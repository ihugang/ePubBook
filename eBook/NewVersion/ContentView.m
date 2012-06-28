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
#import "BookComment.h"
#import "SearchResult.h"
#import "UIWebView+SearchWebView.h"
#import "Tags.h"
#import "TagsHelper.h"
#import <QuartzCore/QuartzCore.h>
#import "CommentVC.h"
#import "ChapterTitlePageView.h"

@implementation ContentView
@synthesize curLable,bookNameLabel,chapterLabel,curWebView,currentSearchResult,jquery,menuController,classId,contentText,rootVC;
- (void)dealloc{
    //释放掉通知
    removeNObserver();
    /*
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"searchText" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"pageLoad" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"addBookMark" object:nil];
     [[NSNotificationCenter defaultCenter] removeObserver:self name:@"removeComment" object:nil];
    */
    
//    [curWebView release];
    [classId release];
    [contentText release];
    [super dealloc];
}
-(void)initLayout{
    // Do any additional setup after loading the view.
    curWebView = [[[UIWebView alloc] init] autorelease];
//    UIImageView *bg = [[[UIImageView alloc] initWithImage:skinImage(@"fontbar/5003.png")] autorelease];
//    [bg setFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
//    [bg setTag:300];
//    if (share.isLandscape) {
//        [self addSubview:bg];
//    }else {
//        [bg removeFromSuperview];
//    }
    
    self.backgroundColor = [UIColor whiteColor];
    //    [webView setBounds:CGRectMake(0, 0, 320, 480)];
//    [curWebView setFrame:CGRectMake(40, 60, self.bounds.size.width, self.bounds.size.height)];
    [curWebView setBackgroundColor:[UIColor clearColor]];//设置背景颜色
    [curWebView setOpaque:NO];//设置透明
    [curWebView setDelegate:self];
    [curWebView setTag:302];
    [curWebView setAutoresizesSubviews:YES];
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
    
//    curWebView2 = [[[UIWebView alloc] init] autorelease];
//    
//    //    [webView setBounds:CGRectMake(0, 0, 320, 480)];
//    //    [curWebView setFrame:CGRectMake(40, 60, self.bounds.size.width, self.bounds.size.height)];
//    [curWebView2 setBackgroundColor:[UIColor grayColor]];//设置背景颜色
//    [curWebView2 setOpaque:NO];//设置透明
//    [curWebView2 setDelegate:self];
//    [curWebView2 setTag:301];
//    [curWebView2 setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin];
//    //    [self.view addSubview:webView];
//    //去除webview中的scrollview
//	for (UIView* v in  curWebView2.subviews) {
//		if([v isKindOfClass:[UIScrollView class]]){
//			sv = (UIScrollView*) v;
//			sv.scrollEnabled = NO;//禁止滚动和回弹
//			sv.bounces = NO;//禁止滚动
//		}
//	}
//    [self addSubview:curWebView2];
    
    UIColor *myColor = [UIColor colorWithRed:94.0/255.0 green:38.0/255.0 blue:18.0/255.0 alpha:1.0];
    
    self.bookNameLabel = [[[UILabel alloc] init] autorelease];
    [self.bookNameLabel setText:@"怎样在澳门靠玩德州扑克每天赚一万港币 1"];
    [self.bookNameLabel setTextColor:myColor];
    [self.bookNameLabel setBackgroundColor:[UIColor clearColor]];
    [self addSubview:bookNameLabel];
    
    self.chapterLabel = [[[UILabel alloc] init] autorelease];
    [self.chapterLabel setTextAlignment:UITextAlignmentCenter];
    [self.chapterLabel setTextColor:myColor];
    [self.chapterLabel setBackgroundColor:[UIColor clearColor]];
    [self addSubview:chapterLabel];
 
    if (mf_IsPad) {
        
        [curWebView setFrame:CGRectMake(40, 50, self.bounds.size.width-80, self.bounds.size.height-90)];
        [self.bookNameLabel setFrame:CGRectMake(curWebView.left, 10, self.bounds.size.width, 44)];
        [self.bookNameLabel setFont:[UIFont boldSystemFontOfSize:15]];
        [self.chapterLabel setFrame:CGRectMake(0, curWebView.bottom - 5, self.bounds.size.width, 44)];
        [self.chapterLabel setFont:[UIFont boldSystemFontOfSize:15]];
//        if (share.isLandscape) {
//            [curWebView setFrame:CGRectMake(40, 50, (self.bounds.size.width-80)/2.0-20, self.bounds.size.height-90)];
//            [curWebView2 setFrame:CGRectMake(curWebView.right+40, 50, (self.bounds.size.width-80)/2.0-20, self.bounds.size.height-90)];
//            NSLog(@"------------landscape");
//            //            
//        }
        
    }else {
        //        [curWebView2 removeFromSuperview];
        //        [bg removeFromSuperview];
        [curWebView setFrame:CGRectMake(10, 35, self.bounds.size.width-20, self.bounds.size.height-60)];
        [self.bookNameLabel setFrame:CGRectMake(curWebView.left, -5, self.bounds.size.width, 44)];
        [self.bookNameLabel setFont:[UIFont boldSystemFontOfSize:12]];
        [self.chapterLabel setFont:[UIFont boldSystemFontOfSize:12]];
        [self.chapterLabel setFrame:CGRectMake(0, curWebView.bottom - 15, self.bounds.size.width, 44)];
    }

    
    self.curLable = [[[UILabel alloc] init] autorelease];
    self.curLable.font = [UIFont boldSystemFontOfSize:12];
    self.curLable.textColor = myColor;
    self.curLable.textAlignment = UITextAlignmentCenter;
    self.curLable.backgroundColor =[UIColor clearColor];
    
    [self addSubview:curLable];
    
    if (share.isLandscape&&mf_IsPad) {
       // [self.curLable setFrame:CGRectMake(self.curWebView2.right - 40, self.self.chapterLabel.top, 50, 44)];
    }else {
        [self.curLable setFrame:CGRectMake(self.curWebView.right - 40, self.self.chapterLabel.top, 50, 44)];
    }
    
    //给页面添加UIMenuController
    self.menuController = [UIMenuController sharedMenuController];
//    UIMenuItem *copyMenu = [[UIMenuItem alloc] initWithTitle:@"复制" action:@selector(copyMenuPressed:)];
    UIMenuItem *noteMenu = [[UIMenuItem alloc] initWithTitle:@"书摘" action:@selector(bookPickMenuPressed:)];
    UIMenuItem *bookPickMenu = [[UIMenuItem alloc] initWithTitle:@"批注" action:@selector(commentPressed:)];
    UIMenuItem *removeMenu = [[UIMenuItem alloc] initWithTitle:@"删除" action:@selector(removePressed:)];
    //becomFirstResponder方法，使view或者viewController的self成为第一响应者，可以在相应文件的任意地方调用实现该方法，不过建议与UIMenuController放在一起。
//    [self becomeFirstResponder];
    //设置大小
//    CGRect selectionRect = CGRectMake(310, 100, 100,30);
//    [menuController setTargetRect:selectionRect inView: self.superview];
    
    //设置显示的菜单，默认是第一菜单，要直接显示第二菜单，设置为NO
    [menuController setMenuVisible:NO animated:YES];
    //菜单项被选中时，菜单会自动隐藏，如果你不想让它自动隐藏
//    menuController.menuVisible = YES;
    //添加menu到 UIMenuController中
    [menuController setMenuItems:[NSArray arrayWithObjects:noteMenu,bookPickMenu,removeMenu, nil]];
    [menuController setArrowDirection:UIMenuControllerArrowDown];
    
    
    DebugLog(@"webview width: %f, height: %f",self.curWebView.bounds.size.width,self.curWebView.bounds.size.height);
    
//    [copyMenu release];
    [noteMenu release];
    [bookPickMenu release];
    [removeMenu release];
       
//    curWebView.userInteractionEnabled = NO;
    
    //给webView添加UIGestureRecognizer
//    UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressWebView:)];
//    [self.curWebView addGestureRecognizer:longPressGesture];
//    [longPressGesture release];
    
    //添加通知监听
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pageLoad:) name:@"pageLoad" object:nil];
    //搜索
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(searchPageLoad:) name:@"searchText" object:nil];
    //添加书签
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addBookMark:) name:@"addBookMark" object:nil];
    //监听删除批注
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeComment:) name:@"removeComment" object:nil];
    
}

//删除书摘
- (void)removeComment:(NSNotification *)notification
{
    NSString *className = [notification object];
    //获取书摘列表
    [bookPick getBookPick];
    //如果在书摘列表中没有当前的class,可以取消高亮显示
    if ([bookPick.currentBookPick objectForKey:className] == nil) {
        NSString* js = [NSString stringWithFormat:@"removetheClass('%@')",className];
        [curWebView stringByEvaluatingJavaScriptFromString:js];
        NSString* newHTML = [curWebView stringByEvaluatingJavaScriptFromString:@"document.documentElement.innerHTML"];
        NSLog(@"newHtml text --> %@",newHTML);
        
        //把html保存到原来的html
        Chapter* chapter = [curBook.chapters objectAtIndex:curSpineIndex];
        DebugLog(@"spinpath-- %@",chapter.spinePath);
        //把修改后的文件保存到原来的html
        [newHTML writeToFile:chapter.spinePath atomically:YES encoding:4 error:nil];
    }
    
}

- (void)longPressWebView:(UILongPressGestureRecognizer *)gestureRecognizer {
    NSLog(@"LONG PRESS");
    if ([gestureRecognizer state] == UIGestureRecognizerStateBegan) {
        [self becomeFirstResponder];
         CGPoint location = [gestureRecognizer locationInView:[gestureRecognizer view]];
         [self.menuController setTargetRect:CGRectMake(0, location.y, 320, 0) inView:[gestureRecognizer view]];
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
//    [bookMarks getBookMark];
    NSString *npageIndex = [notification object];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *localTime=[formatter stringFromDate: [NSDate date]];
    
    DebugLog(@"addBookMark ----> %@",npageIndex);
    Chapter* chapter = [curBook.chapters objectAtIndex:curSpineIndex];
//    DebugLog(@"title  ---- %@",chapter.title);
    
//    DebugLog(@"----> %@",curBook.Pages);
    //获取当前页面的p index 和 Auto Index
    NSString *nowParaIndex = [[curBook.Pages objectAtIndex:curPageIndex] objectForKey:@"ParaIndex"];
    NSString *nowAtomIndex = [[curBook.Pages objectAtIndex:curPageIndex] objectForKey:@"AtomIndex"];
    DebugLog(@"addBookMark ---->P: %@   a: %@",nowParaIndex,nowAtomIndex);
    
    NSString *iphone_min = [curBook getPIndex:@"iPhone_2@2x.plist" pChapter:curSpineIndex pIndex:nowParaIndex aIndex:nowAtomIndex];
    NSString *iphone_mid = [curBook getPIndex:@"iPhone_2@2x36.plist" pChapter:curSpineIndex pIndex:nowParaIndex aIndex:nowAtomIndex];
    NSString *iphone_max = [curBook getPIndex:@"iPhone_2@2x44.plist" pChapter:curSpineIndex pIndex:nowParaIndex aIndex:nowAtomIndex];
    DebugLog(@"min:%@  mid:%@ max:%@",iphone_min,iphone_mid,iphone_max);
    
    [bookMarks getBookMark:iphone_minBookMark];
    //给当前页面添加书签
    NSDictionary *pageIndex = [[[NSDictionary alloc] initWithObjectsAndKeys:iphone_min,@"pageIndex",localTime,@"time",chapter.title,@"content", nil] autorelease];
    [bookMarks.bookmarks setValue:pageIndex forKey:iphone_min];
    [bookMarks.bookmarks writeToFile:bookMarks.filename atomically:YES];
    
    [bookMarks getBookMark:iphone_middleBookMark];
    pageIndex = [[[NSDictionary alloc] initWithObjectsAndKeys:iphone_mid,@"pageIndex",localTime,@"time",chapter.title,@"content", nil] autorelease];
    [bookMarks.bookmarks setValue:pageIndex forKey:iphone_mid];
    [bookMarks.bookmarks writeToFile:bookMarks.filename atomically:YES];
    
    [bookMarks getBookMark:iphone_maxBookMark];
    pageIndex = [[[NSDictionary alloc] initWithObjectsAndKeys:iphone_max,@"pageIndex",localTime,@"time",chapter.title,@"content", nil] autorelease];
    [bookMarks.bookmarks setValue:pageIndex forKey:iphone_max];
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
//    [super canBecomeFirstResponder];
    return YES;
}
//重载函数,设置要显示的菜单项，返回值为YES。若不进行任何限制，则将显示系统自带的所有菜单项
- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
//    [super canPerformAction:action withSender:sender];
    if (/*action == @selector(copyMenuPressed:)||*/action == @selector(commentPressed:)||
        action == @selector(bookPickMenuPressed:)||action == @selector(removePressed:)) {
        return YES;
    }
    else if (action == @selector(copy:))
    {
        return NO;
    }
//    return NO; //隐藏系统默认的菜单项
    return [super canPerformAction:action withSender:sender];
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
    if (self.classId != nil && self.contentText != nil) {
        self.classId = nil;
        self.contentText = nil;
        DebugLog(@"not nil!");
    }else {
        //加载js文件
        NSString *filePath  =  resPath(@"HighlightedString.js");
        
        NSLog(@"filepath:%@",filePath);
        NSData *fileData    = [NSData dataWithContentsOfFile:filePath];
        NSString *jsString  = [[[NSMutableString alloc] initWithData:fileData encoding:NSUTF8StringEncoding] autorelease];
        [curWebView stringByEvaluatingJavaScriptFromString:jsString];
        
        // 获取选取的文本
        NSString *startSearch1   = [NSString stringWithFormat:@"getHighlightedString()"];
        [curWebView stringByEvaluatingJavaScriptFromString:startSearch1];
        
        NSString *selectedText   = [NSString stringWithFormat:@"selectedText"];
        NSString * highlightedString = [curWebView stringByEvaluatingJavaScriptFromString:selectedText];
        NSLog(@"selectedTextString: ---  > %@",highlightedString);
        
        NSString *getPIndex = [NSString stringWithFormat:@"pIndex"];
        NSString *pIndex = [curWebView stringByEvaluatingJavaScriptFromString:getPIndex];
        DebugLog(@"pIndex ----> %@",pIndex);
        
        
        // 把选中的文本样式改变
        NSDateFormatter *formatter = [[[NSDateFormatter alloc] init] autorelease];
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
        
        NSString *npageIndex = [[NSUserDefaults standardUserDefaults] objectForKey:@"currentPageIndex"];
        NSLog(@" npageIndex --> %@",npageIndex);
        //给当前页面添加书摘
        NSDictionary *pageIndex = [[[NSDictionary alloc] initWithObjectsAndKeys:npageIndex,@"pageIndex",className,@"className",localTime,@"time",highlightedString,@"content", nil] autorelease];
        [bookPick.currentBookPick setValue:pageIndex forKey:className];
        //写入document文件
        [bookPick.currentBookPick writeToFile:bookPick.filename atomically:YES];
        
//        #warning loufq tips how to fix page index
        //1.获取HTML页面－－－第几个HTML
        
        //2.获取当前字体大小设置
        
        //3.根据js获取当前字所在的第几个P
        
        //4.在该P中第几个字－－初略获取当前class在html中的位置
        
        //5.找出所在对应的页面找到另外字体大小所在的对应页数
        
        //6.保存到三个字体对应plist。（iphone3个，ipad6个）
        
        
        //把html保存到原来的html
        NSString* newHTML = [curWebView stringByEvaluatingJavaScriptFromString:@"document.documentElement.innerHTML"];
        NSLog(@"newHtml text --> %@",newHTML);
        Chapter* chapter = [curBook.chapters objectAtIndex:curSpineIndex];
        //把修改后的文件保存到原来的html
        [newHTML writeToFile:chapter.spinePath atomically:YES encoding:4 error:nil];
    }
}

//批注
- (void)commentPressed:(id)sender
{
    // 把选中的文本样式改变
    NSDateFormatter *formatter = [[[NSDateFormatter alloc] init] autorelease];
    [formatter setDateFormat:@"yyyyMMddHHmmss"];
    NSString *classTime=[formatter stringFromDate: [NSDate date]];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *localTime = [formatter stringFromDate:[NSDate date]];
    NSLog(@"----> %@",localTime);
    
    CommentVC *comment = [[[CommentVC alloc] init] autorelease];
//    NSLog(@"commentPressed");
    if (self.classId != nil && self.contentText != nil) {
        //调用添加批注的页面
        [self.rootVC presentModalViewController:comment animated:YES];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"comment" object:classId];
        
        //获取批注列表
        [bookComment getBookComment];
        
        NSString *npageIndex = [[NSUserDefaults standardUserDefaults] objectForKey:@"currentPageIndex"];
        NSLog(@" npageIndex --> %@",npageIndex);
        //给当前页面添加书摘
        NSDictionary *pageIndex = [[[NSDictionary alloc] initWithObjectsAndKeys:npageIndex,@"pageIndex",self.classId,@"className",localTime,@"time",self.contentText,@"content", nil] autorelease];
        [bookComment.currentBookComment setValue:pageIndex forKey:classId];
        //写入document文件
        [bookComment.currentBookComment writeToFile:bookComment.filename atomically:YES];
        
        self.classId = nil;
        self.contentText = nil;
        DebugLog(@"not nil!");
    }else {
        //加载js文件
        NSString *filePath  =  resPath(@"HighlightedString.js");
        NSLog(@"filepath:%@",filePath);
        NSData *fileData    = [NSData dataWithContentsOfFile:filePath];
        NSString *jsString  = [[[NSMutableString alloc] initWithData:fileData encoding:NSUTF8StringEncoding] autorelease];
        [curWebView stringByEvaluatingJavaScriptFromString:jsString];
        
        // 获取选取的文本
        NSString *startSearch1   = [NSString stringWithFormat:@"getHighlightedString()"];
        [curWebView stringByEvaluatingJavaScriptFromString:startSearch1];
        
        NSString *selectedText   = [NSString stringWithFormat:@"selectedText"];
        NSString * highlightedString = [curWebView stringByEvaluatingJavaScriptFromString:selectedText];
        NSLog(@"selectedTextString: ---  > %@",highlightedString);
    
        
        NSString *className =  [@"uiWebviewHighlight" stringByAppendingFormat:classTime];
        NSString *startSearch   = [NSString stringWithFormat:@"stylizeHighlightedString('%@')",className];
        //    NSLog(@"Highlighted -- > %@",startSearch);
        [curWebView stringByEvaluatingJavaScriptFromString:startSearch];
        NSLog(@"noteMenuPressed");
        
        //调用添加批注的页面
        [self.rootVC presentModalViewController:comment animated:YES];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"comment" object:className];
        
        //获取批注列表
        [bookComment getBookComment];
        
        NSString *npageIndex = [[NSUserDefaults standardUserDefaults] objectForKey:@"currentPageIndex"];
        NSLog(@" npageIndex --> %@",npageIndex);
        //给当前页面添加书摘
        NSDictionary *pageIndex = [[[NSDictionary alloc] initWithObjectsAndKeys:npageIndex,@"pageIndex",className,@"className",localTime,@"time",highlightedString,@"content", nil] autorelease];
        [bookComment.currentBookComment setValue:pageIndex forKey:className];
        //写入document文件
        [bookComment.currentBookComment writeToFile:bookComment.filename atomically:YES];
        
        //把html保存到原来的html
        NSString* newHTML = [curWebView stringByEvaluatingJavaScriptFromString:@"document.documentElement.innerHTML"];
        NSLog(@"newHtml text --> %@",newHTML);
        Chapter* chapter = [curBook.chapters objectAtIndex:curSpineIndex];
        //把修改后的文件保存到原来的html
        [newHTML writeToFile:chapter.spinePath atomically:YES encoding:4 error:nil];
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"asdfasdf");
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"end");
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
        [bookPick getBookPick];
        [bookPick.currentBookPick removeObjectForKey:classId];
        //写入document文件
        [bookPick.currentBookPick writeToFile:bookPick.filename atomically:YES];
        
        //获取批注列表
        [bookComment getBookComment];
        [bookComment.currentBookComment removeObjectForKey:classId];
        //写入documen
        [bookComment.currentBookComment writeToFile:bookComment.filename atomically:YES];
        
//        DebugLog(@"-- %@",bookPick.currentBookPick);
        //    
        //把html保存到原来的html
        Chapter* chapter = [curBook.chapters objectAtIndex:curSpineIndex];
        DebugLog(@"spinpath-- %@",chapter.spinePath);
        //把修改后的文件保存到原来的html
        [newHTML writeToFile:chapter.spinePath atomically:YES encoding:4 error:nil];
        
        self.classId = nil;
        self.contentText = nil;
        
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
    if (isLoyoutDebug) {
        NSLog(@"contentView showWithIndex()");     
        DebugLog(@"now page Index ----> %@",[[NSUserDefaults standardUserDefaults] objectForKey:@"currentPageIndex"]);
    }

    self.curLable.text =[NSString stringWithFormat:@"%d",aIndex];
    NSString *nowPageIndex = [[NSUserDefaults standardUserDefaults] objectForKey:@"currentPageIndex"];
    if (isLoyoutDebug) {
        DebugLog(@"showWithIndex aIndex -- > %d",aIndex);     
    }
    
    //发送检查页面是否添加书签
    [[NSNotificationCenter defaultCenter] postNotificationName:@"pageChange" object:nowPageIndex];
    [[NSUserDefaults standardUserDefaults] setValue:nowPageIndex forKey:@"curPageIndex"];
    [[NSUserDefaults standardUserDefaults] synchronize];//写入数据
    
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
    if (isLoyoutDebug) {
        NSLog(@"showWithIndex loadSpine: %d  atPageIndex: %d",tempSpineIndex,tempPageIndex);    
    }
    
    //等于0，加载页面扉页
    if (tempPageIndex == 0) {
        ChapterTitlePageView *titlePage = [[[ChapterTitlePageView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)] autorelease];
        [self addSubview:titlePage];
        
        Chapter* chapter = [curBook.chapters objectAtIndex:tempSpineIndex];
        NSRange range = [chapter.title rangeOfString:@"章"]; 
        if(range.location != NSNotFound) 
        { 
            titlePage.chapterIndex.text = [chapter.title substringToIndex:range.location+1];
            titlePage.chapterName.text = [chapter.title substringFromIndex:range.location+1];
        }else {
             titlePage.chapterIndex.text = chapter.title;
        }
    }else {
        [self loadSpine:tempSpineIndex atPageIndex:tempPageIndex-1];
    }
    
    //添加当前选中的页面，对应目录列表中当前选中的行
    [[NSUserDefaults standardUserDefaults] setValue:[NSString stringWithFormat:@"%d",tempSpineIndex] forKey:@"curSpineIndex"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

//加载分页
- (void) loadSpine:(int)spineIndex atPageIndex:(int)pageIndex {
    NSLog(@"ContentView loadSpine atPageIndex");
    
    curSpineIndex = spineIndex;
    curPageIndex = pageIndex; 
    
    //  pageCount, chapterIndex
    Chapter* chapter = [curBook.chapters objectAtIndex:spineIndex];
    //[self loadSpine:spineIndex atPageIndex:pageIndex highlightSearchResult:nil];
    NSURL *url = [NSURL fileURLWithPath:chapter.spinePath];
    [curWebView loadRequest:[NSURLRequest requestWithURL:url]];
    //[curWebView2 loadRequest:[NSURLRequest requestWithURL:url]];
    self.chapterLabel.text = chapter.title;
    
//    [self gotoPageInCurrentSpine:curPageIndex];
}

- (void) gotoPageInCurrentSpine:(int)pageIndex{ 
    
    NSLog(@"ContentView gotoPageInCurrentSpine");
    DebugLog(@"=====spine:%d, curpage:%d", curSpineIndex,curPageIndex);
    
	float pageOffset = 0;
    float pageOffset2 = 0;
    if (!mf_IsPad || !share.isLandscape) {
        pageOffset = pageIndex*curWebView.bounds.size.width ;
    }
    else{
//        pageOffset = pageIndex*curWebView.bounds.size.width + pageIndex *15;
        pageOffset = pageIndex*curWebView.bounds.size.width;
        pageOffset2 = (pageIndex+1)*curWebView.bounds.size.width;
    }
    NSLog(@"gotoPageInCurrentSpine pageOffset -> %f",pageOffset);
    //设置页面依X轴来滚动
	NSString* goToOffsetFunc = [NSString stringWithFormat:@" function pageScroll(xOffset){ window.scroll(xOffset,0); } "];
	NSString* goTo =[NSString stringWithFormat:@"pageScroll(%f)", pageOffset]; 
	[curWebView stringByEvaluatingJavaScriptFromString:goToOffsetFunc];
	[curWebView stringByEvaluatingJavaScriptFromString:goTo];
    
//    NSString* goTo2 =[NSString stringWithFormat:@"pageScroll(%f)", pageOffset2]; 
//    [curWebView2 stringByEvaluatingJavaScriptFromString:goToOffsetFunc];
//	[curWebView2 stringByEvaluatingJavaScriptFromString:goTo2];
   
	curWebView.hidden = NO;
    //curWebView2.hidden = NO;
}

//这个方法是网页中的每一个请求都会被触发的 
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    NSString *requestString = [[request URL] absoluteString];
	NSArray *components = [requestString componentsSeparatedByString:@":"];
    NSLog(@"requestString --> %@",requestString);

	if ([components count] > 2 && [requestString hasPrefix:@"ibooks:"]) {
		// document.location = "iBooks:" + "tags:" + randomCssClass + ":" + selectText; 
        NSString* clssName =[components objectAtIndex:2];
        NSString* txt =[components objectAtIndex:3]; 
        mouseX = [[components objectAtIndex:4] floatValue];
        mouseY = [[components objectAtIndex:5] floatValue];
        //中文乱码转换
        NSString *string = [txt stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        if (txt.length<10) {
            return NO;
        }
        self.classId = clssName;
        self.contentText = string;
//        UIMenuController *theMenu = [UIMenuController sharedMenuController];
       
//        [theMenu setTargetRect:selectionRect inView:self];
//        [theMenu setMenuVisible:YES animated:YES];
        
        DebugLog(@"string ----> %@",string);
        
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
    
    
        NSString *varMySheet = @"var mySheet = document.styleSheets[0];";
        
        NSString *addCSSRule =  @"function addCSSRule(selector, newRule) {"
        "if (mySheet.addRule) {"
        "mySheet.addRule(selector, newRule);"								// For Internet Explorer
        "} else {"
        "ruleIndex = mySheet.cssRules.length;"
        "mySheet.insertRule(selector + '{' + newRule + ';}', ruleIndex);"   // For Firefox, Chrome, etc.
        "}"
        "}";
        
        NSLog(@"webViewDidFinishLoad=========%f,%f",webView.frame.size.height,webView.frame.size.width);
        
        NSString *insertRule1 = [NSString stringWithFormat:@"addCSSRule('html', 'padding: 0px; height: %fpx; -webkit-column-gap: 0px; -webkit-column-width: %fpx;')", webView.frame.size.height, webView.frame.size.width];
        NSString *insertRule2 = [NSString stringWithFormat:@"addCSSRule('p', 'text-align: justify;')"];
        //NSString *setTextSizeRule = [NSString stringWithFormat:@"addCSSRule('body', '-webkit-text-size-adjust: %d%%;')", 94];
        NSString *setHighlightColorRule = [NSString stringWithFormat:@"addCSSRule('highlight', 'background-color: yellow;')"];
        
        //设置页面字体
        //设置页面文字尺寸
        NSString *setTextSizeRule = [NSString stringWithFormat:@"addCSSRule('body', '-webkit-text-size-adjust: %d%%;')",curBook.BodyFontSize];
        NSLog(@"curBook.BodyFontSize --- > %d",curBook.BodyFontSize);
        //设置页面不能选择文本
//        [webView stringByEvaluatingJavaScriptFromString:@"document.body.style.webkitTouchCallout='none';"];
//        [webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitTouchCallout='none';"];
        
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
//    if (!mf_IsPad || !share.isLandscape) { 
//        
//    }
//    else {  //加载css文件
//        NSString *filePath  =  resPath(@"loadRes.js"); 
//        NSData *fileData    = [NSData dataWithContentsOfFile:filePath];
//        NSString *jsString  = [[[NSMutableString alloc] initWithData:fileData encoding:NSUTF8StringEncoding] autorelease];
//        DebugLog(@"-----------> %@",jsString);
//        [curWebView stringByEvaluatingJavaScriptFromString:jsString];
//
//        [curWebView stringByEvaluatingJavaScriptFromString:@"loadCss('split')"];
//        
//    }
    
    [self inject];
    //加载内容
//    NSArray* list =[[TagsHelper sharedInstanse] getTagsInfo];
//    for (Tags* tag in list) {
//        NSString* js = [NSString stringWithFormat:@"loadBeforeTag('%@')",tag.className];
//        [curWebView stringByEvaluatingJavaScriptFromString:js];
//    }
    
    [self gotoPageInCurrentSpine:curPageIndex];
//    if (webView == curWebView){
//        
//    }
//    if (webView == curWebView2)
//    {
//        [self gotoPageInCurrentSpine:curPageIndex+1];
//    }
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
	NSString *jqueryFileContentsAsString = [[[NSString alloc] initWithData:jqueryFileData encoding:NSASCIIStringEncoding] autorelease]; 
	// injection.js
	NSString *injectionFilePath = resPath(@"Res/rangy.js");
//    NSLog(@"injectionFilePath  %@",injectionFilePath);
	
	BOOL injectionFileExists = [fileManager fileExistsAtPath:injectionFilePath]; 
	if (! injectionFileExists) {
		NSLog(@"The injection file does not exist.");
		return;
	} 
	NSData *injectionFileData = [fileManager contentsAtPath:injectionFilePath];
	NSString *injectionFileContentsAsString = [[[NSString alloc] initWithData:injectionFileData encoding:NSASCIIStringEncoding] autorelease]; 
    
    self.jquery = [jqueryFileContentsAsString stringByAppendingString:injectionFileContentsAsString];
    
//    jqueryFileData = [fileManager contentsAtPath:jqueryFilePath];
//    jqueryFileContentsAsString = [[[NSString alloc] initWithData:jqueryFileData encoding:NSASCIIStringEncoding] autorelease]; 
	// injection.js
    injectionFilePath = resPath(@"Res/injection.js");
	
	injectionFileExists = [fileManager fileExistsAtPath:injectionFilePath]; 
	if (! injectionFileExists) {
		NSLog(@"The injection file does not exist.");
		return;
	} 
    
    injectionFileData = [fileManager contentsAtPath:injectionFilePath];
    injectionFileContentsAsString = [[[NSString alloc] initWithData:injectionFileData encoding:NSASCIIStringEncoding] autorelease];
    
	// concat the two files
	self.jquery = [self.jquery stringByAppendingString:injectionFileContentsAsString];
}

@end
