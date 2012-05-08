//
//  SettingVC.h
//  eBook
//
//  Created by LiuWu on 12-4-28.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "BaseVC.h"

@interface SettingVC : BaseVC<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *settingView;
    NSArray *test;
    UINavigationController *navControl;
}
@property (nonatomic,retain) NSArray *test;
@property (nonatomic,retain) UINavigationController *navControl;

@end
