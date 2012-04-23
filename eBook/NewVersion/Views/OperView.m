//
//  OperView.m
//  eBook
//
//  Created by loufq on 12-4-20.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "OperView.h"

@implementation OperView

-(void)initLayout{
    CGRect frame =  [[UIScreen mainScreen] bounds];
    self.size =CGSizeMake(frame.size.width, 44);
  
    menuButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [menuButton setFrame:CGRectMake(0, 0, 50, 40)];
    [menuButton setTitle:@"目录" forState:UIControlStateNormal];
    [menuButton addTarget:self action:@selector(showChapterIndex:) forControlEvents:UIControlEventTouchUpInside]; 
    [self addSubview:menuButton];
    
}
-(void)showChapterIndex:(UIButton*)sender{
    
}
@end
