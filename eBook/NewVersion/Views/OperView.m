//
//  OperView.m
//  eBook
//
//  Created by loufq on 12-4-20.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "OperView.h"
#import "ChapterListVC.h"
#import "BookMark.h"
#import "Book.h"

@implementation OperView

@synthesize bookMark = _bookMark,btnFontSize = _btnFontSize;
@synthesize delegate,rootVC,currentPageIndex,curChapterIndex,curChapterPageIndex;
- (void)dealloc {
    [_bookMark release];_bookMark = nil;
    [_btnFontSize release];_btnFontSize = nil;
//    [self.curChapterIndex release];self.curChapterIndex = nil;
//    [self.currentPageIndex release];self.currentPageIndex = nil;
//    [self.curChapterPageIndex release];self.curChapterPageIndex = nil;
    self.delegate =nil;
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"pageChange" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"sendPageToBookMark" object:nil];
    [super dealloc];
}

-(void)initLayout{ 
//    self.backgroundColor = [UIColor redColor];
//    //    self.backgroundColor =[UIColor colorWithPatternImage:skinImage(@"operbar/b002.png")];
//    UIImageView* iv =[UIImageView nodeWithImage:skinImage(@"operbar/b002.png")];
    UIImageView *iv = [[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)] autorelease];
    [iv setImage:skinImage(@"navbar/b002.png")];
    [iv setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin];
    [self addSubview:iv];
    
    CGRect frame =  [[UIScreen mainScreen] bounds];
    self.size =CGSizeMake(frame.size.width, frame.size.height - 44);
    
    UIView* ivTapOper =[[[UIView alloc] initWithFrame:frame] autorelease];
//    [ivTapOper setBackgroundColor:[UIColor blueColor]];
    ivTapOper.top = iv.bottom + 10;
    [ivTapOper setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin];
    [self addSubview:ivTapOper];
    [ivTapOper whenTapped:^{
         //switchTap
        [self.delegate operViewTappedToDissmiss];
    }];
    
    UIButton* btnList =[UIButton nodeWithOnImage:nil offImage:skinImage(@"operbar/b003.png")];
    //btnList.size = CGSizeMake(btnList.width*2, btnList.height*2);
    btnList.left = 20;
    btnList.top = 14;
    //    [btnList addEvent:@selector(btnListTapped:) atContainer:self];
    [btnList setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin];
    [btnList addTarget:self action:@selector(btnListTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btnList];
    
    self.btnFontSize =[UIButton nodeWithOnImage:nil offImage:skinImage(@"operbar/b004.png")];
    //btnFontSize.size = btnList.size;
    _btnFontSize.left = btnList.right + 20;
    _btnFontSize.top = btnList.top;
    [_btnFontSize setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin];
    [_btnFontSize addEvent:@selector(btnFontSizeTapped:) atContainer:self];
    [self addSubview:_btnFontSize];
    
    UIButton* btnSearch =[UIButton nodeWithOnImage:nil offImage:skinImage(@"operbar/b005.png")];
    // btnSearch.size = btnList.size;
    btnSearch.left = _btnFontSize.right + 20;
    btnSearch.top = btnList.top;
    [btnSearch setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin];
    [btnSearch addEvent:@selector(btnSearchTapped:) atContainer:self];
    [self addSubview:btnSearch];
    
    UIButton* btnSetting =[UIButton nodeWithOnImage:nil offImage:skinImage(@"operbar/b006.png")];
    // btnSetting.size = btnList.size;
    btnSetting.left = btnSearch.right + 20;
    btnSetting.top = btnList.top;
    [btnSetting setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin];
    [btnSetting addEvent:@selector(btnSettingTapped:) atContainer:self];
    [self addSubview:btnSetting];
    
    self.bookMark = [UIButton nodeWithOnImage:nil offImage:resImage(@"content/bookmark.png")];
    _bookMark.left = btnSetting.right + 20;
    _bookMark.top = 10;
    [_bookMark setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin];
    [_bookMark addEvent:@selector(addBookMark:) atContainer:self];
//    [bookMark addTarget:self action:@selector(addBookMark:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_bookMark];
    
//    bookMark = [UIButton buttonWithType:UIButtonTypeCustom];
//    [bookMark setImage:resImage(@"content/bookmark.png") forState:UIControlStateNormal];
//    [bookMark setFrame:CGRectMake(btnSetting.right + 15, 8, 20, 25)];
//    [bookMark addTarget:self action:@selector(addBookMark:) forControlEvents:UIControlEventTouchUpInside];
//    [self addSubview:bookMark];
    
    UIButton* btnBooks =[UIButton nodeWithTitle:@"赌遍全球" image:skinImage(@"operbar/b007.png")];
    [btnBooks setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnBooks.titleLabel.font =[UIFont systemFontOfSize:12];
    btnBooks.width = 90;
    btnBooks.height = 25;
    btnBooks.right = self.width - 10;
    btnBooks.top = 10;
    [btnBooks setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin];
    [btnBooks addEvent:@selector(btnBooksTapped:) atContainer:self];
    [self addSubview:btnBooks]; 
    
    //监听每个页面，判断是否添加为书签
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkBookMark:) name:@"pageChange" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkBookMark:) name:@"sendPageToBookMark" object:nil];
}

- (void)getPageIndex:(NSNotification *)notification
{
    NSString *test = [notification object];
    DebugLog(@"====================== %@",test);
}

- (void)checkBookMark:(NSNotification *)notification
{
    //设置当前页面
    self.currentPageIndex = [notification object];
    DebugLog(@" BookMark page====================== %@",currentPageIndex);
//    [bookMarks getBookMark];
    switch (curBook.BodyFontSize) {
        case 100:
            [bookMarks getBookMark:iphone_minBookMark];
            break;
        case 120:
            [bookMarks getBookMark:iphone_middleBookMark];
            break;
        case 150:
            [bookMarks getBookMark:iphone_maxBookMark];
            break;
    }
    DebugLog(@"checkBookMark - %@",[notification object]);
    if ([bookMarks.currentBookMark objectForKey: [notification object]] != nil) {
//        //添加标签
        [_bookMark setImage:resImage(@"content/bookmark-blue.png") forState:UIControlStateNormal];
    }else {
        [_bookMark setImage:resImage(@"content/bookmark.png") forState:UIControlStateNormal];
    }
}

-(void)btnListTapped:(UIButton*)sender{
    DebugLog(@"%@", sender);
    ChapterListVC* clv =[[[ChapterListVC alloc] init] autorelease];
//    [UIView beginAnimations:nil context:nil];
//    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
//    [UIView setAnimationDuration:1];
//    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.rootVC.view cache:YES];
//    self.rootVC.view = clv.view;
//    [UIView commitAnimations];
  
    clv.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self.rootVC presentModalViewController:clv animated:YES];
    clv.delegate = self;
}

-(void)btnFontSizeTapped:(UIButton*)sender{
    DebugLog(@"%@",sender);
    if (fv == nil) {
        fv = [[FontView alloc] initWithFrame:CGRectMake(10,_btnFontSize.bottom + 22 , 200, 100)] ;
        [fv setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin];
        fv.tag = 1001;
//        fv.curPageIndex = self.currentPageIndex;
//        [self.superview addSubview:fv];
        [self.rootVC.view addSubview:fv];
    }else{    
        if (fv.hidden == YES) {
            fv.hidden = NO;
        }else {
            fv.hidden = YES;
        }
    }
}

-(void)btnSearchTapped:(UIButton*)sender{
    DebugLog(@"%@", sender);
    SearchVC *svc = [[[SearchVC alloc] init] autorelease];
    [self.rootVC presentModalViewController:svc animated:YES];
    svc.delegate = self;
}

-(void)btnSettingTapped:(UIButton*)sender{
    DebugLog(@"%@", sender);
    SettingVC *set = [[[SettingVC alloc] init] autorelease];
//    [self.rootVC presentModalViewController:set animated:YES];
    navController = [[[UINavigationController alloc] initWithRootViewController:set] autorelease];
    [self.rootVC presentModalViewController:navController animated:YES];
}

- (void)addBookMark:(UIButton*)sender{
    //添加标签
//    [bookMark setImage:resImage(@"content/bookmark-blue.png") forState:UIControlStateNormal];
    if ([bookMarks.currentBookMark objectForKey:currentPageIndex] == nil) {
        //给当前页面添加书签
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"addBookMark" object:currentPageIndex];
        
        [self getPages];
        [self addBookMark];
        
//        [bookMark setImage:resImage(@"content/bookmark-blue.png") forState:UIControlStateNormal];
        //检查当前页面书签图标显示状态
        [[NSNotificationCenter defaultCenter] postNotificationName:@"sendPageToBookMark" object:currentPageIndex];
    }else {
        //删除当前页面书签
        DebugLog(@"remove bookmark");
        [self getPages];
        
        NSInteger before = [self getNowPageIndex];
        
        DebugLog(@"----> %@",[curBook.Pages objectAtIndex:self.curChapterIndex.intValue]);
        //获取当前页面的p index 和 Auto Index
        NSString *curNowPageIndex = [NSString stringWithFormat:@"%d",self.curChapterPageIndex.intValue];
        NSString *nowParaIndex = [[[curBook.Pages objectAtIndex:self.curChapterIndex.intValue] objectAtIndex:curNowPageIndex.intValue] objectForKey:@"ParaIndex"]; 
        NSString *nowAtomIndex = [[[curBook.Pages objectAtIndex:self.curChapterIndex.intValue] objectAtIndex:curNowPageIndex.intValue] objectForKey:@"AtomIndex"]; 
        //    NSString *nowParaIndex = [[curBook.Pages objectAtIndex:self.currentPageIndex.intValue] objectForKey:@"ParaIndex"];
        //    NSString *nowAtomIndex = [[curBook.Pages objectAtIndex:self.currentPageIndex.intValue] objectForKey:@"AtomIndex"];
        DebugLog(@"addBookMark ---->P: %@   a: %@",nowParaIndex,nowAtomIndex);
        
        NSString *iphone_min = [curBook getPIndex:@"iPhone_2@2x.plist" pChapter:self.curChapterIndex.intValue pIndex:nowParaIndex aIndex:nowAtomIndex];
        NSString *iphone_mid = [curBook getPIndex:@"iPhone_2@2x36.plist" pChapter:self.curChapterIndex.intValue pIndex:nowParaIndex aIndex:nowAtomIndex];
        NSString *iphone_max = [curBook getPIndex:@"iPhone_2@2x44.plist" pChapter:self.curChapterIndex.intValue pIndex:nowParaIndex aIndex:nowAtomIndex];
        DebugLog(@"min:%@  mid:%@ max:%@",iphone_min,iphone_mid,iphone_max);
        
        //删除书签
        [bookMarks getBookMark:iphone_minBookMark];
         NSString *pIndex = [NSString stringWithFormat:@"%d",iphone_min.intValue+before];
        DebugLog(@"pIndx -----> %@",pIndex);
        [bookMarks.bookmarks removeObjectForKey:pIndex];
        [bookMarks.bookmarks writeToFile:bookMarks.filename atomically:YES];
        
        [bookMarks getBookMark:iphone_middleBookMark];
        pIndex = [NSString stringWithFormat:@"%d",iphone_mid.intValue+before];
        DebugLog(@"pIndx -----> %@",pIndex);
        [bookMarks.bookmarks removeObjectForKey:pIndex];
        [bookMarks.bookmarks writeToFile:bookMarks.filename atomically:YES];
        
        [bookMarks getBookMark:iphone_maxBookMark];
        DebugLog(@"pIndx -----> %@",pIndex);
        pIndex = [NSString stringWithFormat:@"%d",iphone_max.intValue+before];
        [bookMarks.bookmarks removeObjectForKey:pIndex];
        [bookMarks.bookmarks writeToFile:bookMarks.filename atomically:YES];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"sendPageToBookMark" object:currentPageIndex];
    }
}
//获取当前页面所在的html和在html的第几页
- (void)getPages
{
    int tempSpineIndex = 0;//HTML
    int tempPageIndex = 0;//Page
    
    int perTotalIndex = 0;//temp
    int curTotalIndex = 0;//temp
    for (Chapter* chapter in curBook.chapters) {   
        curTotalIndex += chapter.pageCount;
        if (self.currentPageIndex.intValue >=perTotalIndex && self.currentPageIndex.intValue <curTotalIndex) {
            tempPageIndex = self.currentPageIndex.intValue - perTotalIndex;
            break;
        }
        perTotalIndex=curTotalIndex;
        tempSpineIndex++;
    }
    self.curChapterIndex = [NSString stringWithFormat:@"%d",tempSpineIndex];
    self.curChapterPageIndex = [NSString stringWithFormat:@"%d",tempPageIndex];
    DebugLog(@"BookMark -------------> chapter:%@   Page: %@ ",curChapterIndex,curChapterPageIndex);
}
//获取当前Chapter之前的chapter中的页面数量
- (NSInteger)getNowPageIndex
{
    int allpage = 0;
    Chapter *chapter ;
    for (int i = 0; i < curChapterIndex.intValue; i ++) {
        if (curChapterIndex.intValue == 0) {
            allpage = 0;
        }else {
            chapter = [curBook.chapters objectAtIndex:i];
            allpage += chapter.pageCount;
        }
    }
    DebugLog(@"getNowPageIndex: ---- %d",allpage);
    return allpage;
}

//添加书签
- (void)addBookMark
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *localTime=[formatter stringFromDate: [NSDate date]];
    
    DebugLog(@"addBookMark ----> %@",self.currentPageIndex);
    Chapter* chapter = [curBook.chapters objectAtIndex:self.curChapterIndex.intValue];
    //    DebugLog(@"title  ---- %@",chapter.title);
    NSInteger before = [self getNowPageIndex];
    
    DebugLog(@"----> %@",[curBook.Pages objectAtIndex:self.curChapterIndex.intValue]);
    //获取当前页面的p index 和 Auto Index
    NSString *curNowPageIndex = [NSString stringWithFormat:@"%d",self.curChapterPageIndex.intValue];
    NSString *nowParaIndex = [[[curBook.Pages objectAtIndex:self.curChapterIndex.intValue] objectAtIndex:curNowPageIndex.intValue] objectForKey:@"ParaIndex"]; 
    NSString *nowAtomIndex = [[[curBook.Pages objectAtIndex:self.curChapterIndex.intValue] objectAtIndex:curNowPageIndex.intValue] objectForKey:@"AtomIndex"]; 
//    NSString *nowParaIndex = [[curBook.Pages objectAtIndex:self.currentPageIndex.intValue] objectForKey:@"ParaIndex"];
//    NSString *nowAtomIndex = [[curBook.Pages objectAtIndex:self.currentPageIndex.intValue] objectForKey:@"AtomIndex"];
    DebugLog(@"addBookMark ---->P: %@   a: %@",nowParaIndex,nowAtomIndex);
        
    NSString *iphone_min = [curBook getPIndex:@"iPhone_2@2x.plist" pChapter:self.curChapterIndex.intValue pIndex:nowParaIndex aIndex:nowAtomIndex];
    NSString *iphone_mid = [curBook getPIndex:@"iPhone_2@2x36.plist" pChapter:self.curChapterIndex.intValue pIndex:nowParaIndex aIndex:nowAtomIndex];
    NSString *iphone_max = [curBook getPIndex:@"iPhone_2@2x44.plist" pChapter:self.curChapterIndex.intValue pIndex:nowParaIndex aIndex:nowAtomIndex];
    DebugLog(@"min:%@  mid:%@ max:%@",iphone_min,iphone_mid,iphone_max);
    
    [bookMarks getBookMark:iphone_minBookMark];
    //给当前页面添加书签
    NSString *pIndex = [NSString stringWithFormat:@"%d",iphone_min.intValue+before];
    NSDictionary *pageIndex = [[[NSDictionary alloc] initWithObjectsAndKeys:pIndex,@"pageIndex",localTime,@"time",chapter.title,@"content", nil] autorelease];
    [bookMarks.bookmarks setValue:pageIndex forKey:pIndex];
    [bookMarks.bookmarks writeToFile:bookMarks.filename atomically:YES];
    
    [bookMarks getBookMark:iphone_middleBookMark];
    pIndex = [NSString stringWithFormat:@"%d",iphone_mid.intValue +before];
    pageIndex = [[[NSDictionary alloc] initWithObjectsAndKeys:pIndex,@"pageIndex",localTime,@"time",chapter.title,@"content", nil] autorelease];
    [bookMarks.bookmarks setValue:pageIndex forKey:pIndex];
    [bookMarks.bookmarks writeToFile:bookMarks.filename atomically:YES];
    
    [bookMarks getBookMark:iphone_maxBookMark];
    pIndex = [NSString stringWithFormat:@"%d",iphone_max.intValue +before];
    pageIndex = [[[NSDictionary alloc] initWithObjectsAndKeys:pIndex,@"pageIndex",localTime,@"time",chapter.title,@"content", nil] autorelease];
    [bookMarks.bookmarks setValue:pageIndex forKey:pIndex];
    [bookMarks.bookmarks writeToFile:bookMarks.filename atomically:YES];
    
    [formatter release];
}

-(void)btnBooksTapped:(UIButton*)sender{
    DebugLog(@"%@", sender);
    BooksListVC *booksList = [[[BooksListVC alloc] init] autorelease];
    [self.rootVC presentModalViewController:booksList animated:YES];
    
}

-(void)showChapterIndex:(UIButton*)sender{
    
}

- (void)ChapterListClick
{
    [self.rootVC dismissModalViewControllerAnimated:NO];
}

- (void)showSearchVC
{
    [self.rootVC dismissModalViewControllerAnimated:YES];
}

@end
