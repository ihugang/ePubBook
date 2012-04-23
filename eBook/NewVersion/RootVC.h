//
//  RootVC.h
//  eBook
//
//  Created by loufq on 12-4-17.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "BaseVC.h"
#import "ATPagingView.h"

@interface RootVC : BaseVC<ATPagingViewDelegate>
{ 
    BOOL parsing;
}

@property(nonatomic,retain) ATPagingView* pageView;

@property(nonatomic,retain)NSArray* datasoucre;

@end
