//
//  eBookViewController.m
//  eBook
//
//  Created by LiuWu on 12-4-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "eBookViewController.h"

@interface eBookViewController ()

@end

@implementation eBookViewController
@synthesize catalogLabel,catalogLists;
@synthesize epubViewController;
@synthesize epubPageView;
@synthesize epub;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    //初始化屏幕内容
    catalogLabel = [[UILabel alloc] init];
    [catalogLabel setFrame:CGRectMake((self.view.bounds.size.width - 200.0f) / 2, 20.0f, 200.0f, 44.0f)];
    //设置根据屏幕自适应
    [catalogLabel setAutoresizesSubviews:YES];
    [catalogLabel setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    [catalogLabel setTextAlignment:UITextAlignmentCenter];
    [catalogLabel setText:@"创业36条军规"];
    [self.view addSubview:catalogLabel];
    
    catalogLists = [[UITableView alloc] initWithFrame:CGRectMake(30, 70, self.view.bounds.size.width - 60,  self.view.bounds.size.height - 100) style:UITableViewStylePlain];
    [catalogLists setAutoresizesSubviews:YES];
    [catalogLists setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
    [catalogLists setDelegate:self];
    [catalogLists setDataSource:self];
    [catalogLists setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:catalogLists];
    
    //初试化解析epub文件
    NSLog(@"初始化，开始epub文件解析！");

    epub = [[EPub alloc] initWithEPub:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"vhugo" ofType:@"epub"]]];
    NSLog(@"epub:  %d",[[epub spineIndexArray] count]);
    [catalogLabel setText:[epub title]];

    epubViewController = [[EPubViewController alloc] init];
    //调用解析epub文件
//    [epubViewController loadEpub:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"vhugo" ofType:@"epub"]]];
//    
//    epubPageView = [[EPubPageView alloc] init];
//    //调用解析epub文件
//    [epubPageView loadEpub:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"vhugo" ofType:@"epub"]]];
//    
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
}

#pragma mark - 
#pragma mark TableView DataSource Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [epub.spineIndexArray count];
//    return [epubViewController.loadedEpub.spineArray count];
//    return [epubPageView.epub.spineArray count];
}
//设置每一行显示的数据
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *eBookIdentifier = @"eBookIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:eBookIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:eBookIdentifier] autorelease];
    }
    //
    cell.textLabel.numberOfLines = 2;
    cell.textLabel.lineBreakMode = UILineBreakModeMiddleTruncation;
    cell.textLabel.adjustsFontSizeToFitWidth = YES;
    //设置每行显示的数据
    cell.textLabel.text = [[epub.spineIndexArray objectAtIndex:[indexPath row]] title];
//    cell.textLabel.text = [[epubViewController.loadedEpub.spineArray objectAtIndex:[indexPath row]] title];
//    cell.textLabel.text = [[epubPageView.epub.spineArray objectAtIndex:[indexPath row]] title];

    //详细的页数
//    cell.detailTextLabel.text = [epubViewController.loadedEpub.spineIndexArray objectAtIndex:[indexPath row]];
    return cell;
}

#pragma mark TableView Delegate Method
//选中行
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //选中行的动画
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //调转到内容页面
    [self presentModalViewController:self.epubViewController animated:YES];
    [epubViewController loadSpine:[indexPath row] atPageIndex:0];
}

- (void)dealloc
{
    [catalogLabel release];
    [catalogLists release];
    [epubViewController release];
    [super dealloc];
}

- (void)viewDidUnload
{
    catalogLabel = nil;
    catalogLists = nil;
    epubViewController = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
   // return YES;
}

@end
