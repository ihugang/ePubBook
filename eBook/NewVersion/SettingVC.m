//
//  SettingVC.m
//  eBook
//
//  Created by LiuWu on 12-4-28.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "SettingVC.h"
#import "AboutVC.h"

@interface SettingVC ()

@end

@implementation UINavigationBar (CustomImage)
-(void)drawRect:(CGRect)rect {
    UIImage *image = skinImage(@"operbar/b002.png");
    [image drawInRect:CGRectMake(0,0,self.frame.size.width,self.frame.size.height)];
}
@end

@implementation SettingVC
@synthesize test,navControl;

- (void)dealloc
{
    [settingView release];
    [test release];
    [super dealloc];
}


- (void)viewDidLoad
{
    [self.view setBackgroundColor:[UIColor scrollViewTexturedBackgroundColor]];
    
//    UINavigationBar *navBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 44)];
////    [self.view addSubview:navBar];
//    [navBar setAutoresizesSubviews:YES];
//    [navBar setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin];
    self.navigationController.navigationBar.tintColor = [UIColor colorWithPatternImage:skinImage(@"operbar/b002.png")];
//    [self.navigationController.navigationBar setFrame:CGRectMake(0, 0, self.view.bounds.size.width, 44)];
    
    //    //创建一个导航栏集合  
    //    UINavigationItem *navigationItem = [[UINavigationItem alloc] initWithTitle:nil];
    //创建一个左边按钮  
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithTitle:@"返回"     
                                                                   style:UIBarButtonItemStyleBordered     
                                                                  target:self     
                                                                  action:@selector(clickLeftButton)];    
    //创建一个右边按钮  
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"Done"     
                                                                    style:UIBarButtonItemStyleDone     
                                                                   target:self     
                                                                   action:@selector(clickRightButton)]; 
    self.navigationItem.title = @"设置";
    //添加按钮
    [self.navigationItem setLeftBarButtonItem:leftButton];
//    [self.navigationItem setRightBarButtonItem:rightButton];
    

//    //设置导航栏内容  
//    [navigationItem setTitle:@"设置"]; 
//    //把导航栏集合添加入导航栏中，设置动画关闭  
//    [navBar pushNavigationItem:navigationItem animated:YES];
//    //把左右两个按钮添加入导航栏集合中  
//    [navigationItem setLeftBarButtonItem:leftButton];   
//    [navigationItem setRightBarButtonItem:rightButton]; 
    
    UIView *baseView = [[UIView alloc] initWithFrame:CGRectMake(10,10, self.view.bounds.size.width - 20, self.view.bounds.size.height- 64)];
    [baseView setBackgroundColor:[UIColor whiteColor]];
    [baseView setAutoresizesSubviews:YES];
    [baseView setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin];
    [self.view addSubview:baseView];
    
    settingView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, baseView.bounds.size.width, baseView.bounds.size.height) style:UITableViewStyleGrouped];
    [settingView setDelegate:self];
    [settingView setDataSource:self];
    [settingView setAutoresizesSubviews:YES];
    [settingView setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin];
    [baseView addSubview:settingView];
    
    NSArray *aa = [NSArray arrayWithObjects:@"test",@"test",@"test", nil];
    self.test = aa;
    
    //释放对象
//    [navBar release];
//    [navigationItem release];    
    [leftButton release];    
    [rightButton release]; 
    
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

#pragma mark -
#pragma mark TableView delegate methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }else{
        return 3;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *set = @"set";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:set];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:set] autorelease];
    }
//    DebugLog(@"numberofsection --- %d",[indexPath section]);
    if (indexPath.section == 0) {
        cell.textLabel.text = @"版权信息";
    }
    if (indexPath.section == 1) {
        cell.textLabel.text = [test objectAtIndex:indexPath.row];
    }
    cell.textLabel.font = [UIFont boldSystemFontOfSize:14];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    DebugLog(@"didSelectRowAtIndexPath");
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            AboutVC *about = [[[AboutVC alloc] init] autorelease];
            [self.navigationController pushViewController:about animated:YES];
        }
    }
//     [self presentModalViewController:navController animated:YES]; 
}

//设置标题
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return @"关于";
    }else {
        return @"通用";
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    NSString *sectionTitle = [self tableView:tableView titleForHeaderInSection:section];
    if (sectionTitle == nil) {
        return nil;
    }
    
    // Create label with section title
    UILabel *label = [[[UILabel alloc] init] autorelease];
    label.frame = CGRectMake(20, 6, 300, 30);
    label.backgroundColor = [UIColor clearColor];
//    label.textColor = [UIColor colorWithHue:(136.0/360.0)  // Slightly bluish green
//                                 saturation:1.0
//                                 brightness:0.60
//                                      alpha:1.0];
    label.textColor = [UIColor blueColor];
    label.shadowColor = [UIColor whiteColor];
    label.shadowOffset = CGSizeMake(0.0, 1.0);
    label.font = [UIFont boldSystemFontOfSize:16];
    label.text = sectionTitle;
    
    // Create header view and add label as a subview
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
    [view autorelease];
    [view addSubview:label];
    
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if ([self tableView:tableView titleForHeaderInSection:section] != nil) {
        return 40;
    }
    else {
        // If no section header title, no section header needed
        return 0;
    }
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

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation{
    [super didRotateFromInterfaceOrientation:fromInterfaceOrientation];
}

@end
