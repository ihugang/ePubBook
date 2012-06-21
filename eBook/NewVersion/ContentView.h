//
//  ContentView.h
//  eBook
//
//  Created by loufq on 12-4-17.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "BaseView.h"
@class SearchResult;

@interface ContentView : BaseView<UIWebViewDelegate,UITextViewDelegate>{
    UIWebView* curWebView;
    int curSpineIndex;
    int curPageIndex;
    SearchResult* currentSearchResult;
    
    UIMenuController *menuController;
    BOOL injected;
    float mouseX;
    float mouseY;
}
@property(nonatomic,assign)UIWebView*  curWebView;
@property(nonatomic,assign)UIWebView*  curWebView2;
@property(nonatomic,assign)UILabel*  curLable;
@property(nonatomic,assign)UILabel*  bookNameLabel;
@property(nonatomic,assign)UILabel*  chapterLabel;
@property (nonatomic, retain) SearchResult* currentSearchResult;
@property (nonatomic, retain) NSString *jquery; 
@property(nonatomic,assign)UIMenuController *menuController;
@property (nonatomic, retain) NSString *classId; 
@property (nonatomic, retain) NSString *contentText; 
@property(nonatomic,assign)UIViewController *rootVC;

-(void)showWithIndex:(int)aIndex;

//@private
- (void) loadSpine:(int)spineIndex atPageIndex:(int)pageIndex;

@end
