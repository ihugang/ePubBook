//
//  CommentVC.m
//  eBook
//
//  Created by LiuWu on 12-5-18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "CommentVC.h"
#import <QuartzCore/QuartzCore.h>
#import "BookComment.h"

@interface CommentVC ()

@end

@implementation CommentVC
@synthesize className,textView,comment;

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"comment" object:nil];
    [super dealloc];
}

- (void)viewDidLoad
{
    [self.view setBackgroundColor:[UIColor scrollViewTexturedBackgroundColor]];
    
    UINavigationBar *navBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 44)];
    [self.view addSubview:navBar];
    //    CustomNavigationBar *bar = (CustomNavigationBar *)navBar;
    //    CustomNavigationBar *bar = [[CustomNavigationBar alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 44)];
    //    [self.view addSubview:bar];
    [navBar setAutoresizesSubviews:YES];
    [navBar setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin];
    //    [navBar setTintColor:[UIColor colorWithPatternImage:skinImage(@"operbar/b002.png")]];
    //给导航栏设置背景图片
    if ([navBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)]) {
        [navBar setBackgroundImage:skinImage(@"navbar/b002.png") forBarMetrics:UIBarMetricsDefault];
    }
    
    
    
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
    
    //创建一个导航栏集合  
    UINavigationItem *navigationItem = [[UINavigationItem alloc] initWithTitle:nil];
    //创建一个左边按钮  
//    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithTitle:@"返回"     
//                                                                   style:UIBarButtonItemStylePlain    
//                                                                  target:self     
//                                                                  action:@selector(clickLeftButton)];    
//    //创建一个右边按钮  
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"添加"     
                                                                    style:UIBarButtonItemStyleDone     
                                                                   target:self     
                                                                   action:@selector(clickRightButton)];    
    //设置导航栏内容  
    [navigationItem setTitle:@"添加批注"];  
    //把导航栏集合添加入导航栏中，设置动画关闭  
    [navBar pushNavigationItem:navigationItem animated:YES];
    //    [bar pushNavigationItem:navigationItem animated:YES];
    
    //把左右两个按钮添加入导航栏集合中  
    [navigationItem setLeftBarButtonItem:customButton];
    [navigationItem setRightBarButtonItem:rightButton];
    
    
    self.textView = [[[UITextView alloc] initWithFrame:CGRectMake(0, navBar.frame.size.height, self.view.bounds.size.width, self.view.bounds.size.height/2-10)] autorelease];
    [textView setFont:[UIFont fontWithName:@"Arial" size:18.0]];//设置字体名字和字体大小
    textView.textColor = [UIColor blackColor];//设置textview里面的字体颜色
    textView.backgroundColor = [UIColor whiteColor];//设置它的背景颜色
    textView.returnKeyType = UIReturnKeyDefault;//返回键的类型
    textView.keyboardType = UIKeyboardTypeDefault;//键盘类型
    textView.scrollEnabled = YES;//是否可以拖动
    //设置圆角
    [textView.layer setCornerRadius:10];
    [self.view addSubview:textView];
//    [textView resignFirstResponder];
    [textView becomeFirstResponder];
    
    //监听事件
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addComment:) name:@"comment" object:nil];
    
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)addComment:(NSNotification *)notification
{
    self.className = [notification object];
}

-(void)clickLeftButton  
{  
    //获取批注列表
    [bookComment getBookComment];
    
    //删除批注
    [bookComment.currentBookComment removeObjectForKey:className];
    //写入document文件
    [bookComment.currentBookComment writeToFile:bookComment.filename atomically:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"removeComment" object:self.className];
    
    
    NSLog(@"qu xiao add comment");
    [self dismissModalViewControllerAnimated:YES];
}  


-(void)clickRightButton  
{  
    NSLog(@"add comment");
    NSString *text = self.textView.text;
    DebugLog(@"text -- > %@",text);
    if (text.length > 0) {
        //获取批注列表
        [bookComment getBookComment];
        //给匹配clasName的添加批注
        NSDictionary *dic = [bookComment.currentBookComment objectForKey:className];
        self.comment = [NSMutableDictionary dictionaryWithDictionary:dic];
        [comment setObject:text forKey:@"commentText"];
        //添加当前批注内容
        [bookComment.currentBookComment setValue:comment forKey:className];
        //写入document文件
        [bookComment.currentBookComment writeToFile:bookComment.filename atomically:YES];
        [self dismissModalViewControllerAnimated:YES];
    }else {
         DebugLog(@"text nil");
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
