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
@synthesize currentSearchResult = _currentSearchResult,jquery = _jquery,classId = _classId,contentText = _contentText;
@synthesize curWebView = _curWebView,curLable = _curLable,bookNameLabel = _bookNameLabel,chapterLabel = _chapterLabel;
@synthesize menuController = _menuController,rootVC = _rootVC,hud = _hud;

- (void)dealloc{
    //释放掉通知
    removeNObserver();
    /*
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"searchText" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"pageLoad" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"addBookMark" object:nil];
     [[NSNotificationCenter defaultCenter] removeObserver:self name:@"removeComment" object:nil];
    */
    
    [_currentSearchResult release];_currentSearchResult = nil;
    [_jquery release];_jquery = nil;
    [_classId release];_classId = nil;
    [_contentText release];_contentText = nil;
    [super dealloc];
}
-(void)initLayout{
    // Do any additional setup after loading the view.
    self.curWebView = [[[UIWebView alloc] init] autorelease];
    
//    [self inject];
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
    [_curWebView setBackgroundColor:[UIColor clearColor]];//设置背景颜色
    [_curWebView setOpaque:NO];//设置透明
    [_curWebView setDelegate:self];
    [_curWebView setTag:302];
    [_curWebView setAutoresizesSubviews:YES];
    [_curWebView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin];
    [self addSubview:_curWebView]; 
    [_curWebView setDebug:NO];
    
    //去除webview中的scrollview
    UIScrollView* sv = nil;
	for (UIView* v in  _curWebView.subviews) {
		if([v isKindOfClass:[UIScrollView class]]){
			sv = (UIScrollView*) v;
			sv.scrollEnabled = NO;//禁止滚动和回弹
			sv.bounces = NO;//禁止滚动
		}
	}
    
    self.hud =[MBProgressHUD showHUDAddedTo:self animated:YES];
    [_hud setLabelText:@"Loading....."];
    [_curWebView setHidden:YES];
    
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
    [_bookNameLabel setText:@"怎样在澳门靠玩德州扑克每天赚一万港币 1"];
    [_bookNameLabel setTextColor:myColor];
    [_bookNameLabel setBackgroundColor:[UIColor clearColor]];
    [self addSubview:_bookNameLabel];
    
    self.chapterLabel = [[[UILabel alloc] init] autorelease];
    [_chapterLabel setTextAlignment:UITextAlignmentCenter];
    [_chapterLabel setTextColor:myColor];
    [_chapterLabel setBackgroundColor:[UIColor clearColor]];
    [self addSubview:_chapterLabel];
 
    if (mf_IsPad) {
        
        [_curWebView setFrame:CGRectMake(40, 50, self.bounds.size.width-80, self.bounds.size.height-90)];
        [_bookNameLabel setFrame:CGRectMake(_curWebView.left, 10, self.bounds.size.width, 44)];
        [_bookNameLabel setFont:[UIFont boldSystemFontOfSize:15]];
        [_chapterLabel setFrame:CGRectMake(0, _curWebView.bottom - 5, self.bounds.size.width, 44)];
        [_chapterLabel setFont:[UIFont boldSystemFontOfSize:15]];
//        if (share.isLandscape) {
//            [curWebView setFrame:CGRectMake(40, 50, (self.bounds.size.width-80)/2.0-20, self.bounds.size.height-90)];
//            [curWebView2 setFrame:CGRectMake(curWebView.right+40, 50, (self.bounds.size.width-80)/2.0-20, self.bounds.size.height-90)];
//            NSLog(@"------------landscape");
//            //            
//        }
        
    }else {
        //        [curWebView2 removeFromSuperview];
        //        [bg removeFromSuperview];
//        DebugLog(@"====== w: %f  =====  h:%f",self.bounds.size.width,self.bounds.size.height);
        [_curWebView setFrame:CGRectMake(10, 35, self.bounds.size.width-20, self.bounds.size.height-60)];
        [_bookNameLabel setFrame:CGRectMake(_curWebView.left, -5, self.bounds.size.width, 44)];
        [_bookNameLabel setFont:[UIFont boldSystemFontOfSize:12]];
        [_chapterLabel setFrame:CGRectMake(0, _curWebView.bottom - 15, self.bounds.size.width, 44)];
        [_chapterLabel setFont:[UIFont boldSystemFontOfSize:12]];
    }

    
    self.curLable = [[[UILabel alloc] init] autorelease];
    _curLable.font = [UIFont boldSystemFontOfSize:12];
    _curLable.textColor = myColor;
    _curLable.textAlignment = UITextAlignmentCenter;
    _curLable.backgroundColor =[UIColor clearColor];
    [self addSubview:_curLable];
    
    if (share.isLandscape&&mf_IsPad) {
       // [self.curLable setFrame:CGRectMake(self.curWebView2.right - 40, self.self.chapterLabel.top, 50, 44)];
    }else {
        [_curLable setFrame:CGRectMake(_curWebView.right - 40, _chapterLabel.top, 50, 44)];
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
    [_menuController setMenuVisible:NO animated:YES];
    //菜单项被选中时，菜单会自动隐藏，如果你不想让它自动隐藏
//    menuController.menuVisible = YES;
    //添加menu到 UIMenuController中
    [_menuController setMenuItems:[NSArray arrayWithObjects:noteMenu,bookPickMenu,removeMenu, nil]];
    [_menuController setArrowDirection:UIMenuControllerArrowDown];
    
    
    DebugLog(@"webview width: %f, height: %f",_curWebView.bounds.size.width,_curWebView.bounds.size.height);
    
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
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pageLoad:) name:@"pageLoad" object:nil];
    //搜索
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(searchPageLoad:) name:@"searchText" object:nil];
    //添加书签
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addBookMark:) name:@"addBookMark" object:nil];
    //监听删除批注
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeComment:) name:@"removeComment" object:nil];
    
}

//删除书摘
- (void)removeComment:(NSNotification *)notification
{
    NSString *className = [notification object];
    //获取书摘列表
    switch (curBook.BodyFontSize) {
        case 100:
            [bookPick getBookPick:iphone_minBookpick];
            break;
        case 120:
            [bookPick getBookPick:iphone_middleBookpick];
            break;
        case 150:
            [bookPick getBookPick:iphone_maxBookpick];
            break;
        default:
            break;
    }
    if ([bookPick.currentBookPick objectForKey:className] == nil) {
        //如果在书摘列表中没有当前的class,可以取消高亮显示
        NSString* js = [NSString stringWithFormat:@"removetheClass('%@')",className];
        [_curWebView stringByEvaluatingJavaScriptFromString:js];
        NSString* newHTML = [_curWebView stringByEvaluatingJavaScriptFromString:@"document.documentElement.innerHTML"];
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
         [_menuController setTargetRect:CGRectMake(0, location.y, 320, 0) inView:[gestureRecognizer view]];
        //    CGRect selectionRect = CGRectMake(mouseX, mouseY, 30,20);
        //    [menuController setTargetRect:selectionRect inView: self];
        //设置显示位置  
        //    //        [menuController setTargetRect:self.frame inView: self];
        [_menuController setMenuVisible:YES animated:YES];
    }
}


//字体改变，重新加载页面
//- (void)pageLoad:(NSNotification *)notification
//{
//    NSLog(@"pageLoad --- %d",[[notification object] intValue]);
//    NSLog(@"loadSpine curSpineIndex:%d , curPageIndex : %d",curSpineIndex,curPageIndex);
//    //重新加载页面
////    [self showWithIndex:curSpineIndex];
//    
//    //发送通知，就是说此时要调用观察者处的方
////    [[NSNotificationCenter defaultCenter] postNotificationName:@"fontChange" object:[[NSUserDefaults standardUserDefaults] objectForKey:@"curPageIndex"]];
//    [self loadSpine:curSpineIndex atPageIndex:curPageIndex];
//}

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

//获取当前Chapter之前的chapter中的页面数量
- (NSInteger)getNowPageIndex
{
    int allpage = 0;
    Chapter *chapter ;
    for (int i = 0; i < curSpineIndex; i ++) {
        if (curSpineIndex == 0) {
            allpage = 0;
        }else {
            chapter = [curBook.chapters objectAtIndex:i];
            allpage += chapter.pageCount;
        }
    }
    DebugLog(@"getNowPageIndex: ---- %d",allpage);
    return allpage;
}

//书摘
- (void)bookPickMenuPressed:(id)sender
{
    if (_classId != nil && _contentText != nil) {
        self.classId = nil;
        self.contentText = nil;
        DebugLog(@"not nil!");
    }else {
        //加载js文件
        NSString *filePath = resPath(@"HighlightedString.js");
        
        NSLog(@"filepath:%@",filePath);
        NSData *fileData    = [NSData dataWithContentsOfFile:filePath];
        NSString *jsString  = [[[NSMutableString alloc] initWithData:fileData encoding:NSUTF8StringEncoding] autorelease];
        [_curWebView stringByEvaluatingJavaScriptFromString:jsString];
        
        // 获取选取的文本
        NSString *startSearch1   = [NSString stringWithFormat:@"getHighlightedString()"];
        [_curWebView stringByEvaluatingJavaScriptFromString:startSearch1];
        
        NSString *selectedText   = [NSString stringWithFormat:@"selectedText"];
        NSString * highlightedString = [_curWebView stringByEvaluatingJavaScriptFromString:selectedText];
        NSLog(@"selectedTextString: ---  > %@",highlightedString);
        
        //获取当前书摘所在p 在页面中的索引
        NSString *getPIndex = [NSString stringWithFormat:@"pIndex"];
        NSString *pIndex = [_curWebView stringByEvaluatingJavaScriptFromString:getPIndex];
        DebugLog(@"pIndex ----> %@",pIndex);
        
        //在段落中的偏移位置 
        NSString *aIndex = [NSString stringWithFormat:@"atomIndex"];
        NSString *nowAtomIndex = [_curWebView stringByEvaluatingJavaScriptFromString:aIndex];
        DebugLog(@"AtomIndex ----> %@",nowAtomIndex);
        
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
        [_curWebView stringByEvaluatingJavaScriptFromString:startSearch];
        NSLog(@"noteMenuPressed");
 
        //根据p 所在位置，计算所在页数
        NSString *iphone_min = [curBook getPIndex:@"iPhone_2@2x.plist" pChapter:curSpineIndex pIndex:pIndex aIndex:nowAtomIndex];
        NSString *iphone_mid = [curBook getPIndex:@"iPhone_2@2x36.plist" pChapter:curSpineIndex pIndex:pIndex aIndex:nowAtomIndex];
        NSString *iphone_max = [curBook getPIndex:@"iPhone_2@2x44.plist" pChapter:curSpineIndex pIndex:pIndex aIndex:nowAtomIndex];
        DebugLog(@"min:%@  mid:%@ max:%@",iphone_min,iphone_mid,iphone_max);
        
        NSInteger before = [self getNowPageIndex];
        
//        NSString *npageIndex = [[NSUserDefaults standardUserDefaults] objectForKey:@"currentPageIndex"];
//        NSLog(@" npageIndex --> %@",npageIndex);
        //获取书摘列表
        [bookPick getBookPick:iphone_minBookpick];
        //给当前页面添加书摘
        NSString *nIndex = [NSString stringWithFormat:@"%d",iphone_min.intValue + before];
        NSDictionary *pageIndex = [[[NSDictionary alloc] initWithObjectsAndKeys:nIndex,@"pageIndex",className,@"className",localTime,@"time",highlightedString,@"content",pIndex,@"pIndex",nowAtomIndex,@"AtomIndex", nil] autorelease];
        [bookPick.currentBookPick setValue:pageIndex forKey:className];
        //写入document文件
        [bookPick.currentBookPick writeToFile:bookPick.filename atomically:YES];
        
        //获取书摘列表
        [bookPick getBookPick:iphone_middleBookpick];
        //给当前页面添加书摘
        nIndex = [NSString stringWithFormat:@"%d",iphone_mid.intValue + before];
        pageIndex = [[[NSDictionary alloc] initWithObjectsAndKeys:nIndex,@"pageIndex",className,@"className",localTime,@"time",highlightedString,@"content",pIndex,@"pIndex",nowAtomIndex,@"AtomIndex", nil] autorelease];
        [bookPick.currentBookPick setValue:pageIndex forKey:className];
        //写入document文件
        [bookPick.currentBookPick writeToFile:bookPick.filename atomically:YES];
        
        //获取书摘列表
        [bookPick getBookPick:iphone_maxBookpick];
        //给当前页面添加书摘
        nIndex = [NSString stringWithFormat:@"%d",iphone_max.intValue + before];
        pageIndex = [[[NSDictionary alloc] initWithObjectsAndKeys:nIndex,@"pageIndex",className,@"className",localTime,@"time",highlightedString,@"content",pIndex,@"pIndex",nowAtomIndex,@"AtomIndex", nil] autorelease];
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
        NSString* newHTML = [_curWebView stringByEvaluatingJavaScriptFromString:@"document.documentElement.innerHTML"];
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
    if (_classId != nil && _contentText != nil) {
        //调用添加批注的页面
        [self.rootVC presentModalViewController:comment animated:YES];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"comment" object:_classId];
        switch (curBook.BodyFontSize) {
            case 100:
                [bookPick getBookPick:iphone_minBookpick];
                break;
            case 120:
                [bookPick getBookPick:iphone_middleBookpick];
                break;
            case 150:
                [bookPick getBookPick:iphone_maxBookpick];
                break;
            default:
                break;
        }
        NSDictionary *bp =  [bookPick.currentBookPick objectForKey:_classId];
        NSString *pIndex = [bp objectForKey:@"pIndex"];
        NSString *nowAtomIndex = [bp objectForKey:@"AtomIndex"];
        
        //根据p 所在位置，计算所在页数
        NSString *iphone_min = [curBook getPIndex:@"iPhone_2@2x.plist" pChapter:curSpineIndex pIndex:pIndex aIndex:nowAtomIndex];
        NSString *iphone_mid = [curBook getPIndex:@"iPhone_2@2x36.plist" pChapter:curSpineIndex pIndex:pIndex aIndex:nowAtomIndex];
        NSString *iphone_max = [curBook getPIndex:@"iPhone_2@2x44.plist" pChapter:curSpineIndex pIndex:pIndex aIndex:nowAtomIndex];
        DebugLog(@"min:%@  mid:%@ max:%@",iphone_min,iphone_mid,iphone_max);
        NSInteger before = [self getNowPageIndex];
        
//        NSString *npageIndex = [[NSUserDefaults standardUserDefaults] objectForKey:@"currentPageIndex"];
//        NSLog(@" npageIndex --> %@",npageIndex);
        
        //获取批注列表
        [bookComment getBookComment:iphone_minBookComment];
        //给当前页面添加书摘
        NSString *nIndex = [NSString stringWithFormat:@"%d",iphone_min.intValue + before];
        
        //给当前页面添加书摘
        NSDictionary *pageIndex = [[[NSDictionary alloc] initWithObjectsAndKeys:nIndex,@"pageIndex",_classId,@"className",localTime,@"time",_contentText,@"content", nil] autorelease];
        [bookComment.currentBookComment setValue:pageIndex forKey:_classId];
        //写入document文件
        [bookComment.currentBookComment writeToFile:bookComment.filename atomically:YES];
        
        //获取批注列表
        [bookComment getBookComment:iphone_middleBookComment];
        nIndex = [NSString stringWithFormat:@"%d",iphone_mid.intValue + before];
        
        //给当前页面添加书摘
        pageIndex = [[[NSDictionary alloc] initWithObjectsAndKeys:nIndex,@"pageIndex",_classId,@"className",localTime,@"time",_contentText,@"content", nil] autorelease];
        [bookComment.currentBookComment setValue:pageIndex forKey:_classId];
        //写入document文件
        [bookComment.currentBookComment writeToFile:bookComment.filename atomically:YES];
        
        //获取批注列表
        [bookComment getBookComment:iphone_maxBookComment];
        nIndex = [NSString stringWithFormat:@"%d",iphone_max.intValue + before];
        //给当前页面添加书摘
        pageIndex = [[[NSDictionary alloc] initWithObjectsAndKeys:nIndex,@"pageIndex",_classId,@"className",localTime,@"time",_contentText,@"content", nil] autorelease];
        [bookComment.currentBookComment setValue:pageIndex forKey:_classId];
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
        [_curWebView stringByEvaluatingJavaScriptFromString:jsString];
        
        // 获取选取的文本
        NSString *startSearch1   = [NSString stringWithFormat:@"getHighlightedString()"];
        [_curWebView stringByEvaluatingJavaScriptFromString:startSearch1];
        
        NSString *selectedText   = [NSString stringWithFormat:@"selectedText"];
        NSString * highlightedString = [_curWebView stringByEvaluatingJavaScriptFromString:selectedText];
        NSLog(@"selectedTextString: ---  > %@",highlightedString);
    
        //获取当前书摘所在p 在页面中的索引
        NSString *getPIndex = [NSString stringWithFormat:@"pIndex"];
        NSString *pIndex = [_curWebView stringByEvaluatingJavaScriptFromString:getPIndex];
        DebugLog(@"pIndex ----> %@",pIndex);
        
        //在段落中的偏移位置 
        NSString *aIndex = [NSString stringWithFormat:@"atomIndex"];
        NSString *nowAtomIndex = [_curWebView stringByEvaluatingJavaScriptFromString:aIndex];
        DebugLog(@"AtomIndex ----> %@",nowAtomIndex);
        
        NSString *className =  [@"uiWebviewHighlight" stringByAppendingFormat:classTime];
        NSString *startSearch   = [NSString stringWithFormat:@"stylizeHighlightedString('%@')",className];
        //    NSLog(@"Highlighted -- > %@",startSearch);
        [_curWebView stringByEvaluatingJavaScriptFromString:startSearch];
        NSLog(@"noteMenuPressed");
        
        //调用添加批注的页面
        [self.rootVC presentModalViewController:comment animated:YES];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"comment" object:className];
        
        //根据p 所在位置，计算所在页数
        NSString *iphone_min = [curBook getPIndex:@"iPhone_2@2x.plist" pChapter:curSpineIndex pIndex:pIndex aIndex:nowAtomIndex];
        NSString *iphone_mid = [curBook getPIndex:@"iPhone_2@2x36.plist" pChapter:curSpineIndex pIndex:pIndex aIndex:nowAtomIndex];
        NSString *iphone_max = [curBook getPIndex:@"iPhone_2@2x44.plist" pChapter:curSpineIndex pIndex:pIndex aIndex:nowAtomIndex];
        DebugLog(@"Comment min:%@  mid:%@ max:%@",iphone_min,iphone_mid,iphone_max);
        
        NSInteger before = [self getNowPageIndex];
        
//        NSString *npageIndex = [[NSUserDefaults standardUserDefaults] objectForKey:@"currentPageIndex"];
//        NSLog(@" npageIndex --> %@",npageIndex);
        //获取批注列表
        [bookComment getBookComment:iphone_minBookComment];
        //给当前页面添加书摘
        NSString *nIndex = [NSString stringWithFormat:@"%d",iphone_min.intValue + before];
        
        NSDictionary *comm = [[[NSDictionary alloc] initWithObjectsAndKeys:nIndex,@"pageIndex",className,@"className",localTime,@"time",highlightedString,@"content", nil] autorelease];
        [bookComment.currentBookComment setValue:comm forKey:className];
        //写入document文件
        [bookComment.currentBookComment writeToFile:bookComment.filename atomically:YES];
        
        //获取批注列表
        [bookComment getBookComment:iphone_middleBookComment];
        //给当前页面添加书摘
        nIndex = [NSString stringWithFormat:@"%d",iphone_mid.intValue + before];
        
        comm = [[[NSDictionary alloc] initWithObjectsAndKeys:nIndex,@"pageIndex",className,@"className",localTime,@"time",highlightedString,@"content", nil] autorelease];
        [bookComment.currentBookComment setValue:comm forKey:className];
        //写入document文件
        [bookComment.currentBookComment writeToFile:bookComment.filename atomically:YES];
        
        //获取批注列表
        [bookComment getBookComment:iphone_maxBookComment];
        //给当前页面添加书摘
        nIndex = [NSString stringWithFormat:@"%d",iphone_max.intValue + before];
        comm = [[[NSDictionary alloc] initWithObjectsAndKeys:nIndex,@"pageIndex",className,@"className",localTime,@"time",highlightedString,@"content", nil] autorelease];
        [bookComment.currentBookComment setValue:comm forKey:className];
        //写入document文件
        [bookComment.currentBookComment writeToFile:bookComment.filename atomically:YES];
        
        //把html保存到原来的html
        NSString* newHTML = [_curWebView stringByEvaluatingJavaScriptFromString:@"document.documentElement.innerHTML"];
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

//删除书摘、批注
- (void)removePressed:(id)sender
{
    DebugLog(@"classname --> %@",_classId);
    DebugLog(@"contentText --> %@",_contentText);
    if (_classId != nil && _contentText != nil) {
        NSString* js = [NSString stringWithFormat:@"removetheClass('%@')",_classId];
        [_curWebView stringByEvaluatingJavaScriptFromString:js];
        NSString* newHTML = [_curWebView stringByEvaluatingJavaScriptFromString:@"document.documentElement.innerHTML"];
        NSLog(@"newHtml text --> %@",newHTML);
        
        //获取书摘列表  //删除所有字体对应的书摘
        [bookPick getBookPick:iphone_minBookpick];
        [bookPick.currentBookPick removeObjectForKey:_classId];
        //写入document文件
        [bookPick.currentBookPick writeToFile:bookPick.filename atomically:YES];
        
        [bookPick getBookPick:iphone_middleBookpick];
        [bookPick.currentBookPick removeObjectForKey:_classId];
        //写入document文件
        [bookPick.currentBookPick writeToFile:bookPick.filename atomically:YES];
        
        [bookPick getBookPick:iphone_maxBookpick];
        [bookPick.currentBookPick removeObjectForKey:_classId];
        //写入document文件
        [bookPick.currentBookPick writeToFile:bookPick.filename atomically:YES];
        
        //获取批注列表  删除所有字体对应的批注
        [bookComment getBookComment:iphone_minBookComment];
        [bookComment.currentBookComment removeObjectForKey:_classId];
        //写入documen
        [bookComment.currentBookComment writeToFile:bookComment.filename atomically:YES];
        
        [bookComment getBookComment:iphone_middleBookComment];
        [bookComment.currentBookComment removeObjectForKey:_classId];
        //写入documen
        [bookComment.currentBookComment writeToFile:bookComment.filename atomically:YES];
        
        [bookComment getBookComment:iphone_maxBookComment];
        [bookComment.currentBookComment removeObjectForKey:_classId];
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
    [_curWebView stringByEvaluatingJavaScriptFromString:@"uiWebview_RemoveAllHighlights()"];
}

-(void)updateInfo:(NSDictionary*)aInfo{
   
}

-(void)showWithIndex:(int)aIndex {
    if (isLoyoutDebug) {
        NSLog(@"contentView showWithIndex()");     
        DebugLog(@"now page Index ----> %@",[[NSUserDefaults standardUserDefaults] objectForKey:@"currentPageIndex"]);
    }

    _curLable.text =[NSString stringWithFormat:@"%d",aIndex];
    NSString *nowPageIndex = [[NSUserDefaults standardUserDefaults] objectForKey:@"currentPageIndex"];
    if (isLoyoutDebug) {
        DebugLog(@"showWithIndex aIndex -- > %d",aIndex);     
    }
    
    //发送检查页面是否添加书签
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"pageChange" object:nowPageIndex];
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
//        ChapterTitlePageView *titlePage = [[[ChapterTitlePageView alloc] initWithFrame:CGRectMake(0, 0, , t)] autorelease];
        ChapterTitlePageView *titlePage = [ChapterTitlePageView createWithSize:CGSizeMake(self.bounds.size.width, self.bounds.size.height)];
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
    [_curWebView loadRequest:[NSURLRequest requestWithURL:url]];
    //[curWebView2 loadRequest:[NSURLRequest requestWithURL:url]];
    _chapterLabel.text = chapter.title;
    
//    [self gotoPageInCurrentSpine:curPageIndex];
}

- (void) gotoPageInCurrentSpine:(int)pageIndex{ 
    
    NSLog(@"ContentView gotoPageInCurrentSpine");
    DebugLog(@"=====spine:%d, curpage:%d", curSpineIndex,curPageIndex);
    
	float pageOffset = 0;
//    float pageOffset2 = 0;
    if (!mf_IsPad || !share.isLandscape) {
        pageOffset = pageIndex*_curWebView.bounds.size.width ;
    }
    else{
//        pageOffset = pageIndex*curWebView.bounds.size.width + pageIndex *15;
        pageOffset = pageIndex*_curWebView.bounds.size.width;
//        pageOffset2 = (pageIndex+1)*curWebView.bounds.size.width;
    }
    NSLog(@"gotoPageInCurrentSpine pageOffset -> %f",pageOffset);
    //设置页面依X轴来滚动
	NSString* goToOffsetFunc = [NSString stringWithFormat:@" function pageScroll(xOffset){ window.scroll(xOffset,0); } "];
	NSString* goTo =[NSString stringWithFormat:@"pageScroll(%f)", pageOffset]; 
	[_curWebView stringByEvaluatingJavaScriptFromString:goToOffsetFunc];
	[_curWebView stringByEvaluatingJavaScriptFromString:goTo];
    
//    NSString* goTo2 =[NSString stringWithFormat:@"pageScroll(%f)", pageOffset2]; 
//    [curWebView2 stringByEvaluatingJavaScriptFromString:goToOffsetFunc];
//	[curWebView2 stringByEvaluatingJavaScriptFromString:goTo2];
   
    [_hud setHidden:YES];//隐藏loading提醒
	_curWebView.hidden = NO;//显示webview
    //curWebView2.hidden = NO;
}

//这个方法是网页中的每一个请求都会被触发的 
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    NSString *requestString = [[request URL] absoluteString];
	NSArray *components = [requestString componentsSeparatedByString:@":"];
    NSLog(@"requestString --> %@",requestString);

	if ([components count] > 2 && [requestString hasPrefix:@"iBooks:"]) {
		// document.location = "iBooks:" + "tags:" + randomCssClass + ":" + selectText; 
        NSString* clssName =[components objectAtIndex:2];
        NSString* txt =[components objectAtIndex:3]; 
        mouseX = [[components objectAtIndex:4] floatValue];
        mouseY = [[components objectAtIndex:5] floatValue];
        if (mouseY < 80.f) {
            mouseY = 25.f;
        }
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
        DebugLog(@"--- x: %f  --- y: %f",mouseX,mouseY);
        [self becomeFirstResponder];
        CGRect selectionRect = CGRectMake(self.bounds.size.width / 2.f, mouseY, 30,20);
        [_menuController setTargetRect:selectionRect inView: self];
        //设置显示位置  
//        [menuController setTargetRect:self.frame inView: self];
        [_menuController setMenuVisible:YES animated:YES];
        
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
//        NSString *setHighlightColorRule = [NSString stringWithFormat:@"addCSSRule('highlight', 'background-color: yellow;')"];
        
        //设置页面字体
        //设置页面文字尺寸
        NSString *setTextSizeRule = [NSString stringWithFormat:@"addCSSRule('body', '-webkit-text-size-adjust: %d%%;')",curBook.BodyFontSize];
        NSLog(@"curBook.BodyFontSize --- > %d",curBook.BodyFontSize);
        //设置页面不能选择文本
//        [webView stringByEvaluatingJavaScriptFromString:@"document.body.style.webkitTouchCallout='none';"];
//        [webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitTouchCallout='none';"];
        
        
        [_curWebView stringByEvaluatingJavaScriptFromString:varMySheet];
        [_curWebView stringByEvaluatingJavaScriptFromString:addCSSRule];
        [_curWebView stringByEvaluatingJavaScriptFromString:setTextSizeRule];
        [_curWebView stringByEvaluatingJavaScriptFromString:insertRule1];
        [_curWebView stringByEvaluatingJavaScriptFromString:insertRule2];
//        [webView stringByEvaluatingJavaScriptFromString:setHighlightColorRule];
        
        //加亮显示搜索的内容
        if(currentSearchResult!=nil){
            //	NSLog(@"Highlighting %@", currentSearchResult.originatingQuery);
            [_curWebView highlightAllOccurencesOfString:currentSearchResult.originatingQuery];
        }
        
        //获取返回页面的总宽度
//        int totalWidth = [[webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.scrollWidth"] intValue];
        //计算文件的页数
//        int pageCount = totalWidth / webView.bounds.size.width;
//        NSLog(@"Chapter %d: title: -> 包含：%d pages", curSpineIndex, pageCount);
    
    
    
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
    if (!_jquery) {
        [self inject];
    }
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
		[_curWebView stringByEvaluatingJavaScriptFromString:_jquery];
        [_curWebView stringByEvaluatingJavaScriptFromString:@"loadjscssfile('css.css', 'css')"];
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
    
	NSString *jqueryFilePath =resPath(@"Res/jquery-1.7.2.min.js");
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
