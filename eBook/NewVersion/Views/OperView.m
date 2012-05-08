//
//  OperView.m
//  eBook
//
//  Created by loufq on 12-4-20.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "OperView.h"
#import "ChapterListVC.h"

@implementation OperView
@synthesize delegate,rootVC;
- (void)dealloc {
    self.delegate =nil;
    [super dealloc];
}

-(void)initLayout{ 
    //    self.backgroundColor =[UIColor colorWithPatternImage:skinImage(@"operbar/b002.png")];
    UIImageView* iv =[UIImageView nodeWithImage:skinImage(@"operbar/b002.png")];
    [self addSubview:iv];
    
    CGRect frame =  [[UIScreen mainScreen] bounds];
    self.size =CGSizeMake(frame.size.width, frame.size.height - 44);
    UIButton* btnList =[UIButton nodeWithOnImage:nil offImage:skinImage(@"operbar/b003.png")];
    //btnList.size = CGSizeMake(btnList.width*2, btnList.height*2);
    btnList.left = 20;
    btnList.top = 12;
    //    [btnList addEvent:@selector(btnListTapped:) atContainer:self];
    [btnList addTarget:self action:@selector(btnListTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btnList];
    
    btnFontSize =[UIButton nodeWithOnImage:nil offImage:skinImage(@"operbar/b004.png")];
    //btnFontSize.size = btnList.size;
    btnFontSize.left = btnList.right + 30;
    btnFontSize.top = btnList.top;
    [btnFontSize addEvent:@selector(btnFontSizeTapped:) atContainer:self];
    [self addSubview:btnFontSize];
    
    UIButton* btnSearch =[UIButton nodeWithOnImage:nil offImage:skinImage(@"operbar/b005.png")];
    // btnSearch.size = btnList.size;
    btnSearch.left = btnFontSize.right + 30;
    btnSearch.top = btnList.top;
    [btnSearch addEvent:@selector(btnSearchTapped:) atContainer:self];
    [self addSubview:btnSearch];
    
    UIButton* btnSetting =[UIButton nodeWithOnImage:nil offImage:skinImage(@"operbar/b006.png")];
    // btnSetting.size = btnList.size;
    btnSetting.left = btnSearch.right + 30;
    btnSetting.top = btnList.top;
    [btnSetting addEvent:@selector(btnSettingTapped:) atContainer:self];
    [self addSubview:btnSetting];
    
    bookMark = [UIButton buttonWithType:UIButtonTypeCustom];
    [bookMark setImage:resImage(@"content/bookmark.png") forState:UIControlStateNormal];
    [bookMark setFrame:CGRectMake(btnSetting.right + 15, 8, 20, 20)];
    [bookMark addTarget:self action:@selector(addBookMark:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:bookMark];
    
    
    UIButton* btnBooks =[UIButton nodeWithTitle:@"赌遍全球" image:skinImage(@"operbar/b007.png")];
    [btnBooks setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnBooks.titleLabel.font =[UIFont systemFontOfSize:12];
    btnBooks.width = 90;
    btnBooks.height = 25;
    btnBooks.right = self.width - 10;
    btnBooks.top = 7;
    [btnBooks addEvent:@selector(btnBooksTapped:) atContainer:self];
    [self addSubview:btnBooks]; 
}

-(void)btnListTapped:(UIButton*)sender{
    DebugLog(@"%@", sender);
    ChapterListVC* clv =[[[ChapterListVC alloc] init] autorelease];
    [self.rootVC presentModalViewController:clv animated:YES];
    clv.delegate = self;
}

-(void)btnFontSizeTapped:(UIButton*)sender{
    DebugLog(@"%@",sender);
    if (fv == nil) {
        fv = [[FontView alloc] initWithFrame:CGRectMake(10,btnFontSize.frame.origin.y*4 , 200, 100)] ;
        [self.superview addSubview:fv];
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
    [bookMark setImage:resImage(@"content/bookmark-blue.png") forState:UIControlStateNormal];
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
    [self.rootVC dismissModalViewControllerAnimated:YES];
}

- (void)showSearchVC
{
    [self.rootVC dismissModalViewControllerAnimated:YES];
}

@end
