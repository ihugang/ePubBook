//
//  SearchVC.h
//  eBook
//
//  Created by LiuWu on 12-4-28.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "BaseVC.h"

@protocol SearchVCDelegate <NSObject>

- (void)showSearchVC;

@end

@interface SearchVC : BaseVC<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
{
    UITextField *searchField;
}

@property (nonatomic,assign) id<SearchVCDelegate> delegate;

@end
