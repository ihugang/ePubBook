//
//  EPubViewController.h
//  eBook
//
//  Created by LiuWu on 12-4-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ATPagingView.h"
#import "EPub.h"
#import "EPubPageView.h"
#import "Chapter.h"

@interface EPubViewController : ATPagingViewController<UIWebViewDelegate,ChapterDelegate>
{
    UIWebView *webView;
    
    EPub* loadedEpub;
	int currentSpineIndex;
	int currentPageInSpineIndex;
	int pagesInCurrentSpineCount;
	int currentTextSize;
	int totalPagesCount;
    
    BOOL paginating;
    BOOL epubLoaded;
}
@property (nonatomic, retain) EPub* loadedEpub;
@property (nonatomic, retain) UIWebView *webView;
@property (nonatomic)int totalPagesCount;

- (void) loadEpub;
- (void) loadSpine:(int)spineIndex atPageIndex:(int)pageIndex;

@end
