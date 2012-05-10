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
#import "MyTableViewCell.h"
#import "MyTableCell.h"
#import "Chapter.h"
#import "BookMark.h"


@interface ChapterListVC ()

@end

@implementation ChapterListVC
@synthesize delegate,sortedValues;

- (void)dealloc {
    [chapterList release];
    [super dealloc];
}

- (void)viewDidLoad
{
    UIImageView *imageView = [UIImageView nodeWithImage:skinImage(@"catalogbar/h002.png")];
    [imageView setFrame:CGRectMake(10, 10, self.view.bounds.size.width-20, 80)];
    [imageView setUserInteractionEnabled:YES];//允许响应用户交互事件
    [imageView setAutoresizesSubviews:YES];
    [imageView setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    [self.view addSubview:imageView];
    
    float win = self.view.bounds.size.width/4.0 - 20;
    
    cataButton1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [cataButton1 setBackgroundImage:skinImage(@"catalogbar/h003.png") forState:UIControlStateNormal];
    [cataButton1 setFrame:CGRectMake(30, 20, win, 25)];
    [cataButton1 setTitle:@"目录" forState:UIControlStateNormal];
    [cataButton1.titleLabel setFont:[UIFont systemFontOfSize:12]];
    [cataButton1 setAutoresizesSubviews:YES];
    [cataButton1 setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleLeftMargin];
    [cataButton1 setTag:0];
    [cataButton1 addTarget:self action:@selector(catalogSelected:) forControlEvents:UIControlEventTouchUpInside];
    [imageView addSubview:cataButton1];
    
    cataButton2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [cataButton2 setFrame:CGRectMake(91, 20, win, 25)];
    [cataButton2 setTitle:@"书签" forState:UIControlStateNormal];
    [cataButton2.titleLabel setFont:[UIFont systemFontOfSize:12]];
    [cataButton2 setAutoresizesSubviews:YES];
    [cataButton2 setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleLeftMargin];
    [cataButton2 setTag:1];
    [cataButton2 addTarget:self action:@selector(catalogSelected:) forControlEvents:UIControlEventTouchUpInside];
    [imageView addSubview:cataButton2];
    
    cataButton3 = [UIButton buttonWithType:UIButtonTypeCustom];
    [cataButton3 setFrame:CGRectMake(152, 20, win, 25)];
    [cataButton3 setTitle:@"书摘" forState:UIControlStateNormal];
    [cataButton3.titleLabel setFont:[UIFont systemFontOfSize:12]];
    [cataButton3 setAutoresizesSubviews:YES];
    [cataButton3 setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleLeftMargin];
    [cataButton3 setTag:2];
    [cataButton3 addTarget:self action:@selector(catalogSelected:) forControlEvents:UIControlEventTouchUpInside];
    [imageView addSubview:cataButton3];
    
    cataButton4 = [UIButton buttonWithType:UIButtonTypeCustom];
    [cataButton4 setFrame:CGRectMake(214, 20, win, 25)];
    [cataButton4 setTitle:@"批注" forState:UIControlStateNormal];
    [cataButton4.titleLabel setFont:[UIFont systemFontOfSize:12]];
    [cataButton4 setAutoresizesSubviews:YES];
    [cataButton4 setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleLeftMargin];
    [cataButton4 setTag:3];
    [cataButton4 addTarget:self action:@selector(catalogSelected:) forControlEvents:UIControlEventTouchUpInside];
    [imageView addSubview:cataButton4];
    
    chapterList = [[UITableView alloc] initWithFrame:CGRectMake(10, 90, self.view.bounds.size.width-20 , self.view.bounds.size.height) style:UITableViewStyleGrouped];
    [chapterList setAutoresizesSubviews:YES];
    [chapterList setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
    [chapterList setDelegate:self];
    [chapterList setDataSource:self];
    [chapterList setBackgroundColor:[UIColor clearColor]];
    [chapterList setSeparatorColor:[UIColor clearColor]];//去掉背景
    [chapterList setSeparatorStyle:UITableViewCellSeparatorStyleNone];//设置没有分割线
    [self.view addSubview:chapterList];
    
    ///设置默认选中的行
    curSpineIndex = [[[NSUserDefaults standardUserDefaults] valueForKey:@"curSpineIndex"] intValue];
    ip=[NSIndexPath indexPathForRow:curSpineIndex inSection:0];
    [chapterList selectRowAtIndexPath:ip animated:YES scrollPosition:UITableViewScrollPositionBottom];
    
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:skinImage(@"catalogbar/h004.png")]];
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)buttonClick:(id)sender
{
    NSLog(@"buttonClick");
    
    UIButton *button = (UIButton *)sender;
    NSLog(@"button %d",button.tag);
}

- (void)catalogSelected:(id)sender
{
    UIButton *button = (UIButton *)sender;
    check = button.tag;
    NSLog(@"button tag:%d",check);
    switch (button.tag) {  
        case 0:  
            // 目录
            [cataButton1 setBackgroundImage:skinImage(@"catalogbar/h003.png") forState:UIControlStateNormal];
            [cataButton2 setBackgroundImage:nil forState:UIControlStateNormal];
            [cataButton3 setBackgroundImage:nil forState:UIControlStateNormal];
            [cataButton4 setBackgroundImage:nil forState:UIControlStateNormal];
            
            [chapterList reloadData];
            ///设置默认选中的行
            curSpineIndex = [[[NSUserDefaults standardUserDefaults] valueForKey:@"curSpineIndex"] intValue];
            ip=[NSIndexPath indexPathForRow:curSpineIndex inSection:0];
//            DebugLog(@"aaaaa - %d",curSpineIndex);
            [chapterList selectRowAtIndexPath:ip animated:YES scrollPosition:UITableViewScrollPositionBottom]; 
            break;  
        case 1:  
            // 标签
            [cataButton2 setBackgroundImage:skinImage(@"catalogbar/h003.png") forState:UIControlStateNormal];
            [cataButton1 setBackgroundImage:nil forState:UIControlStateNormal];
            [cataButton3 setBackgroundImage:nil forState:UIControlStateNormal];
            [cataButton4 setBackgroundImage:nil forState:UIControlStateNormal];
            [chapterList reloadData];
            break;  
        case 2:  
            // 书摘
            [cataButton3 setBackgroundImage:skinImage(@"catalogbar/h003.png") forState:UIControlStateNormal];
            [cataButton1 setBackgroundImage:nil forState:UIControlStateNormal];
            [cataButton2 setBackgroundImage:nil forState:UIControlStateNormal];
            [cataButton4 setBackgroundImage:nil forState:UIControlStateNormal];
            [chapterList reloadData];
            break; 
        case 3:
            //批注
            [cataButton4 setBackgroundImage:skinImage(@"catalogbar/h003.png") forState:UIControlStateNormal];
            [cataButton1 setBackgroundImage:nil forState:UIControlStateNormal];
            [cataButton2 setBackgroundImage:nil forState:UIControlStateNormal];
            [cataButton3 setBackgroundImage:nil forState:UIControlStateNormal];
            [chapterList reloadData];
            break;
        default:  
            break;  
    }  
}

#pragma mark -
#pragma mark TableView Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSLog(@"check :%d",check);
    if (check == 0) {
        return 1;
    }else if (check == 1) {
        return 1;
    }else if (check == 2){
        return 2;
    }else {
        return 2;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{ 
    NSLog(@"tag----%d",check);
    if (check == 0) {
        return curBook.ChapterCount;
    }else if (check == 1) {
        return bookMarks.currentBookMark.count;
    }else if(check == 2){
        return 8;
    }else {
        return 2;
    }
}

//设置标题
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (check == 0) {
        return @"";
    }else if (check == 1) {
        return @"";
    }else if(check == 2){
        return [NSString stringWithFormat:@"========    Section Title %d    ========",section];;
    }else {
        return [NSString stringWithFormat:@"========    Section Title %d    ========",section];;
    }

}
//重新设置显示标题的View
- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    NSString *sectionTitle = [self tableView:tableView titleForHeaderInSection:section];
    if (sectionTitle == nil) {
        return  nil;
    }
    UILabel * label = [[[UILabel alloc] init] autorelease];
    label.frame = CGRectMake(0, 20, tableView.bounds.size.width, 22);
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor grayColor];
    [label setTextAlignment:UITextAlignmentCenter];
    label.font=[UIFont fontWithName:@"Helvetica-Bold" size:15];
    label.text = sectionTitle;
    [label setAutoresizesSubviews:YES];
    [label setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin];
    
    UIView * sectionView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 50)] autorelease];
    [sectionView setBackgroundColor:[UIColor clearColor]];
    [sectionView addSubview:label];
    [sectionView setAutoresizesSubviews:YES];
    [sectionView setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin];
    return sectionView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *tag = @"cell";//由于用了两种界面模式所以两个tag
    static NSString *tag1 = @"cell1";
    
    UILabel *fenge = [[UILabel alloc] init];
    [fenge setBackgroundColor:[UIColor colorWithPatternImage:skinImage(@"catalogbar/h005.png")]];
    [fenge setAutoresizesSubviews:YES];
    [fenge setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin];
    
    if (check != 0) {
        MyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:tag1];
        if (cell == nil) {
            cell = [[[MyTableViewCell alloc] init] autorelease];
        }
        
        //书签
        if (check == 1) {
            //获取书签列表
            [bookMarks getBookMark];            
            //排序
            NSArray *myKeys = [bookMarks.bookmarks allKeys];
            NSArray *array = [myKeys sortedArrayUsingFunction:customSort context:nil];
            
            self.sortedValues = [[[NSMutableArray alloc] init] autorelease];
            for(id key in array) {
                id object = [bookMarks.bookmarks objectForKey:key];
                [sortedValues addObject:object];
            }
            cell.date.text = [[sortedValues objectAtIndex:indexPath.row] objectForKey:@"time"];
            cell.number.text = [[sortedValues objectAtIndex:indexPath.row] objectForKey:@"pageIndex"];
            cell.content.text = [[sortedValues objectAtIndex:indexPath.row] objectForKey:@"content"];
            
//            cell.date.text = [[bookMarks.currentBookMark.allValues objectAtIndex:indexPath.row] objectForKey:@"time"];
//            cell.number.text = [[bookMarks.currentBookMark.allValues objectAtIndex:indexPath.row] objectForKey:@"pageIndex"];
//            cell.content.text = [[bookMarks.currentBookMark.allValues objectAtIndex:indexPath.row] objectForKey:@"content"];
        }
        //书摘
        if (check == 2) {
            cell.date.text = @"2010.1.1";
            cell.number.text = [NSString stringWithFormat:@"%d",indexPath.row];
            cell.content.text = @"然能够在工作之余整理总结出这本书，也是他对自己多年经营和管理工作经验的一次复盘，我相信他总结出的经验和教训对于后来的创业者会有所启迪。陶然目前正在率领拉卡拉团队在金融服务领域大展宏图，并且有可能成为联想控股旗下现代服务业的一个重要业务模块，代服务业的一个重要业务模块，成为联想正规军的队伍，我也在此祝愿他和他的团队能";
        }
        //批注
        if (check == 3) {
            cell.date.text = @"2010.1.1";
            cell.number.text = [NSString stringWithFormat:@"%d",indexPath.row];
            cell.content.text = @"然能够在工作之余整理总结出这本书，也是他对自己多年经营和管理工作经验的一次复盘，我相信他总结出的经验和教训对于后来的创业者会有所启迪。陶然目前正在率领拉卡拉团队在金融服务领域大展宏图，并且有可能成为联想控股旗下现代服务业的一个重要业务模块，代服务业的一个重要业务模块，成为联想正规军的队伍，我也在此祝愿他和他的团队能";
        }
        cell.date.highlightedTextColor = [UIColor whiteColor];
        cell.number.highlightedTextColor = [UIColor whiteColor];
        cell.content.highlightedTextColor = [UIColor whiteColor];
        
        [fenge setFrame:CGRectMake(0, cell.height-1, tableView.bounds.size.width, 1)];
        [cell.contentView addSubview:fenge];
        return cell;
    }else{
        MyTableCell *cell = [tableView dequeueReusableCellWithIdentifier:tag];
        if (cell == nil) {
            cell = [[[MyTableCell alloc] init] autorelease];
        }
        
        Chapter *chapter =  [curBook.chapters objectAtIndex:indexPath.row];
        cell.content.text = chapter.title;
        cell.index.text = [NSString stringWithFormat:@"%d",chapter.chapterIndex];
//        
//        cell.content.text = @"工作之余整";
//        cell.index.text = [NSString stringWithFormat:@"%d",indexPath.row];
        
        cell.content.highlightedTextColor = [UIColor whiteColor];
        cell.index.highlightedTextColor = [UIColor whiteColor];
        
        [fenge setFrame:CGRectMake(0, cell.height-1, tableView.bounds.size.width, 1)];
        [cell.contentView addSubview:fenge];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DebugLog(@"selectIndex %d",[indexPath row]);
//    ContentView *content = [[ContentView alloc] init];
//    [content showWithIndex:[indexPath row]];
//    [content loadSpine:[indexPath row] atPageIndex:0];
    [tableView setSeparatorStyle:UITableViewCellSelectionStyleBlue];
    if (check == 0) {
        //目录
        Chapter *chapter =  [curBook.chapters objectAtIndex:indexPath.row];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"chapterListPageLoad" object:[NSString stringWithFormat:@"%d",chapter.chapterIndex]];
    }else if (check == 1) {
        //书签
        [[NSNotificationCenter defaultCenter] postNotificationName:@"chapterListPageLoad" object:[[sortedValues objectAtIndex:indexPath.row] objectForKey:@"pageIndex"]];
    }else if(check == 2){
        
    }else {
        
    }

    
    [self.delegate ChapterListClick];
    
}

//设置cell每行间隔的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    if (check == 0) {
        return 45.0;
    }else {
        return 100.0;
    }
}

//排序
NSInteger customSort(id obj1, id obj2,void* context){
    if ([obj1 integerValue] > [obj2 integerValue]) {
        return (NSComparisonResult)NSOrderedDescending;
    }
    
    if ([obj1 integerValue] < [obj2 integerValue]) {
        return (NSComparisonResult)NSOrderedAscending;
    }
    return (NSComparisonResult)NSOrderedSame;
}

- (void)viewDidUnload
{
    [cataButton1 release];
    [cataButton2 release];
    [cataButton3 release];
    [cataButton4 release];
    chapterList = nil;
    cataButton1 = nil;
    cataButton2 = nil;
    cataButton3 = nil;
    cataButton4 = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation{
    [super didRotateFromInterfaceOrientation:fromInterfaceOrientation];
}

@end
