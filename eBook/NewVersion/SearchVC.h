//
//  SearchVC.h
//  eBook
//
//  Created by LiuWu on 12-4-28.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "BaseVC.h"
#import "EGORefreshTableHeaderView.h"
#import "Chapter.h"

@protocol SearchVCDelegate <NSObject>

- (void)showSearchVC;

@end

@interface SearchVC : BaseVC<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UIWebViewDelegate,EGORefreshTableHeaderDelegate>
{
    UITextField *searchField;
    NSMutableArray* results;
    NSString* currentQuery;
    UITableView *resultTable;
    Chapter* chapter;
    
    EGORefreshTableHeaderView *_refreshHeaderView;//上拉刷新
    BOOL _reloading;
    BOOL search;
    
    int first;
    int currentChapterIndex;
}
@property (nonatomic,retain) UITableView *resultTable;
@property (nonatomic,assign) id<SearchVCDelegate> delegate;
@property (nonatomic, retain) NSMutableArray* firstresults;
@property (nonatomic, retain) NSMutableArray* results;
@property (nonatomic, retain) NSString* currentQuery;

- (void) searchString:(NSString*)query;

@end
