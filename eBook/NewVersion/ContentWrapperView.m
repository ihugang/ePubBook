//
//  ContentWrapperView.m
//  eBook
//
//  Created by loufq on 12-4-17.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ContentWrapperView.h"
#import "AppShare.h"
#import "ContentView.h"
@implementation ContentWrapperView
@synthesize rootVC;

-(void)initLayout{
    
    
}


-(void)showWithPathIndex:(int)aIndex{ 
    
    for (UIView* view in self.subviews) {
        [view removeFromSuperview];
    }
    CGSize s= CGSizeMake(self.frame.size.width,self.frame.size.height);
    s= CGSizeMake(s.width-20, s.height-20);
    ContentView* cv1 =[ContentView createWithSize:s];
    cv1.centerX = self.width/2;
    cv1.centerY = self.height/2;
    [self addSubview:cv1]; 
    [cv1 showWithIndex:aIndex]; 
    [cv1 setDebug:YES];
    cv1.rootVC = self.rootVC;
    
    [cv1 setAutoresizingMask:UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin];
//    cv1.backgroundColor =[UIColor scrollViewTexturedBackgroundColor];
//    cv1.backgroundColor = [UIColor whiteColor];
    if (!mf_IsPad || !share.isLandscape) {
        
    }else {
//        cv1.backgroundColor = [UIColor colorWithPatternImage:skinImage(@"fontbar/5003.png")];
//        
//        UIImageView *customBackground = [[UIImageView alloc] initWithImage:skinImage(@"fontbar/5003.png")];
//        [cv1 addSubview:customBackground];
//        [cv1 sendSubviewToBack:customBackground];
    }
}

@end
