//
//  SettingVC.m
//  eBook
//
//  Created by LiuWu on 12-4-28.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "SettingVC.h"

@interface SettingVC ()

@end

@implementation SettingVC

- (void)dealloc
{
    [super dealloc];
}

- (void)viewDidLoad
{
    [self.view setBackgroundColor:[UIColor scrollViewTexturedBackgroundColor]];
    
    UINavigationBar *navBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 44)];
    [self.view addSubview:navBar];
    //创建一个导航栏集合  
    UINavigationItem *navigationItem = [[UINavigationItem alloc] initWithTitle:nil];    
    //创建一个左边按钮  
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithTitle:@"关闭"     
                                                                   style:UIBarButtonItemStyleBordered     
                                                                  target:self     
                                                                  action:@selector(clickLeftButton)];    
    //创建一个右边按钮  
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"Done"     
                                                                    style:UIBarButtonItemStyleDone     
                                                                   target:self     
                                                                   action:@selector(clickRightButton)];    
    //设置导航栏内容  
    [navigationItem setTitle:@"设置"];  
    //把导航栏集合添加入导航栏中，设置动画关闭  
    [navBar pushNavigationItem:navigationItem animated:YES];
    //把左右两个按钮添加入导航栏集合中  
    [navigationItem setLeftBarButtonItem:leftButton];   
    [navigationItem setRightBarButtonItem:rightButton]; 
    
    UIView *baseView = [[UIView alloc] initWithFrame:CGRectMake(10, navBar.bounds.size.height+10, self.view.bounds.size.width - 20, (self.view.bounds.size.height- 44)/2)];
    [baseView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:baseView];
    
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

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation{
    [super didRotateFromInterfaceOrientation:fromInterfaceOrientation];
}

@end
