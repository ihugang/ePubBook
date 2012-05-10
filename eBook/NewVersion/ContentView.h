//
//  ContentView.h
//  eBook
//
//  Created by loufq on 12-4-17.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "BaseView.h"
@class SearchResult;

@interface ContentView : BaseView<UIWebViewDelegate>{
    UIWebView* curWebView;
    int curSpineIndex;
    int curPageIndex;
    SearchResult* currentSearchResult;
}
@property(nonatomic,assign)UIWebView*  curWebView;
@property(nonatomic,assign)UILabel*  curLable;
@property (nonatomic, retain) SearchResult* currentSearchResult;

-(void)showWithIndex:(int)aIndex;

//@private
- (void) loadSpine:(int)spineIndex atPageIndex:(int)pageIndex;

@end
