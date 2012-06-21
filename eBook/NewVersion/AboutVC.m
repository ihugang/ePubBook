//
//  AboutVC.m
//  eBook
//
//  Created by LiuWu on 12-5-7.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "AboutVC.h"

@interface AboutVC ()

@end

@implementation AboutVC

- (void)dealloc
{
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self.navigationItem setTitle:@"版权信息"];
    
//    self.navigationItem.hidesBackButton = YES;
    //自定义返回按钮
    UIButton *button = [UIButton buttonWithType: UIButtonTypeCustom]; 
    [button setTitle:@"设置" forState:UIControlStateNormal];
    [button.titleLabel setFont:[UIFont boldSystemFontOfSize:12]];
    // Set its background image for some states...
    [button setBackgroundImage: skinImage(@"operbar/b007.png") forState:UIControlStateNormal];  
    // Add target to receive Action
    [button addTarget: self action:@selector(clickLeftButton) forControlEvents:UIControlEventTouchUpInside]; 
    // Set frame width, height
    button.frame = CGRectMake(0, 0, 50, 26);  
    // Add this UIButton as a custom view to the self.navigationItem.leftBarButtonItem
    UIBarButtonItem *customButton = [[[UIBarButtonItem alloc] initWithCustomView: button] autorelease]; 
    self.navigationItem.leftBarButtonItem = customButton;
//    self.navigationItem.backBarButtonItem = customButton;
    
    UIImageView *about = [[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height - 44)] autorelease];
    [about setImage:resImage(@"content/g001.png")];
    [self.view addSubview:about];
    [about setAutoresizesSubviews:YES];
    [about setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin];
}

-(void)clickLeftButton  
{  
    [self.navigationController popViewControllerAnimated:YES];
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
