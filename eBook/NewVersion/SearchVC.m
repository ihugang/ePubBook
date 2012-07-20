//
//  SearchVC.m
//  eBook
//
//  Created by LiuWu on 12-4-28.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "SearchVC.h"
#import "ContentView.h"
#import "MyTableViewCell.h"
#import "Book.h"
#import "NSString+HTML.h"
#import "SearchResult.h"
#import "ResManager.h"
#import "UIWebView+SearchWebView.h"
#import "CustomNavigationBar.h"

@interface SearchVC ()

@end

@implementation SearchVC
@synthesize delegate,currentQuery,results,resultTable,firstresults;

- (void)dealloc
{
    [resultTable release];
    [currentQuery release];
    [results release];
    [firstresults release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [self.view setBackgroundColor:[UIColor scrollViewTexturedBackgroundColor]];
    
    UINavigationBar *navBar = [[[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 44)] autorelease];
    [self.view addSubview:navBar];
    [navBar setAutoresizesSubviews:YES];
    [navBar setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin];
    
    //给导航栏设置背景图片
    if ([navBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)]) {
        [navBar setBackgroundImage:skinImage(@"navbar/b002.png") forBarMetrics:UIBarMetricsDefault];
    }
    
//    [navBar setTintColor:[UIColor colorWithPatternImage:skinImage(@"operbar/b002.png")]];
    
    //创建一个导航栏集合  
    UINavigationItem *navigationItem = [[[UINavigationItem alloc] initWithTitle:nil] autorelease];    
    //创建一个左边按钮  
//    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithTitle:@"返回"     
//                                                                   style:UIBarButtonItemStylePlain    
//                                                                  target:self     
//                                                                  action:@selector(clickLeftButton)];   
    //自定义返回按钮
    UIButton *button = [UIButton buttonWithType: UIButtonTypeCustom]; 
    [button setTitle:@"返 回" forState:UIControlStateNormal];
    [button.titleLabel setFont:[UIFont boldSystemFontOfSize:12]];
    // Set its background image for some states...
    [button setBackgroundImage: skinImage(@"operbar/b007.png") forState:UIControlStateNormal];  
    // Add target to receive Action
    [button addTarget: self action:@selector(clickLeftButton) forControlEvents:UIControlEventTouchUpInside]; 
    // Set frame width, height
    button.frame = CGRectMake(0, 0, 50, 26);  
    // Add this UIButton as a custom view to the self.navigationItem.leftBarButtonItem
    UIBarButtonItem *customButton = [[[UIBarButtonItem alloc] initWithCustomView: button] autorelease]; 
    
    //设置导航栏内容  
    [navigationItem setTitle:@"搜 索"];  
    
//    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, navBar.bounds.size.width,navBar.bounds.size.height)];
//    [title setText:@"搜 索"];
//    [title setTextAlignment:UITextAlignmentCenter];
//    [title setFont:[UIFont boldSystemFontOfSize:20]];
//    [title setTextColor:[UIColor redColor]];
////    [title setBackgroundColor:[UIColor clearColor]];
//    [navigationItem setTitleView:title];
    
    //把导航栏集合添加入导航栏中，设置动画关闭  
    [navBar pushNavigationItem:navigationItem animated:YES];
    //把左右两个按钮添加入导航栏集合中  
//    [navigationItem setLeftBarButtonItem:leftButton];
    [navigationItem setLeftBarButtonItem:customButton];
    
    UIView *searchView = [[[UIView alloc] initWithFrame:CGRectMake(10, navBar.bounds.size.height+10, self.view.bounds.size.width - 20, 50)] autorelease];
    [searchView setBackgroundColor:[UIColor whiteColor]];
    [searchView setAutoresizesSubviews:YES];
    [searchView setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin];
    [self.view addSubview:searchView];
    
    UIView *resultView = [[[UIView alloc] initWithFrame:CGRectMake(10, navBar.bounds.size.height + searchView.bounds.size.height + 20, self.view.bounds.size.width - 20, self.view.bounds.size.height - navBar.bounds.size.height - searchView.bounds.size.height - 30)] autorelease];
    [resultView setBackgroundColor:[UIColor whiteColor]];
    [resultView setAutoresizesSubviews:YES];
    [resultView setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin];
    [self.view addSubview:resultView];
    
    UIImageView *bg = [[[UIImageView alloc] initWithFrame:CGRectMake(10, 10, searchView.bounds.size.width - 90, 30)] autorelease];
    [bg setImage:skinImage(@"searchbar/d003.png")];
    [bg setUserInteractionEnabled:YES];
    [bg setAutoresizesSubviews:YES];
    [bg setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin];
    [searchView addSubview:bg];
    
    UIImageView *searchIcon = [[[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 20, 20)] autorelease];
    [searchIcon setImage:skinImage(@"searchbar/d004.png")];
    [bg addSubview:searchIcon];
    
    searchField = [[[UITextField alloc] initWithFrame:CGRectMake(27, 2, bg.bounds.size.width - 28, bg.bounds.size.height - 4)] autorelease] ;
    [searchField setBorderStyle:UITextBorderStyleNone];
    searchField.adjustsFontSizeToFitWidth = YES;//设置为YES时文本会自动缩小以适应文本窗口大小。默认是保持原来大小，而让长文本滚动  
    searchField.clearButtonMode = UITextFieldViewModeUnlessEditing;//右边显示的'X'清楚按钮  
    searchField.returnKeyType = UIReturnKeySearch;
    [searchField setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];//text垂直居中
    [searchField setAutoresizesSubviews:YES];
    [searchField setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin];
    [searchField becomeFirstResponder];
    [searchField setDelegate:self];
    [bg addSubview:searchField];
    
    UIButton *searchButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [searchButton setBackgroundImage: skinImage(@"operbar/b007.png") forState:UIControlStateNormal];  
    [searchButton setTitle:@"搜 索" forState:UIControlStateNormal];
    [searchButton.titleLabel setFont:[UIFont boldSystemFontOfSize:14]];
    [searchButton setFrame:CGRectMake(searchView.bounds.size.width -70, 10, 60, 30)];
    [searchButton addTarget:self action:@selector(searchString:) forControlEvents:UIControlEventTouchUpInside];
    [searchButton setAutoresizesSubviews:YES];
    [searchButton setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin];
    [searchView addSubview:searchButton];
    
    self.resultTable = [[[UITableView alloc] initWithFrame:CGRectMake(5, 5, resultView.bounds.size.width - 10, resultView.bounds.size.height - 10)] autorelease];
    [resultTable setDataSource:self];
    [resultTable setDelegate:self];
    [resultTable setAutoresizesSubviews:YES];
    [resultTable setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin];
    [resultView addSubview:resultTable];
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

-(void)clickLeftButton  
{  
    NSLog(@"clickLeftButton");
    [self dismissModalViewControllerAnimated:YES];
} 

- (void)search:(id)sender
{
    NSLog(@"search");
    [self.delegate showSearchVC];
    
}

#pragma mark -
#pragma mark TableView Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{ 
//    DebugLog(@"result count - %d",results.count);
    return results.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *tag = @"cell";//由于用了两种界面模式所以两个tag
    MyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:tag];
    if (cell == nil) {
        cell = [[[MyTableViewCell alloc] init] autorelease];
    }
    
    SearchResult* hit = (SearchResult*)[results objectAtIndex:[indexPath row]];
//    cell.textLabel.text = [NSString stringWithFormat:@"...%@...", hit.neighboringText];
//    cell.detailTextLabel.text = [NSString stringWithFormat:@"Chapter %d - page %d", hit.chapterIndex, hit.pageIndex+1];
    NSDateFormatter *formatter = [[[NSDateFormatter alloc] init] autorelease];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *localTime=[formatter stringFromDate: [NSDate date]];
    
//    cell.date.text = [NSString stringWithFormat:@"index:%d - page:%d", hit.chapterIndex, hit.pageIndex];
    cell.date.text = localTime;
    cell.number.text = [NSString stringWithFormat:@"%d",hit.chapterPageIndex];
    cell.content.text = [NSString stringWithFormat:@"...%@...", hit.neighboringText];
    
    cell.date.highlightedTextColor = [UIColor whiteColor];
    cell.number.highlightedTextColor = [UIColor whiteColor];
    cell.content.highlightedTextColor = [UIColor whiteColor];
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SearchResult* hit = (SearchResult*)[results objectAtIndex:[indexPath row]];
    
    //发送通知跳转页面
    [[NSNotificationCenter defaultCenter] postNotificationName:@"searchPageIndex" object:nil userInfo:[NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%d",hit.chapterPageIndex],@"chapterPageIndex",hit,@"searchResult", nil]];
    [tableView setSeparatorStyle:UITableViewCellSelectionStyleBlue];
    
    [self.delegate showSearchVC];
    
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView * sectionView = [[[UIView alloc] initWithFrame:CGRectMake(0,resultTable.height, tableView.bounds.size.width,tableView.bounds.size.height)] autorelease];
    //上拉刷新
    _refreshHeaderView=[[EGORefreshTableHeaderView alloc] initWithFrame:
                        CGRectMake(0,100, sectionView.bounds.size.width, sectionView.bounds.size.height)];
    _refreshHeaderView.delegate=self;
    [_refreshHeaderView refreshLastUpdatedDate];
    
    [sectionView setBackgroundColor:[UIColor clearColor]];
    [sectionView addSubview:_refreshHeaderView];
    [sectionView setAutoresizesSubviews:YES];
    [sectionView setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin];
    if (results.count > 4) {
        _refreshHeaderView.hidden = NO;
    }else {
        _refreshHeaderView.hidden = YES;
    }
//    if ([tableView numberOfRowsInSection:0] > 4) {
//        
//    }else {
//        
//    }
    return sectionView;

}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 30;
}

//设置cell每行间隔的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    return 100.0;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    //当捕捉到触摸事件时，取消UITextField的第一相应
    [searchField resignFirstResponder];
}

#pragma mark textField Delegate method
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    [self searchString:textField.text];
    return YES;
}

- (void)searchString:(NSString*)query
{
    first = 0;
    self.results = [[[NSMutableArray alloc] init] autorelease];
    self.currentQuery = searchField.text;
    NSLog(@"query --> %@",currentQuery);   
    [self searchString:currentQuery inChapterAtIndex:0];
    [searchField resignFirstResponder];
}

- (void) searchString:(NSString *)query inChapterAtIndex:(int)index{
    currentChapterIndex = index;
//    firstresults = results;
    
    chapter = [curBook.chapters objectAtIndex:index];
    if (query != nil) {
        NSRange range = NSMakeRange(0, chapter.text.length);
        range = [chapter.text rangeOfString:query options:NSCaseInsensitiveSearch range:range locale:nil];
//        NSRange range = [chapter.text rangeOfString:query options:NSCaseInsensitiveSearch];
        int hitCount=0;
        while (range.location != NSNotFound) {
            DebugLog(@"range location - %d",range.location);
            DebugLog(@"chapter index - %d",index);
            range = NSMakeRange(range.location+range.length, chapter.text.length-(range.location+range.length));
            range = [chapter.text rangeOfString:query options:NSCaseInsensitiveSearch range:range locale:nil];
            hitCount++;
        }
        DebugLog(@"==============%d",firstresults.count);
        if(hitCount!=0){
//            UIWebView* webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
            
            UIWebView* webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, curBook.PageWidth, curBook.PageHeight)];
            [webView setDelegate:self];
            NSURLRequest* urlRequest = [NSURLRequest requestWithURL:[NSURL fileURLWithPath:chapter.spinePath]];
            DebugLog(@"urlrequest --- %@",urlRequest);
            [webView loadRequest:urlRequest];
            
        } else {
            currentChapterIndex = currentChapterIndex + 1;
            if (currentChapterIndex < curBook.ChapterCount) {
                //重新加载下一个html
                [self searchString:self.currentQuery inChapterAtIndex:currentChapterIndex];
            }else {
                DebugLog(@"NO chapter!");
            }
        }
    }
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    NSLog(@"%@", error);
	[webView release];
}

- (void) webViewDidFinishLoad:(UIWebView*)webView{
    NSString *varMySheet = @"var mySheet = document.styleSheets[0];";
	
	NSString *addCSSRule =  @"function addCSSRule(selector, newRule) {"
	"if (mySheet.addRule) {"
    "mySheet.addRule(selector, newRule);"								// For Internet Explorer
	"} else {"
    "ruleIndex = mySheet.cssRules.length;"
    "mySheet.insertRule(selector + '{' + newRule + ';}', ruleIndex);"   // For Firefox, Chrome, etc.
    "}"
	"}";
	
    //    NSLog(@"w:%f h:%f", webView.bounds.size.width, webView.bounds.size.height);
	DebugLog(@"SearchVc webview-----> height:%f   width: %f",webView.frame.size.height,webView.frame.size.width);
    
	NSString *insertRule1 = [NSString stringWithFormat:@"addCSSRule('html', 'padding: 0px; height: %fpx; -webkit-column-gap: 0px; -webkit-column-width: %fpx;')", webView.frame.size.height, webView.frame.size.width];
    //不同大小，窗口寛 高 不同
//    NSString *insertRule1 = [NSString stringWithFormat:@"addCSSRule('html', 'padding: 0px; height: %fpx; -webkit-column-gap: 0px; -webkit-column-width: %fpx;')", curBook.PageHeight, curBook.PageWidth];
	NSString *insertRule2 = [NSString stringWithFormat:@"addCSSRule('p', 'text-align: justify;')"];
	NSString *setTextSizeRule = [NSString stringWithFormat:@"addCSSRule('body', '-webkit-text-size-adjust: %d%%;')",curBook.BodyFontSize];
    DebugLog(@"setTextSizeRule -- %@",setTextSizeRule);
	
	[webView stringByEvaluatingJavaScriptFromString:varMySheet];
	
	[webView stringByEvaluatingJavaScriptFromString:addCSSRule];
    
	[webView stringByEvaluatingJavaScriptFromString:insertRule1];
	
	[webView stringByEvaluatingJavaScriptFromString:insertRule2];
	
    [webView stringByEvaluatingJavaScriptFromString:setTextSizeRule];
    
    [webView highlightAllOccurencesOfString:currentQuery];
    
    NSString* foundHits = [webView stringByEvaluatingJavaScriptFromString:@"results"];
    
    NSLog(@"foundHits --  %@", foundHits);
    
    NSMutableArray* objects = [[NSMutableArray alloc] init];
    
    NSArray* stringObjects = [foundHits componentsSeparatedByString:@";"];
    for(int i=0; i<[stringObjects count]; i++){
        NSArray* strObj = [[stringObjects objectAtIndex:i] componentsSeparatedByString:@","];
        if([strObj count]==3){
            [objects addObject:strObj];   
        }
    }
    
    NSArray* orderedRes = [objects sortedArrayUsingComparator:^(id obj1, id obj2){
        int x1 = [[obj1 objectAtIndex:0] intValue];
        int x2 = [[obj2 objectAtIndex:0] intValue];
        int y1 = [[obj1 objectAtIndex:1] intValue];
        int y2 = [[obj2 objectAtIndex:1] intValue];
        if(y1<y2){
            return NSOrderedAscending;
        } else if(y1>y2){
            return NSOrderedDescending;
        } else {
            if(x1<x2){
                return NSOrderedAscending;
            } else if (x1>x2){
                return NSOrderedDescending;
            } else {
                return NSOrderedSame;
            }
        }
    }];
    
    [objects release];
    
    for(int i=0; i<[orderedRes count]; i++){
        NSArray* currObj = [orderedRes objectAtIndex:i];
        SearchResult* searchRes = [[SearchResult alloc] initWithChapterIndex:currentChapterIndex pageIndex:([[currObj objectAtIndex:1] intValue]/webView.bounds.size.height) hitIndex:0 neighboringText:[webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"unescape('%@')", [currObj objectAtIndex:2]]] originatingQuery:currentQuery];
        [results addObject:searchRes];
		[searchRes release];
    }
    [webView dealloc];

    DebugLog(@"=aa=============%d",first);
    
    if (results.count > 10 && results.count - first > 10 ) {
        currentChapterIndex = currentChapterIndex + 1;
        first = results.count;
        DebugLog(@"=results=============%d",results.count);
        [resultTable performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
    }else {
        DebugLog(@"=results=============%d",results.count );
        [self searchString:currentQuery inChapterAtIndex:(currentChapterIndex + 1 )];
        [resultTable performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
    }

}

//此方法是结束读取数据
- (void)doneLoadingTableViewData{
	first = results.count;
    if (currentChapterIndex < curBook.ChapterCount) {
        [self searchString:currentQuery inChapterAtIndex:currentChapterIndex];
    }else {
        [_refreshHeaderView refreshLastUpdatedDate]; 
    }
    
	_reloading = NO;
	[_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:resultTable];
	NSLog(@"end");
	
}


//此方法是开始读取数据
- (void)reloadTableViewDataSource{
	_reloading = YES;
    search = YES;
	NSLog(@"star");
    [self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:0];
    
	//打开线程，读取网络图片
//	[NSThread detachNewThreadSelector:@selector(requestImage) toTarget:self withObject:nil];
    
}



#pragma mark -
#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{	
	
	[_refreshHeaderView egoRefreshScrollViewDidScroll:resultTable];
	
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
	
	[_refreshHeaderView egoRefreshScrollViewDidEndDragging:resultTable];
	
}


#pragma mark -
#pragma mark EGORefreshTableHeaderDelegate Methods

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view{
	
	[self reloadTableViewDataSource];
	//[self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:0.5];
	
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view{
	
	return _reloading; // should return if data source model is reloading
	
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view{
	
    if (currentChapterIndex < curBook.ChapterCount) {
        return [NSDate date]; // should return date data source was last changed
    }else {
        return nil;
    }
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation{
    [super didRotateFromInterfaceOrientation:fromInterfaceOrientation];
}


@end
