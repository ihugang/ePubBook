//
//  ContentWrapperView.h
//  eBook
//
//  Created by loufq on 12-4-17.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "BaseView.h"

@interface ContentWrapperView : BaseView{
    
}

//显示第几页（横版两页算，竖版一页算）
-(void)showWithPathIndex:(int)aIndex;
@end
