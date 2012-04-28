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

@interface SearchVC ()

@end

@implementation SearchVC
@synthesize delegate;

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
    [searchButton addTarget:self action:@selector(search:) forControlEvents:UIControlEventTouchUpInside];
    [searchButton setAutoresizesSubviews:YES];
    [searchButton setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin];
    [searchView addSubview:searchButton];
    
    UITableView *resultTable = [[UITableView alloc] initWithFrame:CGRectMake(5, 5, resultView.bounds.size.width - 10, resultView.bounds.size.height - 20)];
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
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *tag = @"cell";//由于用了两种界面模式所以两个tag
    MyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:tag];
    if (cell == nil) {
        cell = [[[MyTableViewCell alloc] init] autorelease];
    }
    cell.date.text = @"2010.1.1";
    cell.number.text = [NSString stringWithFormat:@"%d",indexPath.row];
    cell.content.text = @"然能够在工作之余整理总结出这本书，也是他对自己多年经营和管理工作经验的一次复盘，我相信他总结出的经验和教训对于后来的创业者会有所启迪。陶然目前正在率领拉卡拉团队在金融服务领域大展宏图，并且有可能成为联想控股旗下现代服务业的一个重要业务模块，代服务业的一个重要业务模块，成为联想正规军的队伍，我也在此祝愿他和他的团队能";
    
    cell.date.highlightedTextColor = [UIColor whiteColor];
    cell.number.highlightedTextColor = [UIColor whiteColor];
    cell.content.highlightedTextColor = [UIColor whiteColor];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ContentView *content = [[ContentView alloc] init];
    [content showWithIndex:[indexPath row]];
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
    return YES;
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
