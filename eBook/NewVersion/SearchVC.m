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
#import "Chapter.h"
#import "Book.h"
#import "NSString+HTML.h"
#import "SearchResult.h"
#import "UIWebView+SearchWebView.h"

@interface SearchVC ()

@end

@implementation SearchVC
@synthesize delegate,currentQuery,results,resultTable;

- (void)dealloc
{
    [super dealloc];
}

- (void)viewDidLoad
{
    [self.view setBackgroundColor:[UIColor scrollViewTexturedBackgroundColor]];
    
    UIView *searchView = [[UIView alloc] initWithFrame:CGRectMake(10, 20, self.view.bounds.size.width - 20, 50)];
    [searchView setBackgroundColor:[UIColor whiteColor]];
    [searchView setAutoresizesSubviews:YES];
    [searchView setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin];
    [self.view addSubview:searchView];
    
    UIView *resultView = [[UIView alloc] initWithFrame:CGRectMake(10, 80, self.view.bounds.size.width - 20, self.view.bounds.size.height - 100)];
    [resultView setBackgroundColor:[UIColor whiteColor]];
    [resultView setAutoresizesSubviews:YES];
    [resultView setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin];
    [self.view addSubview:resultView];
    
    UIImageView *bg = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, searchView.bounds.size.width - 90, 30)];
    [bg setImage:skinImage(@"searchbar/d003.png")];
    [bg setUserInteractionEnabled:YES];
    [bg setAutoresizesSubviews:YES];
    [bg setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin];
    [searchView addSubview:bg];
    
    UIImageView *searchIcon = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 20, 20)];
    [searchIcon setImage:skinImage(@"searchbar/d004.png")];
    [bg addSubview:searchIcon];
    
    searchField = [[UITextField alloc] initWithFrame:CGRectMake(27, 2, bg.bounds.size.width - 28, bg.bounds.size.height - 4)] ;
    [searchField setBorderStyle:UITextBorderStyleNone];
    searchField.adjustsFontSizeToFitWidth = YES;//设置为YES时文本会自动缩小以适应文本窗口大小。默认是保持原来大小，而让长文本滚动  
    searchField.clearButtonMode = UITextFieldViewModeUnlessEditing;//右边显示的'X'清楚按钮  
    searchField.returnKeyType = UIReturnKeySearch;
    [searchField setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];//text垂直居中
    [searchField setAutoresizesSubviews:YES];
    [searchField setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin];
    [searchField setDelegate:self];
    [bg addSubview:searchField];
    
    UIButton *searchButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [searchButton setTitle:@"search" forState:UIControlStateNormal];
    [searchButton setFrame:CGRectMake(searchView.bounds.size.width -70, 10, 60, 30)];
    [searchButton addTarget:self action:@selector(searchString:) forControlEvents:UIControlEventTouchUpInside];
    [searchButton setAutoresizesSubviews:YES];
    [searchButton setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin];
    [searchView addSubview:searchButton];
    
    resultTable = [[UITableView alloc] initWithFrame:CGRectMake(5, 5, resultView.bounds.size.width - 10, resultView.bounds.size.height - 20)];
    [resultTable setDataSource:self];
    [resultTable setDelegate:self];
    [resultTable setAutoresizesSubviews:YES];
    [resultTable setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin];
    [resultView addSubview:resultTable];

    
    [super viewDidLoad];
	// Do any additional setup after loading the view.
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
    DebugLog(@"result count - %d",results.count);
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
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *localTime=[formatter stringFromDate: [NSDate date]];
    
    cell.date.text = [NSString stringWithFormat:@"index:%d - page:%d", hit.chapterIndex, hit.pageIndex];
//    cell.date.text = localTime;
    cell.number.text = [NSString stringWithFormat:@"%d",hit.chapterPageIndex];
    cell.content.text = [NSString stringWithFormat:@"...%@...", hit.neighboringText];
//    cell.content.text = @"然能够在工作之余整理总结出这本书，也是他对自己多年经营和管理工作经验的一次复盘，我相信他总结出的经验和教训对于后来的创业者会有所启迪。陶然目前正在率领拉卡拉团队在金融服务领域大展宏图，并且有可能成为联想控股旗下现代服务业的一个重要业务模块，代服务业的一个重要业务模块，成为联想正规军的队伍，我也在此祝愿他和他的团队能";
    
    cell.date.highlightedTextColor = [UIColor whiteColor];
    cell.number.highlightedTextColor = [UIColor whiteColor];
    cell.content.highlightedTextColor = [UIColor whiteColor];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SearchResult* hit = (SearchResult*)[results objectAtIndex:[indexPath row]];
//    ContentView *content = [[ContentView alloc] init];
//    [content showWithIndex:[indexPath row]];
//    [content loadSpine:hit.chapterIndex atPageIndex:hit.pageIndex];
    
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"search" object:[NSString stringWithFormat:@"%d",hit.chapterPageIndex]];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"search" object:nil userInfo:[NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%d",hit.chapterIndex],@"chapterIndex", [NSString stringWithFormat:@"%d",hit.pageIndex],@"pageIndex",hit,@"searchResult",nil]];
     
    [tableView setSeparatorStyle:UITableViewCellSelectionStyleBlue];
    
    [self.delegate showSearchVC];
    
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
    self.results = [[NSMutableArray alloc] init];
    self.currentQuery = searchField.text;
    NSLog(@"query --> %@",currentQuery);   
    [self searchString:currentQuery inChapterAtIndex:0];
}

- (void) searchString:(NSString *)query inChapterAtIndex:(int)index{
    currentChapterIndex = index;
    
    Chapter* chapter = [curBook.chapters objectAtIndex:index];
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
        if(hitCount!=0){
            UIWebView* webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
            [webView setDelegate:self];
            NSURLRequest* urlRequest = [NSURLRequest requestWithURL:[NSURL fileURLWithPath:chapter.spinePath]];
            DebugLog(@"urlrequest --- %@",urlRequest);
            [webView loadRequest:urlRequest];   
        } else {
            if ((index + 1) < curBook.ChapterCount) {
                [self searchString:self.currentQuery inChapterAtIndex:(index + 1)];
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
	
	NSString *insertRule1 = [NSString stringWithFormat:@"addCSSRule('html', 'padding: 0px; height: %fpx; -webkit-column-gap: 0px; -webkit-column-width: %fpx;')", webView.frame.size.height, webView.frame.size.width];
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
    
    NSLog(@"orderedRes count  -----》%d",[orderedRes count]);
    
    for(int i=0; i<[orderedRes count]; i++){
        NSArray* currObj = [orderedRes objectAtIndex:i];
//        NSLog(@"vvvvvvvv  -----》%d", );
//        NSLog(@"dddddd - - %d",[[currObj objectAtIndex:1] intValue]);
        NSLog(@"webView height: %f",webView.bounds.size.height);
        SearchResult* searchRes = [[SearchResult alloc] initWithChapterIndex:currentChapterIndex pageIndex:([[currObj objectAtIndex:1] intValue]/webView.bounds.size.height) hitIndex:0 neighboringText:[webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"unescape('%@')", [currObj objectAtIndex:2]]] originatingQuery:currentQuery];
        [results addObject:searchRes];
		[searchRes release];
    }
    [webView dealloc];
    
    [resultTable performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
    if((currentChapterIndex+1) < [curBook.chapters count]){
        [self searchString:currentQuery inChapterAtIndex:(currentChapterIndex+1)];
    } else {
//        epubViewController.searching = NO;
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
