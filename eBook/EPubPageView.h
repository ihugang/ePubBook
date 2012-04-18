//
//  EPubPageView.h
//  eBook
//
//  Created by LiuWu on 12-4-13.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EPub.h"
#import "Chapter.h"

@interface EPubPageView : UIView<UIWebViewDelegate,ChapterDelegate>
{
    UIWebView *webView;
    
    EPub *epub;
    
    int currentSpineIndex;
	int currentPageInSpineIndex;
	int pagesInCurrentSpineCount;
	int currentTextSize;
	int totalPagesCount;
    
    BOOL paginating;
    BOOL epubLoaded;

}
@property (nonatomic, retain) EPub *epub;
@property (nonatomic, retain) UIWebView *webView;
@property (nonatomic) int currentSpineIndex;

- (EPubPageView *)initWithEPubPage:(NSInteger)index;
- (void)load:(NSURL *)path atPageIndex:(int)pageIndex;
- (void) loadSpine:(int)spineIndex atPageIndex:(int)pageIndex;
@end
