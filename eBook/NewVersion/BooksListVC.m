//
//  BooksListVC.m
//  eBook
//
//  Created by LiuWu on 12-5-2.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "BooksListVC.h"
#import "BooksCell.h"
#import "BookStore.h"

@implementation BooksListVC

- (void)dealloc
{
    [super dealloc];
}

- (void)viewDidLoad
{
    [self.view setBackgroundColor:[UIColor scrollViewTexturedBackgroundColor]];
    
    UINavigationBar *navBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 44)];
    [self.view addSubview:navBar];
    [navBar setAutoresizesSubviews:YES];
    [navBar setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin];
    //创建一个导航栏集合  
    UINavigationItem *navigationItem = [[UINavigationItem alloc] initWithTitle:nil];    
    //创建一个左边按钮  
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithTitle:@"关闭"     
                                                                   style:UIBarButtonItemStylePlain    
                                                                  target:self     
                                                                  action:@selector(clickLeftButton)];    
    //创建一个右边按钮  
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"续读"     
                                                                    style:UIBarButtonItemStyleDone     
                                                                   target:self     
                                                                   action:@selector(clickRightButton)];    
    //设置导航栏内容  
    [navigationItem setTitle:@"赌遍全球"];  
    //把导航栏集合添加入导航栏中，设置动画关闭  
    [navBar pushNavigationItem:navigationItem animated:YES];
    //把左右两个按钮添加入导航栏集合中  
    [navigationItem setLeftBarButtonItem:leftButton];   
    [navigationItem setRightBarButtonItem:rightButton]; 
    
    UITableView *booksList = [[UITableView alloc] initWithFrame:CGRectMake(0, navBar.frame.size.height, self.view.bounds.size.width, self.view.bounds.size.height - navBar.frame.size.height)];
    [booksList setDelegate:self];
    [booksList setDataSource:self];
    [booksList setAutoresizesSubviews:YES];
    [booksList setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleLeftMargin];
    [self.view addSubview:booksList];
    
    [bookStore getBook];
    
    //释放对象
    [navBar release];
    [navigationItem release];    
    [leftButton release];    
    [rightButton release]; 
    
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

-(void)clickLeftButton  
{  
    NSLog(@"clickLeftButton");
    [self dismissModalViewControllerAnimated:YES];
}  


-(void)clickRightButton  
{  
    NSLog(@"clickRightButton");
}  

#pragma mark -
#pragma mark TableView Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[bookStore books] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *books = @"books";
    BooksCell *cell = [tableView dequeueReusableCellWithIdentifier:books];
    if (cell == nil) {
//        cell = [[[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:books] autorelease];
        cell = [[[BooksCell alloc] init] autorelease];
    }
    int row = [indexPath row];
//    cell.bookIcon.image = resImage(@"bookicon/d001.png");
    cell.bookIcon.image = resImage([[[bookStore books] objectAtIndex:row] valueForKey:@"icon"]);
    cell.bookName.text = [[[bookStore books] objectAtIndex:row] valueForKey:@"name"];
    cell.bookAbout.text = [[[bookStore books] objectAtIndex:row] valueForKey:@"description"];
    
//    cell.bookIcon.image = skinImage(@"searchbar/d001.png");
//    cell.bookName.text = @"iphone 开发基础";
//    cell.bookAbout.text = @"能够在工作之余整理总结出这本书，也是他对自己多年经营和管理工作经验的一次复盘，我相信他总结出的经验和教训对于后来的创业者会有所启迪。陶然目前正在率领拉卡拉团队在金融服务";
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *path = [[[bookStore books] objectAtIndex:[indexPath row]] valueForKey:@"path"];
    DebugLog(@"select path --> %@",path);
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@",path]];
    //打开系统站点
    [[UIApplication sharedApplication] openURL:url];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
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
