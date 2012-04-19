//
//  ChapterListVC.h
//  eBook
//
//  Created by LiuWu on 12-4-19.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "BaseVC.h"

@interface ChapterListVC : BaseVC<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *chapterList;
}
@end
