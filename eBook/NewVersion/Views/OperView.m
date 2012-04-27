//
//  OperView.m
//  eBook
//
//  Created by loufq on 12-4-20.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "OperView.h"
#import "ChapterListVC.h"
#import "RootVC.h"

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
    self.size =CGSizeMake(frame.size.width, frame.size.height - 64);
    
    self.backgroundColor =[UIColor grayColor];
    
    UIButton* btnList =[UIButton nodeWithOnImage:nil offImage:skinImage(@"operbar/b003.png")];
    //btnList.size = CGSizeMake(btnList.width*2, btnList.height*2);
    btnList.left = 20;
    btnList.top = 12;
//    [btnList addEvent:@selector(btnListTapped:) atContainer:self];
    [btnList addTarget:self action:@selector(btnListTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btnList];
 
    UIButton* btnFontSize =[UIButton nodeWithOnImage:nil offImage:skinImage(@"operbar/b004.png")];
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
 
    UIButton* btnBooks =[UIButton nodeWithTitle:@"赌遍全球" image:skinImage(@"operbar/b007.png")];
    [btnBooks setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnBooks.titleLabel.font =[UIFont systemFontOfSize:12];
    btnBooks.width = 90;
    btnBooks.height = 25;
    btnBooks.right = self.width - 10;
    btnBooks.top = 7;
    [btnBooks addEvent:@selector(btnBooksTapped:) atContainer:self];
    [self addSubview:btnBooks];  
  
    UITapGestureRecognizer* tapGesture =[[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userTapOper:)] autorelease];
    tapGesture.delegate = self;
    [self addGestureRecognizer:tapGesture]; 
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    
    if ([touch.view isKindOfClass:[UIButton class]]) 
    { 
		return NO;
    } 
 
    return YES;
}

-(void)userTapOper:(UITapGestureRecognizer*)gesture{
   
    CGPoint p  =   [gesture locationInView:self];
    if (p.y<44) {
        return;
    }
    
    [(RootVC*)rootVC swichUI:NO];    
}


-(void)btnListTapped:(UIButton*)sender{
    DebugLog(@"%@", sender);
    ChapterListVC* clv =[[[ChapterListVC alloc] init] autorelease];
    [self.rootVC presentModalViewController:clv animated:YES];
    
}

-(void)btnFontSizeTapped:(UIButton*)sender{
    DebugLog(@"%@", sender);
}

-(void)btnSearchTapped:(UIButton*)sender{
    DebugLog(@"%@", sender);
}

-(void)btnSettingTapped:(UIButton*)sender{
    DebugLog(@"%@", sender);
}

-(void)btnBooksTapped:(UIButton*)sender{
    DebugLog(@"%@", sender);
    
    
}


-(void)showChapterIndex:(UIButton*)sender{
    
}

@end
