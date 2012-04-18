//
//  ContentView.h
//  eBook
//
//  Created by loufq on 12-4-17.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "BaseView.h"

@interface ContentView : BaseView<UIWebViewDelegate>{
    UIWebView* curWebView;
    int curSpineIndex;
    int curPageIndex;
}
@property(nonatomic,assign)UIWebView*  curWebView;
@property(nonatomic,assign)UILabel*  curLable;
-(void)showWithIndex:(int)aIndex;

@end
