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

@interface RootVC : BaseVC<ATPagingViewDelegate,NavViewDelegate,OperViewDelegate>
{ 
    BOOL parsing;
    BOOL operViewShowed;
}

@property(nonatomic,retain) ATPagingView* pageView;

@property(nonatomic,retain)NSArray* datasoucre;

@end
