//
//  RootVC.h
//  eBook
//
//  Created by loufq on 12-4-17.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "BaseVC.h"
#import "ATPagingView.h"
#import "OperView.h"
#import "NavView.h"
#import "FontView.h"

@interface RootVC : BaseVC<ATPagingViewDelegate,NavViewDelegate,OperViewDelegate,UIGestureRecognizerDelegate>
{ 
    BOOL parsing;
    BOOL operViewShowed;
    OperView* operView;
    NavView* navView;
    NSString *lastPage;
}
@property(nonatomic,retain) NSString *lastPage;
@property(nonatomic,retain) ATPagingView* pageView;
@property(nonatomic,retain)NSArray* datasoucre;

-(void)swichUI:(BOOL)showOperView;

@end
