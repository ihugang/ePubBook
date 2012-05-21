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

@implementation OperView
@synthesize delegate,rootVC,currentPageIndex;
- (void)dealloc {
    self.delegate =nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"pageChange" object:nil];
    [super dealloc];
}

-(void)initLayout{ 
//    self.backgroundColor = [UIColor redColor];
//    //    self.backgroundColor =[UIColor colorWithPatternImage:skinImage(@"operbar/b002.png")];
//    UIImageView* iv =[UIImageView nodeWithImage:skinImage(@"operbar/b002.png")];
    UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
    [iv setImage:skinImage(@"navbar/b002.png")];
    [self addSubview:iv];
    
    CGRect frame =  [[UIScreen mainScreen] bounds];
    self.size =CGSizeMake(frame.size.width, frame.size.height - 44);
 
    UIView* ivTapOper =[[[UIView alloc] initWithFrame:frame] autorelease];
    ivTapOper.top = iv.bottom + 10;
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
    [btnList addTarget:self action:@selector(btnListTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btnList];
    
    btnFontSize =[UIButton nodeWithOnImage:nil offImage:skinImage(@"operbar/b004.png")];
    //btnFontSize.size = btnList.size;
    btnFontSize.left = btnList.right + 20;
    btnFontSize.top = btnList.top;
    [btnFontSize addEvent:@selector(btnFontSizeTapped:) atContainer:self];
    [self addSubview:btnFontSize];
    
    UIButton* btnSearch =[UIButton nodeWithOnImage:nil offImage:skinImage(@"operbar/b005.png")];
    // btnSearch.size = btnList.size;
    btnSearch.left = btnFontSize.right + 20;
    btnSearch.top = btnList.top;
    [btnSearch addEvent:@selector(btnSearchTapped:) atContainer:self];
    [self addSubview:btnSearch];
    
    UIButton* btnSetting =[UIButton nodeWithOnImage:nil offImage:skinImage(@"operbar/b006.png")];
    // btnSetting.size = btnList.size;
    btnSetting.left = btnSearch.right + 20;
    btnSetting.top = btnList.top;
    [btnSetting addEvent:@selector(btnSettingTapped:) atContainer:self];
    [self addSubview:btnSetting];
    
    bookMark = [UIButton nodeWithOnImage:nil offImage:resImage(@"content/bookmark.png")];
    bookMark.left = btnSetting.right + 20;
    bookMark.top = 10;
    [bookMark addEvent:@selector(addBookMark:) atContainer:self];
//    [bookMark addTarget:self action:@selector(addBookMark:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:bookMark];
    
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
    [btnBooks addEvent:@selector(btnBooksTapped:) atContainer:self];
    [self addSubview:btnBooks]; 
    
    //监听每个页面，判断是否添加为书签
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkBookMark:) name:@"pageChange" object:nil];
}

- (void)checkBookMark:(NSNotification *)notification
{
    //设置当前页面
    self.currentPageIndex = [notification object];
    [bookMarks getBookMark];
    DebugLog(@"checkBookMark - %@",[notification object]);
    DebugLog(@"aaaaa  -----> %@",[bookMarks.currentBookMark objectForKey: [notification object]]);
    if ([bookMarks.currentBookMark objectForKey: [notification object]] != nil) {
//        //添加标签
        [bookMark setImage:resImage(@"content/bookmark-blue.png") forState:UIControlStateNormal];
    }else {
        [bookMark setImage:resImage(@"content/bookmark.png") forState:UIControlStateNormal];
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
    
//    [self.rootVC.view addSubview:clv.view];
    
    clv.delegate = self;
}

-(void)btnFontSizeTapped:(UIButton*)sender{
    DebugLog(@"%@",sender);
    if (fv == nil) {
        fv = [[FontView alloc] initWithFrame:CGRectMake(10,btnFontSize.bottom + 20 , 200, 100)] ;
        fv.tag = 1001;
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
        [[NSNotificationCenter defaultCenter] postNotificationName:@"addBookMark" object:currentPageIndex];
//        [bookMark setImage:resImage(@"content/bookmark-blue.png") forState:UIControlStateNormal];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"pageChange" object:currentPageIndex];
    }else {
        //删除当前页面书签
        DebugLog(@"remove bookmark");
        [bookMarks.bookmarks removeObjectForKey:currentPageIndex];
        [bookMarks.bookmarks writeToFile:bookMarks.filename atomically:YES];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"pageChange" object:currentPageIndex];
//        [bookMark setImage:resImage(@"content/bookmark.png") forState:UIControlStateNormal];
    }
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
