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

-(void)initLayout{
    
    
}


-(void)showWithPathIndex:(int)aIndex{ 
    
    for (UIView* view in self.subviews) {
        [view removeFromSuperview];
    }
 
    if (share.isLandscape) {//two page
        CGSize s= CGSizeMake(self.frame.size.width/2,self.frame.size.height);
        ContentView* cv1 =[ContentView createWithSize:s];
        cv1.backgroundColor =[UIColor whiteColor];
        [cv1 showWithIndex:aIndex*2];
        [self addSubview:cv1]; 
        ContentView* cv2 =[ContentView createWithSize:s];
        cv2.frame = CGRectMake(self.frame.size.width/2,0,self.frame.size.width/2,self.frame.size.height); 
        [self addSubview:cv2]; 
        [cv2 showWithIndex:aIndex*2 + 1];
        cv2.backgroundColor =[UIColor grayColor];
    }
    else {//one page
        CGSize s= CGSizeMake(self.frame.size.width,self.frame.size.height);
        ContentView* cv1 =[ContentView createWithSize:s];
        [self addSubview:cv1]; 
        [cv1 showWithIndex:aIndex];
        cv1.backgroundColor =[UIColor scrollViewTexturedBackgroundColor];
    }
}

@end
