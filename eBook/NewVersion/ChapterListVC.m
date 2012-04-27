//
//  ChapterListVC.m
//  eBook
//
//  Created by LiuWu on 12-4-19.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ChapterListVC.h"
#import "AppShare.h"
#import "ContentView.h"
#import "AllHeader.h"
#import "Book.h"
@interface ChapterListVC ()

@end

@implementation ChapterListVC

- (void)dealloc {
    
    [super dealloc];
}

- (void)viewDidLoad
{
    chapterList = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width ,  self.view.bounds.size.height) style:UITableViewStylePlain];
    [chapterList setAutoresizesSubviews:YES];
    [chapterList setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
    [chapterList setDelegate:self];
    [chapterList setDataSource:self];
    [chapterList setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:chapterList];
    
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}
#pragma mark -
#pragma mark TableView Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{ 
    return  curBook.ChapterCount;
//    return [share.ePub.spineIndexArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *chapterIndetifier = @"chapterIndetifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:chapterIndetifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:chapterIndetifier] autorelease];
    }
    //
    cell.textLabel.numberOfLines = 2;
    cell.textLabel.lineBreakMode = UILineBreakModeMiddleTruncation;
    cell.textLabel.adjustsFontSizeToFitWidth = YES;
    //设置每行显示的数据
    cell.textLabel.text = [NSString stringWithFormat:@"%d",indexPath.row];
    //cell.textLabel.text = [[share.ePub.spineIndexArray objectAtIndex:[indexPath row]] title];
    return cell;
}

//RootViewController.m
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"======== Section Title ========";
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //选中行的动画
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //调转到内容页面
//    [self presentModalViewController:self.epubViewController animated:YES];
//    [epubViewController loadSpine:[indexPath row] atPageIndex:0];
    ContentView *content = [[ContentView alloc] init];
    [content showWithIndex:[indexPath row]];
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
